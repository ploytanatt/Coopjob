<template>
  <div class="p-6 card">
    <fieldset :disabled="!modify_profile">
      <div class="field is-horizontals">
        <div class="field">
          <p class="control">
            <img :src="imagePath(profile_image)" alt="Profile Image" class="image-preview profile_image" v-if="profile_image && !modify_profile">
            <img :src="profile_image_preview" alt="Profile Image" class="image-preview profile_image" v-if="profile_image_preview && modify_profile">
          </p>
        </div>
        <div class="file has-name" v-if="modify_profile">
          <label class="file-label">
            <input class="file-input" type="file" @change="handleProfileImageUpload" accept="image/*">
            <span class="file-cta">
              <span class="file-label">เลือกไฟล์</span>
            </span>
            <span class="file-name" v-if="profile_image_name">{{ profile_image_name }}</span>
          </label>
        </div>
        <template v-if="$v.profile_image.$error">
          <p class="help is-danger" v-if="!$v.profile_image.required">โปรดอัปโหลดรูปภาพ</p>
        </template>
      </div>

      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">ชื่อบริษัท</label>
        </div>
        <div class="field-body">
          <div class="field">
            <p class="control">
              <input class="input" type="text" v-model="$v.company_name.$model" :class="{ 'is-danger': $v.company_name.$error }"/>
            </p>
            <template v-if="$v.company_name.$error">
              <p class="help is-danger" v-if="!$v.company_name.required">โปรดกรอกข้อมูลในช่องนี้</p>
            </template>
          </div>
        </div>
      </div>

      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">อีเมล</label>
        </div>
        <div class="field-body">
          <div class="field">
            <p class="control">
              <input class="input" type="text" v-model="$v.email.$model" :class="{ 'is-danger': $v.email.$error }"/>
            </p>
            <template v-if="$v.email.$error">
              <p class="help is-danger" v-if="!$v.email.required">โปรดกรอกข้อมูลในช่องนี้</p>
              <p class="help is-danger" v-else-if="!$v.email.email">รูปแบบอีเมลไม่ถูกต้อง</p>
            </template>
          </div>
        </div>
      </div>

      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">คำอธิบาย</label>
        </div>
        <div class="field-body">
          <div class="field">
            <p class="control">
              <textarea class="textarea" v-model="$v.description.$model" :class="{ 'is-danger': $v.description.$error }"></textarea>
            </p>
            <template v-if="$v.description.$error">
              <p class="help is-danger" v-if="!$v.description.required">โปรดกรอกข้อมูลในช่องนี้</p>
            </template>
          </div>
        </div>
      </div>

      <div class="field" v-show="modify_profile">
        <label class="label">วิดีโอ</label>
        <div class="columns">
          <div class="column">
            <img src="https://sv1.picz.in.th/images/2023/04/02/m1nC4y.png" alt="m1nC4y.png" border="0" />
          </div>
          <div class="column">
            <img src="https://sv1.picz.in.th/images/2023/04/02/m1nvp8.png" alt="m1nvp8.png" border="0" />
          </div>
          <div class="column">
            <img src="https://sv1.picz.in.th/images/2023/04/02/m1nJNR.png" alt="m1nJNR.png" border="0" />
          </div>
        </div>
        <div class="control">
          <input class="input" type="text" v-model="$v.company_video.$model" />
        </div>
      </div>
      <div class="field is-horizontals" v-show="!modify_profile" v-html="company_video"></div>
    </fieldset>

    <div class="mt-6 modify_profile">
      <button v-show="!modify_profile" class="button is-medium ml-2 is-info" @click="modify_profile = !modify_profile">
        แก้ไข
      </button>
      <button v-show="modify_profile" class="button is-medium ml-2 is-success" @click="saveProfile" :disabled="$v.$error">
        บันทึก
      </button>
      <button v-show="modify_profile" class="button is-medium ml-2 is-danger" @click="resetProfile">
        ยกเลิก
      </button>
    </div>
  </div>
</template>

<script>
import { required, email } from 'vuelidate/lib/validators';
import axios from '@/plugins/axios';
import Swal from 'sweetalert2';

export default {
  data() {
    return {
      company_name: '',
      email: '',
      description: '',
      profile_image: '',
      profile_image_name: '',
      profile_image_preview: '',
      company_video: '',
      modify_profile: false,
    };
  },
  mounted() {
  this.getUserProfile();
 // this.imagePath();
},
  methods: {

    getUserProfile() {
    const token = localStorage.getItem("token");
    const config = {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    };
    axios.get("http://localhost:3000/recruiter/getData", config).then((res) => {
      const user = res.data;
     // console.log("getappProfile",user)
     if(user[0].profile_image){
      this.profile_image = user[0].profile_image.replace(/\\/g, '/').replace('static', '');
     }
     
     this.company_name = user[0].company_name
     this.description = user[0].description
     this.email = user[0].email
     this.role = user[0].role;
     this.company_video = user[0].company_video
    });
  },
  imagePath(previewProfileImage) {
      if (previewProfileImage) {
        return "http://localhost:3000" + previewProfileImage;
      } else {
        return "https://bulma.io/images/placeholders/640x360.png";
      }
    },
    
  saveProfile() {
    const token = localStorage.getItem("token");
    const config = {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    };
      const formData = new FormData();
      formData.append('company_name', this.company_name);
      formData.append('email', this.email);
      formData.append('description', this.description);
      if (this.profile_image) {
        formData.append('profile_image', this.profile_image);
      }
      formData.append('company_video', this.company_video);

      axios
        .post('http://localhost:3000/recruiter/editProfile', formData, config)
        .then((response) => {
          console.log(response);
         
          Swal.fire({
            position: 'center',
            icon: 'success',
            title: 'บันทึกข้อมูลสำเร็จ',
            showConfirmButton: false,
          });
          this.getUserProfile();
          this.modify_profile = false;
        })
        .catch((error) => {
          console.log(error);
          Swal.fire({
            position: 'center',
            icon: 'error',
            title: 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
            showConfirmButton: false,
          });
        });
    },
    handleProfileImageUpload(event) {
      const file = event.target.files[0];
      this.profile_image = file;
      this.profile_image_name = file.name;

      // แสดงตัวอย่างรูปภาพที่อัปโหลด
      const reader = new FileReader();
      reader.onload = () => {
        this.profile_image_preview = reader.result;
      };
      reader.readAsDataURL(file);
    },
    resetProfile() {
    this.getUserProfile();
      this.modify_profile = false;
    },
  },
  validations: {
    firstName: {
      required,
    },
    lastName: {
      required,
    },
    company_name: {
      required,
    },
    email: {
      required,
      email,
    },
    description: {
      required,
    },
    profile_image: {
      required,
    },
    company_video: {
      
    },
  },
};
</script>

<style scoped>
/* สไตล์ CSS สำหรับฟอร์ม */
.card {
  width: 80%; /* เพิ่มความกว้างของการ์ด ค่าที่เพิ่มขึ้นนี้ขึ้นอยู่กับความต้องการของคุณ */
  margin: 0 auto; /* ใช้ในการจัดวางการ์ดให้อยู่ตรงกลางหน้าจอ */
}
.profile_image {
  width: 150px;
  height: 150px;
  border: 2px solid gray;
  border-radius: 25px;
}
.field.is-horizontals {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}
</style>