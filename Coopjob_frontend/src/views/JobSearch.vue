<template>
    <div class="main-content">
      <div class="container">
        <div class="columns">
          <!-- Search tab -->
     
          <!-- Job section -->
          <div class="column is-6">
            <div class="rows">
              <div v-for="job in filteredJobs" :key="job.job_id" class="column" @click="goToJobDetails(job.job_id)">
                <div class="card">
                  <div class="card-content">
                    <div class="media">
                      <div class="media-left">
                        <figure class="image is-48x48">
                          <img :src="imagePath(job.company.profile_image)" alt="Company Logo">
                        </figure>
                      </div>
                      <div class="media-content">
                        <p>
                          <strong>{{ job.job_title }}</strong>
                        </p>
                        <p>
                          <small>{{ job.company.company_name }}</small>
                        </p>
                        <span class="tag is-normal">{{ job.job_type }}</span>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <!-- Pagination Controls for Jobs -->
            <nav class="pagination" role="navigation" aria-label="pagination">
              <a class="pagination-previous" @click="currentPageJobs = Math.max(1, currentPageJobs - 1)" :disabled="currentPageJobs === 1">Previous</a>
              <a class="pagination-next" @click="currentPageJobs = Math.min(totalPagesJobs, currentPageJobs + 1)" :disabled="currentPageJobs === totalPagesJobs || jobs.length === 0">Next page</a>
              <ul class="pagination-list">
                <li v-for="page in totalPagesJobs" :key="page">
                  <a class="pagination-link" @click="currentPageJobs = page" :class="{ 'is-current': currentPageJobs === page }">
                    {{ page }}
                  </a>
                </li>
              </ul>
            </nav>
            </div>
            
  
            
          </div>

          <div class="column is-3">
            <div class="searchtab">
              <div class="field">
                <div class="control">
                  <label class="radio">
                    <input type="radio" name="question">
                    ฝึกงาน
                  </label>
                  <label class="radio">
                    <input type="radio" name="question">
                    สหกิจศึกษา
                  </label>
                </div>
              </div>
            <div class="card">
                <p>sad</p>
            </div>
            </div>
          </div>
        </div>
  
        <footer class="footer">
          <div class="content has-text-centered">
            <p>&copy;</p>
          </div>
        </footer>
      </div>
    </div>
</template>
  
  <script>
  import axios from "axios";
  
  export default {
    data() {
      return {
        companies: [],
        jobs: [],
        perPage: 4,
        currentPageCompanies: 1,
        currentPageJobs: 1,
        activeTab: 'all',
      };
    },
    computed: {
      filteredJobs() {
      return this.jobs.filter(job => job.status === 'open' && (this.activeTab === 'all' || job.job_type === this.activeTab));
    },
      paginatedCompanies() {
        const start = (this.currentPageCompanies - 1) * this.perPage;
        const end = start + this.perPage;
        return this.companies.slice(start, end);
      },
      totalPagesCompanies() {
        return Math.ceil(this.companies.length / this.perPage);
      },
      paginatedJobs() {
        const start = (this.currentPageJobs - 1) * this.perPage;
        const end = start + this.perPage;
        return this.jobs.slice(start, end);
      },
      totalPagesJobs() {
        return Math.ceil(this.jobs.length / this.perPage);
      },
    },
    created() {
      this.getCompanies();
      this.getJobs();
    },
    methods: {
      getCompanies() {
        axios
          .get("http://localhost:3000/recruiter/getRecruiter")
          .then((response) => {
            this.companies = response.data;
          })
          .catch((error) => {
            console.error(error);
          });
      },
      // ใน methods
      getJobs() {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
  
      axios
        .get("http://localhost:3000/recruiter/getAllJobs", config)
        .then((res) => {
          // เพิ่มข้อมูลบริษัทลงในข้อมูลงาน
          this.jobs = res.data.map(job => {
            return {
              ...job,
              company: this.companies.find(company => company.user_id === job.user_id)
            };
          });
        })
        .catch((error) => {
          console.log(error);
        });
    },
      imagePath(companyProfileImage) {
        if (companyProfileImage) {
          return "http://localhost:3000" + companyProfileImage.replace(/\\/g, '/').replace('static', '');
        } else {
          return "https://bulma.io/images/placeholders/640x360.png";
        }
      },
      goToCompanyDetails(companyId) {
        this.$router.push("/company/" + companyId);
      },
      goToJobDetails(jobId) {
        this.$router.push("/job/" + jobId);
      },
      changeTab(tab) {
        this.activeTab = tab;
      },
      parseBusinessType(businessType) {
      try {
        return JSON.parse(businessType);
      } catch (error) {
        console.error('Error parsing business type:', error);
        return [];
      }
    },
    parseLocation(location) {
      try {
        return JSON.parse(location);
      } catch (error) {
        console.error('Error parsing business type:', error);
        return [];
      }
    },
    },
  };
  </script>
  
<style scoped>
.main-content {
  background-color: #F5F8FA;
  padding: 2rem;
}

.searchtab {
  background-color: #ffffff;
  width: 100%;
  border: 1px solid rgb(24, 24, 24);
}

.card {
  cursor: pointer;
  transition: transform 0.2s;
}

.card:hover {
  transform: scale(1.05);
}

.pagination {
  margin-top: 20px;
  justify-content: center;
}

.pagination-previous,
.pagination-next {
  margin: 0 5px;
}

.pagination-link.is-current {
  background-color: #00d1b2;
  color: #fff;
}

.pagination-next[disabled] {
  opacity: 0.5;
}
</style>