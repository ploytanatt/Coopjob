<template>
  <div class="container">
    <h1 class="title">แก้ไขงาน</h1>

    <form @submit="updateJob">
      <div class="field">
        <label class="label">ชื่องาน</label>
        <div class="control">
          <input class="input" type="text" v-model="$v.title.$model"/>
        </div>
        <p v-if="$v.title.$error" class="help is-danger">โปรดกรอกชื่องาน</p>
      </div>

      <div class="field">
        <label class="label">สถานที่ปฏิบัติงาน</label>
        <div class="control">
            <input class="input" type="text" v-model="$v.location.$model" />
        </div>
        <p v-if="$v.location.$error" class="help is-danger">โปรดกรอกสถานที่ปฏิบัติงาน</p>
      </div>

      <div class="field">
        <label class="label">ค่าตอบแทน</label>
        <div class="control">
            <input class="input" type="number" v-model="$v.salary.$model" />
      </div>
      <p v-if="$v.salary.$error" class="help is-danger">โปรดกรอกเงินเดือน</p>
      </div>

      <div class="field">
        <label class="label">สถานะ</label>
        <div class="control">
          <select class="input" v-model="$v.status.$model" required>
            <option value="open">เปิดรับสมัคร</option>
            <option value="close">ปิดรับสมัคร</option>
          </select>
        </div>
      </div>

      <div class="field">
        <label class="label">คำอธิบาย</label>
        <div class="control">
            <textarea class="textarea" v-model="$v.description.$model"></textarea>
      </div>
      <p v-if="$v.description.$error" class="help is-danger">โปรดกรอกคำอธิบาย</p>
      </div>

      <div class="field">
        <label class="label">คุณสมบัติ</label>
        <div class="control">
            <textarea class="textarea" v-model="$v.qualifications.$model"></textarea>
      </div>
      <p v-if="$v.qualifications.$error" class="help is-danger">โปรดกรอกคุณสมบัติ</p>
      </div>

      <div class="field">
        <label class="label">ระยะเวลา (เดือน)</label>
        <div class="control">
            <input class="input" type="number" v-model="$v.internship_duration.$model" />
      </div>
      <p v-if="$v.internship_duration.$error" class="help is-danger">โปรดกรอกระยะเวลา</p>
      </div>

      
    </form>
    <div class="field is-grouped">
      <div class="control">
        <button class="button is-primary" @click="updateJob()">บันทึก</button>
      </div>
      <div class="control">
        <button class="button is-link" @click="cancel()">ยกเลิก</button>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { required, minValue } from 'vuelidate/lib/validators';
import Swal from "sweetalert2";
export default {
  data() {
    return {
        title: "",
        location: "",
        salary: 0,
        status: "",
        description: "",
        qualifications: "",
        internship_duration: 0,
    };
  },
  created() {
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
          const job = res.data;
          this.title = job.title,
          this.location = job.location,
          this.status = job.status,
          this.salary = job.salary,
          this.description = job.description
          this.qualifications = job.qualifications,
          this.internship_duration = job.internship_duration
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
      const data ={
        title: this.title,
        description: this.description,
        salary: this.salary,
        location: this.location,
        qualifications: this.qualifications,
        internship_duration: this.internship_duration,
        status: this.status
      }
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
  validations: {
    title: {
      required,
    },
    location: {
      required,
    },
    salary: {
      required,
      minValue: minValue(0),
    },
    description: {
      required,
    },
    qualifications: {
      required,
    },
    internship_duration: {
      required,
      minValue: minValue(0),
    },
    status:{
        required
    }
  },
};
</script>

<style scoped>
.container {
  max-width: 800px;
  margin: auto;
  padding: 2rem;
}
</style>
