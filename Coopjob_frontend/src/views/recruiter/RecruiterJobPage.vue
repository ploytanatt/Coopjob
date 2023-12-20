<template>
    <div class="container">
        <div class="columns mt-6">
            <div class="column has-background-light is-3 pt-3 pb-3 cardcontainer">
                <div :class="[
                    'select_option',
                    select_option === 'recruiterProfile' ? 'has-background-primary has-text-white' : '',]">
                    <router-link to="/recruiterProfile">
                        <p class="has-text-centered is-size-5 p-3" @click="select_option = 'recruiterProfile'">ข้อมูลบริษัท
                        </p>
                    </router-link>
                </div>
                <div :class="[
                        'select_option',
                        select_option === 'myjob'
                            ? 'has-background-primary has-text-white'
                            : '',
                    ]">
                    <router-link to="/recruiterJob">
                        <p class="has-text-centered is-size-5 p-3 " @click="select_option = 'myjob'">
                            งานที่ประกาศ</p>
                    </router-link>
                </div>
            </div>
            <div class="p-6 card">
        <h1 class="title">งานที่ประกาศ</h1><div>
    <button class="button is-primary add" @click="addJobs()">เพิ่มงาน</button>
    <noInformationVue v-if="!(jobs.length > 0)"></noInformationVue>
        <div class="detail" v-for="job in jobs" :key="job.job_id">
            
                  <div class="job-detail">
                    <div class="columns is-multiline is-mobile">
                      <div class="column is-one-quarter">
                        <p class="is-size-4 has-text-weight-bold"> {{ job.title }} {{ formatDate(job.date_posted) }} </p>
                      </div>
                      <div class="column is-one-quarter">
                      </div>
                      <div class="column is-one-quarter">
                       
                      </div>
                      <div class="column is-one-quarter">
                        
                        <button class="button is-danger is-pulled-right" @click="confirmDeleteJob(job.job_id)">ลบงาน</button>
                      </div>
                    </div>
                    <div class="columns">
                    <div class="column">
                        <p>คำอธิบาย : {{ job.description }}</p>
                        <p>เงินเดือน : {{ job.salary }}</p>
                        <p>สถานที่ทำงาน : {{ job.location }}</p>
                    </div>
                    <div class="column">
                        <p>คุณสมบัติ : {{ job.qualifications }}</p>
                        <p>ระยะเวลา (เดือน) : {{ job.internship_duration }}</p>
                        <p>สถานะ : {{ job.status }}</p>
                    </div>
                    </div>
                   <button class="button is-info" @click="editJob(job.job_id)">แก้ไขงาน</button>
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
    };
  },
  mounted() {
    this.getJobs();
  },
  methods: {
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
    addJobs() {
      this.$router.push("/recruiterAddJob");
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
    background-color: rgb(255, 255, 255);
}
.job-detail {
  border-radius: 6px;
  padding: 1rem;
  background-color: #f1f1f1;
}
.detail{
  padding: 0.5rem;
  border-radius: 6px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  margin: 1rem;
  background-color: #6b6b69;
}
.card {
  width: 60%;
  
}
.add{
    margin-left: 1rem;
}
.title{
    margin-left: 1rem;
}
</style>
