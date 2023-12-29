<template>
  <div>
    <div v-for="likedJob in likedJobs" :key="likedJob.job_id">
      <div class="card px-5 py-3">
        <div class="pt-3" style="border-top: 0.5px solid gray">
          <div class="columns p-4">
            <div class="column">
              <p class="is-size-5 has-text-weight-bold"> ID: {{ likedJob.job_id }} </p>
            </div>
            <div class="column">
              <p class="is-size-5 has-text-weight-bold"> ตำแหน่ง: {{ likedJob.jobTitle }} </p>
            </div>
            <div class="column">
              <p class="is-size-5 has-text-weight-bold"> วันที่กดถูกใจ: {{ likedJob.likedDate }} </p>
            </div>
            <div class="column">
              <!-- เพิ่มปุ่มดูรายละเอียด -->
              <router-link :to="'/company/' + likedJob.job_id">ดูรายละเอียด</router-link>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      likedJobs: [],
    };
  },
  mounted() {
    this.getLikedJobs();
  },
  methods: {
    async getLikedJobs() {
      try {
        const token = localStorage.getItem("token");
        const config = {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        };

        const response = await axios.get("http://localhost:3000/application/getLikedJobs", config);
        
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

<style scoped>
</style>
