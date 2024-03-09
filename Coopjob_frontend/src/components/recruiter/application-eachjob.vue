<template>

   
    <div class="columns">
      <recruiterSideMenu></recruiterSideMenu>
      <div class="column " >
      <div class="card">    
      
    <button class="button is-dark go-back-button" @click="goback">
      <i class="fa-solid fa-left-long"></i> 
    </button>
    <span class="is-size-4 p-3 has-text-weight-bold">{{ jobName }}</span>
  
    <div>
        <p class="is-size-3">จำนวนผู้สมัครทั้งหมด : {{ applicationsByJob.length }}</p>
      </div>
      <div class="table">
        <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">
          <thead>
            <tr>
              <th>รหัสนักศึกษา</th>
              <th>ชื่อ-นามสกุล</th>
              <th>ชื่องาน</th>
              <th>สถานะ</th>
              <th>วันที่สมัคร</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="application in applicationsByJob" :key="application.id">
              <td>{{ application.studentID }}</td>
              <td>{{ application.firstName }} {{ application.lastName }}</td>
              <td>{{ application.job_title }}</td>
            

              <td>
              <span :class="{
                'button': true, 

                'is-warning': applicationStatus(application.student_job_id).join(', ') === 'pending', 
                'is-success': applicationStatus(application.student_job_id).join(', ') === 'approve', 
                'is-danger': applicationStatus(application.student_job_id).join(', ') === 'reject' || applicationStatus(application.student_job_id).join(', ') === 'canceled'
              }">
                {{ applicationStatus(application.student_job_id).join(', ') }}
              </span>
            </td>

              <td>{{ formatDate(application.date_posted) }}</td>
              <td>
                <button class="button is-info"  @click="viewApplicationDetail(application.student_job_id)">See Application</button>
              </td>
            </tr>
          </tbody>
        </table>
        </div>
      </div>


</div>
      
      
    </div>

</template>

  
  <script>
//import jobListFormVue from "@/components/company/job-listing-form.vue"
import axios from "@/plugins/axios";
//import Swal from "sweetalert2";
import recruiterSideMenu from '@/components/recruiter/recruiter-side-menu.vue';
  export default {
    components: {
      recruiterSideMenu
    },
    data() {
      return {
        applicationsByJob:[],
        viewApplicationlist:true,
        applications:[],
        jobName:''
    
      };
    },
    mounted() {
    const jobId = this.$route.params.jobId;
    this.getApplicationByJob(jobId);
    this.getApplications();
  },
  
    methods: {
      getApplications() {
      this.isLoading = true;
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      axios
        .get("http://localhost:3000/application/getApplications", config)
        .then((response) => {
          this.applications = response.data;
          
          this.isLoading = false;
        })
        .catch((error) => {
          console.error(error);
          this.isLoading = false;
        });
    },
    getApplicationByJob(jobId) {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      axios
        .get(`http://localhost:3000/application/getApplicationByJob/${jobId}`, config)
        .then((response) => {
          this.applicationsByJob = response.data;
          this.jobName = response.data[0].job_title
        })
        .catch((error) => {
          console.error(error);
        });
    },
    formatDate(dateString) {
      const options = { year: 'numeric', month: 'long', day: 'numeric' };
      return new Date(dateString).toLocaleDateString('th-TH', options);
    },
    goback(){
      this.$router.push("/recruiterJob");
    },
    applicationStatus(jobId) {
  // หา applicants ที่มี job_id ตรงกับ jobId ที่กำหนดและคืนค่า array ของ status
  return this.applications
             .filter(applicant => applicant.id=== jobId)
             .map(applicant => applicant.status);
},

viewApplicationDetail(applicationId) {
      this.$router.push("/applicantDetail/" + applicationId);
    },
    },
  };
</script>
<style scoped>

.table {
  width: 80%;
  padding:0;
  border-radius: 5px;
  overflow-x: auto; /* Allows table to be scrollable on small screens */
}
.column{
  
  padding: 0%;
}
.card{
  padding: 2rem;
}


</style>
