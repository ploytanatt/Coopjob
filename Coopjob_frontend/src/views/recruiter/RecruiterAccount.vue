<template>
<div>
      <div class="columns">
        <recruiterSideMenu></recruiterSideMenu>
          <div class="column is-10 mt-4">
            <section class="hero is-dark welcome is-small">
          <div class="hero-body">
            <p class="is-size-2">ตั้งค่าบัญชีผู้ใช้</p>
          </div>
        </section>
            <div class="email_password">
            <div class="column is-12" >
                <div class="field">
                  <label class="label">อีเมล</label>
                    <div class="control">
                      <input class="input" type="text" v-model="user.email"/>
                  </div>
                </div>
              </div>
            <div class="column is-12">
            <div class="field">
                  <label class="label">รหัสผ่านของคุณ</label>
                    <div class="control">
                      <input class="input" type="password" v-model.trim="check_password_Email"/>
                    </div>
                </div>
                </div>
            <button class="button changeEmail ml-3 is-info" @click="changeEmail()">เปลี่ยนอีเมล</button>
          </div>
          <div class="email_password">
              <div class="column is-12" >
                  <div class="field">
                    <label class="label">รหัสผ่านปัจจุบัน</label>
                      <div class="control">
                        <input class="input" type="password" v-model="check_password"/>
                    </div>
                  </div>
                </div>
    
                <div class="column is-12">
                <div class="field">
                  <label class="label">รหัสผ่านใหม่</label>
                  <div class="control">
                    <input class="input" :class="{ 'is-danger': $v.newPassword.$error }" type="password" v-model.trim="$v.newPassword.$model"/>
                  </div>
                  <template v-if="$v.newPassword.$error">
                  <p class="help is-danger" v-if="!$v.newPassword.minLength">รหัสผ่านต้องมีความยาวอย่างน้อย 8 ตัว </p>
                  <p class="help is-danger" v-else-if="!$v.newPassword.complex">รหัสผ่านต้องประกอบไปด้วยตัวพิมพ์เล็ก ตัวพิมพ์ใหญ่ และตัวเลข</p>
                </template>
                </div>
              </div>
              <div class="column is-12">
                <div class="field">
                  <label class="label">ยืนยันรหัสผ่านใหม่</label>
                  <div class="control">
                    <input class="input" :class="{ 'is-danger': $v.confirmPassword.$error }" type="password" v-model.trim="$v.confirmPassword.$model"/>
                  </div>
                  <!-- Add validation checks -->
                  <template v-if="$v.confirmPassword.$error">
              <p class="help is-danger" v-if="!$v.confirmPassword.sameAsPassword">รหัสไม่ตรงกัน</p>
              <p class="help is-danger" v-else-if="!$v.confirmPassword.minLength">รหัสผ่านต้องมีความยาวอย่างน้อย 8 ตัว </p>
              <p class="help is-danger" v-else-if="!$v.confirmPassword.complex">รหัสผ่านต้องประกอบไปด้วยตัวพิมพ์เล็ก ตัวพิมพ์ใหญ่ และตัวเลข</p>
            </template>
                </div>
              </div>
              <button class="button changeEmail ml-3 is-info" @click="changePassword()">เปลี่ยนรหัสผ่าน</button>
            </div>
        </div>
          </div>
        </div>
