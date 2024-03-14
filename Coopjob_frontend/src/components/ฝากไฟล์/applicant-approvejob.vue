<template>
    <div class="columns">
       <applicantSideMenu></applicantSideMenu>
       <div class="columns">
        <div v-for="application in applications" :key="application.application_id">
            <div class="px-5 py-3 column" v-if="application.application_status === 'approve'">
                <div class="column is-12">         
                    <h3 class="title is-4">วันที่ : {{ formatDate(application.applied_datetime) }}</h3>
                    <div class="box">
                        <div class="media">
                            <div class="media-left">
                            <div class="">
                                <figure class="image">
                                    <router-link :to="'/company/' + application.user_id">
                                        <img :src="imagePath(application.profile_image)" alt="Company Logo" class="CompanyLogo">
                                    </router-link>
                                </figure>
                            </div>
                            </div>
                            <div class="media-content">
                                <p class="is-size-5 has-text-weight-bold"> ชื่อบริษัท: <router-link :to="'/company/' + application.user_id">{{ application.company_name }}</router-link> </p>
                                <p class="is-size-5 has-text-weight-bold"> ชื่องาน: <router-link :to="'/job/' + application.job_id" >{{ application.job_title }}</router-link></p>
                            </div>
                        </div>
                        <div class="card mt-3 p-3 option">
                            <div class="buttons">
                                <button class="button is-danger" @click="showReportModal(application.job_id)">รายงาน</button>
                                <button class="button is-primary"
                                    @click="showBenefitModal(application.job_id)">
                                    กรอกค่าแรงและสวัสดิการ
                                </button>
                                <button class="button is-light" @click="gotofilecoop(application.job_id)">ดูใบตอบรับ</button>
                                <button class="button is-info" @click="openReviewModal(application.job_id)"><i class="fa-regular fa-star"></i>ให้คะแนน</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="">             
                </div> 
                        <!-- Review Modal -->
        <div class="modal" :class="{'is-active': showReviewModal}">
      <div class="modal-background" @click="showReviewModal = false"></div>
      <div class="modal-card">
        <header class="modal-card-head">
            <p class="modal-card-title">ให้คะแนน {{ application.company_name }}</p>
            <button class="delete" aria-label="close" @click="openReviewModal = false"></button>
        </header>
        
      <section class="modal-card-body">
        <p>ชื่องาน {{ application.job_title }}</p>
        <div class="stars">
          <i v-for="star in 5"
             :key="star"
             @click="rate(star)"
             class="fa-duotone fa-star"
             :class="{'is-rated': star <= reviewRating}"></i>
        </div>
        <p class="rating-text">{{ ratingText }}</p>
          <div class="field">
        
            <div class="control my-3">
              <textarea class="textarea" v-model="reviewComment" placeholder="เขียนคอมเม้นท์ที่นี่..."></textarea>
            </div>
          </div>
        </section>
        <footer class="modal-card-foot">
          <button class="button is-success" @click="submitReview()">บันทึก</button>
          <button class="button" @click="showReviewModal = false">ยกเลิก</button>
        </footer>
      </div>
        </div>
        </div>
            <!-- Report Modal -->
            
            <div class="modal" :class="{ 'is-active': isReportModalActive }">
                <div class="modal-background" @click="closeReportModal">
                </div>
                <div class="modal-card">
                    <header class="modal-card-head">
                    <p class="modal-card-title"></p>
                    <button class="delete" aria-label="close"  @click="closeReportModal"></button>
                    </header>
                    <section class="modal-card-body">        
                        <div class="field">
                            <label class="label">Report Type:</label>
                            <div class="control">
                            <label class="radio"><input type="radio" value="job" v-model="reportOptions">Job</label>
                            <label class="radio"><input type="radio" value="company" v-model="reportOptions">Company</label>
                            <label class="radio"><input type="radio" value="mentor" v-model="reportOptions">Mentor</label>
                            <label class="radio"><input type="radio" value="work" v-model="reportOptions">Work</label>
                            <label class="radio"><input type="radio" value="other" v-model="reportOptions">Other</label>
                            </div>
                        </div>
                        <div class="field">
                            <label class="label">Description:</label>
                            <div class="control">
                                <textarea class="textarea" placeholder="Description" v-model="reportDescription"></textarea>
                            </div>
                        </div>
                    </section>
                    <footer class="modal-card-foot">
                        <button class="button is-success" @click="submitReport()" >Submit Report</button>
                        <button class="button" @click="closeReportModal">Cancel</button>
                    </footer>
                </div>
            </div>
        </div>
        
        <!--Benefit Modal -->
        <div class="modal" :class="{'is-active': showBenefitForm}">
        <div class="modal-background" @click="showBenefitForm = false"></div>
        <div class="modal-card  card">
          <header class="modal-card-head">
            <p class="modal-card-title">แบบฟอร์มค่าแรงและสวัสดิการ</p>
            <button class="delete" aria-label="close" @click="showBenefitForm = false"></button>
          </header>
          <section class="modal-card-body">
            <!-- Form Fields -->
            <div class="field">
            <label class="label">ชื่อบริษัท</label>
            <div class="control">
                <input class="input" type="text" v-model="$v.company_name.$model" />
            </div>
            <p v-if="$v.company_name.$error" class="help is-danger">โปรดกรอกชื่อบริษัท</p>
            </div>

            <div class="field">
            <label class="label">ตำแหน่ง</label>
            <div class="control">
                <input class="input" type="text" v-model="$v.job_position.$model" />
            </div>
            <p v-if="$v.job_position.$error" class="help is-danger">โปรดกรอกตำแหน่ง</p>
            </div>

            <div class="field">
            <label class="label">คำอธิบาย</label>
            <div class="control">
                <textarea class="textarea" v-model="$v.description.$model"></textarea>
            </div>
            <p v-if="$v.description.$error" class="help is-danger">โปรดกรอกคำอธิบาย</p>
            </div>

            <div class="field">
            <label class="label">ค่าตอบแทน</label>
            <div class="control">
                <div class="field has-addons">
                <div class="control">
                    <input class="input" type="text" v-model="$v.salary.$model" />
                </div>
                <div class="control">
                    <a class="button is-static">บาท/วัน</a>
                </div>
                </div>
            </div>
            <p v-if="$v.salary.$error" class="help is-danger">โปรดกรอกค่าตอบแทน</p>
            </div>

            <div class="field">
            <label class="label">สวัสดิการ</label>
            <div class="control">
                <input class="input" type="text" v-model="$v.benefit.$model" />
            </div>
            <p v-if="$v.benefit.$error" class="help is-danger">โปรดกรอกข้อมูลสวัสดิการ</p>
            </div>
          </section>
          <footer class="modal-card-foot">
            <button class="button is-primary" @click="submitBenefit">บันทึก</button>
            <button class="button" @click="showBenefitForm = false">ยกเลิก</button>
          </footer>
        </div>
        </div>


    </div>

    </div>
