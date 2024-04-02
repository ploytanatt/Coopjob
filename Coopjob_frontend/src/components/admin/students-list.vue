<template>
  <div>
    <div class="columns">
      <div class="column ">
        <section class="hero is-info welcome is-small">
          <div class="hero-body">
            <div class="">
                <h1 class="title">
               รายชื่อนักศึกษาทั้งหมด
                </h1>
            </div>
                    </div>
                </section>
                <section class="info-tiles mt-4">
                    <div class="tile is-ancestor has-text-centered">
                        <div class="tile is-parent is-2">
                            <article class="tile is-child box" style="background-color: #A6E3E9;">
                                <p class="title">{{ studentLists.length }} </p>
                                <p class="subtitle">จำนวนนักศึกษา</p>
                            </article>
                        </div>
                        <div class="tile is-parent is-2">
                            <article class="tile is-child box " style="background-color: #D0F288;">
                                <p class="title">{{ studentsWithApplications }}</p>
                                <p class="subtitle">สมัครงานแล้ว</p>
                            </article>
                        </div>
                        <div class="tile is-parent is-2">
                            <article class="tile is-child box" style="background-color: #FFBFBF;">
                                <p class="title">{{ studentsWithNoApplications }}</p>
                                <p class="subtitle">ไม่พบข้อมูลการสมัคร</p>
                            </article>
                        </div>
                        
                    </div>
                </section>

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
              <select v-model="selectedStatus">
                <option value="">ปีการศึกษา</option>
                <option value="2563">2563</option>
                <option value="2564">2564</option>
                <option value="2565">2565</option>
                <option value="2566">2566</option>
              </select>
            </div>
            <div class="filter_search control has-icons-left">
              <input v-model="searchText" class="input is-small" type="text" placeholder="ค้นหาจากชื่องาน" />
              <span class="icon is-small is-left">
                <i class="fa fa-search"></i>
              </span>
            </div>
        </div>
      </div>

  <div class="box mb-3">
    <div class="table-container">
      <table class="table is-striped is-fullwidth is-size-7">
        <thead>
          <tr>
            <th>#</th>
          <th class="">
            <button class="button is-small is-white" @click="sortApplications('studentID')">
              <span class="has-text-grey">รหัสนักศึกษา </span>&nbsp;
              <i class="fa-solid fa-angles-up-down"></i>
            </button>
          </th>
          <th class="" @click="sortApplications('firstName')">
            <button class="button is-small is-white" >
              <span class="has-text-grey">ชื่อ-นามสกุล </span>&nbsp;
              <i class="fa-solid fa-angles-up-down"></i>
            </button>
          </th>
          <th @click="sortApplications('email')">
            <button class="button is-small is-white" >
              <span class="has-text-grey">อีเมล</span>&nbsp;
              <i class="fa-solid fa-angles-up-down"></i>
            </button>
          </th>
          <th @click="sortApplications('applications_count')">
            <button class="button is-small is-white" >
              <span class="has-text-grey">จำนวนงานที่สมัคร </span>&nbsp;
              <i class="fa-solid fa-angles-up-down"></i>
            </button>
          </th>

          <th  @click="sortApplications('academic_year')">
            <button class="button is-small is-white">
              <span class="px-5 has-text-grey">ปีการศึกษา </span>&nbsp;
              <i class="fa-solid fa-angles-up-down"></i>
            </button>
          </th>
          <th class="px-6 py-3 has-text-grey">Action</th>

        </tr>

        </thead>
        <tbody>
          <tr v-for="(student, index) in computedFilteredApplications" :key="student.user_id">

            <td>{{ index + 1 }}</td>
            <td>{{ student.studentID }}</td>
            <td>{{ student.firstName }} {{ student.lastName }}</td>
            <td>{{ student.email}}</td>
            <td>{{ student.applications_count}}</td>
            <td>{{ student.academic_year}}</td>
                        <td class="pl-6 pt-5 pb-1">
              <button class="button is-info" @click="viewStudentDetails(student.user_id)">
           ดูรายละเอียด
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
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
        <p class="is-size-7 has-text-grey-light">จากทั้งหมด {{ studentLists.length }} คน</p>
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
  </div>


</template>
<script>
import axios from "axios";
//import Swal from "sweetalert2";
import Papa from 'papaparse';
import * as XLSX from 'xlsx'
export default {
data() {

  return {
    studentLists:[],
    currentFilter: 'all',
    selectedStatus:'',
    itemsPerPage: 10,
    currentPage: 1,
    sortKey: 'job_title',
    sortOrder: 'desc',

    searchText:'',
  };
},
computed: {
  computedFilteredApplications() {
    let filtered = this.studentLists;

    // Filter ปีการศึกษา
    if (this.selectedStatus) {
      filtered = filtered.filter(
        student => student.academic_year === this.selectedStatus
      );
    }

    // Filter by search text
    if (this.searchText) {
      filtered = filtered.filter(student =>
        student.studentID.toLowerCase().includes(this.searchText.toLowerCase())
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
    totalApplicationsCount() {
    return this.applications.length;
  },
    studentsWithNoApplications() {
      return this.studentLists.filter(student => student.applications_count === 0).length;
    },

    studentsWithApplications() {
      return this.studentLists.filter(student => student.applications_count > 0).length;
    }
},
mounted() {
  this.getStudentLists()
},
methods: {
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
  viewStudentDetails(studentId) {
   // this.$router.push({ name: 'StudentDetails', params: { id: studentId } });
    this.$router.push("/studentDetail/" + studentId);
  },
  getStudentLists(){
    const token = localStorage.getItem("token");
    const config = {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    };
     axios
      .get("http://localhost:3000/admin/students/application-stats", config)
      .then((response) => {
        this.studentLists = response.data;
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
.filter_search{
  margin-top: 20px;
  margin-left: 10px;
}

.filter_searchbox{
 padding: 1rem;
 margin-top: 1rem;
 background-color: #eaeaea;
}
</style>
