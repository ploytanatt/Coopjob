<template>

    <div class="columns">
      <applicantSideMenu></applicantSideMenu>
      <div class="">
<applicantApplication></applicantApplication>
<applicantApproveJob></applicantApproveJob>
<applicantHistory></applicantHistory>
<applicantreporthistory></applicantreporthistory>
      </div>

    </div>
 
</template>
<script lang="ts">
import applicantApplication from '@/components/applicant/applicant-application.vue';
import applicantApproveJob from '@/components/applicant/applicant-approvejob.vue';
import applicantHistory from '@/components/applicant/applicant-history.vue';
import applicantreporthistory from '@/components/applicant/applicant-report.vue';

import applicantSideMenu from '@/components/applicant/applicant-side-menu.vue';
export default ({
    components: {
     applicantHistory,
     applicantApproveJob,
     applicantApplication,
applicantreporthistory,
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
