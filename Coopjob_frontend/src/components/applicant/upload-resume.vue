<template>
  <div>
    <div>
        <button class="button mb-3 is-info" @click="isEdit = true"><i class="fa-solid fa-pen-to-square mr-1"></i>Edit</button>
    </div>
    
  <div class="upload_content mt-3 ml-3" v-if="isEdit">
    <div class="columns mb-3">
      <div class="file is-info has-name">
        <label class="file-label">
          <input class="file-input" type="file" ref="fileInput" accept=".pdf" @change="handleFileChange($event)"/>
          <span class="file-cta">
            <span class="file-icon">
              <i class="fa-regular fa-upload"></i>
            </span>
            <span class="file-label"> Choose a {{ upload_category }} </span>
          </span>
          <span class="file-name">
            {{ file.name }}
          </span>
        </label>
      </div>
      <button class="button ml-3 is-warning" @click="resetFileInput()">
        Reset
      </button>
      <button class="button ml-3 is-danger" @click="cancelEdit()">
        Cancel
      </button>
    </div>
    
    <div v-if="errors.length > 0">
      <div class="has-text-danger" v-for="(error, index) in errors" :key="index">
        <h1>{{ error }}</h1>
      </div>
    </div>
    <button
      v-if="previewNewResume" class="button mb-3 mt-3 is-success" @click="uploadFile()">Upload</button>
    <div v-if="previewNewResume" class="pre-review">
      <iframe :src="previewNewResume" type="application/pdf" class="preview-pdf" />
    </div>
  </div>



    <div v-show="!previewNewResume && previewCurrentResume" class="pre-review">  
      <iframe :src="imagePath(previewCurrentResume)" class="preview-pdf"/>
  </div>

  <noInformation v-if="!previewCurrentResume"></noInformation>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import noInformation from "@/components/no-information.vue";
import Swal from "sweetalert2";
export default {
  components: {
    noInformation
  },
  data() {
    return {
      upload_category: "PDF File",
      file: {
        name: "",
        isUploaded: false,
      },
      previewNewResume: "",
      previewCurrentResume: "",
      errors: [],
      isEdit: false,
      role:''
    };
  },
  mounted() {
  this.getUserProfile();
  this.imagePath();
},
  methods: {
    getUserProfile() {
    const token = localStorage.getItem("token");
    const config = {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    }; 
    axios.get("http://localhost:3000/applicant/getData", config).then((res) => {
      const user = res.data;
      //console.log("getappProfile",user[0].resume)
     if(user[0].resume){
      this.previewCurrentResume = user[0].resume.replace(/\\/g, '/').replace('static', '');
      
     }
    
     this.role = user[0].role;
    });
  },
  imagePath(previewCurrentResume) {
      if (previewCurrentResume) {
        return "http://localhost:3000/" + previewCurrentResume;
      } else {
        return "https://bulma.io/images/placeholders/640x360.png";
      }
    },
    handleFileChange(event) {
      const file = event.target.files[0];
      this.file.name = file.name;
      if (file) {
        const reader = new FileReader();
        reader.onload = (e) => {
          this.previewNewResume = e.target.result;
        };
        reader.readAsDataURL(file);
      }
    },
    resetFileInput() {
      this.$refs.fileInput.value = "";
      this.file.name = "";
      this.file.isUploaded = false;
      this.previewNewResume = "";
      this.errors = [];
    },
    cancelEdit() {
      this.resetFileInput();
      this.isEdit = false;
    },
    uploadFile() {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      this.isEdit = true;
      const file = this.$refs.fileInput.files[0];
      if (!file) {
        this.errors = ["Please select a file to upload."];
        return;
      }
      const formData = new FormData();
      formData.append("student_status", 'open');
      formData.append("resume", file);
      axios.post("http://localhost:3000/applicant/uploadResume", formData, config)
        .then((response) => {
          if(response.data.filePath) {
            this.previewCurrentResume = response.data.filePath.replace(/\\/g, '/').replace('static', '');
          }
          this.file.isUploaded = true;
          this.isEdit = false;
          this.previewNewResume = null;
          // บังคับให้ Vue อัพเดทหน้าจอ
          Swal.fire({
            position: "center",
            icon: "success",
            title: "แก้ไขข้อมูลสำเร็จ",
            showConfirmButton: false,
          });
          this.$forceUpdate();
        })
        .catch((error) => {
          console.log(error);
          this.errors = ["Failed to upload the file. Please try again later."];
        });
    },
  },
};
</script>

<style scoped>
.preview-pdf {
  width: 100%;
  height: 1000px;
}
</style>