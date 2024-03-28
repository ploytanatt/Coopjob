<template>
  <div class="columns">
    <applicantSideMenu></applicantSideMenu>
    <div class="column ">
      <div class="columns">
        <div class="column is-3  mt-4">
  
          <div class="job-card card">
                        <div class="job-card-header">
                          <span class="job-date">Applied Jobs</span>
                          <span class="job-date">วว/ดด/ปปปป</span>
                        </div>
                        <hr>
                        <div class="job-card-body">
                          <p class="job-role">Product Development</p>
                          <p class="job-details">Marketing • Internship</p>
                        </div>
                      </div>


                      <div class="job-card card">
                        <div class="job-card-body">
                          <div class="column">
                        <div class="field">
                        <label class="label">Personal Info</label>
                        <div class="columns is-multiline  mt-1">
                          <p class="column is-6">ชื่อ-นามสกุล: {{ user.firstName }} {{user.lastName }}</p>
                          
                          <p class="column is-6">เพศ: {{ user.gender }}</p>

                          <p class="column is-6">วัน-เดือน-ปี เกิด: {{formatDate(user.birthdate)}}</p>
                          <p class="column is-6">ที่อยู่: {{user.address }}</p>
                        
                        </div>
                      </div>
                        <div class="field">
                        <label class="label">Contact</label>
                        <div class="control">
                          <p class="">  <i class="fa-regular fa-envelope mr-1"></i> Email</p>
                          <P class="ml-5"> {{ user.email }}</P>
                        </div>
                      </div>
                      <div class="field">
                
                        <div class="control">
                          <p class=""><i class="fa-regular fa-mobile mr-2"></i> Phone</p>
                          <P class="ml-5"> {{ user.phone_number}}</P>
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
                                  <uploadResume v-if="select_option === 'resume'" ></uploadResume>
                              <uploadTranscript v-if="select_option === 'transcript'"></uploadTranscript>
                              <uploadPortfolio v-if="select_option === 'portfolio'" ></uploadPortfolio>     
                                </div>
                        </div>
                      </div>
                  </div>
                   
                   
      </div>
    </div>
    
    </div>
</template>
<script>
import UploadResume from "@/components/applicant/upload-resume.vue";
import uploadPortfolio from "./upload-portfolio.vue";
import uploadTranscript from "./upload-transcript.vue";
import applicantSideMenu from '@/components/applicant/applicant-side-menu.vue';
import axios from "@/plugins/axios";
export default {
  components: {
    UploadResume,
    uploadPortfolio,
    uploadTranscript,
    applicantSideMenu

  },
  data() {
    return {
      select_option: "resume",
      user: "",
    };
  },
  mounted() {
    // เรียก API เพื่อดึงข้อมูลส่วนตัวของผู้ใช้และกำหนดค่าให้กับตัวแปร
    this.getUserProfile();
  },
  methods: {
    getUserProfile() {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      axios
      axios.get("http://localhost:3000/applicant/getData", config).then((res) => {
      this.user = res.data[0];
     // console.log("getappProfile",user)
 
    });
},
formatDate(date) {
    return new Date(date).toLocaleDateString()
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
  width:80%; 
  height: 1080px;
}

.content ul{
  margin-left: 0;
}
</style>
