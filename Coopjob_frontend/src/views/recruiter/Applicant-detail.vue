<template>
    <div class="card px-5 py-3">
      <div class="pt-3" style="border-top:0.5px solid gray;">
        <div class="columns mt-6">
          <div class="column is-2"></div>
          <div class="tabs is-boxed column is-8">
            <div>
              <div class="column is-11">
                <div class="columns is-multiline ml-6 mt-1">
                  <p class="column is-12 is-size-5 has-text-weight-bold">
                    ชื่อผู้สมัคร: {{ applicationJob.firstName }}
                    {{ applicationJob.lastName }}
                  </p>
                  <p class="column is-6">เพศ: {{ applicationJob.gender }}</p>
                  <p class="column is-6">
                    อีเมล: {{ applicationJob.email }}
                  </p>
                  <p class="column is-6">
                    วัน-เดือน-ปี เกิด: {{ applicationJob.birthdate }}
                  </p>
                  <p class="column is-6">
                    ที่อยู่: {{ applicationJob.address }}
                  </p>
                  <p class="column is-6">
                    เบอร์โทร: {{ applicationJob.phone_number }}
                  </p>
                </div>
              </div>
              <iframe :src="imagePath(applicationJob.resume)" type="application/pdf" class="preview-pdf" />
            </div>
          </div>
          <div class="column is-2"></div>
        </div>
      </div>
    </div>
</template>
  <script>
  import axios from "@/plugins/axios";
  import Swal from "sweetalert2";
  export default {
    data() {
      return {
        applicationJob: null,
      };
    },
    mounted() {
      // Get application details
      const applicationId = this.$route.params.applicationId;
      this.getApplicationDetails(applicationId);
    },
    methods: {
      getApplicationDetails(applicationId) {
        const token = localStorage.getItem("token");
        const config = {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        };
        axios
          .get(`http://localhost:3000/application/getApplicationDetails/${applicationId}`, config)
          .then((response) => {
            this.applicationJob = response.data[0];
          })
          .catch((error) => {
            console.error(error);
          });
      },
        imagePath(resume) {
        if (resume) {
            return "http://localhost:3000/" + resume.replace(/\\/g, '/').replace('static', '');
        } else {
            return "https://bulma.io/images/placeholders/640x360.png";
        }
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
        })
        .catch((error) => {
          console.error(error);
        });
      },
    },
  };
</script>
  <style scoped>
.preview-pdf {
  width: 100%;
  height: 1000px;
}
  </style>
  