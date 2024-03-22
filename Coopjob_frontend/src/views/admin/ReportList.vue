<template>
    <div class="">
      
      <div class="columns">
        
        <sideMenu></sideMenu>
        <div class="column">
         <reportList></reportList>
        </div>
      </div>

    
    </div>
</template>
  
<script>
import sideMenu from '@/components/admin/side-menu.vue';
import reportList from '@/components/admin/report-list.vue';
  export default {
    name: 'BarChart',
   components: { 
    sideMenu,
    reportList
   },
    data() {
      return {

      }
    }
  }
  </script>