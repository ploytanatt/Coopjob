<template>
  <div class="p-6 card" style="background-color: #393E46;">
      <div class="card">
        <div class="columns mt-0">
          <div class="tabs is-boxed column p-6">
              <div class="column">
                <div class="columns is-multiline ml-6 mt-1">
                  <p class="column is-12">ชื่อ-นามสกุล: {{ firstName }} {{lastName }}</p>
                  <p class="column is-6">เพศ: {{ gender }}</p>
                  <p class="column is-6">อีเมล: {{ email}}</p>
                  <p class="column is-6">วัน-เดือน-ปี เกิด: {{birthdate}}</p>
                  <p class="column is-6">ที่อยู่: {{address }}</p>
                  <p class="column is-6">เบอร์โทร: {{phone_number }}</p>
                  <div class="column is-6">
                  </div>
                </div>
              </div>
            <UploadResume></UploadResume>
          </div>
          </div>
        </div>
      </div>
</template>
<script>
import UploadResume from "@/components/upload-resume.vue";
import axios from "@/plugins/axios";
export default {
  components: {
    UploadResume,
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
      select_option: "user_profile",
      user: "",
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
      axios
      axios.get("http://localhost:3000/applicant/getData", config).then((res) => {
      const user = res.data;
     // console.log("getappProfile",user)
      this.firstName = user[0].firstName;
      this.lastName = user[0].lastName;
      this.birthdate = new Date(user[0].birthdate).toISOString().split("T")[0];
      this.phone_number = user[0].phone_number;
      this.gender = user[0].gender;
      this.email = user[0].email;
      this.address = user[0].address;
    });
},
  },
};
</script>
<style scoped>
</style>
