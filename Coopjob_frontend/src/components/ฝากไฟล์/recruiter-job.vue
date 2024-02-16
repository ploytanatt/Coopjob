<template>
    <div class="container">
        <div class="columns mt-6">
            <!--
          <div class="column tap-list is-3 pt-3 pb-3 cardtab">
          <div :class="['select_option', select_option === 'recruiterProfile' ? 'has-background-light' : '']">
            <router-link to="/recruiterProfile">
              <p class="has-text-centered has-text-black is-size-5 p-3" @click="select_option = 'recruiterProfile'">ข้อมูลบริษัท</p>
            </router-link>
          </div>
          <div :class="['select_option', select_option === 'myjob' ? 'has-background-light' : '']">
            <router-link to="/recruiterJob">
              <p class="has-text-centered has-text-black is-size-5 p-3" @click="select_option = 'myjob'">งานที่ประกาศ</p>
            </router-link>
          </div>
          <div :class="['select_option', select_option === 'myApplicant' ? 'has-background-light' : '']">
            <router-link to="/applicantList">
              <p class="has-text-centered has-text-black is-size-5 p-3" @click="select_option = 'myApplicant'">คนที่มายื่นสมัคร</p>
            </router-link>
            </div>
          <div :class="['select_option', select_option === 'myAccount' ? 'has-background-light' : '']">
            <router-link to="/recruiterAccount">
              <p class="has-text-centered has-text-black is-size-5 p-3" @click="select_option = 'myAccount'">ตั้งค่าบัญชีผู้ใช้</p>
            </router-link>
          </div>
        </div>
-->
            <div class="p-6 card">
        <h1 class="title">งานที่ประกาศ Components</h1><div>
          <div class="twitter-pop-out-container">
          <button class="button is-primary add" @click="openAddJobModal">เพิ่มงาน</button>
          <div class="modal" :class="{ 'is-active': addJob }">
            <div class="modal-background" @click="closeAddJobModal"></div>
            <div class="modal-card">
              <header class="modal-card-head">
                <p class="modal-card-title">เลือกวิธีเพิ่มงาน</p>
                <button class="delete" aria-label="close" @click="closeAddJobModal"></button>
              </header>
              <section class="modal-card-body">
                <button class="button is-primary" @click="goToAddForm">เพิ่มงานแบบกรอกฟอร์ม</button>
                <button class="button is-info" @click="goToAddFile">เพิ่มงานโดยอัพโหลดไฟล์</button>
              </section>
            </div>
          </div>
      
    <noInformationVue v-if="!(jobs.length > 0)"></noInformationVue>

      <div class="tabs is-centered is-boxed">
        <ul>
          <li :class="{ 'is-active': activeTab === 'form' }">
            <a @click="changeTab('form')">
              <span class="icon is-small"><i class="fa-solid fa-pen" aria-hidden="true"></i></span>
              <span>form</span>
            </a>
          </li>
          <li :class="{ 'is-active': activeTab === 'upload' }">
            <a @click="changeTab('upload')">
              <span class="icon is-small"><i class="fa-solid fa-file-arrow-up" aria-hidden="true"></i></span>
              <span>upload</span>
            </a>
          </li>
        </ul>
      </div>
     
<div class="detail" v-for="job in filteredJobs" :key="job.job_id">
  <div v-show="job.create_type==='form'">
  <div class="job-detail">
    <div class="columns">
      <div class="column">
        <p class="is-size-6 has-text-weight-bold">วันที่ประกาศ:{{ job.title }} {{ formatDate(job.date_posted) }} </p>
        <p>ชื่องาน: {{ job.job_title }}</p>
          <p>คำอธิบาย: {{ job.description }}</p>
          <p>รูปแบบการทำงาน: {{ job.job_type }}</p>
          <p>ค่าตอบแทน: {{ job.salary }}</p>
          <p>จำนวนที่รับ: {{ job.quantity }}</p>
          <p>คุณสมบัติผู้สมัคร: {{ job.specification }}</p>
          <p>ตำแหน่ง: {{ job.job_position }}</p>
          <p>สวัสดิการ: {{ job.benefit}}</p>

          <p>GPA: {{ job.gpa }}</p>
          <p>Internship Duration: {{ job.internship_duration }} months</p>
          <p v-if="job.job_type==='cooperative'">Project Name: {{ job.project_name }}</p>
          <span>ประเภทงาน: </span>
          <span v-for="(type, index) in parsePositionType(job.position_type)" :key="index" class="tag is-medium">{{ type.title }} </span>
          <p>status: {{ job.status }}</p>
      </div>
      <div class="columns">
        <div class="column">
        <v-switch v-model="job.status">
        </v-switch>
      </div>
      <div class="column">
        <button class="button is-danger is-pulled-right" @click="confirmDeleteJob(job.job_id)">ลบงาน</button>
      </div>
    </div>
    </div>
    
    <div class="columns">
      <div class="column">
        <button class="button is-info" @click="editJob(job.job_id)">แก้ไขงาน</button>

      </div>
    </div>
  </div>
