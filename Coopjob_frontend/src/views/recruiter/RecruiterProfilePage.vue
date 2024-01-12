<template>
    <div class="container">
      <div class="columns mt-6">
        <div class="column tap-list is-3 pt-3 pb-3 cardtab">
          <div :class="['select_option', select_option === 'recruiterProfile' ? 'has-background-light' : '']">
            <router-link to="/recruiterProfile">
              <p class="has-text-centered has-text-black is-size-5 p-3" @click="select_option = 'recruiterProfile'">ข้อมูลบริษัท</p>
            </router-link>
          </div>
          <div :class="['select_option', select_option === 'myjob' ? 'has-background-light' : '']">
            <router-link to="/recruiterJob">
              <p class="has-text-centered has-text-black is-size-5 p-3" @click="select_option = 'myjob'">งานที่ประกาศ</p>
            </router-link>
          </div>
          <div :class="['select_option', select_option === 'myApplicant' ? 'has-background-light' : '']">
            <router-link to="/applicantList">
              <p class="has-text-centered has-text-black is-size-5 p-3" @click="select_option = 'myApplicant'">คนที่มายื่นสมัคร</p>
            </router-link>
            </div>
          <div :class="['select_option', select_option === 'myAccount' ? 'has-background-light' : '']">
            <router-link to="/recruiterAccount">
              <p class="has-text-centered has-text-black is-size-5 p-3" @click="select_option = 'myAccount'">ตั้งค่าบัญชีผู้ใช้</p>
            </router-link>
            </div>
        </div>
        <recruiterProfile v-if="select_option === 'recruiterProfile'"></recruiterProfile>
      </div>
    </div>
</template>
<script lang="ts">
import recruiterProfile from '@/components/company/recruiter-profile.vue';
export default ({
    components: {
     recruiterProfile,
    },
    data() {
  return {
    select_option : 'recruiterProfile',
  };
},  
})
</script>
<style scoped>
.cardtab {
  background-color: #eeeeee;

}
.select_option {
  cursor: pointer;
  background-color: #eeeeee;
}
.select_option:hover {
  background-color: #4a84ca21;
}
.has-background-light {
  background-color: #4a83cadc !important;
}
.email{
  background-color: aqua;
}
</style>