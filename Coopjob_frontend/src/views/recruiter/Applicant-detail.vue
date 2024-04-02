<template>
   <div class="columns is-centered">
  <div class="column is-3  mt-4">

        <button class="button is-dark go-back-button m-3"  @click="goback">
      <i class="fa-solid fa-left-long"></i> 
    </button>
    
  <div class="job-card card" v-for="application in applications" :key="application.student_job_id">

                <div class="job-card-header" >
                  <span class="job-date">Applied Jobs</span>
                  <small>{{ formatDate(application.applied_datetime) }}</small>
                </div>
                <hr>
                <div class="job-card-body">
                  <p class="card-header-title">ตำแน่งงาน: {{ jobName }} {{  getApplicationByJob(application.job_id) }}</p>
                </div>
                <header class="card">
                  <div class="card-header-icon is-pull-right">
                    <button class="button is-primary" @click="showModal = true" :disabled="application.application_status === 'approve'">Accept</button>
                    <button class="button is-danger ml-3" @click="declineApplicant(applicationUserId)">Decline</button>
                  </div>
                </header>
              </div>
              
              <div class="job-card card">
                <div class="job-card-body">
                  <div class="column">
                <div class="field">
                <label class="label">Personal Info</label>
                <div class="columns is-multiline  mt-1">
                  <p class="column is-6">ชื่อ-นามสกุล: {{ applicationJob.firstName }} {{ applicationJob.lastName }}</p>
                  
                  <p class="column is-6">เพศ: {{ applicationJob.gender }}</p>

                  <p class="column is-6">วัน-เดือน-ปี เกิด: {{  formatDate(applicationJob.birthdate)  }}</p>
                  <p class="column is-6">ที่อยู่:  {{applicationJob.address}}</p>
                
                </div>
              </div>
                <div class="field">
                <label class="label">Contact</label>
                <div class="control">
                  <p class="">  <i class="fa-regular fa-envelope mr-1"></i> Email</p>
                  <P class="ml-5"> {{ applicationJob.email }}</P>
                </div>
              </div>
              <div class="field">
        
                <div class="control">
                  <p class=""><i class="fa-regular fa-mobile mr-2"></i> Phone</p>
                  <P class="ml-5"> {{ applicationJob.phone_number }}</P>
                </div>
              </div>
              </div>
              </div>
        </div>
        
      </div>
      <!-- ส่วนของการอัพโหลด -->
      <div class="column is-7 mt-4 mr-3">
                    <div class="card">
                        <div class="content ">
                            <div class="tabs  is-boxed  mb-0 ">
                              <ul class="mt-0 pl-2 pr-2">
                                <li :class="[select_option === 'resume' ? 'is-active' : '']" @click="select_option = 'resume'">
                                  <a><span>Resume</span></a>
                                </li>
                                <li :class="[select_option === 'transcript' ? 'is-active' : '']" @click="select_option = 'transcript'">
                                  <a><span>Transcript</span></a>
                                </li>
                                <li :class="[select_option === 'portfolio' ? 'is-active' : '']" @click="select_option = 'portfolio'">
                                  <a><span>Portfolio</span>
                                  </a>
                                </li>
                              </ul>
                            </div>
                            <div class="p-2 mt-4">
                              <iframe :src="imagePath(applicationJob.resume)" type="application/pdf" class="pdf" v-if="select_option === 'resume'" />
                              <iframe :src="imagePath(applicationJob.transcript)" type="application/pdf" class="pdf" v-if="select_option === 'transcript'" />
                              <iframe :src="imagePath(applicationJob.portfolio)" type="application/pdf" class="pdf" v-if="select_option === 'portfolio'" />
                                     
                                </div>
                        </div>
                      </div>
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
    acceptApplicant(applicationJob) {

  const token = localStorage.getItem("token");
  const config = {
    headers: {
      Authorization: `Bearer ${token}`,
      'Content-Type': 'multipart/form-data',
    },
  };
  const formData = new FormData();
  const file = this.$refs.fileInput.files[0];
  if (!file) {
    Swal.fire({
      title: "เกิดข้อผิดพลาด",
      text: "กรุณาเลือกไฟล์ที่ต้องการอัพโหลด",
      icon: "error",
    });
    return;
  }
    // แสดง SweetAlert การอัพโหลด
  Swal.fire({
        didOpen: () => {
    Swal.showLoading() // แสดง spinner
  },
    title: 'กำลังประมวลผล...',
    text: 'กรุณารอสักครู่ในขณะที่เรากำลังดำเนินการยืนยันการรับสมัคร',
    allowOutsideClick: false,

  });
  formData.append('coopfile', file);
  formData.append('application_status', 'approve');

  axios.put(
    `http://localhost:3000/application/acceptApplicant/${applicationJob}`,
    formData,
    config
  )
  .then((res) => {
    // ปิด SweetAlert การโหลด
    Swal.close();
    Swal.fire({
      title: "สำเร็จ",
      text: res.data.message,
      icon: "success",
    });
    this.showModal = false;
    this.getApplication(this.applicationUserId);
  })
  .catch((error) => {
    // ปิด SweetAlert การโหลด
    Swal.close();
    let errorMessage = "เกิดข้อผิดพลาดในการประมวลผล";
    if (error.response && error.response.data && error.response.data.error) {
      errorMessage = error.response.data.error;
    }
    Swal.fire({
      title: "เกิดข้อผิดพลาด",
      text: errorMessage,
      icon: "error",
    });
  });
},

