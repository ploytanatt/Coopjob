<template>
    <div>
      <div v-for="application in applications" :key="application.application_id">
        <div class="card px-5 py-3">
          <div class="pt-3" style="border-top: 0.5px solid gray;">
            <div class="columns p-4">
              <div class="column">
                <p class="is-size-5 has-text-weight-bold">job_id: {{ application.job.job_id }}</p>
              </div>
              <div class="column">
                <p class="is-size-5 has-text-weight-bold">ตำแหน่ง: {{ application.job.title }}</p>
              </div>
              <div class="column">
                <p class="is-size-5 has-text-weight-bold">สถานะ: {{ application.status }}</p>
              </div>
            </div>
            <div style="display: flex; flex-direction: row; justify-content: flex-end;">
              <button v-if="isCancel" class="button mx-4 mb-4 is-danger" @click="cancelApplication(application.application_id)">
                ยกเลิก
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
</template>
<script>
import axios from "axios";
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
    },
  };
  </script>

  <style scoped>
  /* สไตล์หน้าประวัติงานที่สมัคร */
  </style>
  