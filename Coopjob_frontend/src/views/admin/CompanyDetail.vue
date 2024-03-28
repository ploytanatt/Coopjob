<template>
    <div class="">
      <div class="columns">
        <sideMenu></sideMenu>
        <div class="column is-9">
          <div class="student-details card mt-4">
          <router-link :to="'/companyList'" >
            <button class="button is-dark go-back-button">
              <i class="fa-solid fa-left-long"></i> 
            </button>
          </router-link>
            <h1 class="title">รายละเอียดของบริษัท</h1>
            <div class="details">
             <router-link :to="'/company/' + company.user_id">
                  <img :src="imagePath(company.profile_image)" alt="Company Logo" class="CompanyLogo">
                  <h1>{{ company.company_name }}</h1>
              </router-link>
             <!-- <p><strong>ชื่อบริษัท:</strong> {{ company.company_name }}</p>-->
              <!-- <p><strong>อีเมล:</strong> {{ company.email }}</p> -->
              <!-- แสดงข้อมูลอื่นๆ ตามที่ต้องการ -->
            </div>
          </div>

            
            <div class=" my-4">
               <section class="hero is-dark welcome is-small">
                  <div class="hero-body">
                  
                      <p class="is-size-3">
                        จำนวนงานที่สมัครทั้งหมด: {{ jobs.length }} รายการ
                      </p>       
                  </div>
                </section>
                <div class="field is-horizontal mt-3  card">
                  <div class="field-body filter_searchbox field is-grouped  is-grouped-right ">
                      <div class="filter_search select is-small">
                        <select v-model="selectedStatus">
                          <option value="">สถานะ</option>
                          <option value="open">open</option>
                          <option value="close">close</option>
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
                            <button class="button is-small is-white" @click="sortJobs('job_title')">
                              <span class="has-text-grey">ตำแหน่ง </span>&nbsp;
                              <i class="fa-solid fa-angles-up-down"></i>
                            </button>
                          </th>
                          <th class="">
                            <button class="button is-small is-white" @click="sortJobs('job_type')">
                              <span class="has-text-grey">ประเภทงาน </span>&nbsp;
                              <i class="fa-solid fa-angles-up-down"></i>
                            </button>
                          </th>
                          <th>
                            <button class="button is-small is-white" @click="sortJobs('salary')">
                              <span class="has-text-grey">ค่าตอบแทน บาท/วัน </span>&nbsp;
                              <i class="fa-solid fa-angles-up-down"></i>
                            </button>
                          </th>
                          <th>
                            <button class="button is-small is-white" @click="sortJobs('email')">
                              <span class="has-text-grey">สรุปผลการสมัคร </span>&nbsp;
                              <i class="fa-solid fa-angles-up-down"></i>
                            </button>
                          </th>

                          <th>
                            <button class="button is-small is-white" @click="sortJobs('Job_status')">
                              <span class="has-text-grey">สถานะ </span>&nbsp;
                              <i class="fa-solid fa-angles-up-down"></i>
                            </button>
                          </th>
                          <th>
                            <button class="button is-small is-white">
                              <span class="px-5 has-text-grey">Action </span>&nbsp;
                              
                            </button>
                          </th>
                  
                        </tr>

                        </thead>
                        <tbody>
                          <tr v-for="(job, index) in computedPaginatedJobs" :key="job.job_id">

                            <td>{{ index + 1 }}</td>
                            <td>{{ job.job_title }} </td>
                            <td>{{ job.job_type }} </td>
                            <td class="pl-5 pt-5 pb-1">{{ job.salary}}</td>
                            <td class="pl-5 pt-5 pb-1">จำนวนการสมัคร: {{ job.total_applications}} จำนวนที่รับแล้ว: {{ job.approve_applications }}</td>

                            <td class="pl-5 pt-5 pb-1">
                              <span :class="{
                              'tag': true, 
                              'is-success': job.job_status === 'open', 
                              'is-danger': job.job_status === 'close',
                            }">
                            {{ job.job_status }}
                            </span>
                            </td>
                            <td>
                            <router-link :to="'/job/' + job.job_id">
                            <button class="button is-info mr-2"><i class="fa-solid fa-eye "> </i></button></router-link>
                            <button class="button is-info" @click="viewcompanyDetails(company.user_id)"><i class="fa-solid fa-pen-to-square"></i></button>
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
                            <option :value="5">5</option>
                            <option :value="10">10</option>
                            <option :value="20">20</option>
                            <option :value="50">50</option>
                          </select>
                        </div>
                        <p class="is-size-7 has-text-grey-light">จากทั้งหมด {{ jobs.length }} รายการ</p>
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
    </div>
