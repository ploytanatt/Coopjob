<template>
  <div class="">
    <div class="columns">
        <sideMenu></sideMenu>
    <div class="columns category container  card">
      <!-- Category tabs   -->
          <router-link :to="'/applicationList'">
          <button class="button is-dark go-back-button">
              <i class="fa-solid fa-left-long"></i> 
            </button>
           </router-link>
      <div class="column is-2 drag-areas card">
        <aside class="menu">
          <ul class="menu-list">
            <li v-for="category in categories" :key="category.category_id">
              <a :class="{'is-active': activeCategory === category.category_id,}" @click="setActiveCategory(category.category_id)" >
                {{ category.name }}
              </a>
            </li>
          </ul>
        </aside>
      </div>
      <!-- Application list for selected category -->
      <div class="column is-5 drag-areas card">

        <button class="button is-dark mr-3"  @click="exportToExcel">
          <i class="fa-solid fa-file-xls"></i>
        </button>
      <div class="filter_search select is-small   ">
        <select v-model="selectedYearCategory">
          <option value="">ปีการศึกษา</option>
          <option value="2020">2563</option>
          <option value="2021">2564</option>
          <option value="2022">2565</option>
          <option value="2023">2566</option>
          <option value="2024">2567</option>
        </select>
      </div>
      <div v-if="activeCategory" class="box">
        <h2 class="title is-4">
          {{ getCategoryName(activeCategory) }}
        </h2>
        <draggable class="drag-area" :list="filteredCategoryApplications[activeCategory]" @end="OutEndDrag" group="applications">
          <div 
          v-for="(app, index) in filteredCategoryApplications[activeCategory]" 
          :key="app.application_id" 
          :data-id="app.application_id" class="application">
            {{ index + 1 }}. {{ app.job_title }} - {{ app.firstName }} {{ app.lastName }}
            <span :class="{
            'tag': true, 
            'is-success':app.job_type === 'internship',
            'is-warning':app.job_type === 'cooperative',
            }"> {{ app.job_type}} 
          </span>
          </div>
        </draggable>
      </div>
      </div>
      <!-- List of all applications -->
      <div class="column is-5 drag-areas card" >
        <div class="field is-horizontal  ">
        <div class="field-body filter_searchbox field is-grouped  is-grouped-right ">
          <div class="filter_search select is-small   ">
            <select v-model="selectedYear">
              <option value="">ปีการศึกษา</option>
              <option value="2020">2563</option>
              <option value="2021">2564</option>
              <option value="2022">2565</option>
              <option value="2023">2566</option>
              <option value="2024">2567</option>
            </select>
          </div>
          <div class="filter_search select is-small">
            <select v-model="selectedJobType">
              <option value="">รูปแบบงาน</option>
              <option value="internship">internship</option>
              <option value="cooperative">cooperative</option>
            </select>
          </div>
          <div class="filter_search control has-icons-left  ">
            <input v-model="searchText" class="input is-small" type="text" placeholder="ค้นหาจากชื่องาน" />
            <span class="icon is-small is-left">
              <i class="fa fa-search"></i>
            </span>
          </div>
        </div>
      </div>
        <h2>ผลการสมัครงานของนักศึกษาที่ผ่านแล้ว</h2>
        <draggable class="drag-area" :list="applications" group="applications" @end="onEndDrag">
          <div
            v-for="(application, index) in filteredApplications"
            :key="application.application_id"
            :data-id="application.application_id" class="application">
            {{ index+1 }}.
            {{ application.job_title }}  -
            {{ application.firstName }} {{ application.lastName }}
                      <span :class="{
                'tag': true, 
                'is-success':application.job_type === 'internship',
                'is-warning':application.job_type === 'cooperative',
                 }"> {{ application.job_type}} 
              </span>
          </div>
        </draggable>
      </div>
    </div>
  </div>
  </div>
