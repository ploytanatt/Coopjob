<template>
    <div class="">
      
      <div class="columns">
        
        <sideMenu></sideMenu>
        <div class="column">
         <companyRaing></companyRaing>
        </div>
      </div>

    
    </div>
</template>
  
<script>
import sideMenu from '@/components/admin/side-menu.vue';
import companyRaing from '@/components/admin/companies-rating.vue';
 
  export default {
    name: 'BarChart',
   components: { 
    sideMenu,
    companyRaing
   },
    data() {
      return {

      }
    }
  }
  </script>