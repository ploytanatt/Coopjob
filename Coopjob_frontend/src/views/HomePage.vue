<template>
  <div class="main-content">
   
      <div class="container">
       
        <div class="columns is-multiline">
          
          <img id="suggest"
              class="is-rounded"
              src="https://picsum.photos/id/366/600/375"
              alt=""
            />
          <div class="companys_content">
          
            <div class="field has-addons">
            <p class="control">
              <input class="input" type="text" placeholder="ชื่อตำแหน่งงาน หรือชื่อบริษัท">
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
          
<div class="columns" >
  <div class="column" v-for="company in companies"
                :key="company.job_id">
    <div class="card"  @click="goToCompanyDetails(company.user_id)">
      <div class="card-image">
      </div>
      <div class="card-content">
        <div class="media">
          <div class="media-left">
            <figure class="image is-64x64">
              <img :src="imagePath(company.profile_image)" alt="Placeholder image">
            </figure>
          </div>
          <div class="media-content">
            <p>
          <strong>{{ company.company_name }}</strong> <small>@johnsmith</small> <small>31m</small>
        </p>
        </div>
        </div>
         <span class="tag is-normal">Normal</span>
      </div>
    </div>
  </div>
</div>
          </div>
        </div>
      </div>
 
    <footer class="footer">
      <div class="content has-text-centered">
        <p>
          &copy;
        </p>
      </div>
    </footer>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      companies: []
    };
  },
  mounted() {
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
    this.$router.push("/company/"+companyId);
  },
  }
};
</script>

<style scoped>
.maincontent{
  background-color: #F5F8FA;
}
.container {
  max-width: 1000px;
  margin: auto;
  padding: 2rem;
  background-color: #F5F8FA;
}

.companycard {
  margin: 1rem;
}

#suggest {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 1000px; /* ปรับขนาดกว้างตามที่คุณต้องการ */
  height: 300px; /* ให้ความสูงปรับตามเนื้อหาภายใน */
  margin-bottom: 20px; /* เพิ่มระยะห่างด้านล่างของ #suggest */
 
}

.card-container {
  width: 60%;
  margin: auto;
}

</style>