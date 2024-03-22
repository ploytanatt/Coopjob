<template>
  <div>
    <div class="columns">
      <div class="column ">
        <section class="hero is-info welcome is-small">
          <div class="hero-body">
            <div class="">
                <h1 class="title">
              ผลการสมัครของนักศึกษา
                </h1>
            </div>
                    </div>
                </section>
                <section class="info-tiles mt-4">
                    <div class="tile is-ancestor has-text-centered">
                        <div class="tile is-parent is-2">
                            <article class="tile is-child box" style="background-color: #9BB0C1;">
                                <p class="title">{{ totalInternCount}} </p>
                                <p class="subtitle">ฝึกงาน</p>
                            </article>
                        </div>
                        <div class="tile is-parent is-2">
                            <article class="tile is-child box " style="background-color: #A8CD9F;">
                                <p class="title">{{ totalCoopCount}}</p>
                                <p class="subtitle">สหกิจศึกษา</p>
                            </article>
                        </div>
                    </div>
                </section>

            <div class="field is-horizontal  ">
        <div class="field-body filter_searchbox field is-grouped  is-grouped-right ">
                    <div class="filter_search select is-small mr-2">
              <select v-model="selectedJobType">
                <option value="">รูปแบบงาน</option>
                <option value="internship">internship</option>
                <option value="cooperative">cooperative</option>
              </select>
            </div>
            <div class="filter_search select is-small  mr-2">
              <select v-model="selectedStatus">
                <option value="">สถานะ</option>
                <option value="pending">pending</option>
                <option value="approve">approve</option>
                <option value="declined">declined</option>
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
              <button class="button is-small is-white" @click="sortApplications('company_name')">
                <span class="has-text-grey">ชื่อบริษัท</span>&nbsp;
                <i class="fa-solid fa-angles-up-down"></i>
              </button>
            </th>

            <th class="" @click="sortApplications('job_title')">
              <button class="button is-small is-white" >
                <span class="has-text-grey">ตำแหน่ง </span>&nbsp;
                <i class="fa-solid fa-angles-up-down"></i>
              </button>
            </th>

          <th @click="sortApplications('job_type')">
            <button class="button is-small is-white" >
              <span class="has-text-grey">รูปแบบงาน</span>&nbsp;
              <i class="fa-solid fa-angles-up-down"></i>
            </button>
          </th>

          <th class="" @click="sortApplications('firstName')">
            <button class="button is-small is-white" >
              <span class="has-text-grey">ชื่อผู้สมัคร </span>&nbsp;
              <i class="fa-solid fa-angles-up-down"></i>
            </button>
          </th>
          
          <th @click="sortApplications('applied_datetime')">
            <button class="button is-small is-white" >
              <span class="has-text-grey">วันที่สมัคร </span>&nbsp;
              <i class="fa-solid fa-angles-up-down"></i>
            </button>
          </th>

          <th  @click="sortApplications('job_status')">
            <button class="button is-small is-white">
              <span class="px-5 has-text-grey">สถานะ</span>&nbsp;
              <i class="fa-solid fa-angles-up-down"></i>
            </button>
          </th>
         
        </tr>

        </thead>
        <tbody>
          <tr v-for="(application, index) in computedFilteredApplications" :key="application.application_id">

            <td>{{ index + 1 }}</td>
                          <td>
                <router-link :to="'/company/' + application.user_id">
                  <img :src="imagePath(application.profile_image)" alt="Company Logo" class="CompanyLogo">
                  <p>{{ application.company_name }}</p>
              </router-link>
            </td>
             <td>{{ application.job_title }}</td>
             <td>{{ application.job_type}}</td>
            <td>{{ application.firstName }} {{ application.lastName }}</td>
            
            <td>{{ formatDate(application.applied_datetime)}}</td>
            <td class="pl-5 pt-5 pb-1">
                <span :class="{
                'tag': true, 
                'is-success':application.application_status === 'approve',
                'is-warning':application.application_status === 'pending', 
                'is-dark':application.application_status === 'canceled',
                'is-danger':application.application_status === 'declined',
                 }"> 
                {{ application.application_status }} </span>
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
  </div>


</template>
<script>
import axios from "axios";
//import Swal from "sweetalert2";
export default {
data() {

  return {
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
.CompanyLogo:hover{
width: 80px;
}
</style>
