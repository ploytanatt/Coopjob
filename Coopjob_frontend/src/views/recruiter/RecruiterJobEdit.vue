<template>
  <div class="p-6 card">
    <h1 class="title">แก้ไขงาน</h1>
    <div>
      <div class="field">
      <label class="label">ประเภทงาน</label>
      <div class="control">
        <label class="radio">
          <input type="radio" v-model="jobs.job_type" value="internship" />
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
        <input class="input" type="text" v-model="jobs.project_name" />
      </div>
    </div>

      <div class="field">
        <label class="label">ชื่องาน</label>
        <div class="control">
          <input class="input" type="text" v-model="jobs.job_title" />
        </div>
      </div>

      <div class="field">
      <label class="label">คำอธิบาย</label>
      <div class="control">
        <textarea class="textarea" v-model="jobs.description"></textarea>
      </div>
    </div>

    <div class="columns">
      <div class="column is-3">
        <div class="field">
          <label class="label">ค่าตอบแทน</label>
          <div class="control">
            <div class="field has-addons">
              <div class="control">
                <input class="input" type="text" v-model="jobs.salary" />
              </div>
              <div class="control">
                <a class="button is-static">
                  บาท/วัน
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="column is-3">
        <div class="field">
          <label class="label">จำนวนที่รับ</label>
          <div class="control">
        <div class="field has-addons">
          <div class="control">
            <input class="input" type="text" v-model="jobs.quantity" />
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
            <input class="input" type="text" v-model="jobs.gpa" />
          </div>
          
        </div>
      </div>
    </div>
  <div>
      <label class="label">ประเภทของงาน</label>
    <multiselect v-model="position_type"  placeholder="ค้นหาหรือพิมพ์เพื่อเพิ่มประเภท" label="title" track-by="title" :options="options" :multiple="true" :taggable="true" @tag="addTag"></multiselect>
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
        <input class="input" type="text" v-model="jobs.internship_duration" />
      </div>
      
    </div>


    <div class="field">
      <label class="label">สถานะ</label>
      <div class="control">
        <div class="select">
          <select v-model="jobs.job_status">
            <option value="open">เปิดรับสมัคร</option>
            <option value="close">ปิดรับสมัคร</option>
          </select>
        </div>
      </div>
    </div>



      <div class="field is-grouped">
        <div class="control">
          <button class="button is-primary" @click="updateJob()">บันทึก</button>

         
        </div>
        <div class="control">
          <button class="button is-link" @click="cancel">ยกเลิก</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
//import { required, minValue } from 'vuelidate/lib/validators';
import Swal from "sweetalert2";
import Multiselect from 'vue-multiselect'
import JobtypeJson from '@/assets/jobtype.json'
export default {
  components: {
    Multiselect,
    
  },
  data() {
    return {
        jobs:[],
        options: JobtypeJson,
        position_type:[],

        benefit:[],
        specification:[]
    };
  },
  mounted() {
    this.getJobDetails();
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
    getJobDetails() {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      const jobId = this.$route.params.jobId;
      axios
        .get(`http://localhost:3000/recruiter/getJobDetail/${jobId}`, config)
        .then((res) => {
          this.jobs = res.data[0];
          const job = res.data[0]; 
          this.position_type = JSON.parse(job.position_type);
          this.benefit = JSON.parse(job.benefit);
          this.specification = JSON.parse(job.specification);
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
    const data = {
      ...this.jobs,
      position_type: JSON.stringify(this.position_type),
      benefit : JSON.stringify(this.benefit),
      specification : JSON.stringify(this.specification)
    };
    axios.put(`http://localhost:3000/recruiter/updateJob/${jobId}`, data, config)
      .then((res) => {
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


    addTag(newTag) {
      // ฟังก์ชันที่ถูกเรียกเมื่อมีการเพิ่มแท็กใหม่
      console.log("Added new tag:", newTag);
      this.position_type.push({ title: newTag });
    },
    cancel(){
        this.getJobDetails()
        this.$router.push('/recruiterJob');
    }
  },

};
</script>
<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>
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
