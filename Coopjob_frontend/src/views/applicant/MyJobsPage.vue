<template>
    <div class="container">
        <div class="columns mt-6">
            <div class="column has-background-light is-3 pt-3 pb-3 card">
                <div
                    :class="['select_option', select_option === 'application' ? ['has-background-primary', 'has-text-white'] : '']">
                    <p class="has-text-centered is-size-5 p-3 " @click="select_option = 'application'">งานกำลังที่ยื่นสมัคร
                    </p>
                </div>
                <div
                    :class="['select_option', select_option === 'history' ? ['has-background-primary', 'has-text-white'] : '']">
                    <p class="has-text-centered is-size-5 p-3 " @click="select_option = 'history'">งานที่เคยยื่น</p>
                </div>
                <div
                    :class="['select_option', select_option === 'favorite' ? ['has-background-primary', 'has-text-white'] : '']">
                    <p class="has-text-centered is-size-5 p-3 " @click="select_option = 'favorite'">งานถูกใจ</p>
                </div>
                <div
                    :class="['select_option', select_option === 'report_history' ? ['has-background-primary', 'has-text-white'] : '']">
                    <p class="has-text-centered is-size-5 p-3 " @click="select_option = 'report_history'">ประวัติการรีพอร์ต</p>
                </div>
            </div>
            <applicantApplication v-if="select_option === 'application'">
            </applicantApplication>
            <applicantHistory
                v-if="select_option === 'history'">
            </applicantHistory>
            <applicantFavoritejob
                v-if="select_option === 'favorite'">
            </applicantFavoritejob>
            <applicantreporthistory
                v-if="select_option === 'report_history'">
            </applicantreporthistory> 
        </div>
    </div>
</template>
<script lang="ts">
import applicantApplication from '@/components/applicant-application.vue';
import applicantHistory from '@/components/applicant-history.vue';
import applicantFavoritejob from '@/components/applicant-favorite.vue';
import applicantreporthistory from '@/components/applicant-report.vue';
export default ({
    components: {
     applicantHistory,
     applicantApplication,
     applicantFavoritejob,
     applicantreporthistory,
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
}</style>
