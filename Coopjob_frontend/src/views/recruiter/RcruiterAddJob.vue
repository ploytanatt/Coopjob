<template>
  <div class="p-6 card">
    <h1 class="title">เพิ่มงาน</h1>

    <div class="field">
      <label class="label">ประเภทงาน</label>
      <div class="control">
        <label class="radio">
          <input type="radio" v-model="job_type" value="internship" />
          ฝึกงาน
        </label>
        <label class="radio">
          <input type="radio" v-model="job_type" value="cooperative" />
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
        <input class="input" type="text" v-model="$v.job_title.$model" />
      </div>
      <p v-if="$v.job_title.$error" class="help is-danger">โปรดกรอกชื่องาน</p>
    </div>

    <div class="field">
      <label class="label">คำอธิบาย</label>
      <div class="control">
        <textarea class="textarea" v-model="$v.description.$model"></textarea>
      </div>
      <p v-if="$v.description.$error" class="help is-danger">โปรดกรอกคำอธิบาย</p>
    </div>






    <div class="columns">
      <div class="column is-6">
        <div class="field">
          <label class="label">ตำแหน่ง</label>
          <div class="control">
            <input class="input" type="text" v-model="$v.job_position.$model" />
          </div>
          <p v-if="$v.job_position.$error" class="help is-danger">โปรดกรอกคำอธิบาย</p>
        </div>
      </div>
      <div class="column is-3">
        <div class="field">
          <label class="label">จำนวนที่รับ</label>
          <div class="control">
        <div class="field has-addons">
          <div class="control">
            <input class="input" type="number" v-model="$v.quantity.$model" />
          </div>
          <div class="control">
            <a class="button is-static">
              คน
            </a>
          </div>
        </div>
      </div>
        </div>
        <p v-if="$v.salary.$error" class="help is-danger">โปรดกรอกข้อมูล</p>
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
    <multiselect v-model="position_type"  placeholder="ค้นหาหรือพิมพ์เพื่อเพิ่มประเภท" label="title" track-by="title" :options="options" :multiple="true" :taggable="true" @tag="addTag"></multiselect>
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
            <input class="input" type="text" v-model="$v.benefit.$model" />
          </div>
          <p v-if="$v.benefit.$error" class="help is-danger">โปรดกรอกข้อมูล</p>
        </div>
      </div>
    </div>

    

    <div class="field">
      <label class="label">คุณสมบัติผู้สมัคร</label>
      <div class="control">
        <textarea class="textarea" v-model="$v.specification.$model"></textarea>
      </div>
      <p v-if="$v.specification.$error" class="help is-danger">โปรดกรอกคุณสมบัติ</p>
    </div>
    <div class="field">
      <label class="label">ระยะเวลาฝึกงาน (เดือน)</label>
      <div class="control">
        <input class="input" type="number" v-model="$v.internship_duration.$model" />
      </div>
      <p v-if="$v.internship_duration.$error" class="help is-danger">โปรดกรอกระยะเวลา</p>
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
        <button class="button is-primary" @click="addJob()">บันทึก</button>
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
import Multiselect from 'vue-multiselect'
export default {
  components: {
    Multiselect,
  },
  data() {
    return {
      job_type: 'internship',
      project_name:'',
      job_title: '',
      description: '',
      job_position:'',
      
      quantity: 0,
      gpa:'',
      position_type:[],
      salary: 0,
      benefit:'', 
      specification: '',
      internship_duration:'',
  
      status: 'open',
      options: [
        { title: 'ผู้จัดการโปรแกรม (Program Manager)' },
        { title: 'นักพัฒนาซอฟต์แวร์ (Software Developer)' },
        { title: 'ผู้ชี่วยจัดการโปรแกรม (Assistant Program Manager)' },
        { title: 'นักพัฒนาเว็บ (Web Developer)' },
        { title: 'นักวิเคราะห์ธุรกรรม (Business Analyst)' },
        { title: 'นักพัฒนาแอปพลิเคชันมือถือ (Mobile App Developer)' },
        { title: 'ผู้จัดการโครงการไอที (IT Project Manager)' },
        { title: 'นักทดสอบซอฟต์แวร์ (Software Tester)' },
        { title: 'นักวิเคราะห์ข้อมูล (Data Analyst)' },
        { title: 'นักวิเคราะห์ระบบ (Systems Analyst)' },
        { title: 'ผู้จัดการด้านความปลอดภัยไอที (IT Security Manager)' },
        { title: 'นักวิเคราะห์ความเสี่ยงทางไอที (IT Risk Analyst)' },
        { title: 'นักวิเคราะห์ความเสี่ยงด้านความปลอดภัย (Security Risk Analyst)' },
        { title: 'นักวิเคราะห์ธุรกิจอัจฉริยะ (Business Intelligence Analyst)' },
        { title: 'นักพัฒนา DevOps (DevOps Developer)' },
        { title: 'ผู้ประสานงานโปรแกรม (Software Coordinator)' },
        { title: 'นักวิเคราะห์ฐานข้อมูล (Database Analyst)' },
        { title: 'นักวิเคราะห์ระบบองค์กร (Enterprise Systems Analyst)' },
        { title: 'นักพัฒนาเกม (Game Developer)' },
        { title: 'ผู้จัดการศูนย์ข้อมูล (Data Center Manager)' },
        { title: 'นักวิเคราะห์ภาพระบบ (Systems Imaging Analyst)' },
        { title: 'นักวิเคราะห์ความเสี่ยงด้านข้อมูล (Data Risk Analyst)' },
        { title: 'นักวิเคราะห์ระบบรักษาความปลอดภัย (Security Systems Analyst)' },
        { title: 'นักพัฒนา Blockchain (Blockchain Developer)' },
        { title: 'ผู้บริหารด้านนวัตกรรมทางดิจิทัล (Digital Innovation Executive)' },
        { title: 'นักพัฒนาทำเว็บ (Full-stack Web Developer)' },
      ]

    };
  },
  methods: {
    addJob() {
      const position_type_String = JSON.stringify(this.position_type);
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      this.$v.$touch();
      if (!this.$v.$error) {
      const data ={
        job_type:this.job_type,
        project_name:this.project_name,
        job_title:this.job_title,
        description:this.description,
        location:this.location,
        job_position:this.job_position,
        position_type: position_type_String,
        quantity:this.quantity,
        gpa:this.gpa,
        salary:this.salary,
        benefit:this.benefit,
        specification:this.specification,
        internship_duration:this.internship_duration,
     
        status:this.status
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
              console.log("response.data",error.response.data );
            }
          });
      }
    },
    cancel() {
      this.$router.push('/recruiterJob');
    },
    removeItem(item) {
      // ลบรายการที่ถูกเลือก
      this.selectedValues = this.selectedValues.filter(value => value !== item);
    },
    customLabel(option) {
      // กำหนด custom label สำหรับแสดงผลใน dropdown
      return `${option.name} (${option.id})`;
    },
    addTag(newTag) {
      // ฟังก์ชันที่ถูกเรียกเมื่อมีการเพิ่มแท็กใหม่
      console.log("Added new tag:", newTag);
      this.position_type.push({ title: newTag });
    },
  },
  validations: {
    job_title: {
      required,
    },
    description: {
      required,
    },
    job_position:{
      required
    },
    quantity:{
      required
    },
    salary:{
      required
    },
    benefit:{
      required
    },

    specification: {
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
