<template>
  <div class="signin">
    <h1 class="title">Sign In</h1>
    <div class="container">
      
        <div class="tabs is-boxed column is-8">
        <ul>
          <li :class="{ 'is-active': activeTab === 'applicant' }">
            <a @click="activeTab = 'applicant'">หางาน</a>
          </li>
          <li :class="{ 'is-active': activeTab === 'recruiter' }">
            <a @click="activeTab = 'recruiter'">หาคน</a>
          </li>
        </ul>
      
      <div v-show="activeTab === 'applicant'">
        <h2 class="subtitle">สมัครสมาชิกสำหรับผู้สมัคร</h2>
        <form @submit.prevent="signinApplicant">
          <div class="field">
            <label class="label">Email</label>
            <div class="control">
              <input
                v-model="$v.applicantEmail.$model" :class="{ 'is-danger': $v.applicantEmail.$error }" class="input" type="text"/>
            </div>
            <template v-if="$v.applicantEmail.$error">
              <p class="help is-danger" v-if="!$v.applicantEmail.required"> โปรดกรอกข้อมูลในช่องนี้</p>
              <p class="help is-danger" v-else-if="!$v.applicantEmail.email"> รูปแบบอีเมลไม่ถูกต้อง</p>
            </template>
          </div>
          <div class="field">
            <label class="label">Password</label>
            <div class="control">
              <input v-model="$v.applicantPassword.$model" :class="{ 'is-danger': $v.applicantPassword.$error }" class="input" type="password"/>
            </div>
            <template v-if="$v.applicantPassword.$error">
              <p class="help is-danger" v-if="!$v.applicantPassword.required">โปรดกรอกข้อมูลในช่องนี้</p>
              <p class="help is-danger" v-else-if="!$v.applicantPassword.minLength">รหัสผ่านต้องมีความยาวอย่างน้อย 8 ตัว</p>
              <p class="help is-danger" v-else-if="!$v.applicantPassword.complex">รหัสผ่านต้องประกอบไปด้วยตัวพิมพ์เล็ก ตัวพิมพ์ใหญ่ และตัวเลข</p>
            </template>
          </div>
          <div class="field">
            <button class="button is-link">Sign up</button>
          </div>
        </form>
      </div>
      <div v-show="activeTab === 'recruiter'" >
        <h2 class="subtitle">สมัครสมาชิกสำหรับบริษัท</h2>
        <form @submit.prevent="signinRecruiter">
          <div class="field">
            <label class="label">Email</label>
            <div class="control">
              <input class="input" :class="{ 'is-danger': $v.recruiterEmail.$error }" type="email" v-model.trim="$v.recruiterEmail.$model"/></div>
            <template v-if="$v.recruiterEmail.$error">
              <p class="help is-danger" v-if="!$v.recruiterEmail.required">โปรดกรอกข้อมูลในช่องนี้</p>
              <p class="help is-danger" v-else-if="!$v.recruiterEmail.email">รูปแบบอีเมลไม่ถูกต้อง</p>
            </template>
          </div>
          <div class="field">
            <label class="label">Password</label>
            <div class="control">
              <input class="input" :class="{ 'is-danger': $v.recruiterPassword.$error }" type="password" v-model.trim="$v.recruiterPassword.$model"/>
            </div>
            <template v-if="$v.recruiterPassword.$error">
              <p class="help is-danger" v-if="!$v.recruiterPassword.required">โปรดกรอกข้อมูลในช่องนี้</p>
              <p class="help is-danger" v-else-if="!$v.recruiterPassword.minLength">รหัสผ่านต้องมีความยาวอย่างน้อย 8 ตัว </p>
              <p class="help is-danger" v-else-if="!$v.recruiterPassword.complex">รหัสผ่านต้องประกอบไปด้วยตัวพิมพ์เล็ก ตัวพิมพ์ใหญ่ และตัวเลข</p>
            </template>
          </div>
          <div class="field">
            <button class="button is-link">Sign up</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>
</template>

<script>
import { required, email, minLength } from "vuelidate/lib/validators";
import axios from "@/plugins/axios";
import Swal from "sweetalert2";
function complexPassword(value) {
  if (!(value.match(/[a-z]/) && value.match(/[A-Z]/) && value.match(/[0-9]/))) {
    return false;
  }
  return true;
}

export default {
  data() {
    return {
      activeTab: "applicant",
      applicantEmail: "",
      applicantPassword: "",
      recruiterEmail: "",
      recruiterPassword: "",

    };
  },
  validations: {
    applicantEmail: {
      required,
      email: email,
    },
    applicantPassword: {
      required,
      minLength: minLength(8),
      complex: complexPassword,
    },
    recruiterEmail: {
      required,
      email: email,
    },
    recruiterPassword: {
      required,
      minLength: minLength(8),
      complex: complexPassword,
    },
  },
  methods: {
    signinApplicant() {
    const data = {
      email: this.applicantEmail,
      password: this.applicantPassword,

    };
    axios
      .post("http://localhost:3000/user/signin", data)
      .then((res) => {
        const token = res.data.token;
        localStorage.setItem("token", token);
        this.$emit("auth-change");
        Swal.fire({
          position: "center",
          icon: "success",
          title: "เข้าสู่ระบบสำเร็จ",
          showConfirmButton: false,
        });

        this.$router.push({ path: "/" });
      })
      .catch((error) => {
        if (error.response) {
          console.log(error.response.data);
          Swal.fire({
            position: "center",
            icon: "error",
            title: "อีเมลหรือรหัสผ่านไม่ถูกต้อง",
            showConfirmButton: false,
          });
        }
      });
  
},

    signinRecruiter() {
        const data = {
          email: this.recruiterEmail,
          password: this.recruiterPassword,
        };
        axios
          .post("http://localhost:3000/user/signin", data)
          .then((res) => {
            const token = res.data.token;
            localStorage.setItem("token", token);
            this.$emit("auth-change");
            console.log(res);
            Swal.fire({
              position: "center",
              icon: "success",
              title: "ลงทะเบียนเรียบร้อย",
              showConfirmButton: false,
            });
            this.$router.push({ path: "/" });
          })
          .catch((error) => {
            if (error.response) {
              console.log(error.response.data);
              Swal.fire({
                position: "center",
                icon: "error",
                title: "อีเมลหรือรหัสผ่านไม่ถูกต้อง",
                showConfirmButton: false,
              });
            }
          });
      }
  },
};
</script>

<style scoped>
.signin {
  max-width: 800px;
  margin: 0 auto;

}

.container {
  display: flex;
  justify-content: center;

}


.title {
  text-align: center;
  margin-bottom: 20px;
}

.tabs ul {
  margin-bottom: 20px;
}

.box {
  margin-bottom: 20px;
}
</style>