</template>
<script>
import axios from "axios";
import { minLength, sameAs  } from "vuelidate/lib/validators";
import Swal from "sweetalert2";
import recruiterSideMenu from '@/components/recruiter/recruiter-side-menu.vue';
function complexPassword(value) {
  if (!(value.match(/[a-z]/) && value.match(/[A-Z]/) && value.match(/[0-9]/))) {
    return false;
  }
  return true;
}
export default {
  components: {
    recruiterSideMenu
  },
data() {
  return {
    select_option : 'myAccount',
    check_password_Email: '',
    check_password: '',
    newPassword: '',
    confirmPassword: '',
    user: '',
    modify_account: false,  
  };
},

mounted() {
  this.getUser();
},

methods: {

  getUser() {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      axios.get("http://localhost:3000/user/me", config).then((res) => {
        
        this.user = res.data;
        console.log("App.vue", this.user)
      });
    },
    changeEmail() {
      if (!this.$v.check_password_Email.$pending && this.$v.check_password_Email.$error) {
    return;
  }
  const token = localStorage.getItem('token');
  const config = {
    headers: {
      Authorization: `Bearer ${token}`,
    },
  };
  const data = {
    email: this.user.email,
    password: this.check_password_Email,
  };
  axios
    .post('http://localhost:3000/user/changeEmail', data, config)
    .then((response) => {
      console.log('Email change successful:', response);
      Swal.fire({
        position: 'center',
        icon: 'success',
        title: 'Email changed successfully',
        showConfirmButton: false,
      });
      this.user.email = data.email;
      this.check_password_Email = '';
    })
    .catch((error) => {
      console.error('Email change failed:', error);
      if (error.response && error.response.status === 402) {
        Swal.fire({
          position: 'center',
          icon: 'error',
          title: error.response.data.message,
          showConfirmButton: false,
          timer: 1500,
        });
      }
      if (error.response && error.response.status === 400) {
        Swal.fire({
          position: 'center',
          icon: 'error',
          title: error.response.data.message,
          showConfirmButton: false,
          timer: 1500,
        });
      }
      else {
              // Other errors, show a generic error message
              Swal.fire({
                position: 'center',
                icon: 'error',
                title: 'Failed to change Email',
                showConfirmButton: false,
                timer: 1500,
              });
            }
    });
},
  changePassword() {
    if (!this.$v.check_password.$pending && this.$v.check_password.$error) {
    return;
  }
  if (!this.$v.newPassword.$pending && this.$v.newPassword.$error) {
    return;
  }
  if (!this.$v.confirmPassword.$pending && this.$v.confirmPassword.$error) {
    return;
  }
  console.log('Validation Status:', this.$v);
        const token = localStorage.getItem('token');
        const config = {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        };

        // Check if new password and confirm password match
        if (this.newPassword !== this.confirmPassword) {
          Swal.fire({
            position: 'center',
            icon: 'error',
            title: 'New password and confirm password do not match',
            showConfirmButton: false,
            timer: 1500,
          });
          return;
        }

        const data = {
          currentPassword: this.check_password, // Use the current password field for the current password
          newPassword: this.newPassword,
        };

        axios
          .post('http://localhost:3000/user/changePassword', data, config)
          .then((response) => {
            console.log('Password change successful:', response);
            Swal.fire({
              position: 'center',
              icon: 'success',
              title: 'Password changed successfully',
              showConfirmButton: false,
              timer: 1500,
            });
            this.check_password = '';
            this.newPassword = '';
            this.confirmPassword = '';
          })
          .catch((error) => {
            console.error('Password change failed:', error);
            if (error.response && error.response.status === 401) {
              // Invalid credentials, show an error message
              Swal.fire({
                position: 'center',
                icon: 'error',
                title: error.response.data.message,
                showConfirmButton: false,
                timer: 1500,
              });
            } else {
              // Other errors, show a generic error message
              Swal.fire({
                position: 'center',
                icon: 'error',
                title: 'Failed to change password',
                showConfirmButton: false,
                timer: 1500,
              });
            }
          });
      },

},
validations: {
    check_password: {
      minLength: minLength(8),
      complex: complexPassword,
    },
    check_password_Email: {
      minLength: minLength(8),
      complex: complexPassword,
    },
    newPassword: {
      minLength: minLength(8),
      
    },
    confirmPassword: {
      sameAsPassword: sameAs('newPassword'),
    },
  },
};

</script>

<style scoped>
.columns{
  background-color: #cbcbcb;
}
.card {
  width: 100%;
  background-color: #eeeeee;
}

.title{
    margin-left: 1rem;
}

.cardtab {
background-color: #eeeeee;

}
.select_option {
cursor: pointer;
background-color: #eeeeee;
}
.select_option:hover {
background-color: #4a84ca21;
}
.has-background-light {
background-color: #4a83cadc !important;
}

.email_password{
  
  width: 60%;
  background-color: #ffffff;
  margin-bottom: 1rem;
  border: 1px solid #cbcbcb;
  border-radius: 7px;
  padding: 1rem;
}

</style>
