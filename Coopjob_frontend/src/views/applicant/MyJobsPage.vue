<template>

    <div class="columns">
      <applicantSideMenu></applicantSideMenu>
      <div class="">

      </div>

    </div>
 
</template>
<script lang="ts">
//import applicantApplication from '@/components/applicant/applicant-application.vue';
//import applicantApproveJob from '@/components/applicant/applicant-approvejob.vue';
//import applicantHistory from '@/components/applicant/applicant-history.vue';
//import applicantFavoritejob from '@/components/applicant/applicant-favorite.vue';
//import applicantreporthistory from '@/components/applicant/applicant-report.vue';

import applicantSideMenu from '@/components/applicant/applicant-side-menu.vue';
export default ({
    components: {
     //applicantHistory,
     //applicantApproveJob,
     //applicantApplication,
     //applicantFavoritejob,
     //applicantreporthistory,
     applicantSideMenu
    },
    data() {
  return {
    select_option : 'application',
  };
},
})
</script>
<style scoped>
.select_option {
    cursor: pointer;
}

.select_option:hover {
    background-color: rgb(255, 255, 255);
    
}



.card {
  width: 100%; 
}

</style>
