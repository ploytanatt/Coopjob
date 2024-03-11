<template>
        <aside class="menu">
          <p class="menu-label">โปรไฟล์</p>
          <ul class="menu-list">
            <li>
              <a :class="{'is-active':  menuActiveTab === 'applicantProfile' }" @click="gotoApplicantProfile">
                <i class="fa-regular fa-house-blank"></i>
                <span class="menu-text">แก้ไขประวัติ</span>
              </a>
            </li>
            <li>
              <a :class="{ 'is-active':  menuActiveTab === 'applicantPreview' }" @click="gotoApplicantPreviewPage" >
                  <i class="fa-light fa-users"></i>
                <span class="menu-text">ดูตัวอย่างประวัติ</span>
              </a>
            </li>
            <ul class="menu-list">
              <li>งานของฉัน</li>
              <li>
               
                <ul>
                  <li>
                    <a :class="{ 'is-active':  menuActiveTab === 'MyJobs' }" @click="gotoApplicantJobs">
                      <i class="fa-sharp fa-solid fa-building-memo"></i>
                      <span class="menu-text">งานที่สมัคร</span>
                    </a>
                  </li>
                  <li>
                    <a :class="{ 'is-active':  menuActiveTab === 'MyFavoriteJobs' }" @click="gotoApplicantFavoriteJobs">
                      <i class="fa-sharp fa-solid fa-building-memo"></i>
                      <span class="menu-text">งานที่สนใจ</span>
                    </a>
                  </li>
                  <li>
                    <a :class="{ 'is-active':  menuActiveTab === 'report-history' }" @click="gotoRecruiterReportHistory">
                      <i class="fa-sharp fa-solid fa-building-memo"></i>
                      <span class="menu-text">การรายงาน</span>
                    </a>
                  </li>
                </ul>
              </li>

            </ul>
            <li>
            </li>
            <p class="menu-label">setting</p>
            <ul class="menu-list">
                <li>
              <a :class="{'is-active':  menuActiveTab === 'applicantAccount' }" @click="gotoApplicantAccount">
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
    gotoApplicantProfile() {
      if (this.$route.path !== '/applicantProfile') {
        this.$router.push('/applicantProfile');
      }
    },
    gotoApplicantPreviewPage() {
      if (this.$route.path !== '/applicantPreview') {
        this.$router.push('/applicantPreview');
      }
    },
    gotoApplicantJobs() {
      if (this.$route.path !== '/MyJobs') {
        this.$router.push('/MyJobs');
      }
    },
    gotoApplicantFavoriteJobs() {
      if (this.$route.path !== '/MyFavoriteJobs') {
        this.$router.push('/MyFavoriteJobs');
      }
    },
    gotoRecruiterReportHistory() {
      if (this.$route.path !== '/report-history') {
        this.$router.push('/report-history');
      }
    },
    gotoApplicantAccount() {
      if (this.$route.path !== '/applicantAccount') {
        this.$router.push('/applicantAccount');
      }
    },
    signOut() {
      // logic for sign out
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
  background-color: #4f8592;
  width: 250px;
  height: 100vh;
}
.menu-label{
  color: wheat;
}
.menu-text {
margin-left: 0.5em; /* กำหนดระยะห่างของตัวหนังสือจากไอคอน */
}
.menu-list a {
  color: white;
  padding: 1em 0.75em;
  display: flex;
  align-items: center;
  transition: background-color 0.3s, color 0.3s; /* Smooth transition for hover effect */
}
a {
color: #ffffff;
padding: 1em 0.75em;
display: flex;
align-items: center;
}
.is-active {
background-color: #74f699;
}
.menu-list a:hover {
  color: #d2d2d2;
  background-color: #fff5f5; 
}
</style>
