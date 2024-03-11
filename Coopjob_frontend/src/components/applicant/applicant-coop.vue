<template>
  <div class="p-6 card">
    <h1 class="title">coop.302 file</h1>
    <div v-if="studentJobs.length > 0">
      <div v-for="studentJob in studentJobs" :key="studentJob.job_id">
        <button class="button is-primary mb-1" @click="downloadFile(imagePath(studentJob.coop302))">
          Download PDF
        </button>
        <!-- เช็คหากไม่ใช่หน้าจอโทรศัพท์ให้แสดง iframe -->
        <iframe :src="imagePath(studentJob.coop302)" class="preview-pdf" v-if="$mq !== 'phone'"></iframe>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      jobId: this.$route.query.job_id || '',
      userId: '',
      studentJobs: [],
    };
  },
  mounted() {
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
      axios.get("http://localhost:3000/user/me", config)
        .then((res) => {
          this.user = res.data;
          console.log("App.vue", this.user);

          if (!this.user || !this.user.user_id) {
            console.error('User or user_id is undefined.');
          } else {
            // กำหนดค่า userId หลังจากข้อมูลผู้ใช้ถูกโหลดเรียบร้อยแล้ว
            this.userId = this.user.user_id;
            // เมื่อได้รับ userId แล้ว ให้เรียกเมธอดเพื่อดึงข้อมูล studentJobs
            this.getStudentJobs();
          }
        })
        .catch((error) => {
          console.error(error);
        });
    },
    getStudentJobs() {
      const jobId = this.jobId; // ใช้ค่า jobId ที่ได้รับมาจาก props
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      axios.get(`http://localhost:3000/application/getStudentJobs?job_id=${jobId}`, config)
        .then((res) => {
          this.studentJobs = res.data;
        })
        .catch((error) => {
          console.error(error);
        });
    },
    imagePath(coop302Path) {
      if (coop302Path) {

        return "http://localhost:3000" + coop302Path.replace(/\\/g, '/').replace('static', '');
      } else {

        return "https://bulma.io/images/placeholders/640x360.png";
      }
    },

    downloadFile(url) {
      fetch(url)
        .then(response => response.blob())
        .then(blob => {
          const url = window.URL.createObjectURL(new Blob([blob]));
          const link = document.createElement('a');
          link.href = url;
          link.setAttribute('download', 'coop302fromcompany.pdf'); // ตั้งชื่อไฟล์ที่จะโหลด
          document.body.appendChild(link);
          link.click();
          link.parentNode.removeChild(link);
        });
    },
  }
};
</script>

<style scoped>
.preview-pdf {
  width: 100%;
  height: 1000px;
}
</style>
