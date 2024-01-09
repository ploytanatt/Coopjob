<template>
  <div class="main-content">
    <div class="container">
      <img
        id="suggest"
        class="is-rounded"
        src="https://picsum.photos/id/366/600/375"
        alt=""
      />
      <div class="field has-addons">
        <p class="control">
          <input
            class="input"
            type="text"
            placeholder="ชื่อตำแหน่งงาน หรือชื่อบริษัท"
          />
        </p>
        <p class="control">
          <span class="select">
            <select>
              <option>ประเภทงานทั้งหมด</option>
              <option>UX/UI</option>
              <option>design</option>
            </select>
          </span>
        </p>
        <p class="control">
          <a class="button is-info">ค้นหา</a>
        </p>
      </div>

      <!-- Companies Section -->
      <div class="columns is-multiline">
        <div class="column is-3" v-for="company in paginatedCompanies" :key="company.job_id">
          <div class="card" @click="goToCompanyDetails(company.user_id)" v-if="company.status === 'open'">
            <div class="card-image">
              <figure class="image is-4by3">
                <img :src="imagePath(company.cover_image)" alt="Company Logo">
              </figure>
            </div>
            <div class="card-content">
              <div class="media">
                <div class="media-left">
                  <figure class="image is-48x48">
                    <img :src="imagePath(company.profile_image)" alt="Company Logo">
                  </figure>
                </div>
                <div class="media-content">
                  <p>
                    <strong>{{ company.company_name }}</strong>
                  </p>
                </div>
              </div>
              <span class="tag is-normal">Normal</span>
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
<div class="columns is-multiline">
  <div class="column is-3" v-for="job in filteredJobs" :key="job.job_id" @click="goToJobDetails(job.job_id)">
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
          </div>
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
    <footer class="footer">
      <div class="content has-text-centered">
        <p>&copy;</p>
      </div>
    </footer>
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
  },
};
</script>

<style scoped>
.main-content {
  background-color: #F5F8FA;
  padding: 2rem;
}

#suggest {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 400px;
  margin-bottom: 20px;
}

/* เพิ่มสไตล์ที่ต้องการสำหรับ pagination */
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
</style>
