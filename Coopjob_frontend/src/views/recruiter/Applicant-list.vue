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

      
      <div class="p-6 card">
            <h1 class="title">รายชื่อผู่ที่มาสมัครงาน</h1>

           
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
      <div v-if="isLoading" class="loading-spinner">
        Loading...
      </div>

      <!-- Applications List -->
      <div v-for="application in computedPaginatedApplications" :key="application.id">
        <div class="card px-5 py-3" v-if="application.status !== 'canceled'">
          <div class="pt-3" style="border-top: 0.5px solid gray;">
            <div class="columns p-4" @click="viewApplicationDetail(application.id)">
              <div class="column">
                <p class="is-size-5 has-text-weight-bold">id: {{ application.id }}</p>
              </div>
              <div class="column">
                <p class="is-size-5 has-text-weight-bold">ตำแหน่ง: {{ application.position }}</p>
              </div>
              <div class="column">
                <p class="is-size-5 has-text-weight-bold">สถานะ: {{ application.status }}</p>
              </div>
            </div>
            <button v-show="application.status === 'pending'" class="button is-medium is-success" @click="acceptApplicant(application.id)">ผ่าน</button>
            <button v-show="application.status === 'pending'" class="button is-medium is-danger" @click="declineApplicant(application.id)">ไม่ผ่าน</button>

          </div>
          <div style="display: flex; flex-direction: row; justify-content: flex-end;"></div>
        </div>
      </div>

      <!-- Pagination -->
      <div class="pagination">
        <button @click="prevPage" :disabled="currentPage === 1">Previous</button>
        <span>{{ currentPage }}</span>
        <button @click="nextPage" :disabled="currentPage === totalPages">Next</button>
      </div>


        </div>
      </div>
  </div>
</template>

<script>
import axios from "axios";
import Swal from "sweetalert2";

export default {
  data() {
    return {
      applications: [],
      selectedStatus: "",
      isLoading: false,
      itemsPerPage: 10,
      currentPage: 1,
      select_option : 'myApplicant',
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
    acceptApplicant(applicationJob) {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      const status = "approve";
      axios
        .put(
          `http://localhost:3000/application/updateStatus/${applicationJob}`,
          { status },
          config
        )
        .then((res) => {
          Swal.fire(res.data.message, "", "success");
          this.getApplications(); // โหลดข้อมูลใหม่หลังจากอนุมัติ
        })
        .catch((error) => {
          console.error(error);
        });
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
