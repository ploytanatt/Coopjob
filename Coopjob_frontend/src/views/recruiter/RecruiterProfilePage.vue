<template>
      <div class="columns">
      <recruiterSideMenu></recruiterSideMenu>
      <div class="card">
        <recruiterProfile></recruiterProfile>
      </div>
   
        </div>
   
</template>
<script lang="ts">
import recruiterProfile from '@/components/recruiter/recruiter-profile.vue';
import recruiterSideMenu from '@/components/recruiter/recruiter-side-menu.vue';
export default ({
    components: {
     recruiterProfile,
     recruiterSideMenu
    },
    data() {
  return {
    select_option : 'profile',
  };
},  
})
</script>
<style scoped>

</style>