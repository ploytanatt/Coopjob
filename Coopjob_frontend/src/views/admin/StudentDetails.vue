<template>
    <div class="">
      <div class="columns">
        <sideMenu></sideMenu>
        <div class="column is-9">
    <div class="student-details card mt-4">
      <router-link :to="'/studentList'" >
         <button class="button is-dark go-back-button">
           <i class="fa-solid fa-left-long"></i> 
         </button>
      </router-link>
    <h1 class="title">รายละเอียดของนักศึกษา</h1>
    <div class="details">
      <p><strong>ปีการศึกษา:</strong> {{ student.academic_year }}</p>
      <p><strong>รหัสนักศึกษา:</strong> {{ student.studentID }}</p>
      <p><strong>ชื่อ-นามสกุล:</strong> {{ student.firstName }} {{ student.lastName }}</p>
      <p><strong>เพศ:</strong> {{ student.gender }}</p>
      <p><strong>ที่อยู่:</strong> {{ student.address }}</p>
      <p><strong>อีเมล:</strong> {{ student.email }}</p>
      <p><strong>โทรศัพท์:</strong> {{ student.phone_number }}</p>
    </div>
  </div>
            
            <div class=" my-4">
               <section class="hero is-dark welcome is-small">
                  <div class="hero-body">
                  
                      <p class="is-size-3">
                        จำนวนงานที่สมัครทั้งหมด: {{ applications.length }} รายการ
                      </p>       
                  </div>
                </section>
                <div class="field is-horizontal mt-3  card">
                
                  <div class="field-body filter_searchbox field is-grouped  is-grouped-right ">
                  <div class="filter_search select is-small">
                        <select v-model="selectedJobType">
                          <option value="">รูปแบบงาน</option>
                          <option value="internship">internship</option>
                          <option value="cooperative">cooperative</option>
                        </select>
                      </div>
                      <div class="filter_search select is-small">
                        <select v-model="selectedStatus">
                          <option value="">สถานะ</option>
                          <option value="pending">Pending</option>
                          <option value="approve">Approve</option>
                          <option value="Declined">Declined</option>
                          <option value="canceled">canceled</option>
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
                              <span class="has-text-grey">ชื่อบริษัท </span>&nbsp;
                              <i class="fa-solid fa-angles-up-down"></i>
                            </button>
                          </th>
                          <th class="">
                            <button class="button is-small is-white" @click="sortApplications('job_title')">
                              <span class="has-text-grey">ชื่องาน </span>&nbsp;
                              <i class="fa-solid fa-angles-up-down"></i>
                            </button>
                          </th>
                          <th>
                            <button class="button is-small is-white" @click="sortApplications('job_type')">
                              <span class="has-text-grey">รูปแบบงาน </span>&nbsp;
                              <i class="fa-solid fa-angles-up-down"></i>
                            </button>
                          </th>
                          <th>
                            <button class="button is-small is-white" @click="sortApplications('email')">
                              <span class="has-text-grey">อีเมล </span>&nbsp;
                              <i class="fa-solid fa-angles-up-down"></i>
                            </button>
                          </th>

                          <th>
                            <button class="button is-small is-white" @click="sortApplications('application_status')">
                              <span class="has-text-grey">สถานะ </span>&nbsp;
                              <i class="fa-solid fa-angles-up-down"></i>
                            </button>
                          </th>
                          <th>
                            <button class="button is-small is-white" @click="sortApplications('applied_datetime')">
                              <span class="px-5 has-text-grey">วันที่สมัคร </span>&nbsp;
                              <i class="fa-solid fa-angles-up-down"></i>
                            </button>
                          </th>
                  
                        </tr>

                        </thead>
                        <tbody>
                          <tr v-for="(application, index) in computedPaginatedApplications" :key="application.application_id">

                            <td>{{ index + 1 }}</td>
                            <td>
                              <router-link :to="'/company/' + application.user_id">
                                <img :src="imagePath(application.profile_image)" alt="Company Logo" class="CompanyLogo">
                                <p>{{ application.company_name }}</p>
                            </router-link>
                          </td>
                            <td class="pl-5 pt-5 pb-1"><router-link :to="'/job/' + application.job_id" >{{ application.job_title }}</router-link></td>
                            <td class="pl-5 pt-5 pb-1">{{ application.job_type }}</td>
                            <td class="pl-5 pt-5 pb-1">{{ application.email }}</td>

                            <td class="pl-5 pt-5 pb-1">
                              <span :class="{
                              'tag': true, 
                              'is-warning': application.application_status === 'pending', 
                              'is-success': application.application_status === 'approve', 
                              'is-danger': application.application_status === 'declined',
                              'is-info': application.application_status === 'canceled', 
                            }">
                            {{ application.application_status }}
                            </span>
                            </td>
                            <td class="pl-6 pt-5 pb-1">{{ formatDate(application.applied_datetime) }}</td>

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
      student: null,
      applications:[],
      currentFilter: 'all',
    selectedStatus:'',
    selectedJobType:'',
    itemsPerPage: 5,
    currentPage: 1,
    sortKey: 'job_title',
    sortOrder: 'desc',
    searchText:'',
    };
  },
  created() {
    this.fetchStudentDetails();
    this.fetchStudentJob();
  },
  computed: {
  computedFilteredApplications() {
    let filtered = this.applications;

    // Filter by status
    if (this.selectedStatus) {
      filtered = filtered.filter(
        application => application.application_status === this.selectedStatus
      );
    }

    //Filter ny job type
    if (this.selectedJobType){
      filtered = filtered.filter(
        application => application.job_type === this.selectedJobType
      )
    }
    // Filter by search text
    if (this.searchText) {
      filtered = filtered.filter(application =>
        application.job_title.toLowerCase().includes(this.searchText.toLowerCase())
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
},
  methods: {
    fetchStudentDetails() {
      const studentId = this.$route.params.id;
      axios.get(`http://localhost:3000/admin/studentDetail/${studentId}`)
        .then(response => {
          this.student = response.data;
        })
        .catch(error => {
          console.error('Error fetching student details:', error);
        });
    },
    fetchStudentJob() {
      const studentId = this.$route.params.id;
      axios.get(`http://localhost:3000/admin/studentApplications/${studentId}`)
        .then(response => {
          this.applications = response.data;
        })
        .catch(error => {
          console.error('Error fetching student details:', error);
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
  sortApplications(key) {
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
width: 50px;
border: 1px solid rgb(240, 240, 240);
border-radius: 5px;
transition: width 0.3s ease-in-out;
}
.CompanyLogo:hover{
width: 80px;
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
</style>
