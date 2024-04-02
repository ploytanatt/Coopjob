<template>
    <div class="">
      <div class="columns">
        <sideMenu></sideMenu>
        <div class="column">
         <applicationList></applicationList>
        </div>
      </div>
    </div>
</template>

<script>
import sideMenu from '@/components/admin/side-menu.vue';
import applicationList from '../../components/admin/application-list.vue';
  export default {
    name: 'BarChart',
   components: { 
    sideMenu,
    applicationList
   },
    data() {
      return {

      }
    }
  }
  </script>