declineApplicant(applicationJob) {
  Swal.fire({
    title: 'คุณแน่ใจไหม?',
    text: "คุณต้องการปฏิเสธผู้สมัครนี้หรือไม่?",
    icon: 'warning',
    showCancelButton: true,
    confirmButtonColor: '#3085d6',
    cancelButtonColor: '#d33',
    confirmButtonText: 'ใช่, ปฏิเสธเลย!',
    cancelButtonText: 'ไม่, ยกเลิก'
  }).then((result) => {
    if (result.isConfirmed) {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      const application_status = "declined";

      axios.put(
        `http://localhost:3000/application/declineApplicant/${applicationJob}`,
        { application_status },
        config
      )
      .then((res) => {
        Swal.fire(
          'ปฏิเสธแล้ว!',
          res.data.message,
          'success'
        );
        this.getApplication(this.applicationUserId);
      })
      .catch((error) => {
        let errorMessage = "There was an error processing your request.";
        if (error.response && error.response.data && error.response.data.error) {
          errorMessage = error.response.data.error;
        }
        Swal.fire({
          title: "Error",
          text: errorMessage,
          icon: "error",
        });
      });
    }
  });
},
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
    formatDate(dateString) {
      const date = new Date(dateString);
      const options = {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hour12: false
      };
      return date.toLocaleDateString('en-EN', options);
    },
    goback(){
      this.$router.push("/applicantList");
    },
  },
};

</script>
<style scoped>


.job-card {
  background-color: #F8F8FD;
  border-radius: 6px;
  padding: 16px;
  box-shadow: 0 2px 4px #0000002d;
  margin-left: 16px;
  margin-right: 16px;
  margin-bottom: 16px; 
  width: 380px; 
}

.job-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px; /* Adjust as needed */
}

.job-title {
  font-weight: bold;
  color: #333; /* Adjust as needed */
}

.job-date {
  color: #666; /* Adjust as needed */
  font-size: 0.875rem;
}

.job-card-body p {
  margin: 0;
  color: #333; /* Adjust as needed */
}

.job-role {
  font-size: 1.125rem;
  font-weight: bold;
  margin-bottom: 4px; /* Adjust as needed */
}

.job-details {
  font-size: 0.875rem;
  color: #666; /* Adjust as needed */
}

hr {
  border: none;
  height: 1px;
  background-color: #ddd; /* Adjust as needed */
  margin-bottom: 8px; /* Adjust as needed */
}
.preview-pdf {
  width: 100%; 
  display: flex;
  justify-content: center; 
  background-color: #424242;
}

.pdf {
  width:100%; 
  height: 1080px;
}

.content ul{
  margin-left: 0;
}
</style>