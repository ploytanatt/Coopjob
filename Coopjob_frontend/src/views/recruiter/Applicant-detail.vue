<template>
  <div class="w3-light-grey">
    
      <div class="card">
        <button class="button is-dark go-back-button"  @click="goback">
      <i class="fa-solid fa-left-long"></i> 
    </button>
        <div class="columns" v-for="application in applications" :key="application.student_job_id">
          <div class="column is-2 job_position mt-6">
            <div class="columns is-multiline  ml-6 mt-1">
              <p class="column is-12">ตำแน่งงาน:{{ jobName }} {{  getApplicationByJob(application.job_id) }}</p>
            </div>
            
          </div>

          <div class="columns is-2 ml-6 mt-6"  >
        <button class="button is-primary" @click="showModal = true"  :disabled="application.status === 'approve'" >Accept</button>
      </div>
          
        </div>
      
          <div class=" applicant_info">
            <div class="columns is-multiline ml-6 mt-1">
              <p class="column is-12">ชื่อ-นามสกุล: {{ applicationJob.firstName }} {{ applicationJob.lastName }}</p>
              <p class="column is-12">เพศ: {{ applicationJob.gender }}</p>
              <p class="column is-12">วัน-เดือน-ปี เกิด: {{  applicationJob.birthdate  }}</p>
              <p class="column is-12">ที่อยู่: {{applicationJob.address}}</p>
              <p class="column is-12">เบอร์โทร: {{ applicationJob.phone_number }}</p>
              <p class="column is-12">อีเมล: {{ applicationJob.email }}</p>
            </div>
          </div>

 
       
        <div class="tabs is-centered is-boxed">
      <ul>
        <li :class="[select_option === 'resume' ? 'is-active' : '']" @click="select_option = 'resume'">
          <a>
            <span>Resume</span>
          </a>
        </li>
        <li :class="[select_option === 'transcript' ? 'is-active' : '']" @click="select_option = 'transcript'">
          <a>
            <span>Transcript</span>
          </a>
        </li>
        <li :class="[select_option === 'portfolio' ? 'is-active' : '']" @click="select_option = 'portfolio'">
          <a>
            <span>Portfolio</span>
          </a>
        </li>
      </ul>
      
    </div>
    <div class="preview-pdf">
      <iframe :src="imagePath(applicationJob.resume)" type="application/pdf" class="pdf" v-if="select_option === 'resume'" />
      <iframe :src="imagePath(applicationJob.transript)" type="application/pdf" class="pdf" v-if="select_option === 'transcript'" />
      <iframe :src="imagePath(applicationJob.portfolio)" type="application/pdf" class="pdf" v-if="select_option === 'portfolio'" />
    </div>
        <!-- Modal Content -->
        <div class="modal" :class="{ 'is-active': showModal }">
          <div class="modal-background"></div>
          <div class="modal-card">
            
            <header class="modal-card-head">
              
              <p class="modal-card-title"> กรุณาทำตามขั้นตอนการรับสมัครดังนี้</p>
              
              <button class="delete" aria-label="close" @click="showModal = false"></button>
            </header>
            <section class="modal-card-body">
              <article class="download-instructions">
                <h2>1.ดาวน์โหลดแบบตอบรับและเสนองานนักศึกษาสหกิจศึกษา</h2>
                  <div class="file has-name">
                  <label class="file-label" @click="downloadFile('http://localhost:3000/coop302/coop302.pdf')">               
                    <span class="file-cta">
                      <span class="file-icon">
                        <i class="fa-sharp fa-solid fa-download"></i>
                      </span>
                      <span class="file-label">Download</span>
                    </span>
                    <span class="file-name">coop302.pdf</span>
                  </label>
                </div>
              </article>
            <div class="upload-section">
              <div class="upload-area">
                <h2>2.ทำการกรอกข้อมูลลงในแบบฟอร์มและอัพโหลดไฟล์ลงในช่องด้านล่าง</h2>
                <div class="file has-name">
                  <label class="file-label">
                    <input class="file-input" type="file" ref="fileInput" accept=".pdf" @change="handleFileUpload($event)" />
                    <span class="file-cta">
                      <span class="file-icon">
                        <i class="fa-sharp fa-solid fa-upload"></i>
                      </span>
                      <span class="file-label">
                        Choose a file…
                      </span>
                    </span>
                    <span class="file-name">{{ file ? file.name : 'No file selected' }}</span>

                  </label>
                </div>
              </div>
            </div>
            <div class="upload-section">
              <div class="upload-area">
                <h2>3.กด Submit เพื่อส่งเอกสารแบบตอบรับและเสนองานนักศึกษาสหกิจศึกษา</h2>
              </div>
            </div>
            </section>
            <footer class="modal-card-foot">
              
              <button class="button is-medium is-success" @click="acceptApplicant(applicationUserId, file)">ผ่าน</button>
              <button class="button" @click="showModal = false">Cancel</button>
            </footer>
          </div>
          
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
      applications: [],
      applicationss: [],
      applicationJob: [],
      select_option:'resume',
      showModal: false,
      file:'',
      applicationUserId:'',
      applicationsByJob:[],
      jobName:''
    };
  },
  mounted() {
    const applicationId = this.$route.params.applicationId;

    this.getApplication(applicationId);
    this.getApplicationDetails(applicationId);
    this.getApplications();
  },
  methods: {
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
          this.applicationss = response.data;
          this.isLoading = false;
        })
        .catch((error) => {
          console.error(error);
          this.isLoading = false;
        });
    },
    getApplication(applicationId) {
      this.isLoading = true;
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      axios
        .get(`http://localhost:3000/application/getApplication/${applicationId}`, config)
        .then((response) => {
          this.applications = response.data[0];      
        })
        .catch((error) => {
          console.error(error);
        });
    },
    getApplicationByJob(jobId) {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      axios
        .get(`http://localhost:3000/application/getApplicationByJob/${jobId}`, config)
        .then((response) => {
          this.applicationsByJob = response.data;
          this.jobName = response.data[0].job_title
        })
        .catch((error) => {
          console.error(error);
        });
    },
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
          this.applicationUserId = applicationId;
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
    acceptApplicant(applicationJob, file) {
        const token = localStorage.getItem("token");
        const config = {
          headers: {
            Authorization: `Bearer ${token}`,
            'Content-Type': 'multipart/form-data',
          },
        };
        const filess = this.$refs.fileInput.files[0];
        const formData = new FormData();
        formData.append('coopfile', filess); 
        formData.append('status', 'approve'); 
        if (!file) {
          this.errors = ["Please select a file to upload."];
          return;
        }
        axios.put(
          `http://localhost:3000/application/updateStatus/${applicationJob}`,
          formData,
          config
        )
        .then((res) => {
          Swal.fire({
        title: res.data.message,
        icon: "success",
      })
      this.showModal = false;
      this.getApplication(this.applicationUserId);
        })
        .catch((error) => {
          Swal.fire(error);
        });
    },
   //   declineApplicant(applicationJob) {
   //   const token = localStorage.getItem("token");
   //   const config = {
   //     headers: {
   //       Authorization: `Bearer ${token}`,
   //     },
   //   };
   //   const status = "reject";
   //   axios
   //     .put(
   //       `http://localhost:3000/application/updateStatus/${applicationJob}`,
   //       { status },
   //       config
   //     )
   //     .then((res) => {
   //       Swal.fire(res.data.message, "", "success");
   //       this.getApplications(); // โหลดข้อมูลใหม่หลังจากปฏิเสธ
   //     })
   //     .catch((error) => {
   //       console.error(error);
   //     });
   // },

    downloadFile(url) {
      fetch(url)
        .then(response => response.blob())
        .then(blob => {
          const url = window.URL.createObjectURL(new Blob([blob]));
          const link = document.createElement('a');
          link.href = url;
          link.setAttribute('download', 'coop302.pdf'); // ตั้งชื่อไฟล์ที่จะโหลด
          document.body.appendChild(link);
          link.click();
          link.parentNode.removeChild(link);
        });
    },
    handleFileUpload(event) {
      this.file = event.target.files[0]; // เซ็ตค่าของ file เมื่อมีการเปลี่ยนแปลงไฟล์
    }, 
    goback(){
      this.$router.push("/applicantList");
    },
  },
};

</script>
<style scoped>

.job_position{
  background-color: #e6e6e6;
  width: 40%;
  margin-bottom: 2rem;
  border-radius: 7px;
  box-shadow: 1px 1px 1px 1px #00000019;
}

.applicant_info{
  background-color: #efefef;
  width: 100%;
  margin-bottom: 2rem;
  border-radius: 7px;
  box-shadow: 1px 1px 1px 1px #00000019;
}

.preview-pdf {
width: 100%;
height: 1000px;
display: flex;
  justify-content: center; /* จัดให้อยู่ตรงกลางแนวนอน */
background-color: #c9c9c9;
}

.pdf{
  width: 60%;
}
</style>