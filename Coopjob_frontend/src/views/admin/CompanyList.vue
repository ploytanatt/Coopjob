<template>
    <div class="">
      
      <div class="columns">
        
        <sideMenu></sideMenu>
        <div class="column">
         <companiesList></companiesList>
        </div>
      </div>

    
    </div>
</template>
  
<script>
import sideMenu from '@/components/admin/side-menu.vue';
import companiesList from '../../components/admin/companies-list.vue';
 
  export default {
    name: 'BarChart',
   components: { 
    sideMenu,
    companiesList
   },
    data() {
      return {

      }
    }
  }
  </script>