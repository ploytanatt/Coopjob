<template>
    <div class="">
      
      <div class="columns">
        
        <sideMenu></sideMenu>
        <div class="column">
          <overviewAdmin v-if="activeTab === 'overview'"></overviewAdmin>
        </div>
      </div>

    
    </div>
</template>
<script>
import overviewAdmin from '@/components/admin/overview-admin.vue'
import sideMenu from '@/components/admin/side-menu.vue'
export default {
    components: {
      overviewAdmin,
      sideMenu
    },
    data(){
      return{
        activeTab: 'overview'
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
