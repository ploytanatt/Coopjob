<template>
  <div>
    <div class="columns">
      <div class="column ">





    
            <div class="field is-horizontal  ">
        <div class="field-body filter_searchbox field is-grouped  is-grouped-right ">
        
            <div class="filter_search  ">
              <button class="button is-success mr-3" @click="exportToCSV">
                <i class="fa-solid fa-file-csv"></i>
              </button>
              <button class="button is-dark " @click="exportToExcel">
                <i class="fa-solid fa-file-xls"></i>
              </button>
             </div>
            <div class="filter_search select is-small">
              <select v-model="selectedJobType">
                <option value="">รูปแบบงาน</option>
                <option value="internship">internship</option>
                <option value="cooperative">cooperative</option>
              </select>
            </div>
            <div class="filter_search select is-small  ">
              <select v-model="selectedStatus">
                <option value="">สถานะ</option>
                <option value="pending">pending</option>
                <option value="approve">approve</option>
                <option value="declined">declined</option>
              </select>
            </div>

            <div class="filter_search control has-icons-left  ">
              <input v-model="searchText" class="input is-small" type="text" placeholder="ค้นหาจากชื่องาน" />
              <span class="icon is-small is-left">
                <i class="fa fa-search"></i>
              </span>
            </div>

            <div class="filter_search control has-icons-left">
              
            </div>
        </div>
      </div>

    <div class="columns">

    
      <div class="column">
              <main>
            <div class="mt-5">
              <div class="row justify-content-center border py-5">
              <button class="button toggle-button" @click="toggleAllCategories">
                {{ showAll ? 'Hide All Categories' : 'Show All Categories' }}
              </button>
                <!-- Toggle for each category -->
                <div class="col-12" v-for="category in categories" :key="category.name" v-show="showAll"> 
                  <h4 class="mb-3 button" @click="toggleCategory(category.name)">{{ category.name }}</h4>
                  <draggable v-if="category.visible" class="draggable-list" :list="category.items" group="categories">
                    <div class="list-item" v-for="item in category.items" :key="item.name">
                      {{ item.name }}
                    </div>
                  </draggable>
                </div>
              </div>
            </div>
          </main>

  </div>
<!-- ...ส่วนอื่นๆของtemplate... -->
<div class="column is-full container">
  <draggable class="draggable-list card_list" :list="computedFilteredApplications" group="shared-group" @change="handleDrag">
    <div v-for="(application, index) in computedFilteredApplications" :key="application.application_id" class="box draggable-item">
      <!-- Content of draggable card -->
        {{ index + 1 }}       
                <router-link :to="'/company/' + application.user_id">
                  <img :src="imagePath(application.profile_image)" alt="Company Logo" class="CompanyLogo">
                  <p>{{ application.company_name }}</p>
              </router-link>
           
            {{ application.job_title }}
             {{ application.job_type}}
            {{ application.firstName }} {{ application.lastName }}
            
           {{ formatDate(application.applied_datetime)}}
          
                <span :class="{
                'tag': true, 
                'is-success':application.application_status === 'approve',
                'is-warning':application.application_status === 'pending', 
                'is-dark':application.application_status === 'canceled',
                'is-danger':application.application_status === 'declined',
                 }"> 
                {{ application.application_status }} </span>
    </div>
  </draggable>
</div>
<!-- ...ส่วนอื่นๆของtemplate... -->

    </div>

  <div class="columns">

    <div class="column">
      <div class="is-flex is-align-items-center">
        <p class="is-size-7 has-text-grey-light">แสดง</p>
        <div class="select is-small mx-3">
          <select v-model="itemsPerPage" class="has-background-white" aria-label="Select example">
            <option :value="10">10</option>
            <option :value="50">50</option>
            <option :value="100">100</option>
          </select>
        </div>
        <p class="is-size-7 has-text-grey-light">จากทั้งหมด {{ applications.length }} รายการ</p>
      </div>

    </div>

    <div class="column is-flex is-justify-content-flex-end">
      <nav class="pagination" role="navigation" aria-label="pagination">
        <ul class="pagination-list" style="font-size: 12px;">
          <li>
            <a class="pagination-link has-background-white" @click="prevPage" :disabled="currentPage === 1">
              <i class="fa-solid fa-angle-left"></i>
            </a>
          </li>
          
          <!-- Dynamically generate page numbers -->
          <li v-for="page in totalPages" :key="page">
            <a class="pagination-link has-background-white" :class="{'is-current has-background-info': page === currentPage}" @click="goToPage(page)">
              {{ page }}
            </a>
          </li>

          <li>
            <a class="pagination-link has-background-white"  @click="nextPage" :disabled="currentPage === totalPages">
              <i class="fa-solid fa-angle-right"></i>
            </a>
          </li>
        </ul>
      </nav>
    </div>
  </div>
        </div>
    </div>

    <div v-if="isGroupModalActive" class="modal is-active">
    <div class="modal-background" @click="closeNewGroupModal"></div>
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">สร้างกลุ่มใหม่</p>
        <button class="delete" aria-label="close" @click="closeNewGroupModal"></button>
      </header>
      <section class="modal-card-body">
        <div class="field">
          <label class="label">ชื่อกลุ่ม</label>
          <div class="control">
            <input class="input" type="text" placeholder="ชื่อกลุ่ม" v-model="newGroupName">
          </div>
        </div>
      </section>
      <footer class="modal-card-foot">
        <button class="button is-success" @click="createNewGroup">สร้าง</button>
        <button class="button" @click="closeNewGroupModal">ยกเลิก</button>
      </footer>
    </div>
  </div>
  </div>


