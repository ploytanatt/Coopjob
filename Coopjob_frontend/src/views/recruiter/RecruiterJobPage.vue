<template>
    <div >
        <div class="columns">
      <recruiterSideMenu></recruiterSideMenu>
       <div class="column is-10 mt-4">
        <section class="hero is-dark welcome is-small">
          <div class="hero-body">      
              <p class="is-size-2">งานที่ประกาศ</p>
          </div>
        </section>
          <div class="twitter-pop-out-container">
          <button class="button is-success add mt-4" @click="openAddJobModal"><i class="fa-regular fa-file-plus"> เพิ่มงาน</i></button>
          <div class="modal" :class="{ 'is-active': addJob }">
            <div class="modal-background" @click="closeAddJobModal">
            </div>
          <div class="modal-card">
            <header class="modal-card-head">
              <p class="modal-card-title">เลือกวิธีเพิ่มงาน</p>
              <button class="delete" aria-label="close"  @click="closeAddJobModal"></button>
            </header>
            <footer class="modal-card-foot">
              <button class="addjob button is-primary" @click="goToAddForm"><i class="fa-solid fa-pen" aria-hidden="true"> กรอกฟอร์ม</i></button>
              <button class="addjob button is-info" @click="goToAddFile"><i class="fa-solid fa-file-arrow-up" aria-hidden="true"> อัพโหลดไฟล์</i></button>
            </footer>
          </div>
          </div>
          <applicationEachJob v-if="viewApplicationlist"></applicationEachJob>   
      <div class="tabs is-centered is-boxed">
        <ul>
          <li :class="{ 'is-active': activeTab === 'form' }">
            <a @click="changeTab('form')">
              <span class="icon is-small"><i class="fa-solid fa-pen" aria-hidden="true"></i></span>
              <span>form</span>
            </a>
          </li>
          <li :class="{ 'is-active': activeTab === 'upload' }">
            <a @click="changeTab('upload')">
              <span class="icon is-small"><i class="fa-solid fa-file-arrow-up" aria-hidden="true"></i></span>
              <span>upload</span>
            </a>
          </li>
        </ul>
      </div>
 <jobListFormVue v-show="activeTab ==='form'"></jobListFormVue>
 <jobListingUpload v-show="activeTab ==='upload'"></jobListingUpload>

  </div>
  </div>
  </div>

  </div>

</template>
<script>
import jobListFormVue from "@/components/recruiter/job-listing-form.vue"
import jobListingUpload from "@/components/recruiter/job-listing-upload.vue"
import applicationEachJob from "@/components/recruiter/application-eachjob.vue"
import recruiterSideMenu from '@/components/recruiter/recruiter-side-menu.vue';
export default {
  components: {
    jobListFormVue,
    jobListingUpload,
    applicationEachJob,
    recruiterSideMenu
  },
  data() {
    return {
      jobs: [],
      addJob: false,
      select_option : 'jobpage',
      isJobOpen: true,
      activeTab: 'form',
      model: true,
    };
  },
  methods: {
    changeTab(tab) {
      this.activeTab = tab;
    },
    openAddJobModal() {
      this.addJob = true;
    },
    closeAddJobModal() {
      this.addJob = false;
    },
    goToAddForm() {
      this.$router.push("/recruiterAddJob");
      this.closeAddJobModal();
    },
    goToAddFile() {
      this.$router.push("/recruiterAddJobByUpload");
      this.closeAddJobModal();
    },
  },

};
</script>

<style scoped>
.modal-card{
  width: 350px;
}
.addjob{
  border-radius: 180px;
  margin: 0.8rem;
}
.toggle{
  background-color: bisque;
}
.select_option {
    cursor: pointer;
}
.select_option:hover {
    background-color: #ffffff;
}
.detail{
  margin: 1rem;
}
.card {
  width: 100%;
  background-color: #eeeeee;

  
}
.add{
    margin-left: 1rem;
}
.title{
    margin-left: 1rem;
}
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

</style>
