<template>
   <div class="container">
  <section class="section main">
    <div class="container">
      <div class="columns">
        <div class="column is-12">
          <div class="card is-fullwidth">
            <header class="card-header">
              <img :src="imagePath(company.cover_image)"  class="card-header-img" />
            </header>
            <div class="card-content">
              <a class="card-profile">
                <img :src="imagePath(company.profile_image)"  class="card-profile-img" />
               
              </a>
              <div class="card-user">
                <div class="card-user-name">
                  <p class="is-size-4 has-text-weight-bold">{{ company.company_name }}</p>
                </div>
                <i class="fa-regular fa-envelope"></i>
                <span> {{ company.contact_email }}</span>
                <p>
                      <span>ประเภทธุรกิจ : </span>
                      <span v-for="(type, index) in parseBusinessType(company.business_type)" :key="index" >{{ type.title }}</span>
                  </p>
              </div>
              <br>
                  <br>
              <div class="card-stats">
                  <span>{{ company.description }}</span>        
              </div>
              <div class="card-video_iframe">
                <div class="video_iframe" v-html="company.company_video"></div>

            </div>
            </div>
          </div>

        </div>

    
      </div>

      <div class="columns">
        <div class="column is-3">
          <div class="box rating">       
            <p class="rating-title"><span class=" is-3">คะแนนบริษัท</span></p>
            <article class="media">
              <p class="">
            <i class="fa fa-star title is-5" style="color:#ed6c63"></i>
            <i class="fa fa-star title is-5" style="color:#ed6c63"></i>
            <i class="fa fa-star title is-5" style="color:#ed6c63"></i>
            <i class="fa fa-star title is-5"></i>
            <i class="fa fa-star title is-5"></i>
            &nbsp; &nbsp;
            <strong>1 Reviews</strong>
            &nbsp; &nbsp;
            <a href="#">show all</a>
          </p>
          </article>
            <article class="media">
            <figure class="media-left">
              <p class="image is-64x64">
                <img src="http://placehold.it/128x128">
              </p>
            </figure>
            <div class="media-content">
              <div class="content">
                <p>
                  <strong>Barbara Middleton</strong> <small> · 3 hrs</small>
                  <br>
                  Lorem ipsum dolor
                  <br>
                </p>
              </div>
            </div>
          </article>
          </div>
        </div>
        <div class="column is-6">
          <div class="box">
            <article class="media">
              <div class="media-left">
              </div>
                <div class="media-content ">
                  <div class="content">
                    <div class="jobs">
                    <p class="is-size-6 has-text-weight-bold">ตำแหน่งที่รับสมัคร</p>
                    </div>
                    <div  v-for="(job, index) in jobs" :key="index" >
                    <div class="job_content" v-if="job.create_type === 'form'" @click="viewJob(job.job_id)">
                      <span class="">{{ formatDate(job.date_posted) }} </span>
                      <br>
                      <span class="is-size-6 has-text-weight-bold" >{{ job.job_title }}</span>
                      <br>
                      <i class="fa-solid fa-location-dot"></i>
                      <span v-for="(type, index) in parseLocation(company.location)" :key="index" > {{ type.tambon }} {{ type.amphure }} {{ type.province }} {{ type.zip_code }}</span>
                      <br>
                      <i class="fa-solid fa-money-bill-1-wave"></i>
                      <span> {{ job.salary }} บาท/วัน</span>
                      <br>
                      <i class="fa-solid fa-user"></i>
                      <span> {{ job.quantity }} อัตรา</span>
                      <br>
                      <i class="fa-regular fa-clock"></i>
                      <span> {{ job.internship_duration }} เดือน</span>
                      <br>
                      <i class="fa-solid fa-graduation-cap"></i>
                      <span> {{ job.job_type }}</span>
                      <br>
                      <br>
                      <p class="button is-small is-primary" href="#">สมัครงาน</p>
                    </div>

                    <div class="job_content" v-if="job.create_type === 'upload'" @click="viewJob(job.job_id)">
                      
                      <span class="">{{ formatDate(job.date_posted) }} </span>
                      <br>
                      <span class="is-size-6 has-text-weight-bold" >{{ job.job_title }}</span>
                      <br>
                      <img :src="imagePath(job.job_upload_file)"  class="card-profile-img" />
                      <br>
                      <i class="fa-solid fa-location-dot"></i>
                      <span v-for="(type, index) in parseLocation(company.location)" :key="index" > {{ type.tambon }} {{ type.amphure }} {{ type.province }} {{ type.zip_code }}</span>
                      <br>
                      <br>
                      <p class="button is-small is-primary" href="#">สมัครงาน</p>

                    </div>

                      </div>
                  </div>
              </div>
            </article>   
          </div>
        </div>
        <div class="column is-3">
          <div class="box">
            <p><span class="title is-5">บริษัทที่คุณอาจสนใจ</span></p>
            <hr>
            <div class="columns">
              <div class="column is-3 is-marginless">    
              </div>  
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
  </div>
