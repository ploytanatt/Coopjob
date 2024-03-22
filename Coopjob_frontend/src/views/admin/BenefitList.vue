<template>
    <div class="">
      
      <div class="columns">
        
        <sideMenu></sideMenu>
        <div class="column">
         <benefitList></benefitList>
        </div>
      </div>

    
    </div>
</template>
  
<script>
import sideMenu from '@/components/admin/side-menu.vue';
import benefitList from '@/components/admin/benefit-list.vue';
 
  export default {
    name: 'BarChart',
   components: { 
    sideMenu,
    benefitList
   },
    data() {
      return {

      }
    }
  }
  </script>