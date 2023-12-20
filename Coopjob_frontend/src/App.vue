<template>
  <div id="app">
    <nav class="navbar" role="navigation" aria-label="main navigation">
      <div class="navbar-brand">
        <a class="navbar-item-logo" href="/">
          <img
            src="./assets/images/logo.png"
            width="200px" 
            height="auto"
            alt="Logo"
          />
        </a>
        <a
          role="button"
          class="navbar-burger"
          aria-label="menu"
          aria-expanded="false"
          data-target="navbarBasicExample"
        >
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
          <span aria-hidden="true"></span>
        </a>
      </div>

      <div id="navbarBasicExample" class="navbar-menu">
        <div class="navbar-end">
          <div class="navbar-item">
            <div class="buttons">
              <router-link class="button is-dark" to="/signup" v-if="!user">
                <strong>Sign Up</strong>
              </router-link>
              <router-link class="button is-dark" to="/signin" v-if="!user">
                <strong>Sign In</strong>
              </router-link>

              <!-- ของบริษัท -->
              <router-link class="navbar-item " to="/recruiterProfile" v-if="user.role === 'recruiter'">
                <font-awesome-icon icon="exclamation" style="color: red" v-if="recruiter.status === 'close'" />ข้อมูลบริษัท
              </router-link>
              <router-link class="navbar-item " to="/applicantList" v-if="user.role === 'recruiter'">
                คนที่มายื่นสมัคร 
              </router-link>

              <!-- ของคนหางาน -->
              <router-link class="navbar-item " to="/applicantProfile" v-if="user.role === 'applicant' ">
                <font-awesome-icon icon="exclamation" style="color: red" v-if="applicant.status === 'close'" />ประวัติส่วนตัว
              </router-link>
              <router-link class="navbar-item " to="/MyJobs" v-if="user.role === 'applicant'">
                งานของฉัน
              </router-link>

              <button class="button is-danger" @click="logout()" v-if="user">
                Logout
              </button>
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
  background-color: #b9b9b9;
  padding: 10px;
  position: sticky;
  top: 0;
  z-index: 1000;
}

.navbar-item-logo {
 
  padding: 10px;
}

.navbar-burger {
  margin-top: 20px; 
  
}

</style>