</template>
<script>
import axios from "axios";
//import Swal from "sweetalert2";
import Papa from 'papaparse';
import * as XLSX from 'xlsx'
import draggable from 'vuedraggable';
export default {
  components: {
    draggable
  },
data() {

  return {
    groups: [],

     isGroupModalActive: false, // ใช้สำหรับควบคุมการแสดง modal
    newGroupName: '', // ใช้สำหรับเก็บชื่อกลุ่มใหม่ที่ผู้ใช้ป้อน

    applications:[],
    without_applications:[],
    currentFilter: 'all',
    selectedStatus:'',
    selectedJobType:'',
    itemsPerPage: 10,
    currentPage: 1,
    sortKey: 'job_title',
    sortOrder: 'desc',

    searchText:'',


    showAll: false,
      categories: [
        { name: 'Software', items: [] , visible: false},
        { name: 'Web App', items: [] , visible: false},
        { name: 'Mobile App', items: [] , visible: false},
        { name: 'Network/System', items: [], visible: false },
        { name: 'IOT', items: [] , visible: false},
        { name: 'Security', items: [], visible: false },
        { name: 'Cloud', items: [] , visible: false},
        { name: 'DevOps', items: [] , visible: false},
        { name: 'Testing/Quality Assurance/Performance', items: [], visible: false },
        { name: 'Game', items: [], visible: false },
        { name: 'System/Business Analyst', items: [] , visible: false},
        { name: '3D', items: [] },
        { name: 'BI/Data Analytics/Data Science/Machine Learning/AI/Chatbot/Credit Risk Analysis', items: [] , visible: false},
        { name: 'Data Engineer', items: [], visible: false },
        { name: 'Consultant', items: [], visible: false },
        { name: 'ด้าน บัญชี RPA, Retail Support, Trainee, Operation Support, Audit, Business Process Improvement', items: [], visible: false },
      ],
  
  };
},
computed: {
  computedFilteredApplications() {
    let filtered = this.applications;

    // Filter ปีการศึกษา
    if (this.selectedStatus) {
      filtered = filtered.filter(
        application => application.application_status === this.selectedStatus
      );
    }

     if (this.selectedJobType) {
      filtered = filtered.filter(
        application => application.job_type === this.selectedJobType
      );
    }

    // Filter by search text
    if (this.searchText) {
      filtered = filtered.filter(พำยนพะ =>
        พำยนพะ.firstName.toLowerCase().includes(this.searchText.toLowerCase())
      );
    }

    // Apply sorting
    return filtered.sort((a, b) => {
      let result = 0;
      if (a[this.sortKey] < b[this.sortKey]) {
        result = -1;
      } else if (a[this.sortKey] > b[this.sortKey]) {
        result = 1;
      }
      return this.sortOrder === 'asc' ? result : -result;
    });
  },
  
  // Other computed properties...
  computedPaginatedApplications() {
    const startIndex = (this.currentPage - 1) * this.itemsPerPage;
    const endIndex = startIndex + this.itemsPerPage;
    return this.computedFilteredApplications.slice(startIndex, endIndex);
  },
  totalPages() {
    return Math.ceil(
      this.computedFilteredApplications.length / this.itemsPerPage
    );
  },
   totalInternCount() {
      return this.applications.reduce((count, application) => {
        return application.job_type === 'internship' ? count + 1 : count;
      }, 0);
    },
    totalCoopCount() {
      return this.applications.reduce((count, application) => {
        return application.job_type === 'cooperative' ? count + 1 : count;
      }, 0);
    },
},
mounted() {
  this.getApplicationList()
},
methods: {
   handleDrop(event) {
      // สมมติว่ามีการใช้ ID หรือประเภทเพื่อระบุกลุ่มที่เหมาะสม
      let application = this.computedFilteredApplications[event.oldIndex];
      let targetCategory = this.categories[event.newIndex];
      targetCategory.items.push(application);
      // ถ้าคุณต้องการลบรายการจาก `computedFilteredApplications` หลังจากการวาง
      this.removeFromFilteredApplications(application.application_id);
    },
    handleDrag(event) {
    if (event.added) {
      const newItem = event.added.element;
      const newCategory = this.categories.find(category => category.name === event.to.dataset.category);
      if (newCategory) {
        newCategory.items.push(newItem);
        // ลบจาก `computedFilteredApplications` ถ้าจำเป็น
        this.removeFromFilteredApplications(newItem.application_id);
      }
    }
  },

  removeFromFilteredApplications(applicationId) {
    this.applications = this.applications.filter(app => app.application_id !== applicationId);
  },
 addToCategory(application, categoryName) {
      const category = this.categories.find(c => c.name === categoryName);
      if (category) {
        category.items.push(application);
      }
    },

   exportToCSV() {
      const data = this.computedPaginatedApplications;
      const csv = Papa.unparse(data);
      const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
      const link = document.createElement('a');
      link.href = URL.createObjectURL(blob);
      link.setAttribute('download', 'export.csv');
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    },
    exportToExcel() {
      // ตัวอย่างโค้ดการใช้งาน XLSX
      const worksheet = XLSX.utils.json_to_sheet(this.computedFilteredApplications);
      const workbook = XLSX.utils.book_new();
      XLSX.utils.book_append_sheet(workbook, worksheet, 'Applications');
      XLSX.writeFile(workbook, 'applications.xlsx');
    },

  viewApplicationDetails(reportId) {
   // this.$router.push({ name: 'StudentDetails', params: { id: reportId } });
    this.$router.push("/reportDetail/" + reportId);
  },

  getApplicationList(){
    const token = localStorage.getItem("token");
    const config = {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    };
     axios
      .get("http://localhost:3000/admin/ApplicationList", config)
      .then((response) => {
        this.applications = response.data;
      })
      .catch((error) => {
        console.error(error);
      });
  },
  formatDate(date) {
    return new Date(date).toLocaleDateString()
  },
  imagePath(companyProfileImage) {
    if (companyProfileImage) {
      return "http://localhost:3000" + companyProfileImage.replace(/\\/g, '/').replace('static', '');
    } else {
      return "https://bulma.io/images/placeholders/640x360.png";
    }
  },
  setFilter(filter) {
      this.currentFilter = filter
  },
  goToPage(page) {
  this.currentPage = page;
},
  nextPage() {
    if (this.currentPage < this.totalPages) {
      this.currentPage++;
    }
  },
  prevPage() {
    if (this.currentPage > 1) {
      this.currentPage--;
    }
  },
  sortApplications(key) {
  if (this.sortKey === key) {
    this.sortOrder = this.sortOrder === 'asc' ? 'desc' : 'asc';
  } else {
    this.sortKey = key;
    this.sortOrder = 'asc';
  }
},

 toggleAllCategories() {
      this.showAll = !this.showAll;
  
    },
    toggleCategory(categoryName) {
      const category = this.categories.find(c => c.name === categoryName);
      if (category) {
        category.visible = !category.visible;
      }
    },

},
filters: {
  capitalize(value) {
    if (!value) return ''
    value = value.toString()
    return value.charAt(0).toUpperCase() + value.slice(1)
  }
},
};
</script>
<style scoped>

.table td, .table th {
  text-align: center; /* จัดให้ข้อความอยู่ตรงกลาง */
  vertical-align: middle; /* จัดให้ข้อความอยู่กลางแนวตั้ง */
}
.CompanyLogo{
width: 50px;
border: 1px solid rgb(240, 240, 240);
border-radius: 5px;
transition: width 0.3s ease-in-out;
}


.filter_search{
  margin-top: 20px;
  margin-left: 10px;
}

.filter_searchbox{
 padding: 1rem;
 margin-top: 1rem;
 background-color: #eaeaea;
}

.draggable-list {
  background: #3f51b5;
  color: #fff;

  min-height: 10vh;

}
.list-item {


  cursor: pointer;
  font-size: 16px;
  background: #ffffff;
  text-align: center;
}

.card_list{
  padding: 1rem;
  background-color: #dedede;
}
</style>