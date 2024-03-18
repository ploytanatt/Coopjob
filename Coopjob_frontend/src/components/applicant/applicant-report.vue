<template>
  <div class="columns ">
    <applicantSideMenu></applicantSideMenu>
    <div class="column is-10 mt-4">
    <section class="hero is-dark welcome is-small">
        <div class="hero-body">
          <p class="is-size-2">ประวัติการรายงาน</p>
          <p class="is-size-3">
            ทั้งหมด: {{ report_history.length }}
          </p>       
        </div>
      </section>
      <div class="container is-pulled-left mt-5">
    <div v-for="report in report_history" :key="report.report_id" class="box">
      <article class="media">
        <div class="media-content">
          <div class="content">
            <p>
              <strong>หัวข้อ: {{ report.report_title }}</strong>
              <br>
              รายละเอียด: {{ report.report_description }}
              <br>
              <small>วันที่รายงาน: {{ formatDate(report.report_created_at) }}</small>
             
            </p>
            <p class="tag " :class="{'is-success': report.report_status === 'approved', 'is-warning': report.report_status === 'pending', 'is-danger': report.report_status === 'rejected'}">สถานะการรายงาน: {{ report.report_status }}</p>
          </div>
        </div>
        <div class="media-right">
          <router-link :to="'/job/' + report.job_id">
            <button class="button is-info">ดูรายละเอียดงาน</button>
          </router-link>
        </div>
      </article>
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
      report_history:[],
    };
  },
  mounted() {
    this.getReportHistory();
  },
  methods: {
    getReportHistory(){
            const token = localStorage.getItem("token");
            const config = {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            };
            axios.get("http://localhost:3000/application/getReportHistory", config)
                .then((res) => {
                    this.report_history = res.data;
                })
                .catch((error) => {
                    console.error(error);
                });
        },
    formatDate(dateString) {
      const date = new Date(dateString);
      const options = {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hour12: false
      };
      return date.toLocaleDateString('en-EN', options);
    },
  },
};
</script>
 
<style scoped>
.container{
  width: 40%;
}
.box {
  margin-bottom: 1rem;
}

.tag.is-success {
  background-color: #48c774; /* or your success color */
}

.tag.is-warning {
  background-color: #ffdd57; /* or your warning color */
}

.tag.is-danger {
  background-color: #f14668; /* or your danger color */
}
</style>
 