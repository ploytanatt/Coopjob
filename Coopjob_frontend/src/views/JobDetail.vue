<template>
  <div class="container mt-4">

    <div class="columns m-5">

      <img :src="imagePath(job.profile_image)" class="column is-2 profile_image" />
      <p class="is-size-4 has-text-weight-bold">{{ job.company_name }}</p>

      <div class="column is-4">

      </div>
      <div class="column is-3 has-text-right" v-show="user.role === 'applicant'"  >
    
        <button class="button mr-2 heart" @click="favThisJob(job.job_id)"  v-if="!isJobLiked ">
          <i class="fa fa-heart is-medium "></i>
        </button>
        <button class="button mr-2 heart" @click="unfavThisJob(job.job_id)" v-if="isJobLiked">
          <i class="fa fa-heart is-medium is-liked"></i>
        </button>
        <button class="button is-success mr-2" @click="applyToJob(job.job_id)">
          ยื่นสมัคร
        </button>
        <button @click="showReportModal(job.job_id)" class="button is-danger">รายงาน</button>
      </div>
    </div>

    <div class="box has-background-light m-5">
      <p class="has-text-right"></p>
      <div class="columns mt-1">
        <div class="column is-11">
          <p class="is-size-5-mobile is-size-4-desktop pl-4"><b>ชื่องาน : {{ job.title }}</b></p>
          <div class="pl-2">
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>รายละเอียด : </b>{{ job.description }}</span>
            </div>
            
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>จำนวนที่รับสมัคร : </b>{{ job.date_posted }}</span>
            </div>
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>วันที่รับสมัคร : </b></span>
            </div>
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>สวัสดิการ : </b></span>
            </div>
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-6"><b>ค่าตอบแทน: </b> {{ job.salary }} / วัน</span>
              <span class="is-size-5-mobile is-size-4-desktop pl-6"><b>สวัสดิการอื่นๆ </b>: xxxx </span>
            </div>
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>ระยะเวลาทำงาน :</b> {{ job.internship_duration
              }}
                เดือน
              </span>
            </div>
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>คุณสมบัติผู้สมัคร :</b> {{ job.qualifications
              }}
              </span>
            </div>
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>ช่องทางการติดต่อ :</b></span>
              <span class="is-size-5-mobile is-size-4-desktop pl-4">ชื่อผู้ติดต่อ อีเมลล์ โทรศัพท์</span>
            </div>
          </div>
        </div>
      </div>
    </div>

     <!-- Report Modal -->
     <div :class="{'is-active': isReportModalActive}" class="modal">
      <div class="modal-background"></div>
      <div class="modal-card">
        <header class="modal-card-head">
          <p class="modal-card-title">Report</p>
          <button class="delete" aria-label="close" @click="isReportModalActive = false"></button>
        </header>
        <section class="modal-card-body">
          <div>
            <label for="report-option">หัวข้อ: </label>
            <label><input type="radio" v-model="$v.reportType.$model" value="job"> Job </label>
            <label><input type="radio" v-model="$v.reportType.$model" value="company"> Company </label>
          </div>
          <p v-if="$v.reportType.$error" class="help is-danger">โปรดกรอกข้อมูล</p>
          <div class="field">
            <label for="report-description">คำอธิบาย:</label>
            <textarea v-model="$v.reportDescription.$model" class="textarea" placeholder="Description"></textarea>
          </div>
          <p v-if="$v.reportDescription.$error" class="help is-danger">โปรดกรอกข้อมูล</p>
        </section>
        <footer class="modal-card-foot">
          <button class="button is-success" @click="submitReport">Submit Report</button>
          <button class="button" @click="isReportModalActive = false">Cancel</button>
        </footer>
      </div>
    </div>
  </div>
</template>


