<template>
  <div class="main-content">
    <div class="container">
      <img
        id="suggest"
        class="is-rounded"
        src="https://picsum.photos/id/366/600/375"
        alt=""
      />
      <div class="field has-addons">
        <p class="control">
          <input
            class="input"
            type="text"
            placeholder="ชื่อตำแหน่งงาน หรือชื่อบริษัท"
          />
        </p>
        <p class="control">
          <span class="select">
            <select>
              <option>ประเภทงานทั้งหมด</option>
              <option>UX/UI</option>
              <option>design</option>
            </select>
          </span>
        </p>
        <p class="control">
          <a class="button is-info">ค้นหา</a>
        </p>
      </div>

      <div class="columns is-multiline" >
        <div class="column is-3" v-for="company in paginatedCompanies" :key="company.job_id">
          <div class="card" @click="goToCompanyDetails(company.user_id)" v-if="company.status === 'open'">
            <div class="card-image">
              <figure class="image is-4by3">
                <img :src="imagePath(company.profile_image)" alt="Company Logo">
              </figure>
            </div>
            <div class="card-content">
              <div class="media">
                <div class="media-left">
                  <figure class="image is-48x48">
                    <img :src="imagePath(company.profile_image)" alt="Company Logo">
                  </figure>
                </div>
                <div class="media-content">
                  <p>
                    <strong>{{ company.company_name }}</strong> 
                  </p>
                </div>
              </div>
              <span class="tag is-normal">Normal</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Pagination Controls -->
      <nav class="pagination" role="navigation" aria-label="pagination">
        <a class="pagination-previous" @click="currentPage = Math.max(1, currentPage - 1)" :disabled="currentPage === 1">Previous</a>
        <a class="pagination-next" @click="currentPage = Math.min(totalPages, currentPage + 1)" :disabled="currentPage === totalPages || companies.length === 0">Next page</a>
        <ul class="pagination-list">
          <li v-for="page in totalPages" :key="page">
            <a class="pagination-link" @click="currentPage = page" :class="{ 'is-current': currentPage === page }">
              {{ page }}
            </a>
          </li>
        </ul>
      </nav>
    </div>

    <footer class="footer">
      <div class="content has-text-centered">
        <p>&copy;</p>
      </div>
    </footer>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      companies: [],
      perPage: 4,
      currentPage: 1,
    };
  },
  computed: {
    paginatedCompanies() {
      const start = (this.currentPage - 1) * this.perPage;
      const end = start + this.perPage;
      return this.companies.slice(start, end);
    },
    totalPages() {
      return Math.ceil(this.companies.length / this.perPage);
    },
  },
  created() {
    this.getCompanies();
  },
  methods: {
    getCompanies() {
      axios
        .get("http://localhost:3000/recruiter/getRecruiter")
        .then((response) => {
          this.companies = response.data;
        })
        .catch((error) => {
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
    goToCompanyDetails(companyId) {
      this.$router.push("/company/" + companyId);
    },
  },
};
</script>

<style scoped>
.main-content {
  background-color: #F5F8FA;
  padding: 2rem;
}

#suggest {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 400px;
  margin-bottom: 20px;
}

/* เพิ่มสไตล์ที่ต้องการสำหรับ pagination */
.pagination {
  margin-top: 20px;
  justify-content: center;
}

.pagination-previous,
.pagination-next {
  margin: 0 5px;
}

.pagination-link.is-current {
  background-color: #00d1b2;
  color: #fff;
}

.card {
  cursor: pointer;
  transition: transform 0.2s;
}

.card:hover {
  transform: scale(1.05);
}

.pagination-next[disabled] {
  opacity: 0.5; /* Or a different style to convey disabled state */
}
</style>
