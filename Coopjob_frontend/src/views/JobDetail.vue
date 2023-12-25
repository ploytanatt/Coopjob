<!--โค้ดเก่า
<template>
    <div>
      <div>
        <div class="has-background-light box mt-3 pl-3 pr-4 pt-4 pb-4">
        <p class="has-text-right"></p>
        <div class="columns mt-1">
          <div class="column is-11">
            <p class="is-size-5 p-4">
              <b>{{ jobs.title }}</b>
            </p>
            <div class="pl-3">
              <div class="p-4">
                <i class="pi pi-map-marker">
                  <span class="is-size-5 pl-4"><b>สถานที่ทำงาน:{{ jobs.location }} </b></span></i>
              </div>
              <div class="p-4">
                <i class="pi pi-dollar">
                  <span class="is-size-5 pl-4"><b>ค่าตอบแทน / วัน : {{ jobs.salary }} </b></span></i>
              </div>
              <div class="p-4">
                <i class="pi pi-user"><span class="is-size-5 pl-4"><b>ระยะเวลา / เดือน : {{ jobs.internship_duration }} </b></span></i>
              </div>
              <div class="p-4">
                <i class="pi pi-user"><span class="is-size-5 pl-4"><b>รายละเอียดงาน : {{ jobs.description }} </b></span></i>
              </div>
              <div class="p-4">
                <i class="pi pi-user"><span class="is-size-5 pl-4"><b>คุณสมบัติผู้สมัคร : {{ jobs.qualifications }} </b></span></i>
              </div>
            </div>
          </div>
          <div class="column my-3" style="display: flex;flex-direction: column;justify-content: space-between;">
            <button class="button is-success" v-show="user.role === 'applicant'" @click="applyToJob(jobs.job_id)">
              ยื่นสมัคร
            </button>
          </div>
        </div>
      </div>
      <div style="display: flex; flex-direction: column; align-items: flex-end">
      </div>
      </div>
    </div>
</template>-->

<template>
  <div>
    <div class="columns m-5">
      <div class="column is-1">
        <img
          src="https://media.licdn.com/dms/image/D4D0BAQEadGTydTHpOA/company-logo_200_200/0/1695133131669/img_golf_course_management_logo?e=2147483647&v=beta&t=xLnWCc44yGYTSK1xdMk4dg_EQXsXlblzMqdARTvs8eQ"
          alt="Your Image" style="width: 100%; height: 100%; object-fit: cover;" />
      </div>
      <div class="column is-4">
        <p class="is-size-5"><b>บริษัท sssss</b></p>
      </div>
      <div class="column is-4">
        <!--ช่องว่าง-->
      </div>
      <div class="column is-3 has-text-right">
        <button class="button mr-2" v-show="user.role === 'applicant'">
          <span class="icon is-small">
            <i class="fas fa-city"></i>
          </span>
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
          <p class="is-size-5-mobile is-size-4-desktop pl-4"><b>ชื่องาน : {{ jobs.title }}</b></p>
          <div class="pl-2">
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>รายละเอียด : </b>{{ jobs.description }}</span>
            </div>
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>สถานที่ทำงาน : </b>{{ jobs.location }} </span>
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
              <span class="is-size-5-mobile is-size-4-desktop pl-6"><b>ค่าตอบแทน: </b> {{ jobs.salary }} / วัน</span>
              <span class="is-size-5-mobile is-size-4-desktop pl-6"><b>สวัสดิการอื่นๆ </b>: xxxx </span>
            </div>
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>ระยะเวลาทำงาน :</b> {{ jobs.internship_duration }}
                เดือน
              </span>
            </div>
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>คุณสมบัติผู้สมัคร :</b> {{ jobs.qualifications }}
              </span>
            </div>
            <div class="p-4">
              <span class="is-size-5-mobile is-size-4-desktop pl-4"><b>ช่องทางการติดต่อ :</b></span>
              <span class="is-size-5-mobile is-size-4-desktop pl-4">ชื่อผู้ติดต่อ อีเมลล์ โทรศัพท์</span>
            </div>
          </div>
        </div>
        <!--<div class="column my-3" style="display: flex; flex-direction: column; justify-content: space-between;">
          <button class="button is-success" v-show="user.role === 'applicant'" @click="applyToJob(jobs.job_id)">
            ยื่นสมัคร
          </button>
        </div>-->
      </div>
    </div>
  </div>
</template>


<script>
  import axios from "axios";
  import Swal from "sweetalert2";
  export default {
    data() {
      return {
        company: null,
        jobs: [],
        user:[]
      };
    },
    mounted() {
      const jobId = this.$route.params.jobId;
      this.getCompanyJobs(jobId);
      this.getUser();
    },
    methods: {
 //     getUser() {
 //     const token = localStorage.getItem("token");
 //     const config = {
 //       headers: {
 //         Authorization: `Bearer ${token}`,
 //       },
 //     };
 //     axios.get("http://localhost:3000/user/me", config).then((res) => {
 //       
 //       this.user = res.data;
 //       console.log("App.vue", this.user)
 //     });
 //   },
      getCompanyJobs(jobId) {
        axios
          .get(`http://localhost:3000/recruiter/getJobDetail/${jobId}` )
          .then((response) => {
            this.jobs = response.data;
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
          });
      },
      
      showReportPopup() {
      Swal.fire({
        title: 'Report',
        html:
          '<div>' +
          '<label for="report-title">Title: </label>' +
          '<label><input type="radio" name="report-option" value="job" checked> Job </label>' +
          '<label><input type="radio" name="report-option" value="company"> Company </label>' +
          '</div><br>' +
          '<label for="report-description">Description:</label><br>'+
          '<textarea id="report-description" class="swal2-input" placeholder="Description"></textarea>',
        showCancelButton: true,
        confirmButtonText: 'ส่งรายงาน',
        cancelButtonText: 'ยกเลิก',
        showLoaderOnConfirm: true,
        preConfirm: () => {
          const reportOption = document.querySelector('input[name="report-option"]:checked').value;
          const title = document.getElementById('report-title').value;
          const description = document.getElementById('report-description').value;

          // ทำสิ่งที่คุณต้องการกับ reportOption, title, และ description
          console.log('Report Option:', reportOption);
          console.log('Title:', title);
          console.log('Description:', description);

          // ตอบสนองกับข้อมูล
          Swal.fire({
            title: 'ส่งรายงานเรียบร้อย',
            icon: 'success',
          });
        },
      });
    },
    },
  };
  </script>
  
  <style scoped>
  /* สไตล์ของหน้ารายละเอียดบริษัท */
  </style>
  