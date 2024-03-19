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
      <label class="label">หัวข้อโครงงาน(ถ้ามี)</label>
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
      <div class="column is-3">
        <div class="field">
          <label class="label">ค่าตอบแทน</label>
          <div class="control">
            <div class="field has-addons">
              <div class="control">
                <input class="input" type="text" v-model="$v.salary.$model" />
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
      <div class="column is-3">
        <div class="field">
          <label class="label">จำนวนที่รับ</label>
          <div class="control">
        <div class="field has-addons">
          <div class="control">
            <input class="input" type="text" v-model="$v.quantity.$model" />
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
    <div>
      <label class="label">ประเภทของงาน</label>
    <multiselect v-model="$v.position_type.$model"  placeholder="ค้นหาหรือพิมพ์เพื่อเพิ่มประเภทงาน" label="title" track-by="title" :options="options" :multiple="true" :taggable="true" @tag="addTag"></multiselect>
    <p v-if="$v.position_type.$error" class="help is-danger">โปรดกรอกเงินเดือน</p>
  </div>

    <div class="columns mt-3">
      <div class="column is-6">
        <label class="label">สวัสดิการ</label>
        <div class="field is-grouped" v-for="(spec, index) in benefit" :key="index">
          <div class="control is-expanded">
            <input class="input" type="text" v-model="spec.text" placeholder="Enter specification"/>
          </div>
          <div class="control">
            <button class="button is-danger" @click="removeBenefit(index)">Remove</button>
          </div>
        </div>
        <button class="button is-primary" @click="addBenefit">เพิ่ม</button>
      </div>

      <div class="column is-6">
        <label class="label">คุณสมบัติ</label>
        <div class="field is-grouped" v-for="(spec, index) in specification" :key="index">
          <div class="control is-expanded">
            <input class="input" type="text" v-model="spec.text" placeholder="Enter specification"/>
          </div>
          <div class="control">
            <button class="button is-danger" @click="removeSpecification(index)">Remove</button>
          </div>
        </div>
        <button class="button is-primary" @click="addSpecification">เพิ่ม</button>
      </div>
    </div>

    <div class="field">
      <label class="label">ระยะเวลาฝึกงาน (เดือน)</label>
      <div class="control">
        <input class="input" type="text" v-model="$v.internship_duration.$model" />
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
import { validationMixin } from 'vuelidate';
import axios from 'axios';
import Swal from "sweetalert2";
import Multiselect from 'vue-multiselect'
import JobtypeJson from '@/assets/jobtype.json'
export default {
  components: {
    Multiselect,
  },
  mixins: [validationMixin],
  data() {
    return {
      job_type: 'internship',
      project_name:'',
      job_title: '',
      description: '',
      
      quantity: 0,
      gpa:'',
      position_type:[],
      salary: 0,
      benefit:[{ text: '' }],
      specification: [{ text: '' }],
      internship_duration:'',
      status: 'open',
      options: JobtypeJson,
    };
  },
  methods: {
    addSpecification() {
      this.specification.push({ text: '' });
    },
    removeSpecification(index) {
      this.specification.splice(index, 1);
    },
    addBenefit() {
      this.benefit.push({ text: '' });
    },
    removeBenefit(index) {
      this.benefit.splice(index, 1);
    },
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
        job_type:this.job_type,
        project_name:this.project_name,
        job_title:this.job_title,
        description:this.description,
        salary:this.salary,
        quantity:this.quantity,
        gpa:this.gpa,
        position_type: JSON.stringify(this.position_type),
        benefit:JSON.stringify(this.benefit),
        specification: JSON.stringify(this.specification),
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
    addTag(newTag) {
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
    required 
  },
    internship_duration: {
      required,
      minValue: minValue(0),
    },
    position_type:{
      required
    }
  },
  
};
</script>
<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>
<style scoped>
.card {
  width:  50%;
  margin: 0 auto; 
  background-color: #eeeeee;
}
.profile_image {
  width: 150px;
  height: 150px;
  border: 2px solid gray;
  border-radius: 25px;
}
.cover_image {
  object-fit: cover; 
  border-radius: 10px; 
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
