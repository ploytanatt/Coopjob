<template>
    <div class="">
      
      <div class="columns">
        
        <sideMenu></sideMenu>
        <div class="column">
         <jobList></jobList>
        </div>
      </div>

    
    </div>
</template>
  
<script>
import sideMenu from '@/components/admin/side-menu.vue';
import jobList from '../../components/admin/jobs-list.vue';
  export default {
    name: 'BarChart',
   components: { 
    sideMenu,
    jobList
   },
    data() {
      return {

      }
    }
  }
  </script>