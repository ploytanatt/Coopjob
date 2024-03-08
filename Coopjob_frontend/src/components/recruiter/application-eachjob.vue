<template>
    <div class="p-6 card">    
        <div class="card-content">
          <button><i class="fa-solid fa-left-long" @click="goback()">go back</i></button>
          <p>{{ jobName }}</p>
          <div class="columns is-2 ml-6 mt-6"  v-for="application in applicationsByJob" :key="application.job_id">
            <p class="column is-12">ชื่อ-นามสกุล: {{ application.student_id }} {{ application.firstName }} {{ application.lastName }}</p>
      </div>
        </div>
  

    </div>
</template>
  
  <script>
//import jobListFormVue from "@/components/company/job-listing-form.vue"
import axios from "@/plugins/axios";
//import Swal from "sweetalert2";
  export default {
    components: {
  //   jobListFormVue
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
    goback(){
      this.$router.push("/recruiterJob");
    }
 
    },
  };
  </script>
  <style scoped>

 
  </style>