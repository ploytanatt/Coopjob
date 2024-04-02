<template>
    <div class="">
      <div class="columns">
        <sideMenu></sideMenu>
        <div class="column is-4">
          <div class="report-details card mt-4">
          <router-link :to="'/reportList'" >
          <button class="button is-dark go-back-button">
            <i class="fa-solid fa-left-long"></i> 
           </button>
           </router-link>
              <h1 class="title">รายละเอียดคำร้องเรียน</h1>
              <div class="details">
              <h1>#{{ report.report_id }}</h1>
                <p><strong>ชื่อผู้รายงาน:</strong> {{ report.firstName }} {{ report.lastName }}</p>
                <p><strong>วันที่รายงาน:</strong> {{ formatDate(report.report_created_at) }}</p>
                <p><strong>หัวข้อการรายงาน:</strong> {{ report.report_title }}</p>
                <p><strong>คำอธิบาย:</strong> {{ report.report_description }}</p>
              </div>
            </div>
        </div>
              <!-- Right Column: Job Summary and Apply Button -->
      <div class="column is-5 mt-4">
                   <div class="job-card card mt-4">
            <div class="job-card-header">
              <router-link :to="'/company/' + report.user_id">
                <button class="button is-info"><i class="fa-sharp fa-solid fa-building"> ตรวจสอบบริษัท</i> </button>
              </router-link>
              <router-link :to="'/job/' + report.job_id">
                <button class="button is-info">ตรวจสอบงาน</button>
              </router-link>
              
            </div>
            <hr>
            <p>{{ report.reviewComment }}</p>
            <div class="job-card-body mt-3">
              <router-link :to="'/company/' + report.user_id">
                <div class="card mt-3 mb-3 ml-0 p-0 columns company_card">
                  <div class="column is-4 m-0">
                    <img :src="imagePath(report.profile_image)" alt="Company Logo" class="CompanyLogo">
                  </div>
                  <div class="column m-0">
                    <p class="job-role">{{ report.company_name }}</p>
                    <p class="job-details">{{ report.job_title }}</p>
                  </div>
                </div>
                
              </router-link>
             
            </div>
            
            <div class="job-card card mt-4">
            <div class="job-card-header">
              <h1>Action</h1>
            </div>
            <hr>
         
            <div class="job-card-body mt-3">
              <div class="radio-buttons">
                <input type="radio" id="ban" value="ban" v-model="selectedAction">
                <label for="ban">Ban Company</label>
                <input type="radio" id="reject" value="reject" v-model="selectedAction">
                <label for="reject">Reject Case</label>
              </div>
              <button class="button is-success is-small mt-2 mr-2" @click="confirmAction">ยืนยัน</button>
            
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
import Swal from "sweetalert2";
export default {
    components:{
        sideMenu
    },
  data() {
    return {
      report: null,
      applications:[],
      currentFilter: 'all',
    selectedStatus:'',
    selectedJobType:'',
    itemsPerPage: 5,
    currentPage: 1,
    sortKey: 'job_title',
    sortOrder: 'desc',
    searchText:'',
     selectedAction: ''
    };
  },
  created() {
    this.fetcReportDetails();
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
    fetcReportDetails() {
      const reportId = this.$route.params.id;
      axios.get(`http://localhost:3000/admin/ReportDetail/${reportId}`)
        .then(response => {
          this.report = response.data;
        })
        .catch(error => {
          console.error('Error fetching report details:', error);
        });
    },
    fetchStudentJob() {
      const reportId = this.$route.params.id;
      axios.get(`http://localhost:3000/admin/reportApplications/${reportId}`)
        .then(response => {
          this.applications = response.data;
        })
        .catch(error => {
          console.error('Error fetching report details:', error);
        });
    },
    formatDate(date) {
    return new Date(date).toLocaleDateString()
  },

  confirmAction() {
      if (this.selectedAction === 'ban') {
        this.banCompany();
      } else if (this.selectedAction === 'reject') {
        this.rejectCase();
      }
    },
     async banCompany() {
        const companyId = this.report.user_id;
        const reportId = this.report.report_id;
        const result = await Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, ban it!'
        });

        if (result.isConfirmed) {
            axios.put(`http://localhost:3000/admin/closeCompany`, { companyId , reportId})
                .then(response => {
                    Swal.fire('Banned!', 'The company has been banned.', 'success');
                    console.log(response);
                })
                .catch(error => {
                    Swal.fire('Error!', 'The company could not be banned.', 'error');
                    console.log(error);
                });
        }
    },

    async rejectCase() {
        const reportId = this.report.report_id;
        const result = await Swal.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, reject it!'
        });

        if (result.isConfirmed) {
            axios.put(`http://localhost:3000/admin/rejectReport`, { reportId })
                .then(response => {
                    Swal.fire('Rejected!', 'The case has been rejected.', 'success');
                    console.log(response);
                })
                .catch(error => {
                    Swal.fire('Error!', 'The case could not be rejected.', 'error');
                    console.log(error);
                });
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

.report-details {
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



.job-card {
  background-color: #F8F8FD;
  border-radius: 6px;
  padding: 16px;
  box-shadow: 0 2px 4px #0000002d;
  
  margin-right: 16px;
  margin-bottom: 16px; 
  width: 380px; 
}

.job-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px; 
}

.job-title {
  font-weight: bold;
  color: #333;
}

.job-date {
  color: #666; 
  font-size: 0.875rem;
}

.job-card-body p {
  margin: 0;
  color: #333; 
}

.job-role {
  font-size: 1.125rem;
  font-weight: bold;
  margin-bottom: 4px;
}

.job-details {
  font-size: 0.875rem;
  color: #666; 
}

hr {
  border: none;
  height: 1px;
  background-color: #ddd; 
  margin-bottom: 8px; 
}

.CompanyLogo{
width: 100px;
border: 1px solid rgb(240, 240, 240);
border-radius: 5px;
transition: width 0.3s ease-in-out;
}

.stars .fa {
  color: #ccc; /* Default star color */
}

.stars .fa.is-rated {
  color: gold; /* Active star color (when rated) */
}
.fa-star:hover {
  transform: scale(1.5);
}

.rating-text{
    color: rgba(255, 217, 0, 0.908);
}
</style>
