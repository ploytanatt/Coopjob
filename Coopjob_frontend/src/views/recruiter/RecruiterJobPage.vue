<template>
    <div >
        <div class="columns">
      <recruiterSideMenu></recruiterSideMenu>
 
       <div class="p-6 card">
        <h1 class="title">งานที่ประกาศ</h1><div>
          <div class="twitter-pop-out-container">
          <button class="button is-primary add" @click="openAddJobModal">เพิ่มงาน</button>
          <div class="modal" :class="{ 'is-active': addJob }">
            <div class="modal-background" @click="closeAddJobModal"></div>
            <div class="modal-card">
              <header class="modal-card-head">
                <p class="modal-card-title">เลือกวิธีเพิ่มงาน</p>
                <button class="delete" aria-label="close" @click="closeAddJobModal"></button>
              </header>
              <section class="modal-card-body">
                <button class="button is-primary" @click="goToAddForm">เพิ่มงานแบบกรอกฟอร์ม</button>
                <button class="button is-info" @click="goToAddFile">เพิ่มงานโดยอัพโหลดไฟล์</button>
              </section>
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
