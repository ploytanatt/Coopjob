<template>
  <div>
    <div class="columns">
      <div class="column ">
        <section class="hero is-info welcome is-small">
          <div class="hero-body">
            <div class="">
                <h1 class="title">
              คำร้องเรียน
                </h1>
                
            </div>
                    </div>
                </section>
                <section class="info-tiles mt-4">
                    <div class="tile is-ancestor has-text-centered">
                        <div class="tile is-parent is-2">
                            <article class="tile is-child box" style="background-color: #FFAF45;">
                                <p class="title">{{ reportLists[0].pending_report }} </p>
                                <p class="subtitle">รอการตรวจสอบ</p>
                            </article>
                        </div>
                        <div class="tile is-parent is-2">
                            <article class="tile is-child box " style="background-color: #9BCF53;">
                                <p class="title">{{ reportLists[0].processed_report}}</p>
                                <p class="subtitle">ตรวจสอบแล้ว</p>
                            </article>
                        </div>
                    </div>
                </section>

            <div class="field is-horizontal  ">
        <div class="field-body filter_searchbox field is-grouped  is-grouped-right ">
            <div class="filter_search select is-small">
              <select v-model="selectedStatus">
                <option value="">สถานะ</option>
                <option value="pending">pending</option>
                <option value="banned">banned</option>
                <option value="rejected">rejected</option>
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

          <th class="" @click="sortReports('firstName')">
            <button class="button is-small is-white" >
              <span class="has-text-grey">ชื่อ-นามสกุล </span>&nbsp;
              <i class="fa-solid fa-angles-up-down"></i>
            </button>
          </th>
          <th @click="sortReports('report_title')">
            <button class="button is-small is-white" >
              <span class="has-text-grey">หัวข้อการรายงาน</span>&nbsp;
              <i class="fa-solid fa-angles-up-down"></i>
            </button>
          </th>
          <th @click="sortReports('report_description')">
            <button class="button is-small is-white" >
              <span class="has-text-grey">คำอธิบาย </span>&nbsp;
              <i class="fa-solid fa-angles-up-down"></i>
            </button>
          </th>

          <th  @click="sortReports('date_posted')">
            <button class="button is-small is-white">
              <span class="px-5 has-text-grey">วันที่รายงาน</span>&nbsp;
              <i class="fa-solid fa-angles-up-down"></i>
            </button>
          </th>

          <th  @click="sortReports('job_status')">
            <button class="button is-small is-white">
              <span class="px-5 has-text-grey">สถานะ</span>&nbsp;
              <i class="fa-solid fa-angles-up-down"></i>
            </button>
          </th>
          <th class="px-6 py-3 has-text-grey">Action</th>

        </tr>
        </thead>
        
        <tbody>
          <tr v-for="(report, index) in computedFilteredReports" :key="report.report_id">

            <td>{{ index + 1 }}</td>
            <td>{{ report.firstName }} {{ report.lastName }}</td>
            <td>{{ report.report_title}}</td>
            <td>{{ report.report_description}}</td>
            <td>{{ formatDate(report.date_posted)}}</td>
            <td class="pl-5 pt-5 pb-1">
                <span :class="{
                'tag': true, 
                'is-warning':report.report_status === 'pending', 
                'is-danger':report.report_status === 'banned',
                'is-danger':report.report_status === 'rejected',
                 }"> 
                {{ report.report_status }} </span>
              </td>
            <td class="pl-6 pt-5 pb-1">
              <button class="button is-info" @click="viewReportDetails(report.report_id)">
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
        <p class="is-size-7 has-text-grey-light">จากทั้งหมด {{ reportLists.length }} รายการ</p>
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
export default {
data() {

  return {
    reportLists:[],
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
  computedFilteredReports() {
    let filtered = this.reportLists;

    // Filter ปีการศึกษา
    if (this.selectedStatus) {
      filtered = filtered.filter(
        report => report.report_status === this.selectedStatus
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
  computedPaginatedReports() {
    const startIndex = (this.currentPage - 1) * this.itemsPerPage;
    const endIndex = startIndex + this.itemsPerPage;
    return this.computedFilteredReports.slice(startIndex, endIndex);
  },
  totalPages() {
    return Math.ceil(
      this.computedFilteredReports.length / this.itemsPerPage
    );
  },
    totalReportsCount() {
    return this.applications.length;
  },
},
mounted() {
  this.getReportList()
},
methods: {
  viewReportDetails(reportId) {
   // this.$router.push({ name: 'StudentDetails', params: { id: reportId } });
    this.$router.push("/reportDetail/" + reportId);
  },
  getReportList(){
    const token = localStorage.getItem("token");
    const config = {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    };
     axios
      .get("http://localhost:3000/admin/ReportList", config)
      .then((response) => {
        this.reportLists = response.data;
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
  sortReports(key) {
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

</style>
