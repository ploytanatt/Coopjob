<template>
    <div class="columns">
    <applicantSideMenu></applicantSideMenu>
    <div class="column is-10 mt-4">
        <section class="hero is-dark welcome is-small">
          <div class="hero-body">
            
              <p class="is-size-2">งานที่สมัคร</p>
              <p class="is-size-3">
                จำนวนงานที่สมัครทั้งหมด : {{ }}
              </p>

            
          </div>
        </section>
        <div class="field is-horizontal  ">
          <div class="field-body filter_searchbox field is-grouped  is-grouped-right ">
              <div class="filter_search select is-small">
                <select v-model="selectedStatus">
                  <option value="">สถานะ</option>
                  <option value="pending">Pending</option>
                  <option value="approve">Approve</option>
                  <option value="Declined">Declined</option>
                  <option value="canceled">canceled</option>
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
        <table class="table is-striped is-fullwidth is-size-7">
          <thead>
            <tr>
              <th>#</th>
            <th class="">
              <button class="button is-small is-white" @click="sortApplications('job_title')">
                <span class="has-text-grey">ชื่อบริษัท </span>&nbsp;
                <i class="fa-solid fa-angles-up-down"></i>
              </button>
            </th>
            <th class="">
              <button class="button is-small is-white" @click="sortApplications('job_title')">
                <span class="has-text-grey">ชื่องาน </span>&nbsp;
                <i class="fa-solid fa-angles-up-down"></i>
              </button>
            </th>
            <th>
              <button class="button is-small is-white" @click="sortApplications('job_type')">
                <span class="has-text-grey">รูปแบบงาน </span>&nbsp;
                <i class="fa-solid fa-angles-up-down"></i>
              </button>
            </th>
            <th>
              <button class="button is-small is-white" @click="sortApplications('email')">
                <span class="has-text-grey">อีเมล </span>&nbsp;
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
              <button class="button is-small is-white" @click="sortApplications('applied_datetime')">
                <span class="px-5 has-text-grey">วันที่สมัคร </span>&nbsp;
                <i class="fa-solid fa-angles-up-down"></i>
              </button>
            </th>
            <th class="px-6 py-3 has-text-grey">Action</th>

          </tr>

          </thead>
          <tbody>
            <tr v-for="(application, index) in computedFilteredApplications" :key="application.application_id">

              <td>{{ index + 1 }}</td>
              <td>
                <router-link :to="'/company/' + application.user_id">
              <img :src="imagePath(application.profile_image)" alt="Company Logo"
                class="CompanyLogo">
                
                  <p>{{ application.company_name }}</p>
              </router-link>
            </td>
              <td class="pl-5 pt-5 pb-1"><router-link :to="'/job/' + application.job_id" >{{ application.job_title }}</router-link></td>
              <td class="pl-5 pt-5 pb-1">{{ application.job_type }}</td>
              <td class="pl-5 pt-5 pb-1">{{ application.email }}</td>

              <td class="pl-5 pt-5 pb-1">
                <span :class="{
                'tag': true, 
                'is-warning': application.application_status === 'pending', 
                'is-success': application.application_status === 'approve', 
                'is-danger': application.application_status === 'declined',
                'is-info': application.application_status === 'canceled', 
              }">
              {{ application.application_status }}
              </span>
              </td>
              <td class="pl-6 pt-5 pb-1">{{ formatDate(application.applied_datetime) }}</td>
              <td class="pl-6 pt-5 pb-1">
                <button class="button is-info">
                <router-link :to="'/job/' + application.job_id" class="has-text-white">ดูรายละเอียดงาน</router-link>
                </button>
                <button class="button mx-4 mb-4 is-danger"
                    @click="cancelApplication(application.application_id)">ยกเลิกการสมัคร</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
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
</template>
<script>
import axios from "axios";
import Swal from "sweetalert2";
import applicantSideMenu from '@/components/applicant/applicant-side-menu.vue';
export default {
  components:{
    applicantSideMenu
  },
  data() {
    return {
      applications: [],
      currentFilter: 'all',
      selectedStatus:'',
      itemsPerPage: 10,
      currentPage: 1,
      sortKey: 'job_title',
      sortOrder: 'desc',

      searchText:'',
    };
  },
  computed: {
    computedFilteredApplications() {
      let filtered = this.applications;

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
  },
  mounted() {
    this.getJobApplications();
  },
  methods: {
    imagePath(companyProfileImage) {
      if (companyProfileImage) {
        return "http://localhost:3000" + companyProfileImage.replace(/\\/g, '/').replace('static', '');
      } else {
        return "https://bulma.io/images/placeholders/640x360.png";
      }
    },
    getJobApplications() {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      axios
        .get("http://localhost:3000/application/getJobApplications", config)
        .then((response) => {
          this.applications = response.data;
        })
        .catch((error) => {
          console.error(error);
        });
    },
    cancelApplication(applicationId) {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      const application_status = 'canceled'
      axios
        .put(`http://localhost:3000/application/cancelJob/${applicationId}`, { application_status },

          config
        )
        .then((res) => {
          Swal.fire(res.data.message, "", "success");

          this.getJobApplications();
        })
        .catch((error) => {
          console.error(error);
        });
    },
    formatDate(date) {
      return new Date(date).toLocaleDateString()
    },
    setFilter(filter) {
        this.currentFilter = filter
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
  
  },
  filters: {
    capitalize(value) {
      if (!value) return ''
      value = value.toString()
      return value.charAt(0).toUpperCase() + value.slice(1)
    }
  },
};
</script>
<style scoped>
.CompanyLogo{
  width: 50px;
  border: 1px solid rgb(240, 240, 240);
  border-radius: 5px;
  transition: width 0.3s ease-in-out;
}
.CompanyLogo:hover{
  width: 80px;
}
</style>
