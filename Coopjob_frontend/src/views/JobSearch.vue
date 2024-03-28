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
                  <input value="internship" type="radio" name="jobType" v-model="selectedJobType">
                  ฝึกงาน
                </label>
                <label class="radio">
                  <input value="cooperative" type="radio" name="jobType" v-model="selectedJobType">
                  สหกิจศึกษา
                </label>
              </div>
              
            </div>

            <div class="field">
                <label class="label">ค้นหาชื่องาน</label>
                <div class="control">
                  <input class="input" type="text" v-model="searchKeyword"/>
                </div>
              </div>
          <div class="field">
            <label class="label">ประเภทงาน</label>
  
        </div>
          <multiselect v-model="selectedPosition_type"  placeholder="ค้นหาหรือพิมพ์เพื่อเพิ่มประเภท" label="title" track-by="title" :options="options" :multiple="true" :taggable="true" @tag="addTag"></multiselect>
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
        <button class="button is-success" @click="filterJobs">ค้นหา</button>

      <button class="button ml-2 is-danger" @click="clearFilters" >ยกเลิก</button>
          </div>
        </div>


        <!-- Job section -->
        <div class="column is-6">
          <div class="rows">
            <p>ผลการค้นหา ({{ filteredJobs.length }})</p>
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
        filteredJobs:[],
        currentPageCompanies: 1,
        currentPageJobs: 1,
        activeTab: 'all',
        locations: jsonData,
        options: JobtypeJson,
        searchKeyword: this.$route.query.searchKeyword || '',
        selectedPosition_type:[],
        selectedJobType: '',
        selectedLocation: '',
        selectedProvince: '',
      };
    },

    mounted() {
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
          this.filteredJobs = this.jobs
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
      loadLocationData() {
    if (this.selectedLocation) {
      this.selectedProvince = this.locations.find(location => location.id === this.selectedLocation).name_th || {};
    }
    else {
      this.selectedProvince = {};
    }
  },
      filterJobs() {
         this.filteredJobs = this.jobs.filter(job =>
            job.job_status === 'open' &&
            (this.activeTab === 'all' || job.job_type === this.activeTab) &&
            (this.selectedJobType === '' || job.job_type.includes(this.selectedJobType)) && // กรองตามประเภทงานที่เลือก
            (this.selectedProvince === '' || job.company.location.includes(this.selectedProvince)) &&// กรองตามสถานที่ทำงานที่เลือก
            job.job_title.toLowerCase().includes(this.searchKeyword.toLowerCase())

          );
         
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
    this.searchKeyword = "";
    this.selectedPosition_type = [];
    this.selectedLocation = "";
    
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

      console.log("Added new tag:", newTag);
      this.selectedPosition_type.push({ title: newTag });
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