<template>
    <div class="columns">
      <recruiterSideMenu></recruiterSideMenu>
      <div class="column is-10 mt-4 " >
        <section class="hero is-dark welcome is-small">
          <div class="hero-body">
              <button class="button is-dark go-back-button" @click="goback">
                <i class="fa-solid fa-left-long"></i> 
              </button>
              <span class="is-size-4 p-3 has-text-weight-bold">{{ jobName }}</span>
              <p class="is-size-4">จำนวนผู้สมัครทั้งหมด : {{  applicationsByJob.length }}</p>      
          </div>
        </section>
      
    <div class="field is-horizontal  ">
        <div class="field-body filter_searchbox field is-grouped  is-grouped-right ">
            <div class="filter_search select is-small">
              <select v-model="selectedStatus">
                <option value="">สถานะ</option>
                <option value="approve">Approve</option>
                <option value="reject">Reject</option>
                <option value="pending">Pending</option>
              </select>
            </div>
            <div class="filter_search control has-icons-left">
              <input v-model="searchText" class="input is-small" type="text" placeholder="ค้นหาจากชื่องาน" />
              <span class="icon is-small is-left">
                <i class="fa fa-search"></i>
              </span>
            </div>
        </div>
      </div>

      <div class="box mb-3">
      <div class="table-container">
        <table class="table is-striped is-fullwidth is-size-7 ">
          <thead>
            <tr>
              <th>
              <button class="button is-small is-white" @click="sortApplications('job_title')">
                <span class="has-text-grey">ชื่องาน </span>&nbsp;
                <i class="fa-solid fa-angles-up-down"></i>
              </button>
            </th>
            <th class="">
              <button class="button is-small is-white" @click="sortApplications('studentID')">
                <span class="has-text-grey">รหัสนักศึกษา</span>&nbsp;
                <i class="fa-solid fa-angles-up-down"></i>
              </button>
            </th>

            <th>
              <button class="button is-small is-white" @click="sortApplications('firstName')">
                <span class="has-text-grey">ชื่อ-นามสกุล </span>&nbsp;
                <i class="fa-solid fa-angles-up-down"></i>
              </button>
            </th>

            <th>
              <button class="button is-small is-white" @click="sortApplications('application_status')">
                <span class="has-text-grey">สถานะ </span>&nbsp;
                <i class="fa-solid fa-angles-up-down"></i>
              </button>
            </th>
 
            <th>
              <button class="button is-small is-white" @click="sortApplications('application_datetime')">
                <span class="has-text-grey">วันที่สมัคร </span>&nbsp;
                <i class="fa-solid fa-angles-up-down"></i>
              </button>
            </th>
            <th class="px-6 py-3 has-text-grey">Action</th>

          </tr>
          </thead>
          <tbody>
            <tr v-for="application in computedFilteredApplications" :key="application.application_id">
              <td>{{ application.studentID }}</td>
              <td>{{ application.firstName }} {{ application.lastName }}</td>
              <td>{{ application.job_title }}</td>
              <td>
              <span :class="{
                'button': true, 

                'is-warning': application.application_status === 'pending', 
                'is-success': application.application_status === 'approve', 
                'is-danger': application.application_status === 'declined' || application.application_status === 'canceled'
              }">
                {{ application.application_status }}
              </span>
            </td>

              <td>{{ formatDate(application.applied_datetime) }}</td>
              <td>
                <button class="button is-info"  @click="viewApplicationDetail(application.application_id)">See Application</button>
              </td>
            </tr>
          </tbody>
        </table>

        
        </div>
        <div class="columns">
      <div class="column">
        <div class="is-flex is-align-items-center">
          <p class="is-size-7 has-text-grey-light">แสดง</p>
          <div class="select is-small mx-3">
            <select v-model="itemsPerPage" class="has-background-white" aria-label="Select example">
              <option :value="10">10</option>
              <option :value="50">50</option>
              <option :value="100">100</option>
            </select>
          </div>
          <p class="is-size-7 has-text-grey-light">จากทั้งหมด {{ applications.length }} คน</p>
        </div>

      </div>

      <div class="column is-flex is-justify-content-flex-end">
        <nav class="pagination" role="navigation" aria-label="pagination">
          <ul class="pagination-list" style="font-size: 12px;">
            <li>
              <a class="pagination-link has-background-white" @click="prevPage" :disabled="currentPage === 1">
                <i class="fa-solid fa-angle-left"></i>
              </a>
            </li>
            
            <!-- Dynamically generate page numbers -->
      <li v-for="page in totalPages" :key="page">
        <a class="pagination-link has-background-white" :class="{'is-current has-background-info': page === currentPage}" @click="goToPage(page)">
          {{ page }}
        </a>
      </li>

            <li>
              <a class="pagination-link has-background-white"  @click="nextPage" :disabled="currentPage === totalPages">
                <i class="fa-solid fa-angle-right"></i>
              </a>
            </li>
          </ul>
        </nav>
      </div>
    </div>
