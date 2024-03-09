<template>
  

        <div class="columns">
      <recruiterSideMenu></recruiterSideMenu>
     
        
        <div class="p-6 card">
            <h1 class="title">รายชื่อผู้ที่มาสมัครงาน</h1>
        
            <div class="column is-12" >
      <!-- Filter Dropdown -->
      <div class="field">
        <label class="label">Filter by Status</label>
        <div class="control">
          <div class="select">
            <select v-model="selectedStatus">
              <option value="">All</option>
              <option value="approve">Approve</option>
              <option value="reject">Reject</option>
              <option value="pending">Pending</option>
            </select>
          </div>
        </div>
      </div>
        </div>
      <!-- Loading Spinner -->

      <p class="is-size-3">จำนวนผู้สมัครทั้งหมด : {{  computedPaginatedApplications.length }}</p>
      <div class="table">
        <table class="table is-bordered is-striped is-narrow is-hoverable is-fullwidth">
          <thead>
            <tr>
              <th>ชื่องาน</th>
              <th>ชื่อ-นามสกุล</th>
              <th>ชื่องาน</th>
              <th>สถานะ</th>
              <th>วันที่สมัคร</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="application in computedPaginatedApplications" :key="application.user_id">
              <td>{{ application.position }}</td>
           
            

              <td>
 
            </td>
     
            </tr>
          </tbody>
        </table>
        </div>



      <!-- Applications List -->


      <!-- Pagination -->
      <div class="pagination">
        <button @click="prevPage" :disabled="currentPage === 1">Previous</button>
        <span>{{ currentPage }}</span>
        <button @click="nextPage" :disabled="currentPage === totalPages">Next</button>
      </div>


        </div>
        </div>
    


</template>

<script>
import axios from "axios";
import Swal from "sweetalert2";
import recruiterSideMenu from '@/components/recruiter/recruiter-side-menu.vue';
export default {
  components: {

     recruiterSideMenu
    },
  data() {
    return {
      applications: [],
      selectedStatus: "",
      isLoading: false,
      itemsPerPage: 10,
      currentPage: 1,
      select_option : 'myApplicant',
      
      showModal: false,
    };
  },
  mounted() {
    this.getApplications();
  },
  methods: {
    getApplications() {
      this.isLoading = true;
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      axios
        .get("http://localhost:3000/application/getApplications", config)
        .then((response) => {
          this.applications = response.data;
          this.isLoading = false;
        })
        .catch((error) => {
          console.error(error);
          this.isLoading = false;
        });
    },
    viewApplicationDetail(applicationId) {
      this.$router.push("/applicantDetail/" + applicationId);
    },
    declineApplicant(applicationJob) {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      const status = "reject";
      axios
        .put(
          `http://localhost:3000/application/updateStatus/${applicationJob}`,
          { status },
          config
        )
        .then((res) => {
          Swal.fire(res.data.message, "", "success");
          this.getApplications(); // โหลดข้อมูลใหม่หลังจากปฏิเสธ
        })
        .catch((error) => {
          console.error(error);
        });
    },
    nextPage() {
      if (this.currentPage < this.totalPages) {
        this.currentPage++;
      }
    },
    prevPage() {
      if (this.currentPage > 1) {
        this.currentPage--;
      }
    },
  },
  computed: {
    computedFilteredApplications() {
      if (this.selectedStatus) {
        return this.applications.filter(
          (application) => application.status === this.selectedStatus
        );
      }
      return this.applications;
    },
    computedPaginatedApplications() {
      const startIndex = (this.currentPage - 1) * this.itemsPerPage;
      const endIndex = startIndex + this.itemsPerPage;
      return this.computedFilteredApplications.slice(startIndex, endIndex);
    },
    totalPages() {
      return Math.ceil(
        this.computedFilteredApplications.length / this.itemsPerPage
      );
    },
  },
};
</script>

<style scoped>
.loading-spinner {
  text-align: center;
  padding: 10px;
  font-size: 18px;
  color: #4caf50;
}
.pagination {
  display: flex;
  justify-content: center;
  margin-top: 10px;
}
.pagination button {
  margin: 0 5px;
}
.card {
  width: 100%;
  background-color: #eeeeee;
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
.email{
  background-color: aqua;
}
</style>