<script>
import axios from "axios";
import Swal from "sweetalert2";
import { required} from 'vuelidate/lib/validators';
export default {
  data() {
    return {

      job: [],
      alljobs: [],
      user: [],
      isJobLiked:false,
      
      isReportModalActive: false,
      reportType: 'job',
      reportDescription: '',
      selectedJobId: null,
    };
  },
  mounted() {
    this.getUser();
    const jobId = this.$route.params.jobId;
    this.getCompanyJobs(jobId);
    this.checkIfJobIsLiked(jobId);
  },
  methods: {
    getUser() {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      axios.get("http://localhost:3000/user/me", config).then((res) => {
        this.user = res.data;
        //console.log("App.vue", this.user)
      });
    },
    
    checkIfJobIsLiked(jobId) {
    const token = localStorage.getItem("token");
    axios.get(`http://localhost:3000/application/checkJobLiked/${jobId}`, {
      headers: { Authorization: `Bearer ${token}` }
    })
    .then(response => {
      this.isJobLiked = response.data.isLiked;
    })
    .catch(error => {
      console.error(error);
    });
  },

    getCompanyJobs(jobId) {
      axios.get(`http://localhost:3000/recruiter/getJobDetail/${jobId}`)
        .then((response) => {
          this.job = response.data[0];
        })
        .catch((error) => {
          console.error(error);
        });
    },

    applyToJob(jobId) {
  const token = localStorage.getItem("token");
  const config = {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  };
  const data = {
    user_id: this.user.user_id,
    job_id: jobId,
  };
  console.log(`Applying to job ${jobId}`);
  axios
    .post(`http://localhost:3000/application/sendApplicationJob`, data, config)
    .then(res => {
      console.log(res.data.message)
      Swal.fire({
        position: "center",
        icon: "success",
        title: "ดำเนินการสำเร็จ",
        showConfirmButton: false,
      });
    })
    .catch(error => {
      console.error(error);
      let errorMessage = 'เกิดข้อผิดพลาดในการสมัครงาน กรุณาลองใหม่ภายหลัง';
      if (error.response && error.response.data && error.response.data.error) {
        errorMessage = error.response.data.error;
      }

      Swal.fire({
        icon: 'error',
        title: 'สมัครงานไม่สำเร็จ',
        text: errorMessage
      });
    });
},


    showReportModal(jobId) {
      this.isReportModalActive = true;
      this.selectedJobId = jobId;
    },
    async submitReport() {
      const token = localStorage.getItem('token');

      this.$v.$touch();
     if (!this.$v.$error) {
      const data = {
        job_id: this.selectedJobId,
        user_id: this.user.user_id,
        report_title: this.reportType,
        report_description: this.reportDescription,
      };

      try {
        const response = await axios.post('http://localhost:3000/application/submitReport', data, {
          headers: { Authorization: `Bearer ${token}` },
        });
        console.log(response.data.message);
        this.isReportModalActive = false;
        // Show success message
      } catch (error) {
        console.error(error);
        // Handle the error
      }}
    },
    favThisJob(jobId) {
      const token = localStorage.getItem("token");
      axios.post(`http://localhost:3000/application/sendFavoriteJob/${jobId}`, {}, {
        headers: { Authorization: `Bearer ${token}` }
      })
      .then(() => {
        this.isJobLiked = true;
        Swal.fire("Liked!", "You have liked this job.", "success");
      })
      .catch(error => {
        console.error(error);
      });
    },
    unfavThisJob(jobId) {
      const token = localStorage.getItem("token");
      axios.delete(`http://localhost:3000/application/cancelFavoriteJob/${jobId}`, {
        headers: { Authorization: `Bearer ${token}` }
      })
      .then(() => {
        this.isJobLiked = false;
        Swal.fire("Unliked!", "You have unliked this job.", "success");
      })
      .catch(error => {
        console.error(error);
      });
    },
    imagePath(companyProfileImage) {
      if (companyProfileImage) {
        return "http://localhost:3000" + companyProfileImage.replace(/\\/g, '/').replace('static', '');
      } else {
        return "https://bulma.io/images/placeholders/640x360.png";
      }
    },

  },
  validations: {
    reportType:{
      required
    },
    reportDescription:{
      required
    }
  }
};
</script>
  
<style scoped>
/* สไตล์ของหน้ารายละเอียดบริษัท */
.profile_image {
  width: 150px;
  height: 150px;
  border: 2px solid gray;
  padding: 0;
  border-radius: 25px;
}
.is-liked{
  color: red;
}
</style>
  