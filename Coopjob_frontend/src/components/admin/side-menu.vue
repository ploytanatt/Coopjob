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
              <a @click="gotoStudentList">
                <i class="fa-light fa-users"></i>
                <span class="menu-text">รายชื่อบริษัท</span>
              </a>
            </li>
            <li>
              <a @click="gotoStudentList">
                <i class="fa-light fa-users"></i>
                <span class="menu-text">งานทั้งหมด</span>
              </a>
            </li>
            <li>
              <a @click="gotoStudentList">
                <i class="fa-light fa-users"></i>
                <span class="menu-text">คำร้องเรียน</span>
              </a>
            </li>
            <li>
              <a @click="gotoStudentList">
                <i class="fa-light fa-users"></i>
                <span class="menu-text">ผลการสมัครของนักศึกษา</span>
              </a>
            </li>
            <li>
              <a @click="gotoStudentList">
                <i class="fa-light fa-users"></i>
                <span class="menu-text">สรุปค่าแรงและสวัสดิการ</span>
              </a>
            </li>
            <li>
              <a @click="gotoStudentList">
                <i class="fa-light fa-users"></i>
                <span class="menu-text">รีวิวของบริษัท</span>
              </a>
            </li>

            <p class="menu-label">setting</p>
            <ul class="menu-list">
                <li>
              <a @click="gotoStudentList">
                <i class="fa-light fa-users"></i>
                <span class="menu-text">Account</span>
              </a>
            </li>
            <li>
              <a @click="gotoStudentList">
                <i class="fa-light fa-users"></i>
                <span class="menu-text">Sign Out</span>
              </a>
            </li>
            </ul>
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
        }
    },

}
</script>
<style scoped>
.columns{
    background-color: #e3f8ff;
}
.menu{
    padding: 1rem;
    background-color: #363740;
}
.menu-label{
    color: wheat;
}
.menu-text {
  margin-left: 0.5em; /* กำหนดระยะห่างของตัวหนังสือจากไอคอน */
}

a {
  color: #ffffff;
  padding: 1em 0.75em;
  display: flex; /* ใช้ flexbox เพื่อจัดการ layout ภายใน <a> */
  align-items: center; /* ทำให้ไอคอนและตัวหนังสืออยู่ในแนวเดียวกัน */
}
</style>
