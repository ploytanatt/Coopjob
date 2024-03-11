<template>

    <div class="columns">
      <applicantSideMenu></applicantSideMenu>
      <div class="column">
        <applicantProfile v-if="select_option === 'user_profile'"></applicantProfile>
      <UploadResume v-if="select_option === 'resume'"></UploadResume>
      <UploadTranscript v-if="select_option === 'transcript'"></UploadTranscript>
      <UploadPortfolio v-if="select_option === 'portfolio'"></UploadPortfolio>
      <applicantPreview v-if="select_option === 'preview'"></applicantPreview>
      </div>

    </div>
 
</template>

<script>
import applicantProfile from '@/components/applicant/applicant-profile.vue';
import UploadResume from '@/components/applicant/upload-resume.vue';
import UploadTranscript from '@/components/applicant/upload-transcript.vue';
import UploadPortfolio from '@/components/applicant/upload-portfolio.vue';
import applicantPreview from '@/components/applicant/applicant-preview.vue';
import applicantSideMenu from '@/components/applicant/applicant-side-menu.vue';
import axios from "@/plugins/axios";
export default {
  components: {
    applicantProfile,
    UploadResume,
    UploadTranscript,
    UploadPortfolio,
    applicantPreview,
    applicantSideMenu

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
      modify_profile: false,
      select_option: 'user_profile',
      user: ''
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
.card {
  width: 100%; 
}
</style>
