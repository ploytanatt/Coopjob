<template>

  <div class="columns">
    <applicantSideMenu></applicantSideMenu>
    <div class="">
      <div v-for="likedJob in likedJobs" :key="likedJob.job_id">
      <div class="card px-5 py-3">
        <div class="pt-3" style="border-top: 0.5px solid gray">
          <div class="columns p-4">
            <div class="column">
              <p class="is-size-5 has-text-weight-bold"> บริษัท: {{ likedJob.company_name }} </p>
            </div>
            <!--
            <div class="column">
              <p class="is-size-5 has-text-weight-bold"> ID: {{ likedJob.job_id }} </p>
            </div>-->
            <div class="column">
              <p class="is-size-5 has-text-weight-bold"> ชื่องาน: {{ likedJob.job_title }} </p>
            </div>
            <div class="column">
              <!-- เพิ่มปุ่มดูรายละเอียด -->
              <button class="button is-info">
                <router-link :to="'/job/' + likedJob.job_id" class="has-text-white">ดูรายละเอียด</router-link>
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    </div>

  </div>

</template>

<script>
import axios from "axios";
import applicantSideMenu from '@/components/applicant/applicant-side-menu.vue';
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

        // ใช้ JSON.parse(JSON.stringify()) เพื่อ deep clone และลบ Observer ทิ้ง
        this.likedJobs = JSON.parse(JSON.stringify(response.data));
        console.log(this.likedJobs);
      } catch (error) {
        console.error(error);
      }
    },
  },
};
</script>

<style scoped></style>
