<template>
  <div class="signin">
    <h1 class="title">Sign In</h1>
    <div class="container">    
        <div class="tabs is-boxed column is-8">
      <div >
        <h2 class="subtitle">Admin</h2>
        <form @submit.prevent="signinAdmin">
          <div class="field">
            <label class="label">Email</label>
            <div class="control">
              <input class="input" :class="{ 'is-danger': $v.adminEmail.$error }" type="email" v-model.trim="$v.adminEmail.$model"/></div>
            <template v-if="$v.adminEmail.$error">
              <p class="help is-danger" v-if="!$v.adminEmail.required">โปรดกรอกข้อมูลในช่องนี้</p>
              <p class="help is-danger" v-else-if="!$v.adminEmail.email">รูปแบบอีเมลไม่ถูกต้อง</p>
            </template>
          </div>
          <div class="field">
            <label class="label">Password</label>
            <div class="control">
              <input class="input" :class="{ 'is-danger': $v.adminPassword.$error }" type="password" v-model.trim="$v.adminPassword.$model"/>
            </div>
            <template v-if="$v.adminPassword.$error">
              <p class="help is-danger" v-if="!$v.adminPassword.required">โปรดกรอกข้อมูลในช่องนี้</p>
            </template>
          </div>
          <div class="field">
            <button class="button is-link">Sign In</button>
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
      adminEmail: "",
      adminPassword: "",

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
    adminEmail: {
      required,
      email: email,
    },
    adminPassword: {
      required,
      minLength: minLength(8),
      complex: complexPassword,
    },
  },
  methods: {
    signinAdmin() {
        const data = {
          email: this.adminEmail,
          password: this.adminPassword,
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
            this.$router.push("/adminOverview");
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