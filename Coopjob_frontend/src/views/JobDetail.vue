<template>
  <div class="container mt-4">

    <div class="columns m-5">

      <img :src="imagePath(jobs[0].company.profile_image)" class="column is-2 profile_image" />
      <div class="column ml-4" style="position: relative; top: 100px">
        <p class="is-size-4 has-text-weight-bold">{{ jobs[0].company.company_name }}</p>
      </div>
      <div class="column is-4">
        <!--ช่องว่าง-->
      </div>
      <div class="column is-3 has-text-right">

        <!--<button class="button mr-2" v-show="user.role === 'applicant'" @click="favoriteJob(jobs.job_id)">
          <font-awesome-icon icon="heart" />
        </button>-->
        <!-- ปุ่ม Like เปลี่ยนสีที่ไอค่อน 
        <button class="button mr-2" @click="favoriteJob(jobs.job_id)" v-show="user.role === 'applicant'">
          <font-awesome-icon :icon="isJobLiked ? 'heart' : ['far', 'heart']"
            :style="{ color: isJobLiked ? 'red' : 'black' }" />
        </button>-->

        <!-- ปุ่ม Like  เปี่ลยนสีที่ปุ่ม-->
        <button class="button mr-2" @click="favoriteJob(jobs.job_id)"
          :class="{ 'is-danger': isJobLiked, 'is-dark': !isJobLiked }" v-show="user.role === 'applicant'">
          <font-awesome-icon icon="heart" />
        </button>
        <button class="button is-success mr-2" v-show="user.role === 'applicant'" @click="applyToJob(jobs.job_id)">
          ยื่นสมัคร
        </button>
        <button class="button is-danger" v-show="user.role === 'applicant'" @click="showReportPopup">
          รายงาน
        </button>
      </div>
    </div>

    <div class="box has-background-light m-5">
      <p class="has-text-right"></p>
      <div class="columns mt-1">
        <div class="column is-11">
          <p class="is-size-5-mobile is-size-4-desktop pl-4"><b>ชื่องาน : {{ jobs[0].title }}</b></p>
          <div class="pl-2">
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>รายละเอียด : </b>{{ jobs[0].description }}</span>
            </div>
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>สถานที่ทำงาน : </b>{{ jobs[0].location }} </span>
            </div>
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>จำนวนที่รับสมัคร : </b></span>
            </div>
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>วันที่รับสมัคร : </b></span>
            </div>
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>สวัสดิการ : </b></span>
            </div>
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-6"><b>ค่าตอบแทน: </b> {{ jobs[0].salary }} / วัน</span>
              <span class="is-size-5-mobile is-size-4-desktop pl-6"><b>สวัสดิการอื่นๆ </b>: xxxx </span>
            </div>
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>ระยะเวลาทำงาน :</b> {{ jobs[0].internship_duration
              }}
                เดือน
              </span>
            </div>
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>คุณสมบัติผู้สมัคร :</b> {{ jobs[0].qualifications
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
  </div>
</template>


<script>
import axios from "axios";
import Swal from "sweetalert2";
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
export default {
  components: {
    FontAwesomeIcon
  },
  data() {
    return {

      jobs: [],
      alljobs: [],
      user: [],
      isJobLiked: false, // เพิ่มตัวแปรเพื่อเก็บสถานะการถูกใจ
    };
  },
  mounted() {
    const jobId = this.$route.params.jobId;
    this.getCompanyJobs(jobId);
    this.getUser();
    const storedLikedStatus = localStorage.getItem(`jobLikedStatus_${jobId}`);
    this.isJobLiked = storedLikedStatus === 'true'; // หรือทำเงื่อนไขตามความเหมาะสม
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
        console.log("App.vue", this.user)
      });
    },
    getCompanyJobs(jobId) {
      axios.get(`http://localhost:3000/recruiter/getJobDetail/${jobId}`)
        .then((response) => {
          const job = response.data;

          // เรียก API เพื่อดึงข้อมูลบริษัท
          axios.get(`http://localhost:3000/recruiter/getRecruiterDetails/${job.user_id}`)
            .then(recruiterResponse => {
              // เชื่อมโยงข้อมูลบริษัทกับงาน
              job.company = recruiterResponse.data;

              // ใช้ Map เพื่อเพิ่ม job ลงใน jobs
              this.jobs = this.jobs.map(job => {
                return job;
              });
              // ถ้า job ไม่มีอยู่ใน jobs ให้เพิ่ม job เข้าไป
              if (!this.jobs.find(existingJob => existingJob.id === job.id)) {
                this.jobs.push(job);
              }
            })
            .catch(error => {
              console.error(error);
            });
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
      //console.log(`Applying to job ${jobId}`);
      try {
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

            // ถ้ามีข้อผิดพลาดที่เกิดจากการสมัครงานที่ซ้ำกัน
            if (error.response && error.response.status === 400 && error.response.data.error) {
              Swal.fire({
                icon: 'error',
                title: 'สมัครงานซ้ำ',
                text: error.response.data.error,
              });
            } else {
              // ถ้าเป็นข้อผิดพลาดอื่น ๆ
              Swal.fire({
                icon: 'error',
                title: 'เกิดข้อผิดพลาด',
                text: 'กรุณาลองใหม่ภายหลัง',
              });
            }
          });
      } catch (error) {
        console.log(error);
      }
    },

    showReportPopup() {
      Swal.fire({
        title: 'Report',
        html:
          '<div>' +
          '<label for="report-title">Title: </label>' +
          '<input type="hidden" id="report-title" class="swal2-input">' +
          '<label><input type="radio" name="report-option" value="job" checked> Job </label>' +
          '<label><input type="radio" name="report-option" value="company"> Company </label>' +
          '</div><br>' +
          '<label for="report-description">Description:</label><br>' +
          '<textarea id="report-description" class="swal2-input" placeholder="Description"></textarea>',
        showCancelButton: true,
        confirmButtonText: 'Submit Report',
        cancelButtonText: 'Cancel',
        showLoaderOnConfirm: true,
        preConfirm: () => {
          const reportOption = document.querySelector('input[name="report-option"]:checked').value;
          const title = (reportOption === 'job') ? 'Job' : 'Company'; // Set title based on report-option
          const description = document.getElementById('report-description').value;

          const token = localStorage.getItem('token');
          const config = {
            headers: {
              Authorization: `Bearer ${token}`,
            },
          };

          const data = {
            job_id: (reportOption === 'job') ? this.jobs.job_id : null,
            user_id: this.user.user_id,
            title,
            description,
          };

          // Send the report data to the backend
          axios.post('http://localhost:3000/application/sendReport', data, config)
            .then((res) => {
              console.log(res.data.message);
              Swal.fire({
                title: 'Report submitted successfully',
                icon: 'success',
              });
            })
            .catch((error) => {
              console.error(error);
              Swal.fire({
                icon: 'error',
                title: 'Error',
                text: 'Failed to submit report. Please try again later.',
              });
            });
        },
      });
    },

    favoriteJob(jobId) {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };

      axios
        .post(`http://localhost:3000/application/sendFavoriteJob/${jobId}`, {}, config)
        .then(res => {
          console.log(res.data.message);
          // ทำอย่างอื่น ๆ ที่คุณต้องการหลังจากกดถูกใจสำเร็จ
          this.isJobLiked = !this.isJobLiked; // สลับค่า isJobLiked เมื่อกดถูกใจ
          localStorage.setItem(`jobLikedStatus_${jobId}`, this.isJobLiked); // บันทึกสถานะลงใน LocalStorage
        })
        .catch(error => {
          console.error(error);
          // ถ้ามีข้อผิดพลาด
          if (error.response && error.response.status === 400 && error.response.data.error === 'You have already liked this job.') {
            // ถ้าผู้ใช้กดถูกใจแล้ว
            // ให้ทำการยกเลิกการถูกใจ
            axios.delete(`http://localhost:3000/application/cancelFavoriteJob/${jobId}`, config)
              .then(cancelRes => {
                console.log(cancelRes.data.message);
                console.log('Unlike successful');
                this.isJobLiked = !this.isJobLiked; // สลับค่า isJobLiked เมื่อกดถูกใจ
                localStorage.setItem(`jobLikedStatus_${jobId}`, this.isJobLiked); // บันทึกสถานะลงใน LocalStorage
              })
              .catch(cancelError => {
                console.error(cancelError);
                // ถ้ามีข้อผิดพลาดในการยกเลิกถูกใจ
                Swal.fire({
                  icon: 'error',
                  title: 'เกิดข้อผิดพลาดในการยกเลิกถูกใจ',
                  text: 'กรุณาลองใหม่ภายหลัง',
                });
              });
          } else {
            // ถ้าเป็นข้อผิดพลาดอื่น ๆ
            Swal.fire({
              icon: 'error',
              title: 'เกิดข้อผิดพลาด',
              text: 'กรุณาลองใหม่ภายหลัง',
            });
          }
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
</style>
  