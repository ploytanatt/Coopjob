<template>
  <div class="columns">
    <applicantSideMenu></applicantSideMenu>
    <div class="column is-10 mt-4">
      <section class="hero is-dark welcome is-small">
        <div class="hero-body">
          <p class="is-size-2">งานที่สนใจ</p>
          <p class="is-size-3">
            จำนวนงานที่คุณสนใจทั้งหมด: {{ likedJobs.length }} งาน
          </p>       
        </div>
      </section>
      <div class="job-list columns  mt-2">
        <div v-for="likedJob in likedJobs" :key="likedJob.job_id" class="column is-2">
          <div class="card">
            <div class="card-image">
              <figure class="image CompanyLogo">
                <img :src="imagePath(likedJob.profile_image)" alt="Company Logo">
              </figure>
            </div>
            <div class="card-content">
              <p class="title is-4">{{ likedJob.job_title }}</p>
              <p class="subtitle is-6">{{ likedJob.company_name }}</p>
            </div>
            <footer class="card-footer">
              <router-link :to="'/job/' + likedJob.job_id" class="card-footer-item">ดูรายละเอียด</router-link>
              <a class="card-footer-item" @click="unfavThisJob(likedJob.job_id)">ลบ</a>
            </footer>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import applicantSideMenu from '@/components/applicant/applicant-side-menu.vue';
import Swal from "sweetalert2";
export default {
  components: {
     applicantSideMenu
    },
  data() {
    return {
      likedJobs: [],
      
    };
  },
  mounted() {
    this.getFavoriteJobs();
  },
  methods: {
    async getFavoriteJobs() {
      try {
        const token = localStorage.getItem("token");
        const config = {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        };
        const response = await axios.get("http://localhost:3000/application/getFavoriteJobs", config);
        this.likedJobs = response.data
        //console.log(this.likedJobs);
      } catch (error) {
        console.error(error);
      }
    },
    unfavThisJob(jobId) {
      const token = localStorage.getItem("token");
      axios.delete(`http://localhost:3000/application/cancelFavoriteJob/${jobId}`, {
        headers: { Authorization: `Bearer ${token}` }
      })
      .then(() => {
        
        Swal.fire("Unliked!", "You have unliked this job.", "success");
        this.getFavoriteJobs();
      })
      .catch(error => {
        console.error(error);
      });
    },
    imagePath(companyProfileImage) {
      if (companyProfileImage) {
        return "http://localhost:3000" + companyProfileImage.replace(/\\/g, '/').replace('static', '');
      } else {
        return "https://bulma.io/images/placeholders/640x360.png";
      }
    },
  },
};
</script>

<style scoped>
.liked-jobs-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  grid-gap: 20px;
}

.card {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.card-content {
  flex-grow: 1;
}

.card-footer {
  border-top: 1px solid #dbdbdb;
}
</style>