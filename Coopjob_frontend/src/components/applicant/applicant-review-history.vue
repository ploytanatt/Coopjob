<template>
  <div>
    <div class="columns">
      <applicantSideMenu></applicantSideMenu>
      
      <div class="column is-10 mt-4">
        <section class="hero is-dark welcome is-small">
        <div class="hero-body">
          
            <p class="is-size-2">รีวิวของฉัน</p>
            <p class="is-size-3">
           
            </p>       
        </div>
      </section>
        <div v-for="data in mergedData" :key="data.application_id">
          <div class="job-card card mt-4">
            <div class="job-card-header">
              <span class="job-date">คะแนนของฉัน</span>
              <span class="job-date">{{ formatDate(data.reviewDate) }}</span>
            </div>
            <hr>
            <div class="stars">
              <i v-for="star in 5" :key="star" class="fa fa-star"
                :class="{ 'is-rated': data.reviewRating >= star }"></i>
            </div>
            <p>{{ data.reviewComment }}</p>
            <div class="job-card-body mt-3" v-show="reviewComment">
              <router-link :to="'/company/' + data.user_id">
                <div class="card mt-3 mb-3 ml-0 p-0 columns company_card">
                  <div class="column is-4 m-0">
                    <img :src="imagePath(data.profile_image)" alt="Company Logo" class="CompanyLogo">
                  </div>
                  <div class="column m-0">
                    <p class="job-role">{{ data.company_name }}</p>
                    <p class="job-details">{{ data.job_title }}</p>
                  </div>
                </div>
                
              </router-link>
              <button class="button is-info is-outlined is-small" @click="openReviewModal(data.job_id)"><i class="fa-solid fa-pen-to-square mr-1"></i>แก้ไข</button>
            </div>
            
            
          </div>

          <!-- Review Modal -->
          <div class="modal" :class="{'is-active': showReviewModal}">
            <div class="modal-background" @click="closeReviewModal"></div>
            <div class="modal-card">
              <header class="modal-card-head">
                <p class="modal-card-title">ให้คะแนน {{ selectedJob.company_name }}</p>
                <button class="delete" aria-label="close" @click="closeReviewModal"></button>
              </header>

              <section class="modal-card-body">
                <p>ชื่องาน {{ selectedJob.job_title }}</p>
                <div class="stars">
                  <i v-for="star in 5"
                    :key="star"
                    @click="setRating(star)"
                    class="fa fa-star"
                    :class="{ 'is-rated': star <= reviewRating }"></i>
                </div>

                <p class="rating-text">{{ ratingText }}</p>
                <div class="field">
                  <div class="control my-3">
                    <textarea class="textarea" v-model="$v.reviewComment.$model" placeholder="เขียนคอมเม้นท์ที่นี่..."></textarea>
                    <p class="help is-danger" v-if="$v.reviewComment.$error">กรุณาเขียนคอมเม้น</p>
                  </div>
                </div>
              </section>
              <footer class="modal-card-foot">
                <button class="button is-success" @click="submitReview">บันทึก</button>
                <button class="button" @click="closeReviewModal">ยกเลิก</button>
              </footer>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import Swal from "sweetalert2";
import applicantSideMenu from "./applicant-side-menu.vue";
import { required} from 'vuelidate/lib/validators';
export default {
  components:{
    applicantSideMenu
  },
  data() {
    return {
      applications: [],
      review_history:[],

      //edir review
      selectedJobId: '', 
      showReviewModal: false,
      selectedJob: {},
      reviewRating: '',
      reviewId:'',
      reviewComment: '',
    };
  },
  mounted() {
    this.getJobApplications();
    this.getReviewHistory()
  },
  computed: {
  mergedData() {
    return this.applications
      .filter(app => app.application_status === 'approve')
      .map(app => {
        const review = this.review_history.find(r => r.job_id === app.job_id);
        return {
          ...app,
          reviewComment: review ? review.comment : 'No review',
          reviewRating: review ? review.rating : 'No rating',
          reviewStatus: review ? review.review_status : 'No status',
          reviewDate: review ? review.review_created_at : 'No date'
        };
      });
  },
  ratingText() {
      switch(this.reviewRating) {
        case 1: return 'แย่';
        case 2: return 'พอใช้';
        case 3: return 'ปานกลาง';
        case 4: return 'ดี';
        case 5: return 'ยอดเยี่ยม';
        default: return ''; // หรือข้อความเริ่มต้นถ้าคุณต้องการ
      }
    }
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
    getReviewHistory(){
            const token = localStorage.getItem("token");
            const config = {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            };

            axios.get("http://localhost:3000/application/reviewHistory", config)
                .then((res) => {
                    this.review_history = res.data;
                    this.reviewComment = res.data[0].comment;
                    this.reviewRating = res.data[0].rating;
                    this.reviewId = res.data[0].review_id;
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
    openReviewModal(jobId) {
            this.selectedJobId = jobId;
            this.showReviewModal = true;
        },
        closeReviewModal() {
            this.showReviewModal = false;
        },
        setRating(rating) {
            this.reviewRating = rating;
        },
        submitReview() {
          const token = localStorage.getItem("token");
            const config = {
                headers: {
                Authorization: `Bearer ${token}`,
                },
            };
          this.$v.$touch();
            const data = {
                job_id: this.selectedJobId,
                rating: this.reviewRating,
                comment: this.reviewComment,
                review_id: this.reviewId
  
            };
            axios
            .put("http://localhost:3000/application/editReview", data, config)
            .then((res) =>{
                const message = res.data.message;
                Swal.fire({
                    position: "center",
                    icon: "success",
                    title: "แก้ไขข้อมูลเรียบร้อย",
                    showConfirmButton: message,
                });
                
                this.closeReviewModal();
                this.getJobApplications();
                this.getReviewHistory();
                
            })    
            .catch((error) =>{
                if (error.response){
                    console.error("Error submitting review: ", error);
                    Swal.fire("โปรดกรอกข้อมูลให้ถูกต้อง", "", "error");
                }
                });
            },
  },

  validations: {
    //review
    reviewComment:{
        required
    },
    reviewRating:{
        required
    }
}
};

</script>

<style scoped>
.job-card {
  background-color: #F8F8FD;
  border-radius: 6px;
  padding: 16px;
  box-shadow: 0 2px 4px #0000002d;
  
  margin-right: 16px;
  margin-bottom: 16px; 
  width: 380px; 
}

.job-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px; 
}

.job-title {
  font-weight: bold;
  color: #333;
}

.job-date {
  color: #666; 
  font-size: 0.875rem;
}

.job-card-body p {
  margin: 0;
  color: #333; 
}

.job-role {
  font-size: 1.125rem;
  font-weight: bold;
  margin-bottom: 4px;
}

.job-details {
  font-size: 0.875rem;
  color: #666; 
}

hr {
  border: none;
  height: 1px;
  background-color: #ddd; 
  margin-bottom: 8px; 
}

.CompanyLogo{
width: 100px;
border: 1px solid rgb(240, 240, 240);
border-radius: 5px;
transition: width 0.3s ease-in-out;
}

.stars .fa {
  color: #ccc; /* Default star color */
}

.stars .fa.is-rated {
  color: gold; /* Active star color (when rated) */
}
.fa-star:hover {
  transform: scale(1.5);
}

.rating-text{
    color: rgba(255, 217, 0, 0.908);
}
</style>