<template>
            <div class=" ">
        <div class="columns is-3" v-for="company in companies" :key="company.job_id">

          <div class="card is-fullwidth"  @click="goToCompanyDetails(company.user_id)">
            <div class="job_card">
            <header class="card-header">
              <img :src="imagePath(company.cover_image)"  class="card-header-img" />
            </header>
            <div class="card-content">
              <a class="card-profile">
                <img :src="imagePath(company.profile_image)"  class="card-profile-img" />
              </a>
              <div class="card-user">
                <div class="card-user-name">
                  <a>{{ company.company_name }}</a>
                </div>
                <span>{{ company.contact_email }}</span>
              </div>
              <div class="card-stats">
                <i class="fa-sharp fa-solid fa-location-dot"></i>
                <span v-for="(type, index) in parseLocation(company.location)" :key="index" > {{ type.tambon }} {{ type.amphure }} {{ type.province }} {{ type.zip_code }}</span>
                <br>
                <i class="fa-regular fa-briefcase"></i>
                <span v-for="(type, index) in parseBusinessType(company.business_type)" :key="index" class="tag is-normal"> {{ type.title }}</span>

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
        companies: [],
        currentID:''
      };
    },
  
    mounted() {
      this.getCompanies();
      this.getJobs();
     const current = this.$route.params.companyId;
     this.getCompanyDetails(current);
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
      parseBusinessType(businessType) {
      try {
        return JSON.parse(businessType);
      } catch (error) {
        console.error('Error parsing business type:', error);
        return [];
      }
    },
    parseLocation(location) {
      try {
        return JSON.parse(location);
      } catch (error) {
        console.error('Error parsing business type:', error);
        return [];
      }
    },
    },
  };
  </script>
  
  <style scoped>
  
  .job_card{
  background-color: #ffffff;
  margin: 1rem;
}

.card-header {
  position: relative;
 
}
.card-header-img {
    
  width: 100%;
  height: 100px;
 

}
.card-content {
    padding: 0px;
}
.card-profile {
  background-color: #fff;
  border-radius: 6px;
  display: inline-block !important;
  float: left;
  margin: -30px 5px 0 8px;
  max-width: 100%;
  padding: 1px;
  vertical-align: bottom;
  position: relative;
}
.card-profile-img {
  border: 2px solid #fff;
  border-radius: 7px;
  box-sizing: border-box;
  color: #fff;
  height: 72px;
  width: 72px;
}

.card-user {
    margin: 5px 0 0;
}

.card-stats {
    margin-left: 11px;
    padding: 10px 0;
}

.card {
  cursor: pointer;
  transition: transform 0.2s;
  margin-bottom: 1rem;
}

.card:hover {
  transform: scale(1.05);
}

  
</style>
  