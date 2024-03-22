<template>
  <div id="app">
    <nav class="navbar has-shadow" role="navigation" aria-label="main navigation">
      <div class="navbar-brand">
        <a class="navbar-item" href="/">
          <img src="./assets/images/logo.png" width="200px" height="auto">
        </a>
      </div>

  <div id="navbarBasicExample" class="navbar-menu">
    <div class="navbar-end">
      <div class="buttons">
              <div class="navbar-item">
                <div class="buttons">
                  <router-link class="button is-info" to="/signup" v-if="!user">
                    <strong>Sign Up</strong>
                  </router-link>
                  <router-link class="button is-light" to="/signin" v-if="!user">
                <strong>Sign In</strong>
              </router-link>
                </div>
              </div>


              <!-- ของบริษัท -->
              <router-link class="navbar-item " to="/recruiterProfile" v-if="user.role === 'recruiter'">
                <font-awesome-icon icon="exclamation" style="color: red" v-if="recruiter.status === 'close'" />ข้อมูลบริษัท
              </router-link>
              <router-link class="navbar-item " to="/applicantList" v-if="user.role === 'recruiter'">
                คนที่มายื่นสมัคร 
              </router-link>
              <router-link class="navbar-item " to="/recruiterAccount" v-if="user.role === 'recruiter'">
                <i class="fa-solid fa-gear p-2"></i>
                <span>ตั้งค่าบัญชีผู้ใช้</span>
              </router-link>
              

              <!-- ของคนหางาน -->
              <router-link class="navbar-item " to="/" v-if="user.role === 'applicant'">
                หางาน
              </router-link>
              <router-link class="navbar-item " to="/applicantProfile" v-if="user.role === 'applicant' ">
                <font-awesome-icon icon="exclamation" style="color: red" v-if="applicant.status === 'close'" />ประวัติส่วนตัว
              </router-link>
              <router-link class="navbar-item " to="/MyJobsPage" v-if="user.role === 'applicant'">
                งานของฉัน
              </router-link>
              <router-link class="navbar-item " to="/applicantAccount" v-if="user.role === 'applicant'">
                <i class="fa-solid fa-gear p-2"></i>
                <span>ตั้งค่าบัญชีผู้ใช้</span>
              </router-link>

              <router-link class="navbar-item " to="/adminOverview" v-if="user.role === 'admin'">
                     
                      <span>dashboard</span>
                    </router-link>
              
              <div class="navbar-item">
                <div class="buttons">
                  <a class="button is-danger" @click="logout()" v-if="user">
                    Logout
                  </a>
                </div>
              </div>
            </div>
          
    </div>
  </div>
</nav>
    <router-view
      :key="$route.fullPath"
      @auth-change="getUser"
      :user="user"
    />
  </div>
</template>
<script>
import axios from "@/plugins/axios";
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';

export default {
  components: {
    FontAwesomeIcon
  },
  data() {
    return {
      user: '',
      applicant:'',
      recruiter:''
    };
  },
  mounted() {
    this.onAuthChange();
  },
  methods: {
    onAuthChange() {
      const token = localStorage.getItem("token");
      if (token) {
        this.getUser();
      } else {
        this.user = ''; // เคลียร์ค่า user เมื่อไม่มี token
      }
    },
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
    logout() {
      localStorage.removeItem("token");
      location.reload();
    },
  },
};
</script>
<style scoped>
.navbar {
  background-color: #ffffff; /* Change the background color */
  padding: 10px;
  position: sticky;
  top: 0;
  z-index: 1000;
  
}

.navbar-item-logo img {
  max-height: 3rem; 
}

.navbar-burger {
  margin-top: 20px;
  color: #000000;
}

.navbar-start a,
.navbar-end a {
  color: #000000;
  margin-right: 10px;
}

.navbar-end a:hover {
  color: #0052a3;
}

.navbar-dropdown {
  background-color: #34495e; /* Change the dropdown background color */
}

.navbar-dropdown a {
  color: #fff; /* Change the dropdown link color */
}

.buttons .button {
  margin-right: 5px;
}
.navbar.has-shadow {
    box-shadow: 0 2px 0 0 #0000001e;
}
</style>
