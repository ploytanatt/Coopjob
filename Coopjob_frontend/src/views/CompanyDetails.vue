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
                <iframe 
                  :src="'https://www.youtube.com/embed/' + getVideoId(company.company_video)"
                  width="560" 
                  height="315" 
                  frameborder="0" 
                  allowfullscreen
                  v-if="company.company_video"
                />

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
              {{ averageRating.toFixed(2) }} / 5
            &nbsp;
            <p>({{ companyReviews.length }} รีวิว)</p>
            &nbsp; &nbsp;
  
          </article>
          <article class="media" v-for="review in companyReviews" :key="review.id">
            <figure class="media-left">
          
            </figure>
            <div class="media-content">
              <div class="content">
                <div class="stars">
                  <i v-for="star in 5" :key="star" class="fa fa-star"
                    :class="{ 'is-rated': review.rating >= star }"></i>
                </div>
             
                  <p>ชื่องาน: {{ review.job_title }}</p> 

                  <p>{{ review.comment }}</p>
                  
                  
                  <p>{{ formatDate(review.review_created_at) }}</p>
                  
              
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
              <div class="column ">   
                <allCompany :company-id="currentID"></allCompany> 
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
import allCompany from "@/components/all-company.vue";
export default {
  components:{
    allCompany
  },

  data() {
    return {
      company: [],
      jobs: [],
      companyReviews:[],
      getcompanyId:''
    };
  },
  mounted() {
    const companyId = this.$route.params.companyId;
    this.getycompanyId = companyId;
    this.getCompanyDetails(companyId);
    this.getCompanyJobs(companyId);
    this.getCompanyReviews(companyId);
  },

  computed: {
    averageRating() {
      if (this.companyReviews.length === 0) {
        return 0;
      }
      const sum = this.companyReviews.reduce((acc, review) => acc + review.rating, 0);
      return sum / this.companyReviews.length;
    }
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

    getCompanyReviews(companyId) {
      axios
        .get(`http://localhost:3000/recruiter/getRecruiterReviews/${companyId}`)
        .then((response) => {
          this.companyReviews = response.data;
    
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
    getVideoId(url) {
      const regExp = /^.*(youtu.be\/|v\/|e\/|u\/\w+\/|embed\/|v=)([^#&?]*).*/;
      const match = url.match(regExp);
      if (match && match[2].length === 11) {
        return match[2];
      } else {
        // Handle invalid YouTube URL
        return 'invalid_video_id';
      }
    }
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
.stars .fa {
  color: #ccc; /* Default star color */
}

.stars .fa.is-rated {
  color: gold; /* Active star color (when rated) */
}
</style>