</template>
<script>
import { required} from 'vuelidate/lib/validators';
import axios from "axios";
import Swal from "sweetalert2";
import applicantSideMenu from "./applicant-side-menu.vue";
export default {
    components:{
        applicantSideMenu,

    },
    data() {
        return {
            applications: [],
            user: [],
            job_title:'',
            
            selectedJobId: '', // เพิ่ม property ใหม่
            selectedRating: null, // เพิ่ม property เก็บคะแนนดาวที่เลือก

            isReportModalActive: false,
            reportType: 'job',
            reportDescription: '',
            reportOptions:'',

            isBenefitReportActive: true,

            showBenefitForm: false,
            company_name: '',
            job_position: '',
            description: '',
            salary: '',
            benefit: '',

            showReviewModal: false,
            selectedJob: {},
            reviewRating: 0,
            reviewComment: ''
        };
    },
    mounted() {
        this.getJobApplications();
        this.getUser();
       
    },
    updated() {
        console.log(this.applications); // ล็อกแอปพลิเคชันเพื่อตรวจสอบโครงสร้าง
    },
    computed: {
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
        gotobenefit(companyName, job_id) {
            this.$router.push({
                path: "/benefitReport",
                query: {
                    companyName,
                    job_id,
                },
            });
        },
        gotofilecoop(job_id) {
            this.$router.push({
                path: "/coopFile",
                query: {
                    job_id,
                },
            });
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
                    this.job_title = response.data.job_title
                })
                .catch((error) => {
                    console.error(error);
                });
        },
        getUser() {
            const token = localStorage.getItem("token");
            const config = {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            };
            axios.get("http://localhost:3000/user/me", config)
                .then((res) => {
                    this.user = res.data;
                    console.log("App.vue", this.user);

                    // ตรวจสอบว่า user_id ถูกกำหนดค่าหรือไม่
                    if (!this.user || !this.user.user_id) {
                        console.error('User or user_id is undefined.');
                    }
                })
                .catch((error) => {
                    console.error(error);
                });
        },
        showReportModal(jobId) {
            this.selectedJobId = jobId
            this.isReportModalActive = true;
        },
        closeReportModal() {
            this.isReportModalActive = false;
        },
        showBenefitModal(jobId) {
            this.selectedJobId = jobId
            this.showBenefitForm = true;
        },
        closeBenefitModal() {
            this.showBenefitForm = false;
        },
        submitBenefit() {
            const token = localStorage.getItem("token");
            const config = {
                headers: {
                Authorization: `Bearer ${token}`,
                },
            };
            this.$v.$touch();
            if (!this.$v.$error) {
                const data = {
                company_name: this.company_name,
                job_position: this.job_position,
                description: this.description,
                salary: this.salary,
                benefit: this.benefit,
                job_id: this.job_id, // รวม job_id ในข้อมูล
                };


                axios
                .post("http://localhost:3000/application/addBenefitReport", data, config)
                .then((res) => {
                    const message = res.data.message;
                    Swal.fire({
                    position: "center",
                    icon: "success",
                    title: "กรอกข้อมูลค่าแรงเรียบร้อย",
                    showConfirmButton: message,
                    });

                    this.$router.push('/MyJobspage');

                })
                .catch((error) => {
                    if (error.response) {
                    console.log("response.data", error.response.data);
                    }
                });
            }
            },
        formatDate(dateString) {
        const date = new Date(dateString);
        const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
        return date.toLocaleDateString('th-TH', options);
        },
        rate(star) {
        this.reviewRating = star;
        },
        openReviewModal(jobId) {
            this.selectedJobId = jobId
            this.showReviewModal = true;
        },
        closeReviewModal() {
            this.showReviewModal = false;
        },
        submitReview() {

        console.log({
            job_id: this.selectedJobId,
            rating: this.reviewRating,
            comment: this.reviewComment
        });
        this.showReviewModal = false;
        }
    },
    validations: {
    //benefit
    company_name: {
      required,
    },
    job_position: {
      required,
    },
    description: {
      required,
    },
    salary: {
      required,
    },
    benefit: {
      required,
    },

    //review
    reviewComment:{
        required
    },
    reviewRating:{
        required
    }
  },
};
</script>
<style scoped>
/* สีเหลืองสำหรับดาวที่ถูกเลือก */
.yellow {
    color: yellow;
}


.content figure{
    margin-left: 0;
}

.option{
    background-color: #dbdbdb;
}
.CompanyLogo{
width: 50px;
border: 1px solid rgb(240, 240, 240);
border-radius: 5px;
transition: width 0.3s ease-in-out;
}

.fa-star:hover {
  transform: scale(1.5);
}
.is-rated {
  color: gold;
}

.rating-text{
    color: rgba(255, 217, 0, 0.908);
}
</style>

  


