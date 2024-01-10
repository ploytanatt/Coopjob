<template>
    <div class="p-6 card">
    <h1 class="title">อัพโหลดไฟล์</h1>
    <div class="field">
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
    </div>
</template>

<script>
import { required } from "vuelidate/lib/validators";
import axios from 'axios';
import Swal from "sweetalert2";
export default {
  data() {
    return {
      job_title: "",
      description: "",
      status: "open",
      uploadedFileName: '',
      create_type:'upload',
      fileType: '',
      filePreview: null,
    };
  },
  methods: {
    addJob() {
      const token = localStorage.getItem("token");
      const config = {
          headers: {
            Authorization: `Bearer ${token}`,
            'Content-Type': 'multipart/form-data',
          },
        };

      this.$v.$touch();
      
      const formData = new FormData();
      formData.append('job_title', this.job_title);
      formData.append('description', this.description);
      formData.append('status', this.status);
      formData.append('create_type', this.create_type)
      // เพิ่มไฟล์ job_upload_file เข้า FormData
      const fileInput = document.querySelector('input[type="file"]');
      const uploadedFile = fileInput.files[0];
      formData.append('job_upload_file', uploadedFile);
      axios
        .post("http://localhost:3000/recruiter/addJobByUpload",formData, config)
        .then((res) =>{
          const message = res.data.message;
            Swal.fire({
              position: "center",
              icon: "success",
              title: "ลงประกาศงานเรียบร้อยแล้ว",
              showConfirmButton: message,
            });
            
            this.$router.push('/recruiterJob');
          })
          .catch((error) => {
            if (error.response) {
              console.log("response.data",error.response.data );
            }
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
    isImage(fileType) {
      return fileType.startsWith('image/');
    },
    isPdf(fileType) {
      return fileType === 'application/pdf';
    },
    cancel() {
      this.$router.push("/recruiterJob");
    },
  },
  validations: {
    job_title: {
      required,
    },
    description: {
      required,
    },
  },
};
</script>

<style scoped>
.card {
  width: 60%;
  margin: 0 auto;
}

.image-preview {
  max-width: 100%; /* ทำให้รูปภาพไม่เกินขอบเขตของพื้นที่ */
  max-height: 300px; /* ทำให้รูปภาพไม่สูงเกินไป */
  object-fit: contain; /* ทำให้รูปภาพไม่เปลี่ยนสัดส่วน */
}

.preview-pdf {
  width: 100%; /* ทำให้ไฟล์ PDF เต็มขอบ */
  height: 500px; /* ปรับความสูงของไฟล์ PDF ตามต้องการ */
  border: 1px solid #ddd; /* เพิ่มเส้นขอบสำหรับเล่นรูปภาพ */
}
</style>