</div>
</div>
      
    </div>

</template>

<script>
import axios from "@/plugins/axios";
import recruiterSideMenu from '@/components/recruiter/recruiter-side-menu.vue';

export default {
  components: {
    recruiterSideMenu
  },
  data() {
    return {
      applications: [],
      applicationsByJob:[],
      jobName: '',

      selectedStatus: "",
      searchText:'',
      isLoading: false,
      itemsPerPage: 10,
      currentPage: 1,
      select_option: "myApplicant",
      sortKey: 'job_title',
      sortOrder: 'desc',
      showModal: false,

    };
  },
  mounted() {
    const jobId = this.$route.params.jobId;
    this.getApplicationByJob(jobId);

  },
  methods: {

getApplicationByJob(jobId) {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      axios
        .get(`http://localhost:3000/application/getApplicationByJob/${jobId}`, config)
        .then((response) => {
          this.applicationsByJob = response.data;
          this.jobName = response.data[0].job_title
        })
        .catch((error) => {
          console.error(error);
        });
    },
    formatDate(dateString) {
      const options = { year: 'numeric', month: 'long', day: 'numeric' };
      return new Date(dateString).toLocaleDateString('th-TH', options);
    },
    goback() {
      this.$router.push("/recruiterJob");
    },
    viewApplicationDetail(applicationId) {
      this.$router.push("/applicantDetail/" + applicationId);
    },
    goToPage(page) {
    this.currentPage = page;
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
    sortApplications(key) {
    if (this.sortKey === key) {
      this.sortOrder = this.sortOrder === 'asc' ? 'desc' : 'asc';
    } else {
      this.sortKey = key;
      this.sortOrder = 'asc';
    }
  },
  sortData() {
      this.applications.sort((a, b) => {
        let result = 0;
        if (a[this.sortKey] < b[this.sortKey]) {
          result = -1;
        } else if (a[this.sortKey] > b[this.sortKey]) {
          result = 1;
        }
        return this.sortOrder === 'asc' ? result : -result;
      });
    }
  },
  computed: {
    computedFilteredApplications() {
      let filtered = this.applicationsByJob;

      // Filter by status
      if (this.selectedStatus) {
        filtered = filtered.filter(
          application => application.application_status === this.selectedStatus
        );
      }

      // Filter by search text
      if (this.searchText) {
        filtered = filtered.filter(application =>
          application.job_title.toLowerCase().includes(this.searchText.toLowerCase())
        );
      }

      // Apply sorting
      return filtered.sort((a, b) => {
        let result = 0;
        if (a[this.sortKey] < b[this.sortKey]) {
          result = -1;
        } else if (a[this.sortKey] > b[this.sortKey]) {
          result = 1;
        }
        return this.sortOrder === 'asc' ? result : -result;
      });
    },
    // Other computed properties...
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
    totalApplicationsCount() {
    return this.applications.length;
  },
  }
};
</script>

<style scoped>

.filter_search{
  margin: 1rem;
  display: flex;
}
.filter_searchbox{
  background-color: #ececec;
  border-radius: 3px;
  margin-top: 1rem;
}

.pagination {
  margin-top: 10px;
}

.is-current{
  background-color: aqua;
}


</style>
