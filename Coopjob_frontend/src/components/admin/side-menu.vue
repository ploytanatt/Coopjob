<template>
    <div class="">
          <aside class="menu">
            <p class="menu-label">General</p>
            <ul class="menu-list">
            <li>
              <a @click="gotoOverview">
                <i class="fa-regular fa-house-blank"></i>
                <span class="menu-text">Overview</span>
              </a>
            </li>
            <li>
              <a @click="gotoStudentList">
                <i class="fa-light fa-users"></i>
                <span class="menu-text">รายชื่อนักศึกษา</span>
              </a>
            </li>
            <li>
              <a @click="gotoCompanyList">
                <i class="fa-sharp fa-solid fa-building-memo"></i>
                <span class="menu-text">รายชื่อบริษัท</span>
              </a>
            </li>
            <li>
              <a @click="gotoJobList">
                <i class="fa-light fa-clipboard-list"></i>
                <span class="menu-text">งานทั้งหมด</span>
              </a>
            </li>
            <li>
              <a @click="gotoReportList">
                <i class="fa-regular fa-circle-exclamation"></i>
                <span class="menu-text">คำร้องเรียน</span>
              </a>
            </li>
            <li>
              <a @click="gotoApplicationList">
                <i class="fa-sharp fa-light fa-rectangle-history"></i>
                <span class="menu-text">ผลการสมัครของนักศึกษา</span>
              </a>
            </li>
            <li>
              <a @click="gotoBenefitResult">
                <i class="fa-solid fa-file-invoice-dollar"></i>
                <span class="menu-text">สรุปค่าแรงและสวัสดิการ</span>
              </a>
            </li>
            <li>
              <a @click="gotoCompanyRating">
                <i class="fa-regular fa-star"></i>
                <span class="menu-text">รีวิวของบริษัท</span>
              </a>
            </li>
          </ul>
          </aside>
      </div>
</template>
<script>
//import overviewAdmin from '@/components/admin/overview-admin.vue'
export default {
    components: {
    //  overviewAdmin
    },
    data(){
      return{
        activeTab: 'overview'
      }
    },
    methods: {
        gotoOverview(){
            if (this.$route.path !== '/adminOverview') {
                this.$router.push('/adminOverview');
            }
        },
        gotoStudentList(){
            if (this.$route.path !== '/studentList') {
                this.$router.push('/studentList');
            }
        },
        gotoCompanyList(){
            if (this.$route.path !== '/companyList') {
                this.$router.push('/companyList');
            }
        },
        gotoJobList(){
            if (this.$route.path !== '/companyjobList') {
                this.$router.push('/companyjobList');
            }
        },
        gotoReportList(){
            if (this.$route.path !== '/reportList') {
                this.$router.push('/reportList');
            }
        },
        gotoApplicationList(){
            if (this.$route.path !== '/applicationList') {
                this.$router.push('/applicationList');
            }
        },
        gotoBenefitResult(){
            if (this.$route.path !== '/BenefitResult') {
                this.$router.push('/BenefitResult');
            }
        },
        gotoCompanyRating(){
            if (this.$route.path !== '/CompanyRating') {
                this.$router.push('/CompanyRating');
            }
        },
        gotoAdminAccountSetting(){
            if (this.$route.path !== '/AdminAccountSetting') {
                this.$router.push('/AdminAccountSetting');
            }
        },
        signOut(){ 
        },
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
    height: 100%;
}
.menu-label{
    color: wheat;
}
.menu-text {
  margin-left: 0.5em;
}

a {
  color: #ffffff;
  padding: 1em 0.75em;
  display: flex; 
  align-items: center;
}
</style>
