
<template>
  <div class="p-6 card">
    <h1 class="title">รายละเอียดงาน</h1>
    <div >
      <h2>{{ jobs.job_title }}</h2>

      <p><strong>ระยะเวลาฝึกงาน:</strong> {{ jobs.internship_duration }} เดือน</p>
      <p><strong>สถานะ:</strong> {{ jobs.status }}</p>
    </div>
  </div>
</template>
<script>
import axios from "axios";
//import { required, minValue } from 'vuelidate/lib/validators';
import Swal from "sweetalert2";
export default {
  data() {
    return {
        jobs:[],
    };
  },
  mounted() {
    this.getJobDetails();
  },
  methods: {
    getJobDetails() {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      const jobId = this.$route.params.jobId;
      axios
        .get(`http://localhost:3000/recruiter/getJobDetails/${jobId}`, config)
        .then((res) => {
          this.jobs = res.data;

        })
        .catch((error) => {
          console.log(error);
        });
    },

    updateJob() {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      const jobId = this.$route.params.jobId;
      const data = this.jobs
      axios
        .put(`http://localhost:3000/recruiter/updateJob/${jobId}`, data, config)
        .then((res) => {
          console.log(res.data);
          Swal.fire({
            icon: 'success',
            title: res.data.message,
            showConfirmButton: false,
            timer: 1500
        });
        this.$router.push('/recruiterJob');
        })
        .catch((error) => {
          console.log(error);
        });
    },
    cancel(){
        this.getJobDetails()
        this.$router.push('/recruiterJob');
    }
  },

};
</script>

<style scoped>
.card {
  width:  50%; /* เพิ่มความกว้างของการ์ด ค่าที่เพิ่มขึ้นนี้ขึ้นอยู่กับความต้องการของคุณ */
  margin: 0 auto; /* ใช้ในการจัดวางการ์ดให้อยู่ตรงกลางหน้าจอ */
  background-color: #eeeeee;
}
.profile_image {
  width: 150px;
  height: 150px;
  border: 2px solid gray;
  border-radius: 25px;
}
.cover_image {
 /* ทำให้ภาพเต็มความกว้างของ div */
/* ทำให้ภาพเต็มความสูงของ div */
  object-fit: cover; /* ปรับขนาดภาพให้พอดีกับขนาดของ div โดยไม่เกี่ยวข้องกับสัดส่วนของภาพ */
  border-radius: 10px; /* สามารถปรับค่า border-radius ตามที่ต้องการ */
}

.field.is-horizontals {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}
.selected-items {
  margin-top: 10px;
}
.tag {
  margin-right: 5px;
  margin-bottom: 5px;
}
.overlay-container {
      position: relative;
    }
.overlay-icon {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
.contactperson {
  background-color: rgb(255, 255, 255);
  border: 1px solid rgb(203, 203, 203);

}
</style>