</template>
<script>
import draggable from "vuedraggable";
import axios from "axios";
import sideMenu from '@/components/admin/side-menu.vue';
import * as XLSX from 'xlsx'
export default {
  components: { draggable, sideMenu },
  data() {
    return {
      categories: [],
      applications: [],
      activeCategory: 1,
      newApplicationID: null,
      categoryApplications: {},
      selectedYearCategory:'',

      selectedYear:'',
      selectedJobType:'',
      searchText:''
    };
  },
  mounted() {
    this.fetchCategories();
    this.fetchApplications();
    this.fetchApplicationCategories();
  },
  computed: {
    filteredApplications() {
      return this.applications.filter((app) => {
         const appliedYear = new Date(app.applied_datetime).getFullYear().toString();
        return (
          (this.selectedJobType ? app.job_type === this.selectedJobType : true) &&
          (this.selectedYear ? appliedYear === this.selectedYear : true) &&
      app.job_title.toLowerCase().includes(this.searchText.toLowerCase())
        );
      });
    },
    filteredCategoryApplications() {
    if (!this.selectedYearCategory) {
      // ถ้าไม่มีปีที่เลือก ก็ใช้ข้อมูลทั้งหมด
      return this.categoryApplications;
    }
    
    // กรองข้อมูลตามปีที่เลือก
    return Object.keys(this.categoryApplications).reduce((acc, categoryId) => {
      const filteredApps = this.categoryApplications[categoryId].filter((app) => {
        const appliedYear = app.applied_datetime.split('-')[0];
        return this.selectedYearCategory ? appliedYear === this.selectedYearCategory : true;
      });

      // ถ้าหมวดหมู่มีข้อมูลหลังจากกรอง ให้เพิ่มเข้าไปใน accumulator
      if (filteredApps.length) {
        acc[categoryId] = filteredApps;
      }
      return acc;
    }, {});
  }
  },
  methods: {
    fetchCategories() {
      axios
        .get("http://localhost:3000/admin/getcategories")
        .then((response) => {
          this.categories = response.data;
          this.initCategoryApplications();
        })
        .catch((error) => console.error("Error fetching categories:", error));
    },
    fetchApplicationCategories() {
      axios
        .get("http://localhost:3000/admin/assignedApplicationCategories")
        .then((response) => {
          // ประมวลผลข้อมูลที่ได้รับ
          const applicationsWithCategories = response.data;
          // สามารถทำการกระจายข้อมูลเหล่านี้ไปยังหมวดหมู่ที่เกี่ยวข้อง
          applicationsWithCategories.forEach((app) => {
            if (this.categoryApplications[app.category_id]) {
              this.categoryApplications[app.category_id].push(app);
            } else {
              // ถ้าหมวดหมู่ไม่มีอยู่ใน state ให้สร้างขึ้นมาและเพิ่ม application
              this.$set(this.categoryApplications, app.category_id, [app]);
            }
          });
        })
        .catch((error) => {
          console.error("Error fetching applications with categories:", error);
        });
    },
    fetchApplications() {
      axios
        .get("http://localhost:3000/admin/unassignedApplications")
        .then((response) => {
          // รีเซ็ต categoryApplications และ กระจาย applications ให้ถูกต้องตามหมวดหมู่
          this.initCategoryApplications();
          this.applications = response.data; // เคลียร์ list ปัจจุบัน
        })
        .catch((error) => {
          console.error("Error fetching applications:", error);
        });
    },
    initCategoryApplications() {
      this.categories.forEach((category) => {
        this.$set(this.categoryApplications, category.category_id, []);
      });
    },
    setActiveCategory(category_id) {
      this.activeCategory = category_id;
    },
    getCategoryName(category_id) {
      const category = this.categories.find(
        (cat) => cat.category_id === category_id
      );
      return category ? category.name : "";
    },
    getCategoryApplications(category_id) {
      return this.categoryApplications[category_id] || [];
    },
    onEndDrag(event) {
    const applicationId = event.item.dataset.id;
    const newCategoryId = event.to.dataset.categoryId || this.activeCategory;
    this.updateApplicationCategory(applicationId, newCategoryId).then(() => {
      // บังคับให้ Vue รู้จักการเปลี่ยนแปลงข้อมูล
      this.fetchApplicationCategories(); // ดึงข้อมูลหมวดหมู่และประยุกต์ใช้ใหม่
    });
  },
    updateApplicationCategory(applicationId, categoryId) {
    return new Promise((resolve, reject) => {
      const data = {
        application_id: applicationId,
        category_id: categoryId,
      };

      axios.put("http://localhost:3000/admin/updateApplicationCategory", data)
        .then(response => {
          console.log("Category updated successfully:", response.data);
          resolve();
        })
        .catch(error => {
          console.error("Error updating category:", error);
          reject(error);
        });
    });
  },
    OutEndDrag(event) {
      const applicationId = event.item.dataset.id;
      // หา category ID ที่ application ถูกลากไป
      const newCategoryId =  this.activeCategory;
      console.log("applicationId", applicationId);
      console.log("categoryID", newCategoryId);
      // อัปเดต
      this.removeApplicationCategory(applicationId, newCategoryId);
    },
    removeApplicationCategory(applicationId, categoryId) {
        const data = {
          application_id: applicationId,
          category_id: categoryId,
        };
        console.log("data", data);
        axios.delete(`http://localhost:3000/admin/removeApplicationCategory?application_id=${applicationId}&category_id=${categoryId}`)
          .then((response) => {
          console.log("Category removed successfully:", response.data);
            // อาจจะต้องมีการอัพเดท state หรือ UI ที่นี่หลังจากลบข้อมูลสำเร็จ
          }).catch((error) => {
          console.error("Error removing category:", error);
        });
      },

exportToExcel() {
  const workbook = XLSX.utils.book_new(); // สร้าง workbook ใหม่

  // สร้างข้อมูลสรุป
  const summaryData = this.categories.map(category => {
    const categoryApplications = this.categoryApplications[category.category_id] || [];
    return {
      Category: category.name, // ใช้ชื่อหมวดหมู่จากอาร์เรย์ categories
      Count: categoryApplications.length
    };
  });

  // เพิ่มข้อมูลสรุปลงในเวิร์กชีต 'Summary'
  const summaryWorksheet = XLSX.utils.json_to_sheet(summaryData);
  XLSX.utils.book_append_sheet(workbook, summaryWorksheet, 'Summary');

  // เพิ่มเวิร์กชีตสำหรับแต่ละหมวดหมู่
  this.categories.forEach(category => {
    const categoryApplications = this.categoryApplications[category.category_id] || [];
    if (categoryApplications.length > 0) {
      const worksheet = XLSX.utils.json_to_sheet(categoryApplications);
      XLSX.utils.book_append_sheet(workbook, worksheet, category.name); // ชื่อเวิร์กชีตใช้ชื่อหมวดหมู่
    }
  });

  // ส่งออก workbook เป็นไฟล์ Excel
  XLSX.writeFile(workbook, 'categoryApplications.xlsx');
}


  },
};
</script>
<style>
.application {
  padding: 5px;
  border: 1px solid #eee;
  margin: 5px;
  background-color: #f9f9f9;
}

.menu-list a.is-active {
  background-color: #00d1c0;
  color: white;
}
.category{
  padding: 1rem;
  margin-top: 1rem;
  margin-left: 0.5rem;
}
.drag-area {
  border: 1px solid #ccc;
  min-height: 100px;
  overflow-y: auto; /* อนุญาตให้เลื่อนแนวตั้งได้ */
  margin-bottom: 20px;
  padding: 10px;
}
.drag-areas {
  border: 0.5px solid #d1d1d1;

  min-height: 100px;
  overflow-y: auto;
  margin-left: 10px;
  margin-bottom: 20px;
  padding: 10px;
}
.application {
  padding: 5px;
  border: 1px solid #eee;
  margin: 5px;
  background-color: #f9f9f9;
}
.category-column {
  width: 33.3333%; /* หรือกำหนดความกว้างเป็นหน่วย px ถ้าต้องการ */
  min-height: 100px;
  max-height: 500px;
  overflow-y: auto;
}
.application {
  padding: 5px;
  border: 1px solid #eee;
  margin: 5px;
  background-color: #f9f9f9;
}
</style>
