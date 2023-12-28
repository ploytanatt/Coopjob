<template>
  <div class="p-6 card">
    <h1 class="title">เพิ่มงาน</h1>

    <div class="field">
      <label class="label">ประเภทงาน</label>
      <div class="control">
        <label class="radio">
          <input type="radio" v-model="jobType" value="internship" />
          ฝึกงาน
        </label>
        <label class="radio">
          <input type="radio" v-model="jobType" value="cooperative" />
          สหกิจศึกษา
        </label>
      </div>
    </div>

    <div class="field" >
      <label class="label">หัวข้อโครงงาน</label>
      <div class="control">
        <input class="input" type="text" v-model="project_name" />
      </div>
    </div>

    <div class="field" >
      <label class="label">ชื่องาน</label>
      <div class="control">
        <input class="input" type="text" v-model="$v.title.$model" />
      </div>
      <p v-if="$v.title.$error" class="help is-danger">โปรดกรอกชื่องาน</p>
    </div>

    <div class="field">
      <label class="label">คำอธิบาย</label>
      <div class="control">
        <textarea class="textarea" v-model="$v.description.$model"></textarea>
      </div>
      <p v-if="$v.description.$error" class="help is-danger">โปรดกรอกคำอธิบาย</p>
    </div>

    <div class="field">
      <label class="label">สถานที่ทำงาน</label>
      <div class="control">
        <input class="input" type="text" v-model="$v.location.$model" />
      </div>
      <p v-if="$v.location.$error" class="help is-danger">โปรดกรอกสถานที่ปฏิบัติงาน</p>
    </div>




    <div class="columns">
      <div class="column is-6">
        <div class="field">
          <label class="label">ตำแหน่ง</label>
          <div class="control">
            <input class="input" type="text" v-model="job_position" />
          </div>
          
        </div>
      </div>
      <div class="column is-3">
        <div class="field">
          <label class="label">จำนวนที่รับ</label>
          <div class="control">
        <div class="field has-addons">
          <div class="control">
            <input class="input" type="number" v-model="$v.salary.$model" />
          </div>
          <div class="control">
            <a class="button is-static">
              คน
            </a>
          </div>
        </div>
      </div>
        </div>
      </div>

      <div class="column is-3">
        <div class="field">
          <label class="label">GPA</label>
          <div class="control">
            <input class="input" type="text" v-model="gpa" />
          </div>
          
        </div>
      </div>
    </div>

    <div class="columns">
  <div class="column is-3">
    <div class="field">
      <label class="label">ค่าตอบแทน</label>
      <div class="control">
        <div class="field has-addons">
          <div class="control">
            <input class="input" type="number" v-model="$v.salary.$model" />
          </div>
          <div class="control">
            <a class="button is-static">
              บาท/วัน
            </a>
          </div>
        </div>
      </div>
      <p v-if="$v.salary.$error" class="help is-danger">โปรดกรอกเงินเดือน</p>
    </div>
  </div>
  <div class="column is-9">
    <div class="field">
      <label class="label">สวัสดิการ</label>
      <div class="control">
        <input class="input" type="text" v-model="benefit" />
      </div>
    </div>
  </div>
</div>

    

    <div class="field">
      <label class="label">คุณสมบัติผู้สมัคร</label>
      <div class="control">
        <textarea class="textarea" v-model="$v.qualifications.$model"></textarea>
      </div>
      <p v-if="$v.qualifications.$error" class="help is-danger">โปรดกรอกคุณสมบัติ</p>
    </div>
    <div class="field">
      <label class="label">ระยะเวลาฝึกงาน (เดือน)</label>
      <div class="control">
        <input class="input" type="number" v-model="$v.internship_duration.$model" />
      </div>
      <p v-if="$v.internship_duration.$error" class="help is-danger">โปรดกรอกระยะเวลา</p>
    </div>

    <div class="field" >
      <label class="label">วิธีการเดินทาง</label>
      <div class="control">
        <input class="input" type="text" v-model="expedition" />
      </div>
    </div>

    <div class="field">
      <label class="label">สถานะ</label>
      <div class="control">
        <div class="select">
          <select v-model="status">
            <option value="open">เปิดรับสมัคร</option>
            <option value="close">ปิดรับสมัคร</option>
          </select>
        </div>
      </div>
    </div>

    <div class="field is-grouped">
      <div class="control">
        <button class="button is-primary" @click="addJob">บันทึก</button>
      </div>
      <div class="control">
        <button class="button is-link" @click="cancel">ยกเลิก</button>
      </div>
    </div>
  </div>

</template>

<script>
import { required, minValue } from 'vuelidate/lib/validators';
import axios from 'axios';
import Swal from "sweetalert2";
export default {
  data() {
    return {
      jobType: 'internship',
      project_name:'',
      title: '',
      location: '',
      job_position:'',
      quantity: 0,
      gpa:'',
      salary: 0,
      status: 'open',
      description: '',
      benefit:'',
      qualifications: '',
      expedition:'',
      internship_duration: 0,
    };
  },
  methods: {
    addJob() {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      this.$v.$touch();
      if (!this.$v.$error) {
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
        .post("http://localhost:3000/recruiter/addJob", data, config)
        .then((res) =>{
          const message = res.data.message;
            Swal.fire({
              position: "center",
              icon: "success",
              title: "ลงทะเบียนเรียบร้อย",
              showConfirmButton: message,
            });
            
            this.$router.push('/recruiterJob');
          })
          .catch((error) => {
            if (error.response) {
              console.log('erroewi]jt',error.response.data);
              alert("โปรดกรอกข้อมูลให้ครบก่อน",error.response.data );
            }
          });
      }
    },
    cancel() {
      this.$router.push('/recruiterJob');
    },
    
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
  },
  
};
</script>

<style scoped>
.card {
  width: 60%;
  margin: 0 auto;
}

</style>
