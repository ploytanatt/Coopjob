<template>
  <div>
    <div class="columns">
      <div class="column ">
        <section class="hero is-info welcome is-small">
          <div class="hero-body">
            <div class="">
                <h1 class="title">
               รายชื่อบริษัททั้งหมด
                </h1>
            </div>
            </div>
        </section>
        <section class="info-tiles mt-4">
          <label>Top 3 บริษัทที่รับนักศึกษามากที่สุด</label>
          <div class="tile is-ancestor has-text-centered">
            <div v-for="(company, index) in topThreeCompanies" :key="company.company_name" class="tile is-parent is-3">
              <article class="tile is-child box" style="background-color: #A6E3E9;">
                <p class="title">#{{ index + 1 }} {{ company.company_name }}</p>
                <p class="subtitle">จำนวนการรับสมัครงาน {{ company.approve_applications }} คน</p>
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
                <option value="">สถานะ</option>
                <option value="open">open</option>
                <option value="close">close</option>
              </select>
            </div>
            <div class="filter_search control has-icons-left">
              <input v-model="searchText" class="input is-small" type="text" placeholder="ค้นหาจากชื่อบริษัท" />
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
              <button class="button is-small is-white" @click="sortApplications('company_name')">
                <span class="has-text-grey">ชื่อบริษัท</span>&nbsp;
                <i class="fa-solid fa-angles-up-down"></i>
              </button>
            </th>
            <th class="" @click="sortApplications('total_jobs')">
              <button class="button is-small is-white" >
                <span class="has-text-grey">งานทั้งหมด </span>&nbsp;
                <i class="fa-solid fa-angles-up-down"></i>
              </button>
            </th>
            <th @click="sortApplications('total_applications')">
              <button class="button is-small is-white" >
                <span class="has-text-grey">สรุปผลการสมัคร</span>&nbsp;
                <i class="fa-solid fa-angles-up-down"></i>
              </button>
            </th>
            <th @click="sortApplications('average_rating')">
              <button class="button is-small is-white" >
                <span class="has-text-grey">Rating </span>&nbsp;
                <i class="fa-solid fa-angles-up-down"></i>
              </button>
            </th>

            <th  @click="sortApplications('status')">
              <button class="button is-small is-white">
                <span class="px-5 has-text-grey">สถานะ </span>&nbsp;
                <i class="fa-solid fa-angles-up-down"></i>
              </button>
            </th>
            <th class="px-6 py-3 has-text-grey">Action</th>
          </tr>
          </thead>
          <tbody>
            <tr v-for="(company, index) in computedPaginatedApplications" :key="company.company_id">
              <td>{{ index + 1 }}</td>
              <td>
                <router-link :to="'/company/' + company.user_id">
                  <img :src="imagePath(company.profile_image)" alt="Company Logo" class="CompanyLogo">
                  <p>{{ company.company_name }}</p>
              </router-link>
            </td>
              <td>{{ company.total_jobs }}</td>
              <td>จำนวนคนสมัคร: {{ company.total_applications }} จำนวนที่รับแล้ว: {{ company.approve_applications }}</td>
            <td>
              <span v-for="n in Math.floor(company.average_rating)" :key="n" class="fa fa-star checked"></span>
              <span v-if="company.average_rating % 1 > 0" class="fa fa-star-half-alt checked"></span>
              <span v-for="n in 5 - Math.ceil(company.average_rating)" :key="n" class="fa fa-star"></span>
              {{company.average_rating }}
            </td>
              <td class="pl-5 pt-5 pb-1">
                <span :class="{
                'tag': true, 
                'is-success':company.status === 'open', 
                'is-danger':company.status === 'close', }"> 
                {{ company.status }} </span>
              </td>
              <td class="pl-6 pt-5 pb-1">
                <button class="button is-info" @click="viewcompanyDetails(company.user_id)"><i class="fa-solid fa-eye"> ดูรายละเอียด</i></button>
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
        <p class="is-size-7 has-text-grey-light">จากทั้งหมด {{ companyLists.length }} คน</p>
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
    companyLists:[],
    top3company:[],
    without_applications:[],
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
    let filtered = this.companyLists;


    // Filter สถานะบริษัท
    if (this.selectedStatus) {
      filtered = filtered.filter(
        company => company.status === this.selectedStatus
      );
    }

    // Filter by search text
    if (this.searchText) {
      filtered = filtered.filter(company =>
        company.company_name.toLowerCase().includes(this.searchText.toLowerCase())
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
   topThreeCompanies() {
     return [...this.companyLists]
      .sort((a, b) => b.total_applications - a.total_applications)
      .slice(0, 3);
  
  }
    
},
mounted() {
  this.getCompanyLists()

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
  viewcompanyDetails(companyId) {
   // this.$router.push({ name: 'StudentDetails', params: { id: studentId } });
    this.$router.push("/companyDetail/" + companyId);
  },
  getCompanyLists(){
    const token = localStorage.getItem("token");
    const config = {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    };
     axios
      .get("http://localhost:3000/admin/companyList", config)
      .then((response) => {
        this.companyLists = response.data;
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
  text-align: center;
  vertical-align: middle; 
}
.CompanyLogo{
width: 50px;
border: 1px solid rgb(240, 240, 240);
border-radius: 5px;
transition: width 0.3s ease-in-out;
}
.CompanyLogo:hover{
width: 80px;
}
.checked {
  color: gold;
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
