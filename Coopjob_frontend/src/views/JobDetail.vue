<template>
  <div class="containerJob ">
  <div class="job-detail-container ">
      
    <div class="columns ">
      <!-- Left Column: Job Description -->
      <div class="column is-9 mt-6">
        <div class="box">
          <div class="media">
            <div class="media-left">
              <figure class="image is-128x128">
                <router-link :to="'/company/' + job.user_id" >
                <img :src="imagePath(job.profile_image)" alt="Company logo">
                </router-link>
              </figure>
            </div>
            <div class="media-content">
              <div class="content">
               <span class="tag is-dar">{{ job.job_status }}</span>
                <p class="mb-1">
                
                  <strong>{{ job.job_title }}</strong> <br>
                  {{ job.company_name}}
                </p>
                <p class="tags "><span class="tag is-primary">{{ job.job_type }}</span></p>
               
                <small>วันที่ลงประกาศ: {{ formatDate(job.date_posted) }}</small> 
              </div>
            </div>

            <div class="media-right buttons is-aligned-top" v-show="user.role === 'applicant' && job.job_status === 'open'">
              <button class="button mr-2 heart" @click="favThisJob(job.job_id)" v-if="!isJobLiked">
                <i class="fa fa-heart"></i>
              </button>
              <button class="button mr-2 heart is-liked" @click="unfavThisJob(job.job_id)" v-if="isJobLiked">
                <i class="fa fa-heart"></i>
              </button>
              <button class="button is-success mr-2" @click="confirmApplyJob(job.job_id)">
                Apply
              </button>
              <button @click="showReportModal(job.job_id)" class="button is-danger">
                Report
              </button>
            </div>
          </div>
          <hr>
          <div>
          <div v-if="isImage(job.job_upload_file)  ">
            <img :src="imagePath(job.job_upload_file)" class="jobUpload">
          </div>
          <div v-else-if="isPdf(job.job_upload_file)">
            <iframe :src="imagePath(job.job_upload_file)" class="preview-pdf" />
          </div>
        </div>
         
          <div class="content is-3">
            <h3>คำอธิบาย</h3>
            <p>{{ job.job_description }}</p>
            <h3>คุณสมบัติผู้สมัคร</h3>
            <li v-for="item in specification" :key="item.text">{{ item.text }}</li>
            <h3>สวัสดิการ</h3>
            <li v-for="item in benefit" :key="item.text">{{ item.text }}</li>
          </div>
        </div>
      </div>

      <!-- Right Column: Job Summary and Apply Button -->
      <div class="column is-3 mt-6">
        <div class="box ">
          <i class="fa-sharp fa-solid fa-location-dot"></i>
          <span v-for="(type, index) in location" :key="index" > {{ type.tambon }} {{ type.amphure }} {{ type.province }} {{ type.zip_code }}</span>
          <p><strong>ระยะเวลา:</strong> {{ job.internship_duration }} months</p>
          <p><strong>ชื่อโครงงาน:</strong> {{ job.project_name }}</p>
          <p><strong>GPA:</strong> {{ job.gpa }}</p>
          <p><i class="fa-solid fa-envelope-open-dollar"></i><span> {{ job.salary }} บาท/วัน</span></p>
          <p><i class="fa-solid fa-user"></i><span> {{ job.quantity }} อัตรา</span></p>
        </div>
         <div class="box ">
          <div class="content has-text-centered">
            <h3>ติดต่อ</h3>
            <hr>
            </div>
          <p><strong>ชื่อผู้ติดต่อ:</strong> {{ job.contact_person_name }}</p>
          <p><strong>แผนก:</strong> {{ job.contact_person_department }}</p>
          <p><strong>โทรศัพท์:</strong> {{ job.contact_phone_number }}</p>
          <p><strong>อีเมล:</strong> {{ job.contact_email }}(อีเมลนี้ใช้สำหรับการติดต่อและสมัครงาน)</p>
        </div>
        <div class="tags-container is-flex is-justify-content-center">
          <span><strong>Tags:</strong></span>
          <span v-for="(type, index) in position_type" :key="index" class="tag is-info ml-2">{{ type.title }}</span>
        </div>
      </div>
    </div>
    <p>งานอื่น ๆ ของบริษัทนี้</p>
    <div class="columns is-multiline">
      <div class="column is-one-third" v-for="job in jobs.slice(0, 3)" :key="job.job_id">
        <div class="card card-equal-height" @click="viewJob(job.job_id)">
          <div class="card-content">
            <p class=""><strong>{{ job.job_title }}</strong></p>
            <i class="fa-sharp fa-solid fa-location-dot"></i>
          <span v-for="(type, index) in location" :key="index" > {{ type.tambon }} {{ type.amphure }} {{ type.province }} {{ type.zip_code }}</span>
           <p><i class="fa-solid fa-envelope-open-dollar"></i><span> {{ job.salary }} บาท/วัน</span></p>
            
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
      jobs: [],
      alljobs: [],
      user: [],
      companyId:'',
      isJobLiked:false,

      location:[],
      benefit:[],
      specification:[],
      position_type:[],
      
      isReportModalActive: false,
      reportType: 'job',
      reportDescription: '',
      selectedJobId: null,
    };
  },
  watch: {
    companyId(newValue, oldValue) {
      if (newValue !== oldValue && newValue) {
        this.getCompanyJobs(newValue);
      }
    }
  },
  mounted() {
    this.onAuthChange();
    const jobId = this.$route.params.jobId;
    this.getCompanyJobDetail(jobId);
    const c_user_id = this.companyId;
    this.checkIfJobIsLiked(jobId);
    this.getCompanyJobs(c_user_id);
  },
  methods: {
    onAuthChange() {
      const token = localStorage.getItem("token");
      if (token) {
        this.getUser();
      } else {
        this.user = ''; // เคลียร์ค่า user เมื่อไม่มี token
      }
    },
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

    getCompanyJobDetail(jobId) {
      axios.get(`http://localhost:3000/recruiter/getJobDetail/${jobId}`)
        .then((response) => {
          this.job = response.data[0];
          this.position_type = JSON.parse(this.job.position_type);
          this.benefit = JSON.parse(this.job.benefit);
          this.specification = JSON.parse(this.job.specification);
          this.location = JSON.parse(this.job.location);
          this.companyId = this.job.user_id;
        })
        .catch((error) => {
          console.error(error);
        });
    },

    getCompanyJobs(companyId) {
        console.log("companyId", companyId)
      axios
        .get(`http://localhost:3000/recruiter/getAnotherJobs/${companyId}`)
        .then((response) => {
          this.jobs = response.data;
        })
        .catch((error) => {
          console.error(error);
        });
    },
    confirmApplyJob(jobId) {
      Swal.fire({
        title: "ยืนยันการสมัครงาน",
        text: "คุณต้องการสมัครงานนี้หรือไม่?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "ยืนยัน",
        cancelButtonText: "ยกเลิก",
      }).then((result) => {
        if (result.isConfirmed) {
          this.applyToJob(jobId);
        }
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
        Swal.fire({
              position: "center",
              icon: "success",
              title: "ดำเนินการเรียบร้อย",
              showConfirmButton: response.data.message,
            });
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
    formatDate(date) {
      return new Date(date).toLocaleDateString()
    },
    viewJob(jobId){
      if (this.$route.path !== "/job/"+jobId) {
                this.$router.push("/job/"+jobId);
            }
    },
    isImage(filePath) {
      return /\.(jpeg|jpg|gif|png)$/i.test(filePath);
    },
    // ตรวจสอบว่าไฟล์เป็น PDF หรือไม่
    isPdf(filePath) {
      return /\.pdf$/i.test(filePath);
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
.containerJob {
  width: 100%; /* กำหนดความกว้างเป็น 80% ของหน้าจอ */
  margin: 0 auto; /* จัดให้เนื้อหาอยู่ตรงกลางของหน้าจอในแนวนอน */
 /* เปิดใช้งาน flexbox */
  justify-content: center; /* จัดตำแหน่งเนื้อหาให้อยู่ตรงกลาง */
  padding-left: 8rem;
  padding-right: 8rem;
  min-height: 100vh; /* กำหนดความสูงขั้นต่ำให้เต็มหน้าจอ */
  background-color: #f5f8fa;
}
.profile_image {
  width: 130px;
  height: 150px;
  border: 2px solid gray;
  padding: 0;
  border-radius: 25px;
}
.is-liked{
  color: red;
}
.card-equal-height {
  height: 120px;
  /* Add a transition effect for scaling */
  transition: transform 0.3s ease;
}

.card-equal-height:hover {
  /* Scale up the card slightly when hovering */
  transform: scale(1.05);
}

.card-content {
  flex-grow: 1;
  background-color: hsl(0, 0%, 100%);
}
.jobUpload{
  width: 200px;
}

.box{}
</style>
  