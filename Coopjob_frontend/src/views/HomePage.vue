<template>
  <div class=" main-content">
    <div class="column mt-4 container ">
      <img
        id="suggest"
        class="is-rounded"
        src="https://images.unsplash.com/photo-1435575653489-b0873ec954e2?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
        alt=""
      />

<div class="field has-addons">
  <p class="control has-icons-left">
    <input class="input" type="text" placeholder="ชื่อตำแหน่งงาน" v-model="searchKeyword">
    <span class="icon is-small is-left">
      <i class="fas fa-search"></i>
    </span>
  </p>
  <router-link class="pagination-next" :to="{ path: '/jobsearch', query: { searchKeyword: searchKeyword }}">ค้นหางาน</router-link>
</div>
      <!-- Companies Section -->
      <div class="columns is-multiline">
        <div class=" column is-3" v-for="company in paginatedCompanies" :key="company.job_id">

          <div class="card is-fullwidth Companies"  @click="goToCompanyDetails(company.user_id)">
            <header class="card-header">
              <img :src="imagePath(company.cover_image)"  class="card-header-img" />
            </header>
            <div class="card-content">
              <a class="card-profile">
                <img :src="imagePath(company.profile_image)"  class="card-profile-img" />
              </a>
              <div class="card-user">
                <div class="card-user-name">
                  <a>{{ company.company_name }}</a>
                </div>
                <span>{{ company.contact_email }}</span>
              </div>
              <div class="card-stats">
                <i class="fa-sharp fa-solid fa-location-dot"></i>
                <span v-for="(type, index) in parseLocation(company.location)" :key="index" > {{ type.tambon }} {{ type.amphure }} {{ type.province }} {{ type.zip_code }}</span>
                <br>
                <i class="fa-regular fa-briefcase"></i>
                <span v-for="(type, index) in parseBusinessType(company.business_type)" :key="index" class="tag is-normal"> {{ type.title }}</span>

              </div>
            </div>
          </div>  
          </div>
      </div>

      <!-- Pagination Controls for companies -->
      <nav class="pagination" role="navigation" aria-label="pagination">
        <a class="pagination-previous" @click="currentPageCompanies = Math.max(1, currentPageCompanies - 1)" :disabled="currentPageCompanies === 1">Previous</a>
        <a class="pagination-next" @click="currentPageCompanies = Math.min(totalPagesCompanies, currentPageCompanies + 1)" :disabled="currentPageCompanies === totalPagesCompanies || companies.length === 0">Next page</a>
        <ul class="pagination-list">
          <li v-for="page in totalPagesCompanies" :key="page">
            <a class="pagination-link" @click="currentPageCompanies = page" :class="{ 'is-current': currentPageCompanies === page }">
              {{ page }}
            </a>
          </li>
        </ul>
      </nav>

    <!-- jobtype tabs -->
    <div class="tabs is-centered is-boxed">
      <ul>
        <li :class="{ 'is-active': activeTab === 'internship' }">
          <a @click="changeTab('internship')">
            <span class="icon is-small"><i class="fa-solid fa-graduation-cap" aria-hidden="true"></i></span>
            <span>ฝึกงาน</span>
          </a>
        </li>
        <li :class="{ 'is-active': activeTab === 'cooperative' }">
          <a @click="changeTab('cooperative')">
            <span class="icon is-small"><i class="fa-solid fa-briefcase" aria-hidden="true"></i></span>
            <span>สหกิจศึกษา</span>
          </a>
        </li>
        <li :class="{ 'is-active': activeTab === 'all' }">
          <a @click="changeTab('all')">
            <span class="icon is-small"><i class="fas fa-film" aria-hidden="true"></i></span>
            <span>ทั้งหมด</span>
          </a>
        </li>
      </ul>
    </div>

  <!-- Jobs Section -->
  <div class="columns is-multiline ">
    <div class=" card column job_card is-2" v-for="job in filteredJobs" :key="job.job_id" @click="goToJobDetails(job.job_id)">

      <div class="job-card-content">
        <a class="job-card-img">
          <img :src="imagePath(job.company.profile_image)" class="job-image"/>
        </a>

        <div class="card-user">
          <div class="card-user-name">
            <strong>{{ job.job_title }}</strong>
          </div>
          <i class="fa-solid fa-buildings fa-fw"></i>
          <span>
            <small> {{ job.company.company_name }}</small>
          </span>
          <br>
          <i class="fa-solid fa-graduation-cap"></i>
  
          <span>
            <small> {{ job.job_type }}</small>
          </span>
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
      searchKeyword:''
    };
  },
  computed: {
    filteredJobs() {
    return this.jobs.filter(job => job.job_status === 'open' && (this.activeTab === 'all' || job.job_type === this.activeTab));
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
    goToJobsearch() {
      this.$router.push("/jobsearch");
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
  clearSearch() {
      this.searchInput.value = "";
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
  width: 100%; 
  margin: 0 auto; 
  display: flex; 
  justify-content: center;
  min-height: 100vh;
  background-color: #f5f8fa;
}


.searchbar{
  margin-bottom: 1rem;

}
#suggest {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 400px;
  margin-bottom: 20px;
}

.card-header {
  position: relative;
 
}
.card-header-img {
  width: 100%;
  height: 100px;
}
.card-content {
    padding: 0px;
}
.card-profile {
  display: inline-block !important;
  float: left;
  margin: -30px 5px 0 8px;
  max-width: 100%;

  vertical-align: bottom;
  position: relative;
}
.card-profile-img {

  border-radius: 7px;
  box-sizing: border-box;
  color: #fff;
  height: 72px;
  width: 72px;
}

.card-user {
    margin: 5px 0 0;
}

.card-stats {
    margin-left: 11px;
    padding: 10px 0;
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
  background-color: rgb(0, 102, 255);
  color: #ffffff;
}

.card {
  cursor: pointer;
  transition: transform 0.2s;
}

.card:hover {
  transform: scale(1.05);
}

.pagination-next[disabled] {
  opacity: 0.5; /* Or a different style to convey disabled state */
}

.job_card{
  background-color: #ffffff;
  margin: 1rem;
}
.job-card-img {
  background-color: #fff;
  border-radius: 6px;
  display: inline-block !important;
  float: left;
  margin: 0px 25px 0 8px;
  max-width: 100%;
  padding: 1px;
  vertical-align: bottom;
  position: relative;

}
.job-image {
  border: 2px solid #ffffff;
  border-radius: 7px;
  box-sizing: border-box;
  color: #fff;
  height: 72px;
  width: 72px;
}

.Companies{
  background-color: #ffffff;
  height: 260px;
}
</style>
