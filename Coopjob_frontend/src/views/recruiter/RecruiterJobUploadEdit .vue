<template>
  <div class="p-6 card">
    <h1 class="title">แก้ไขงานแบบอัพโหลกด</h1>
    <div>

      <div class="field">
        <div v-if="isImage(jobs.job_upload_file)">
  <img :src="imagePath(jobs.job_upload_file)" class="jobUpload">
        </div>
        <div v-else-if="isPdf(jobs.job_upload_file)">
          <iframe :src="imagePath(jobs.job_upload_file)" class="preview-pdf" />
        </div>
       
        <div class="file is-medium is-boxed has-name">
        <div v-if="isImage(fileType)">
          <img :src="filePreview" alt="Image Preview" class="image-preview" v-if="filePreview"/>
        </div>
        <div v-else-if="isPdf(fileType)">
          <iframe :src="filePreview" type="application/pdf" class="preview-pdf" />
        </div>
        <label class="file-label">
          <input class="file-input" type="file" @change="handleFileUpload" accept=".pdf, .jpg, .jpeg" />
          <span class="file-cta">
            <span class="file-icon">
              <i class="fas fa-upload"></i>
            </span>
            <span class="file-label"> Upload File pdf, jpg</span>
          </span>
          <span class="file-name">{{ uploadedFileName }}</span>
        </label>
      </div>

      <div class="field" >
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
//import Multiselect from 'vue-multiselect'
//import JobtypeJson from '@/assets/jobtype.json'
export default {
  components: {
  //  Multiselect,
    
  },
  data() {
    return {
        jobs:[],
        filePreview: null,
        uploadedFileName: '',
        fileType: '',


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
    handleFileUpload(event) {
      const fileInput = event.target;
      if (fileInput.files.length > 0) {
        const uploadedFile = fileInput.files[0];
        this.uploadedFileName = uploadedFile.name;
        this.fileType = uploadedFile.type;

        // ใช้ FileReader เพื่ออ่านไฟล์และสร้าง URL สำหรับแสดงตัวอย่าง
        const reader = new FileReader();
        reader.onload = () => {
          this.filePreview = reader.result;
        };
        reader.readAsDataURL(uploadedFile);
      } else {
        this.uploadedFileName = '';
        this.fileType = '';
        this.filePreview = null;
      }
    },
    isImage(filePath) {
      return /\.(jpeg|jpg|gif|png)$/i.test(filePath);
    },
    // ตรวจสอบว่าไฟล์เป็น PDF หรือไม่
    isPdf(filePath) {
      return /\.pdf$/i.test(filePath);
    },
    imagePath(jobFile) {
      if (jobFile) {
        return "http://localhost:3000" + jobFile.replace(/\\/g, '/').replace('static', '');
      } else {
        return "https://bulma.io/images/placeholders/640x360.png";
      }
    },
    updateJob() {
  const formData = new FormData();
  // สมมติว่า `this.file` เก็บไฟล์ที่เลือกไว้
  const fileInput = document.querySelector('input[type="file"]');
      const uploadedFile = fileInput.files[0];
  formData.append('job_upload_file', uploadedFile); 
  formData.append('job_title', this.jobs.job_title);
  formData.append('description', this.jobs.description);
  formData.append('job_status', this.jobs.job_status);
  
  // สามารถเพิ่มข้อมูลอื่น ๆ เข้าไปใน formData ตามต้องการ

  const token = localStorage.getItem("token");
  const config = {
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'multipart/form-data'
    }
  };

  const jobId = this.$route.params.jobId;
  axios.put(`http://localhost:3000/recruiter/updateUploadJob/${jobId}`, formData, config)
    .then(response => {
      console.log(response)
      // การจัดการหลังจากอัพเดตสำเร็จ
      Swal.fire({
        icon: 'success',
        title: 'อัพเดตงานสำเร็จ',
        showConfirmButton: false,
        timer: 1500
      });
      this.$router.push('/recruiterJob');
    })
    .catch(error => {
      // การจัดการข้อผิดพลาด
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
.jobUpload{
  width: 200px;
}
</style>
