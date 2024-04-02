<template>
        <aside class="menu">
          <p class="menu-label">General</p>
          <ul class="menu-list">
            <li>
              <a :class="{'is-active':  menuActiveTab === 'recruiterProfile' }" @click="gotoRecruiterProfile">
                <i class="fa-regular fa-house-blank"></i>
                <span class="menu-text">ข้อมูลบริษัท</span>
              </a>
            </li>
            <li>
              <a :class="{ 'is-active':  menuActiveTab === 'recruiterJob' }" @click="gotoRecruiterJobPage" >
                  <i class="fa-light fa-users"></i>
                <span class="menu-text">งานที่ประกาศ</span>
              </a>
            </li>
            <li>
              <a :class="{ 'is-active':  menuActiveTab === 'applicantList' }" @click="gotoApplicantList">
                <i class="fa-sharp fa-solid fa-building-memo"></i>
                <span class="menu-text">คนที่มายื่นสมัคร</span>
              </a>
            </li>
            <li>
            </li>
            <p class="menu-label">setting</p>
            <ul class="menu-list">
                <li>
              <a :class="{'is-active':  menuActiveTab === 'recruiterAccount' }" @click="gotoRecruiterAccountSetting">
                <i class="fa-regular fa-gear"></i>
                <span class="menu-text">Account</span>
              </a>
            </li>
            <li>
              <a :class="{ 'is-active':  menuActiveTab === 'signOut' }" @click="signOut">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span class="menu-text">Sign Out</span>
              </a>
            </li>
          </ul>
        </ul>
        </aside>
</template>
<script>
export default {
  computed: {
    menuActiveTab() {
      return this.$route.path.split('/')[1]; // อัปเดตตาม path ของ route
    }
  },
  methods: {
    gotoRecruiterProfile() {
      if (this.$route.path !== '/recruiterProfile') {
        this.$router.push('/recruiterProfile');
      }
    },
    gotoRecruiterJobPage() {
      if (this.$route.path !== '/recruiterJob') {
        this.$router.push('/recruiterJob');
      }
    },
    gotoApplicantList() {
      if (this.$route.path !== '/applicantList') {
        this.$router.push('/applicantList');
      }
    },
    gotoRecruiterAccountSetting() {
      if (this.$route.path !== '/recruiterAccount') {
        this.$router.push('/recruiterAccount');
      }
    },
    signOut() {
     
    }
  }
}
</script>

<style scoped>
.columns{
  
  background-color: #e3f8ff;
}
.menu{
padding: 1rem;
  background-color: #363740;
  width: 250px;
  min-height: 100lvh;
}
.menu-label{
  color: wheat;
}
.menu-text {
margin-left: 0.5em; 
}
.menu-list a {
  color: white;
  padding: 1em 0.75em;
  display: flex;
  align-items: center;
  transition: background-color 0.3s, color 0.3s;
}
a {
color: #ffffff;
padding: 1em 0.75em;
display: flex;
align-items: center;
}
.is-active {
background-color: #3273dc;
}
.menu-list a:hover {
  color: #3273dc;
  background-color: #fff5f5; 
}
</style>
