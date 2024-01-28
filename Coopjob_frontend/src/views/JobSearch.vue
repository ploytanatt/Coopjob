<template>
  <div class="main-content">
    <div class="container">
      <div class="columns">
        <!-- Search tab -->
        <div class="column is-3">
          <div class="searchtab">
            <div class="field">
              
              <div class="control">
                <label class="radio">
                  <input type="radio" name="jobType" v-model="selectedJobType" @change="filterJobs"> ฝึกงาน
                </label>
                <label class="radio">
                  <input type="radio" name="jobType" v-model="selectedJobType" @change="filterJobs"> สหกิจศึกษา
                </label>
              </div>

              
            </div>

            <div class="field">
            <label class="label">ชื่องาน</label>
            <div class="control">
              <input class="input" type="text" v-model="address" />
            </div>
          </div>

          <div class="field">
            <label class="label">ประเภทงาน</label>
          <div class="control">
            <div class="select">
              <select v-model="selectedLocation" @change="loadLocationData">
                <option value="">ทุกจังหวัด</option>
                <option v-for="province in locations" :key="province.id" :value="province.id">
                  {{ province.name_th }}
                </option>
              </select>
            </div>
          </div>
        </div>
          <multiselect v-model="position_type"  placeholder="ค้นหาหรือพิมพ์เพื่อเพิ่มประเภท" label="title" track-by="title" :options="options" :multiple="true" :taggable="true" @tag="addTag"></multiselect>
          <div class="field">
            <label class="label">สถานที่ทำงาน</label>
          <div class="control">
            <div class="select">
              <select v-model="selectedLocation" @change="loadLocationData">
                <option value="">ทุกจังหวัด</option>
                <option v-for="province in locations" :key="province.id" :value="province.id">
                  {{ province.name_th }}
                </option>
              </select>
            </div>
          </div>
        </div>
            <button  class="button is-success">ค้นหา</button>
      <button class="button ml-2 is-danger" @click="clearFilters" >ยกเลิก</button>
          </div>
        </div>


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
  import jsonData from '@/assets/api_province_with_amphure_tambon.json'
  import JobtypeJson from '@/assets/jobtype.json'
  import Multiselect from 'vue-multiselect'
  export default {
    components: {
    Multiselect,
  },
    data() {
      return {
        companies: [],
        jobs: [],
        perPage: 4,
        currentPageCompanies: 1,
        currentPageJobs: 1,
        activeTab: 'all',
        locations: jsonData,
        options: JobtypeJson,
        position_type:[],
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
    clearFilters() {
    this.selectedJobType = "";
    this.address = "";
    this.position_type = [];
    this.selectedLocation = "";
    this.currentPageJobs = 1;
    // เรียก filterJobs เพื่อทำการกรองข้อมูล
    this.filterJobs();
  },
    removeItem(item) {
      // ลบรายการที่ถูกเลือก
      this.selectedValues = this.selectedValues.filter(value => value !== item);
    },
    customLabel(option) {
      // กำหนด custom label สำหรับแสดงผลใน dropdown
      return `${option.name} (${option.id})`;
    },
    addTag(newTag) {
      // ฟังก์ชันที่ถูกเรียกเมื่อมีการเพิ่มแท็กใหม่
      console.log("Added new tag:", newTag);
      this.position_type.push({ title: newTag });
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
  border: 1px solid rgb(255, 255, 255);
  box-shadow: 0 0.5em 1em -0.125em rgba(10, 10, 10, 0.1), 0 0px 0 1px rgba(10, 10, 10, 0.02);
  border-radius: 7px;
  padding: 1rem;
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

<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>

<style>