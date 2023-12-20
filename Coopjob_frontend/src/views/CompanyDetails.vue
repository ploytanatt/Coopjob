<template>
   <div class="container mt-4">
    <img :src="'https://sv1.picz.in.th/images/2023/05/22/Fif20Z.jpg'" class="background_image" />
    <div class="columns is-gapless ml-6 mb-6" style="position: relative; top: -80px">
      <img :src="imagePath(company.profile_image)" class="column is-2 profile_image" />
      <div class="column ml-4" style="position: relative; top: 100px">
        <p class="is-size-4 has-text-weight-bold">{{ company.company_name }}</p>
      </div>
    </div>
    <p class="is-size-5" style="position: relative; top: -40px">
      {{ company.description }}
    </p>
    <div class="video_iframe mt-4 mb-6" v-html="company.company_video"></div>
    <p class="has-background-dark has-text-weight-bold has-text-white is-size-3 mt-6 p-3 has-text-weight-medium">ตำแหน่งที่รับสมัคร</p>
    <div class="job_content p-6" v-for="(job, index) in jobs" :key="index" style="border-bottom: 0.5px solid gray" @click="viewJob(job.job_id)">
      <p class="is-size-4 has-text-weight-bold">{{ index + 1 + "." }} {{ job.title }}</p>
      <div class="columns is-multiline ml-6 mt-1">
        <div class="column is-9">
          <i class="pi pi-map-marker"> <span class="is-size-5 pl-4"><b>สถานที่ทำงาน: </b>{{ job.location }}</span> </i>
        </div>
        <div class="column is-3">
          <i class="pi pi-dollar">
            <span class="is-size-5 pl-4"><b>ค่าตอบแทน: </b>{{ job.salary }}</span></i>
        </div>
        <div class="column is-9">
          <i class="pi pi-user"><span class="is-size-5 pl-4"><b>ระยะเวลา(เดือน): </b>{{ job.internship_duration }}</span></i>
        </div>
        <p class="is-size-5 column is-3">
          <b>คุณสมบัติ: </b>{{ job.qualifications }}
        </p>
      </div>
    </div>
  </div>
</template>
<script>
import axios from "axios";
export default {
  data() {
    return {
      company: [],
      jobs: [],
    };
  },
  mounted() {
    const companyId = this.$route.params.companyId;
    this.getCompanyDetails(companyId);
    this.getCompanyJobs(companyId);
  },
  methods: {
    getCompanyDetails(companyId) {
      axios
        .get(`http://localhost:3000/recruiter/getRecruiterDetails/${companyId}`)
        .then((response) => {
          this.company = response.data;
          this.company.profile_image = response.data.profile_image.replace(/\\/g, '/').replace('static', '');
        })
        .catch((error) => {
          console.error(error);
        });
    },
    getCompanyJobs(companyId) {
      axios
        .get(`http://localhost:3000/recruiter/getCompanyJobs/${companyId}`)
        .then((response) => {
          this.jobs = response.data;
        })
        .catch((error) => {
          console.error(error);
        });
    },
    imagePath(companyProfileImage) {
      if (companyProfileImage) {
        return "http://localhost:3000" + companyProfileImage;
      } else {
        return "https://bulma.io/images/placeholders/640x360.png";
      }
    },
    viewJob(jobId){
        this.$router.push("/job/"+jobId);
    }
  },
};
</script>
<style scoped>

.profile_image {
  width: 150px;
  height: 150px;
  border: 2px solid gray;
  border-radius: 25px;
}

</style>