</template>
<script>
import axios from "axios";
export default {
  data() {
    return {
      company: [],
      jobs: [],
    };
  },
  mounted() {
    const companyId = this.$route.params.companyId;
    this.getCompanyDetails(companyId);
    this.getCompanyJobs(companyId);
  },
  methods: {
    
    getCompanyDetails(companyId) {
      axios
        .get(`http://localhost:3000/recruiter/getRecruiterDetails/${companyId}`)
        .then((response) => {
          this.company = response.data;
          this.company.profile_image = response.data.profile_image.replace(/\\/g, '/').replace('static', '');
          this.company.cover_image = response.data.cover_image.replace(/\\/g, '/').replace('static', '');
        })
        .catch((error) => {
          console.error(error);
        });
    },
    // ใน method getCompanyJobs
getCompanyJobs(companyId) {
  axios
    .get(`http://localhost:3000/recruiter/getCompanyJobs/${companyId}`)
    .then((response) => {
      this.jobs = response.data;

      // ทำการแปลง path และลบ 'static\' ทุกครั้งที่ได้ข้อมูล
      this.jobs.forEach(job => {
        if (job.job_upload_file) {
          job.job_upload_file = job.job_upload_file.replace(/\\/g, '/').replace('static/', '//');
        }
      });
    })
    .catch((error) => {
      console.error(error);
    });
},

    imagePath(companyProfileImage) {
      if (companyProfileImage) {
        return "http://localhost:3000" + companyProfileImage;
      } else {
        return "https://bulma.io/images/placeholders/640x360.png";
      }
    },
    viewJob(jobId){
        this.$router.push("/job/"+jobId);
    },
    parseLocation(location) {
    try {
      return JSON.parse(location);
    } catch (error) {
      console.error('Error parsing business type:', error);
      return [];
    }
  },
  parseBusinessType(businessType) {
    try {
      return JSON.parse(businessType);
    } catch (error) {
      console.error('Error parsing business type:', error);
      return [];
    }
  },
  formatDate(dateString) {
        const date = new Date(dateString);
        const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
        return date.toLocaleDateString('th-TH', options);
    },
  },
};
</script>
<style scoped>

.section.main {
  background-color: #f5f8fa;
}.card-header {
  position: relative;
}
.card-header-img {

  width: 100%;
  height: 400px;
  object-fit: cover;
}
.card-content {
    padding: 0px;
    background-color: #ffffff;
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
  height: 150px;
  width: 150px;
}
.card-user {
    margin: 5px 0 0;
}

.card-stats {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 1rem;

  margin: 1rem;
  background-color: #ffffff;
  border-bottom: 1px solid #dadada;
  
}
.card-video_iframe {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 1rem;
  margin-top: 1rem;

}
.spacer {
  height:20px;
}

.rating .rating-title {
  padding-bottom: 10px;
}
.job_content {
  background-color: rgb(255, 255, 255);
  padding: 1rem;
  margin-top: 1rem;
  border: 1px solid #c8c8c8;
  border-radius: 7px;
  
  cursor: pointer;
  transition: transform 0.2s;
}

.job_content:hover {
  transform: scale(1.05);
}
.video_iframe {

}
</style>