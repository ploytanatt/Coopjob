<template>
    <div class="">
      <div class="columns">
        <sideMenu></sideMenu>
        <div class="column is-4">
          <div class="report-details card mt-4">
          <router-link :to="'/BenefitResult'">
         
          <button class="button is-dark go-back-button">
                          <i class="fa-solid fa-left-long"></i> 
                        </button>

           </router-link>
              <h1 class="title">สรุปค่าแรงและบริษัท</h1>
             <div class="mt-4 card column" id="benefit_form">
      <section class="hero is-dark welcome is-small">
      </section>
      <div class="">
        <div class="job-card-header">
          
          <span class=""> <p>{{ report.studentID }}</p>{{ report.firstName }} {{ report.lastName }}</span>
          
          <span class="job-date">{{ formatDate(report.created_at) }}</span>
        </div>
        <hr>
        <fieldset :disabled="!modify_benefit">
          <div class="job-card-body mt-3">
            <div class="field">
              <label class="label">ชื่อบริษัท</label>
              <div class="control">
                {{ report.company_name }}
              </div>
            </div>

            <div class="field">
              <label class="label">ตำแหน่ง</label>
              <div class="control">
                {{ report.job_title }}
              </div>
            </div>

            <div class="field">
              <label class="label">คำอธิบาย</label>
              <div class="control">
                {{ report.description }}
              </div>
            </div>

            <div class="field">
              <label class="label">ค่าตอบแทน</label>
              <div class="control">
                <div class="field has-addons">
                  <div class="control">
                  
                  </div>
                  <div class="control">
                  
                    <a class="button is-static"> {{ report.salary }} บาท/วัน</a>
                  </div>
                </div>
              </div>
            </div>

            <div class="field">
              <label class="label">สวัสดิการ</label>
              <div class="control">
                {{ report.benefit }}
              </div>
            </div>
          </div>
        </fieldset>
      </div>
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
    };
  },
  created() {
    this.fetcReportDetails();
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
      const benefitId = this.$route.params.id;
      axios.get(`http://localhost:3000/admin/BenefitDetail/${benefitId}`)
        .then(response => {
          this.report = response.data;
        })
        .catch(error => {
          console.error('Error fetching report details:', error);
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
