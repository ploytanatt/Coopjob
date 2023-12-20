<template>
    <div>
      <div>
        <div class="has-background-light box mt-3 pl-3 pr-4 pt-4 pb-4">
        <p class="has-text-right"></p>
        <div class="columns mt-1">
          <div class="column is-11">
            <p class="is-size-5 p-4">
              <b>{{ jobs.title }}</b>
            </p>
            <div class="pl-3">
              <div class="p-4">
                <i class="pi pi-map-marker">
                  <span class="is-size-5 pl-4"><b>สถานที่ทำงาน:{{ jobs.location }} </b></span></i>
              </div>
              <div class="p-4">
                <i class="pi pi-dollar">
                  <span class="is-size-5 pl-4"><b>ค่าตอบแทน / วัน : {{ jobs.salary }} </b></span></i>
              </div>
              <div class="p-4">
                <i class="pi pi-user"><span class="is-size-5 pl-4"><b>ระยะเวลา / เดือน : {{ jobs.internship_duration }} </b></span></i>
              </div>
              <div class="p-4">
                <i class="pi pi-user"><span class="is-size-5 pl-4"><b>รายละเอียดงาน : {{ jobs.description }} </b></span></i>
              </div>
              <div class="p-4">
                <i class="pi pi-user"><span class="is-size-5 pl-4"><b>คุณสมบัติผู้สมัคร : {{ jobs.qualifications }} </b></span></i>
              </div>
            </div>
          </div>
          <div class="column my-3" style="display: flex;flex-direction: column;justify-content: space-between;">
            <button class="button is-success" v-show="user.role === 'applicant'" @click="applyToJob(jobs.job_id)">
              ยื่นสมัคร
            </button>
          </div>
        </div>
      </div>
      <div style="display: flex; flex-direction: column; align-items: flex-end">
      </div>
      </div>
    </div>
</template>
<script>
  import axios from "axios";
  import Swal from "sweetalert2";
  export default {
    data() {
      return {
        company: null,
        jobs: [],
        user:[]
      };
    },
    mounted() {
      const jobId = this.$route.params.jobId;
      this.getCompanyJobs(jobId);
      this.getUser();
    },
    methods: {
      getUser() {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      axios.get("http://localhost:3000/user/me", config).then((res) => {
        
        this.user = res.data;
        console.log("App.vue", this.user)
      });
    },
      getCompanyJobs(jobId) {
        axios
          .get(`http://localhost:3000/recruiter/getJobDetail/${jobId}` )
          .then((response) => {
            this.jobs = response.data;
          })
          .catch((error) => {
            console.error(error);
          });
      },
      applyToJob(jobId) {
        const token = localStorage.getItem("token");
        const config = {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        };
        const data = {
          user_id: this.user.user_id,
          job_id: jobId, 
        };
        //console.log(`Applying to job ${jobId}`);
        axios
          .post(`http://localhost:3000/application/sendApplicationJob`, data, config)
          .then(res => {
            console.log(res.data.message)
           
            Swal.fire({
              position: "center",
              icon: "success",
              title: "ดำเนินการสำเร็จ",
              showConfirmButton: false,
              
            });
          });
      },
    },
  };
  </script>
  
  <style scoped>
  /* สไตล์ของหน้ารายละเอียดบริษัท */
  </style>
  