</div>
  <div v-show="job.create_type==='upload'">
  <div class="job-detail">
    <div class="columns">
      <div class="column">
        <p class="is-size-6 has-text-weight-bold">วันที่ประกาศ:{{ job.title }} {{ formatDate(job.date_posted) }} </p>
        <p >ชื่องาน: {{ job.job_title }}</p>
        <p>คำอธิบาย : {{ job.description }}</p>
      </div>
      <div class="column">
      <button class="button is-warning is-pulled-right" @click="toggleJobStatus">
          {{ isJobOpen ? 'ปิดรับสมัคร' : 'เปิดรับสมัคร' }}
        </button>
        <button class="button is-danger is-pulled-right" @click="confirmDeleteJob(job.job_id)">ลบงาน</button>

      </div>
    </div>
    <div class="columns">
      <div class="column">
        <img :src="imagePath(job.job_upload_file)" class="jobUpload">
      </div>
    
    </div>
    <div class="columns">
      <div class="column">
        <button class="button is-info" @click="editJob(job.job_id)">แก้ไขงาน</button>
      </div>
    </div>
    </div>
  </div>
</div>

  </div>
  </div>
  </div>
  </div>
  </div>
</template>
<script>
import axios from "axios";
import Swal from "sweetalert2";
import noInformationVue from "@/components/no-information.vue";
export default {
  components: {
    noInformationVue
  },
  data() {
    return {
      jobs: [],
      addJob: false,
      select_option : 'myjob',
      isJobOpen: true,
      activeTab: 'form',
    };
  },
  mounted() {
    this.getJobs();
  },
  computed: {
    filteredJobs() {
      // Filter jobs based on the activeTab (form, upload)
      return this.jobs.filter(job => job.create_type === this.activeTab);
    },
  },
  methods: {
    parsePositionType(PositionType) {
    try {
      return JSON.parse(PositionType);
    } catch (error) {
      console.error('Error parsing Position type:', error);
      return [];
    }
  },
    changeTab(tab) {
      // Change activeTab when a tab is clicked
      this.activeTab = tab;
    },
    imagePath(jobFile) {
      if (jobFile) {
        return "http://localhost:3000" + jobFile.replace(/\\/g, '/').replace('static', '');
      } else {
        return "https://bulma.io/images/placeholders/640x360.png";
      }
    },
    toggleJobStatus() {
    // เปลี่ยนสถานะการรับสมัครเมื่อกดปุ่ม toggle
    this.isJobOpen = !this.isJobOpen;
  },
    openAddJobModal() {
      this.addJob = true;
    },
    closeAddJobModal() {
      this.addJob = false;
    },
    goToAddForm() {
      this.$router.push("/recruiterAddJob");
      this.closeAddJobModal();
    },
    goToAddFile() {
      this.$router.push("/recruiterAddJobByUpload");
      this.closeAddJobModal();
    },
    getJobs() {
        const token = localStorage.getItem("token");
    const config = {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    };
      axios
        .get("http://localhost:3000/recruiter/getJob", config)
        .then((res) => {
          this.jobs = res.data;
        })
        .catch((error) => {
          console.log(error);
        });
    },
    //แสดงผลเฉพาะวันที่จากสตริง
    formatDate(dateString) {
        const date = new Date(dateString);
        const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
        return date.toLocaleDateString('th-TH', options);
    },
    editJob(jobId) {
      // นำ jobId ไปยังหน้าแก้ไขงาน
      this.$router.push(`/edit-job/${jobId}`);
    },
    confirmDeleteJob(job_id) {
      Swal.fire({
        title: "ยืนยันการลบงาน",
        text: "คุณต้องการลบงานนี้หรือไม่?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "ยืนยัน",
        cancelButtonText: "ยกเลิก",
      }).then((result) => {
        if (result.isConfirmed) {
          this.deleteJob(job_id);
        }
      });
    },
    deleteJob(job_id) {
        const token = localStorage.getItem("token");
        const config = {
            headers: {
            Authorization: `Bearer ${token}`,
            },
        };
    axios
        .delete(`http://localhost:3000/recruiter/deleteJob/${job_id}`, config)
        .then((res) => {
        // ลบงานสำเร็จ อัปเดตรายการงาน
        console.log(res)
        Swal.fire("ลบงานสำเร็จ", "", "success");
          this.getJobs(); // โหลดรายการงานใหม่หลังจากลบ
        })
        .catch((error) => {
          Swal.fire("เกิดข้อผิดพลาด", error.message, "error");
        });
    }
  },
};
</script>

<style scoped>
.select_option {
    cursor: pointer;
}

.select_option:hover {
    background-color: #ffffff;
}
.job-detail {
  background-color: rgb(255, 255, 255);
  border: 1px solid #cbcbcb;
  border-radius: 7px;
  padding: 1rem;
  background-color: #ffffff;
}
.detail{
  margin: 1rem;
}
.card {
  width: 100%;
  background-color: #eeeeee;
}
.add{
    margin-left: 1rem;
}
.title{
    margin-left: 1rem;
}
.cardtab {
  background-color: #eeeeee;

}
.select_option {
  cursor: pointer;
  background-color: #eeeeee;
}
.select_option:hover {
  background-color: #4a84ca21;
}
.has-background-light {
  background-color: #4a83cadc !important;
}
.jobUpload{
  width: 40%;
}
</style>
