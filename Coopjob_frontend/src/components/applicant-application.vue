<template>
  <div>
    <div v-for="application in applications" :key="application.student_job_id">
      <div class="card px-5 py-3" v-if="application.status === 'pending'">
        <div class="pt-3" style="border-top: 0.5px solid gray">
          <div class="columns p-4">
            <div class="column">
              <p class="is-size-5 has-text-weight-bold"> job_id: {{ application.job.job_id }} </p>
            </div>
            <div class="column">
              <p class="is-size-5 has-text-weight-bold"> ตำแหน่ง: {{ application.job.title }} </p>
            </div>
            <div class="column">
              <p class="is-size-5 has-text-weight-bold"> สถานะ: {{ application.status }}</p>
            </div>
          </div>
          <div style="display: flex; flex-direction: row; justify-content: flex-end;">
            <button class="button mx-4 mb-4 is-danger" @click="cancelApplication(application.student_job_id)">ยกเลิก</button>
          </div>
        </div>
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
      applications: [],
    };
  },
  mounted() {
    this.getJobApplications();
  },
  methods: {
    getJobApplications() {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      axios
        .get("http://localhost:3000/application/getJobApplications", config)
        .then((response) => {
          this.applications = response.data;
        })
        .catch((error) => {
          console.error(error);
        });
    },
    cancelApplication(applicationId) {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      const status = 'canceled'
      axios
        .put(`http://localhost:3000/application/cancelJob/${applicationId}` ,{ status },
          
          config
        )
        .then((res) => {
          Swal.fire(res.data.message, "", "success");

          this.getJobApplications();
        })
        .catch((error) => {
          console.error(error);
        });
    },
  },
};
</script>
<style scoped>
</style>