</template>
  
<script>
import axios from 'axios';
import sideMenu from '@/components/admin/side-menu.vue';
export default {
    components:{
        sideMenu
    },
  data() {
    return {
     company: null,
      jobs:[],
      currentFilter: 'all',
    selectedStatus:'',
    itemsPerPage: 5,
    currentPage: 1,
    sortKey: 'job_title',
    sortOrder: 'desc',
    searchText:'',
    };
  },
  created() {
    this.fetchCompanyDetails();
    this.fetchCompanyJob();
  },
  computed: {
  computedFilteredJobs() {
    let filtered = this.jobs;

    // Filter by status
    if (this.selectedStatus) {
      filtered = filtered.filter(
        job => job.job_status === this.selectedStatus
      );
    }

    // Filter by search text
    if (this.searchText) {
      filtered = filtered.filter(job =>
        job.job_title.toLowerCase().includes(this.searchText.toLowerCase())
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
  computedPaginatedJobs() {
    const startIndex = (this.currentPage - 1) * this.itemsPerPage;
    const endIndex = startIndex + this.itemsPerPage;
    return this.computedFilteredJobs.slice(startIndex, endIndex);
  },
  totalPages() {
    return Math.ceil(
      this.computedFilteredJobs.length / this.itemsPerPage
    );
  },
  totalApplicationsCount() {
  return this.jobs.length;
},
},
  methods: {
    fetchCompanyDetails() {
      const companyId = this.$route.params.id;
      axios.get(`http://localhost:3000/admin/companyDetail/${companyId}`)
        .then(response => {
          this.company = response.data;
        })
        .catch(error => {
          console.error('Error fetching company details:', error);
        });
    },
    fetchCompanyJob() {
      const companyId = this.$route.params.id;
      axios.get(`http://localhost:3000/admin/companyJobs/${companyId}`)
        .then(response => {
          this.jobs = response.data;
        })
        .catch(error => {
          console.error('Error fetching company jobs:', error);
        });
    },
    formatDate(date) {
    return new Date(date).toLocaleDateString()
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
  sortJobs(key) {
  if (this.sortKey === key) {
    this.sortOrder = this.sortOrder === 'asc' ? 'desc' : 'asc';
  } else {
    this.sortKey = key;
    this.sortOrder = 'asc';
  }
},
  imagePath(companyProfileImage) {
    if (companyProfileImage) {
      return "http://localhost:3000" + companyProfileImage.replace(/\\/g, '/').replace('static', '');
    } else {
      return "https://bulma.io/images/placeholders/640x360.png";
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
.CompanyLogo{
width: 80px;
border: 1px solid rgb(240, 240, 240);
border-radius: 5px;
transition: width 0.3s ease-in-out;
}
.CompanyLogo:hover{
width: 100px;
}

.student-details {
  max-width: 600px;
  padding: 20px;
  border-radius: 5px;
  background-color:rgb(255, 255, 255)9;
}

.title {
  text-align: center;
  color: #333;
  margin-bottom: 20px;
}

.details p {
  margin: 10px 0;
  line-height: 1.6;
  color: #555;
}

.details p strong {
  color: #333;
  margin-right: 5px;
}
.columns{
    background-color: #e3f8ff;
}

.table td, .table th {
  text-align: center; /* จัดให้ข้อความอยู่ตรงกลาง */
  vertical-align: middle; /* จัดให้ข้อความอยู่กลางแนวตั้ง */
}
</style>
