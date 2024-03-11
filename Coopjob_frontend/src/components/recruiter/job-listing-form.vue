<template>
  <div class=""> 
    <div class="detail" v-for="job in filteredJobs" :key="job.job_id">
      <div class="job-detail">
        <applicationEachJob @goBack="handleGoBack" v-if="viewApplicationlist"></applicationEachJob>   
        <div class="columns"  v-if="viewApplicationlist === false">
          <div class="column">
            <p class="is-size-6 has-text-weight-bold">{{ job.job_title }}</p>
              <p>รูปแบบงาน: {{ job.job_type }}</p>
              <p v-if="job.job_type==='cooperative'">Project Name: {{ job.project_name }}</p>
              <span>ประเภทงาน: </span>
              <span v-for="(type, index) in parsePositionType(job.position_type)" :key="index" class="tag is-medium">{{ type.title }} </span>
              <p >วันที่ประกาศ:{{ job.title }} {{ formatDate(job.date_posted) }} </p>

              <a  class="is-underlined has-text-weight-bold"  @click="openApplicaionList(job.job_id)">จำนวนคนที่มาสมัคร {{ countApplications(job.job_id) }} คน</a>
          </div>
          <div class="columns">
            <div class="column">
              <input :id="'switchRtlExample-' + job.job_id" type="checkbox" name="switchRtlExample" class="switch is-rtl is-rounded is-success is-pulled-right" :checked="job.job_status === 'open'" @change="updateJobStatus(job)">
                <label :for="'switchRtlExample-' + job.job_id">{{ job.job_status === 'open' ? 'เปิดรับสมัคร' : 'ปิดรับสมัคร' }}</label>
            
            <div class="column">
              <button class="button is-info is-pulled-right is-fullwidth  mb-2" @click="editJob(job.job_id)"><i class="fa-regular fa-pen-to-square"> แก้ไขข้อมูล</i></button>
            </div>
            <div class="column ">
              <button class="button is-danger is-pulled-right   is-fullwidth mb-2" @click="confirmDeleteJob(job.job_id)">ลบงาน</button>
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
import applicationEachJob from "@/components/recruiter/application-eachjob.vue"

export default {
  components: {
    applicationEachJob
  },
  data() {
    return {
      jobs: [],
      select_option : 'myjob',
      isJobOpen: true,
      activeTab: 'form',
      viewApplicationlist:false,
      applicationsByJob:[],
      applications:[],
    };
  },
  mounted() {
    this.getJobs();
    this.getApplications()
  },
  computed: {
    filteredJobs() {
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
      this.activeTab = tab;
    },
    toggleJobStatus() {
    this.isJobOpen = !this.isJobOpen;
  },
    openApplicaionList(jobId) {
      this.$router.push("/getApplicationByJob/" + jobId);
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
    countApplications(jobId) {
      return this.applications.filter(applicant => applicant.job_id === jobId).length;
    },
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

    //แสดงผลเฉพาะวันที่จากสตริง
    formatDate(dateString) {
        const date = new Date(dateString);
        const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
        return date.toLocaleDateString('th-TH', options);
    },
    editJob(jobId) {
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
    },
    updateJobStatus(job) {
    const newStatus = job.job_status === 'open' ? 'close' : 'open';
    job.job_status = newStatus; // อัพเดตสถานะในข้อมูล Vue
    const token = localStorage.getItem("token");
    const config = {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    };
    console.log(newStatus)
    const data = { job_status: newStatus };
    axios.put(`http://localhost:3000/recruiter/updateJobStatus/${job.job_id}`, data, config)
      .then(response => {
        Swal.fire("อัพเดตสถานะงานสำเร็จ", "", "success");
        console.log('Job status updated successfully', response.data);

      })
      .catch(error => {
        Swal.fire("เกิดข้อผิดพลาดในการอัพเดตสถานะงาน", error.message, "error");
        console.error('Error updating job status:', error);

      });
  },
  jobStatusColor(status) {
    return status === 'open' ? 'green' : 'red'; // สีเขียวสำหรับสถานะเปิดและสีแดงสำหรับสถานะปิด
  },
},

};
</script>

<style scoped>
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
</style>
