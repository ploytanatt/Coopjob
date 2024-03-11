<template>
    <div>
      <div class="upload_content mt-6" v-if="isEdit">
        <div class="columns mb-3">
          <div class="file is-info has-name">
            <label class="file-label">
              <input class="file-input" type="file" ref="fileInput" accept=".pdf" @change="handleFileChange($event)" />
              <span class="file-cta">
                <span class="file-icon">
                  <i class="fas fa-upload"></i>
                </span>
                <span class="file-label"> Choose a {{ upload_category }} </span>
              </span>
              <span class="file-name">{{ file.name }}</span>
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
        <button v-if="isEdit && previewNewPortfolio" class="button mb-3 mt-3 is-success" @click="uploadPortfolio()">
          Upload
        </button>
        <div v-if="previewNewPortfolio" class="pre-review">
          <iframe :src="previewNewPortfolio" type="application/pdf" class="preview-pdf" />
        </div>
      </div>
      <div v-if="isEdit === false && role === 'applicant'" style="display: flex; flex-direction: column; align-items: flex-end;">
        <button class="button mb-3 mt-3 is-info" @click="isEdit = true">
          Edit
        </button>
      </div>
      <div v-show="isEdit === false && previewCurrentPortfolio" class="pre-review">
        <iframe :src="imagePath(previewCurrentPortfolio)" class="preview-pdf" />
      </div>
      <noInformation v-if="!previewCurrentPortfolio"></noInformation>
    </div>
</template>
  
  <script>
  import axios from "@/plugins/axios";
  import noInformation from "@/components/no-information.vue";
  
  export default {
    components: {
      noInformation
    },
    data() {
      return {
        upload_category: "Portfolio",
        file: {
          name: "",
          isUploaded: false,
        },
        previewNewPortfolio: "",
        previewCurrentPortfolio: "",
        errors: [],
        isEdit: false,
        role: ""
      };
    },
    mounted() {
      this.getUserProfile();
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
          if (user[0].portfolio) {
            this.previewCurrentPortfolio = user[0].portfolio.replace(/\\/g, '/').replace('static', '');
          }
          this.role = user[0].role;
        });
      },
      imagePath(previewCurrentPortfolio) {
        if (previewCurrentPortfolio) {
          return "http://localhost:3000/" + previewCurrentPortfolio;
        } else {
          return "https://bulma.io/images/placeholders/640x360.png";
        }
      },
       handleFileChange(event) {
      const file = event.target.files[0];
      this.file.name = file.name;
      this.previewNewPortfolio = ""; // เพิ่มบรรทัดนี้
      if (file) {
        const reader = new FileReader();
        reader.onload = (e) => {
          this.previewNewPortfolio = e.target.result;
        };
        reader.readAsDataURL(file);
      }
    },
      resetFileInput() {
        this.$refs.fileInput.value = "";
        this.file.name = "";
        this.file.isUploaded = false;
        this.previewNewPortfolio = "";
        this.errors = [];
      },
      cancelEdit() {
        this.resetFileInput();
        this.isEdit = false;
      },
      uploadPortfolio() {
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
        formData.append("portfolio", file);
  
        axios
          .post("http://localhost:3000/applicant/uploadPortfolio", formData, config)
          .then((response) => {
            // Handle successful upload
            if (response.data.filePath) {
              this.previewCurrentPortfolio = response.data.filePath.replace(/\\/g, '/').replace('static', '');
            }
            this.file.isUploaded = true;
            this.isEdit = false;
          })
          .catch((error) => {
            // Handle upload error
            console.error(error);
            this.errors = [
              "Failed to upload the file. Please try again later."
            ];
          });
      }
    }
  };
  </script>
  
  <style scoped>
  .preview-pdf {
    width: 100%;
    height: 1000px;
  }
  </style>
  