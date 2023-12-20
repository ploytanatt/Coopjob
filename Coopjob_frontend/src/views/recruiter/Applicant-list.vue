<template>
    <div class="column m-0 p-0">
      <div v-for="application in applications" :key="application.id">
        <div class="card px-5 py-3" v-if="application.status !== 'canceled'">
          <div class="pt-3" style="border-top: 0.5px solid gray;">
            <div class="columns p-4" @click="viewApplicationDetail(application.id)">
                <div class="column">
                <p class="is-size-5 has-text-weight-bold">id: {{ application.id }}</p>
              </div>
              <div class="column">
                <p class="is-size-5 has-text-weight-bold">ตำแหน่ง: {{ application.position }}</p>
              </div>
              <div class="column">
                <p class="is-size-5 has-text-weight-bold">สถานะ: {{ application.status }}</p>      
              </div>
            </div>
              <button class="button is-medium is-success" @click="acceptApplicant(application.id)">ผ่าน</button>
              <button class="button is-medium is-danger" @click="declineApplicant(application.id)">ไม่ผ่าน</button>
            </div>
            <div style="display: flex; flex-direction: row; justify-content: flex-end;">
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
      this.getApplications();
    },
    methods: {
      getApplications() {
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
          })
          .catch((error) => {
            console.error(error);
          });
      },
      viewApplicationDetail(applicationId) {
        this.$router.push("/applicantDetail/"+applicationId);
        //console.log(`Viewing application detail for application ID: ${applicationId}`);
      },
      acceptApplicant(applicationJob) {
        const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      const status = 'approve'
        axios.put(
        `http://localhost:3000/application/updateStatus/${applicationJob}`,
        { status },
        config
        )
        .then((res) => {
          Swal.fire(res.data.message, "", "success");
          this.getApplications();
          
        })
        .catch((error) => {
          console.error(error);
        });
      },
      declineApplicant(applicationJob) {
        const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      const status = 'reject'
        axios.put(
        `http://localhost:3000/application/updateStatus/${applicationJob}`,
        { status },
        config
        )
        .then((res) => {
          Swal.fire(res.data.message, "", "success");

          this.getApplications();
        })
        .catch((error) => {
          console.error(error);
        });
      },
    },
  };
  </script>

  <style scoped>
  /* สไตล์ของหน้า Applicant-list.vue */
  </style>
  