<template>
  <div class="columns mt-6">
    <div class="column is-2"></div>
    <div class="tabs is-boxed column is-8">
      <ul>
        <li :class="[select_option === 'user_profile' ? 'is-active' : '']" @click="select_option = 'user_profile'" > <a><span>User Profile</span></a></li>
        <li :class="[select_option === 'resume' ? 'is-active' : '']" @click="select_option = 'resume'" ><a><span>Resume</span></a></li>
        <li :class="[select_option === 'preview' ? 'is-active' : '']" @click="select_option = 'preview'"><a><span>ตัวอย่างใบยื่นสมัคร</span></a></li>
      </ul>
      <applicantProfile  v-if="select_option === 'user_profile'">
      </applicantProfile>
      <UploadResume v-if="select_option === 'resume'"></UploadResume>
    
    <applicantPreview v-if="select_option === 'preview'"></applicantPreview>
  </div>
  </div>
</template>

<script>
import applicantProfile from '@/components/applicant-profile.vue';
import UploadResume from '@/components/upload-resume.vue';
import applicantPreview from '@/components/applicant-preview.vue';
import axios from "@/plugins/axios";
export default {
  components: {
        applicantProfile,
        UploadResume,
        applicantPreview
    },
  data() {
    return {
       firstName: "",
      lastName: "",
      birthdate: "",
      phone_number: "",
      gender: "",
      email: "",
      address: "",
      modify_profile : false,
      select_option : 'user_profile',
      user:''
    };
  },
  mounted() {
    // เรียก API เพื่อดึงข้อมูลส่วนตัวของผู้ใช้และกำหนดค่าให้กับตัวแปร
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
        this.user = res.data;
       // console.log("appProfile", res.data[0].email)
        this.firstName = res.data[0].firstName;
        this.lastName = res.data[0].lastName;
        this.birthdate = new Date(res.data[0].birthdate).toISOString().split("T")[0];
        this.phone_number = res.data[0].phone_number;
        this.gender = res.data[0].gender;
        this.email = res.data[0].email;
        this.address = res.data[0].address;

      });
    },
    saveProfile() {
      // เรียก API เพื่อบันทึกข้อมูลส่วนตัวที่ผู้ใช้แก้ไข
      // ใช้ค่าในตัวแปร fullName, email, phoneNumber, address
    },
  },
};
</script>

<style scoped>
/* สไตล์ CSS สำหรับฟอร์ม */
</style>
