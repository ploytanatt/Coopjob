<template>
    <div class="container">
        <div class="columns mt-6">
            <div class="column has-background-light is-3 pt-3 pb-3 card">
                <div
                :class="['select_option', select_option === 'recruiterProfile' ? 'has-background-primary ' : '']">
                <router-link to="/recruiterProfile">
                    <p class="has-text-centered is-size-5 p-3 has-text-white" @click="select_option = 'recruiterProfile'">ข้อมูลบริษัท</p>
                </router-link>
                </div>
                <div
                :class="['select_option', select_option === 'myjob' ? 'has-background-primary has-text-white' : '']">
                <router-link to="/recruiterJob">
                    <p class="has-text-centered is-size-5 p-3 " @click="select_option = 'myjob'">งานที่ประกาศ</p>
                </router-link>
                </div>
            </div>
            <recruiterProfile v-if="select_option === 'recruiterProfile'">
            </recruiterProfile >
        </div>
    </div>
</template>
<script lang="ts">
import recruiterProfile from '@/components/recruiter-profile.vue';
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
.select_option {
    cursor: pointer;
}
.select_option:hover {
    background-color: rgb(255, 255, 255);
}</style>
