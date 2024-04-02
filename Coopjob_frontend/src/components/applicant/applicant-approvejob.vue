<template>
    <div class="columns">
       <applicantSideMenu></applicantSideMenu>
        <div class="column is-10 mt-4 ml-0">
      <section class="hero is-dark welcome is-small">
        <div class="hero-body">
            <p class="is-size-2">งานที่อนุมัติแล้ว</p>
            <p class="is-size-3">
           
            </p>       
        </div>
      </section>
        <div v-for="application in applications" :key="application.application_id">
            <div class="px-1 py-3 column is-6" v-if="application.application_status === 'approve'">
                <div class="column is-12">         
                   
                    <div class="box">
                        <span class="job-date ">วันที่สมัคร: {{ formatDate(application.applied_datetime) }}</span>
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
                                <button class="button is-danger" v-if="!hasReportHistory(application.job_id)" @click="showReportModal(application.job_id)">
                                <i class="fa-regular fa-circle-exclamation"> รายงาน</i>
                                </button>
                                
                                <button class="button is-primary" v-if="!benefit_history" @click="showBenefitModal(application.job_id)">กรอกค่าแรงและสวัสดิการ</button>
                                <button class="button is-primary" v-if="benefit_history"><router-link :to="'/benefitReport'" >ดูข้อมูลการกรอกค่าแรงและสวัสดิการ</router-link></button>
                                <button class="button" @click="gotofilecoop(application.job_id)">ดูใบตอบรับ</button>
                                <button class="button is-info" v-if="!review_history" @click="showReviewModal(application.job_id, application.user_id)"><i class="fa-regular fa-star"></i>ให้คะแนน</button>
                                <button class="button is-warning" v-if="review_history"> <router-link :to="'/review-history'" ><i class="fa-regular fa-star"></i> ดูรีวิว</router-link></button>
                            </div>
                        </div>
                    </div>
                </div>
        </div>
    </div>
     
        <!-- Report Modal -->
        <div class="modal" :class="{ 'is-active': showReportForm }">
            <div class="modal-background" @click="showReportForm = false;">
            </div>
            <div class="modal-card">
                <header class="modal-card-head">
                <p class="modal-card-title"></p>
                <button class="delete" aria-label="close"  @click="showReportForm = false;"></button>
                </header>
                <section class="modal-card-body">        
                    <div class="field">
                        <label class="label">Report Type:</label>
                        <div class="control">
                        <label class="radio"><input type="radio" value="job" v-model="$v.reportForm.reportOptions.$model">Job</label>
                        <label class="radio"><input type="radio" value="company" v-model="$v.reportForm.reportOptions.$model">Company</label>
                        <label class="radio"><input type="radio" value="mentor" v-model="$v.reportForm.reportOptions.$model">Mentor</label>
                        <label class="radio"><input type="radio" value="work" v-model="$v.reportForm.reportOptions.$model">Work</label>
                        <label class="radio"><input type="radio" value="other" v-model="$v.reportForm.reportOptions.$model">Other</label>
                        </div>
                        <p class="help is-danger" v-if="$v.reportForm.reportOptions.$error">กรุณากรอกข้อมูลให้ครบ</p>
                    </div>
                    <div class="field">
                        <label class="label">Description:</label>
                        <div class="control">
                            <textarea class="textarea" placeholder="Description" v-model="$v.reportForm.reportDescription.$model"></textarea>
                            <p class="help is-danger" v-if="$v.reportForm.reportDescription.$error">กรุณากรอกข้อมูลให้ครบ</p>
                        </div>
                    </div>
                </section>
                <footer class="modal-card-foot">
                    <button class="button is-success" @click="submitReport()" >Submit Report</button>
                    <button class="button" @click="showReportForm = false;">Cancel</button>
                </footer>
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
                            <input class="input" type="text" v-model="$v.benefitForm.company_name.$model" />
                        </div>
                        <p v-if="$v.benefitForm.company_name.$error" class="help is-danger">โปรดกรอกชื่อบริษัท</p>
                        </div>

                        <div class="field">
                        <label class="label">ตำแหน่ง</label>
                        <div class="control">
                            <input class="input" type="text" v-model="$v.benefitForm.job_position.$model" />
                        </div>
                        <p v-if="$v.benefitForm.job_position.$error" class="help is-danger">โปรดกรอกตำแหน่ง</p>
                        </div>

                        

                        <div class="field">
                        <label class="label">ค่าตอบแทนที่ได้รับจริง</label>
                        <div class="control">
                            <div class="field has-addons">
                            <div class="control">
                                <input class="input" type="text" v-model="$v.benefitForm.salary.$model" />
                            </div>
                            <div class="control">
                                <a class="button is-static">บาท/วัน</a>
                            </div>
                            </div>
                        </div>
                        <p v-if="$v.benefitForm.salary.$error" class="help is-danger">โปรดกรอกค่าตอบแทน</p>
                        </div>

                        <div class="field">
                        <label class="label">สวัสดิการที่ได้รับจริง</label>
                        <div class="control">
                            <input class="input" type="text" v-model="$v.benefitForm.benefit.$model" />
                        </div>
                        <p v-if="$v.benefitForm.benefit.$error" class="help is-danger">โปรดกรอกข้อมูลสวัสดิการ</p>
                        </div>

                        <div class="field">
                        <label class="label">คำอธิบายเพิ่มเติม</label>
                        <div class="control">
                            <textarea class="textarea" v-model="benefitForm.description"></textarea>
                        </div>
                        
                        </div>
                    </section>
                    <footer class="modal-card-foot">
                        <button class="button is-primary" @click="submitBenefit">บันทึก</button>
                        <button class="button" @click="showBenefitForm = false">ยกเลิก</button>
                    </footer>
                </div>
        </div>

        <!-- Review Modal -->
        <div class="modal" :class="{'is-active': showReviewForm}">
            <div class="modal-background" @click="showReviewForm = false"></div>
            <div class="modal-card">
                <header class="modal-card-head">
                    <p class="modal-card-title">ให้คะแนน </p>
                    <button class="delete" aria-label="close" @click="showReviewForm = false"></button>
                </header>
            <section class="modal-card-body">
                <div class="stars" >
                    <i v-for="star in 5"
                    :key="star"
                    @click="rate(star)"
                    class="fa fa-star"
                    :class="{ 'is-rated': star <= reviewForm.reviewRating}"></i>
                </div>
                <p v-if="$v.reviewForm.reviewRating.$error" class="help is-danger">กรุณาเลือกคะแนน</p>
                <p class="rating-text">{{ ratingText }}</p>
                <div class="field">
                    <div class="control my-3">
                    <textarea class="textarea" v-model="$v.reviewForm.reviewComment.$model" placeholder="เขียนคอมเม้นท์ที่นี่..."></textarea>
                    <p class="help is-danger" v-if="$v.reviewForm.reviewComment.$error">กรุณาเขียนคอมเม้น</p>
                    </div>
                </div>
                </section>
                <footer class="modal-card-foot">
                <button class="button is-success" @click="submitReview">บันทึก</button>
                <button class="button" @click="showReviewForm = false">ยกเลิก</button>
                </footer>
            </div>
        </div>

        </div>
    </div>
</template>
<script>
import { required} from 'vuelidate/lib/validators';
import { validationMixin } from 'vuelidate';
import axios from "axios";
import Swal from "sweetalert2";
import applicantSideMenu from "./applicant-side-menu.vue";
export default {
    components:{
        applicantSideMenu,

    },
    mixins: [validationMixin],
    data() {
        return {
            applications: [],
            user: [],
            job_title:'',
            selectedJobId: '',

            showReportForm: false,
            showBenefitForm: false,
            showReviewForm: false,

            //เพื่อเช็คว่ามีการกรอกข้อมูลไปแล้วหรือยัง
            report_history: [],
            benefit_history:[],
            review_history:[],
            

            reportForm: { //report
                reportDescription: '',
                reportOptions: ''
            },
            benefitForm: { //benefit
                company_name: '',
                job_position: '',
                description: '',
                salary: '',
                benefit: ''
            },
            reviewForm: { //review
                reviewComment: '',
                reviewRating: ''
            } 
        };
    },
    mounted() {
        this.getJobApplications();
        this.getUser();
        this.getReviewHistory();
        this.getReportHistory();
        this.getBenefitHistory();
    },
    updated() {
        console.log(this.applications); // ล็อกแอปพลิเคชันเพื่อตรวจสอบโครงสร้าง
    },
    computed: {
    ratingText() {
      switch(this.reviewForm.reviewRating) {
        case 1: return 'แย่';
        case 2: return 'พอใช้';
        case 3: return 'ปานกลาง';
        case 4: return 'ดี';
        case 5: return 'ยอดเยี่ยม';
        default: return ''; // หรือข้อความเริ่มต้นถ้าคุณต้องการ
      }
    },
    hasReportHistory() {
    return (jobId) => {
      return Array.isArray(this.report_history) && this.report_history.some(report => report.job_id === jobId);
    };
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
                .get("http://localhost:3000/application/getJobApprovedApplication", config)
                .then((response) => {

                    this.applications = response.data;
                    this.benefitForm.company_name = this.applications[0].company_name
                    this.benefitForm.job_position = this.applications[0].job_title
                    this.job_title = this.applications[0].job_title
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
        getReportHistory(){
            const token = localStorage.getItem("token");
            const config = {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            };
            axios.get("http://localhost:3000/application/getReportHistory", config)
                .then((res) => {
                    this.report_history = res.data[0];
                })
                .catch((error) => {
                    console.error(error);
                });
        },
        getBenefitHistory(){
            const token = localStorage.getItem("token");
            const config = {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            };
            axios.get("http://localhost:3000/application/getBenefitHistory", config)
                .then((res) => {
                    this.benefit_history = res.data[0];
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
                    this.review_history = res.data[0];
                })
                .catch((error) => {
                    console.error(error);
                });
        },
        //REPORT SECTION
        showReportModal(jobId) {
            this.selectedJobId = jobId;
            this.showReportForm = true;
        },
        submitReport() {
            const token = localStorage.getItem("token");
            const config = {
                headers: {
                Authorization: `Bearer ${token}`,
                },
            };
            this.$v.reportForm.$touch();

            if (!this.$v.reportForm.$error) {
                const data = {
                report_description: this.reportForm.reportDescription,
                report_title: this.reportForm.reportOptions,
                job_id: this.selectedJobId,
                };
                //console.log('fronend report job', data)
                axios   
                .post("http://localhost:3000/application/submitReport", data, config)
                .then((res) => {
                    const message = res.data.message;
                    Swal.fire({
                    position: "center",
                    icon: "success",
                    title: "บันทึกการายงานแล้ว",
                    showConfirmButton: message,
                    });
                    this.showReportForm = false;
                })
                .catch((error) => {
                    if (error.response) {
                    console.log("response.data", error.response.data);
                    }
                });
            }
            },
        //BENEFIT SECTION
        showBenefitModal(jobId) {
            this.selectedJobId = jobId
            this.showBenefitForm = true;
        },
        submitBenefit() {
            const token = localStorage.getItem("token");
            const config = {
                headers: {
                Authorization: `Bearer ${token}`,
                },
            };
            this.$v.benefitForm.$touch();
            if (!this.$v.benefitForm.$error) {
                const data = {
                company_name: this.benefitForm.company_name,
                job_position: this.benefitForm.job_position,
                description: this.benefitForm.description,
                salary: this.benefitForm.salary,
                benefit: this.benefitForm.benefit,
                job_id: this.selectedJobId,
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
                    this.getBenefitHistory();
                    this.showBenefitForm = false;
                })
                .catch((error) => {
                    if (error.response) {
                    console.log("response.data", error.response.data);
                    }
                });
            }
            },
        //REVIEW SECTION
        showReviewModal(jobId, companyId) {
            this.selectedJobId = jobId
            this.companyId = companyId
            this.showReviewForm = true;
        },
        submitReview() {
            const token = localStorage.getItem("token");
            const config = {
                headers: {
                Authorization: `Bearer ${token}`,
                },
            };
           // console.log("this.selectedJobId", this.selectedJobId)
            this.$v.reviewForm.$touch();
            if (!this.$v.reviewForm.$error) {
                const data = {
                    company_id: this.companyId,
                    job_id: this.selectedJobId,
                    rating: this.reviewForm.reviewRating,
                    comment: this.reviewForm.reviewComment
                };
            axios
            .post("http://localhost:3000/application/submitReview", data, config)
            .then((res) =>{
                const message = res.data.message;
                Swal.fire({
                    position: "center",
                    icon: "success",
                    title: "ให้คะแนนเรียบร้อย",
                    showConfirmButton: message,
                });
                this.getReviewHistory();
                this.showReviewForm = false;
            })    
            .catch((error) =>{
                if (error.response){
                    console.error("Error submitting review: ", error);
                    Swal.fire("โปรดกรอกข้อมูลให้ถูกต้อง", "", "error");
                }
                });
            }
            },
        rate(star) {
            this.reviewForm.reviewRating = star;
           // console.log('star',star)
        },
        //แปลงวันที่
        formatDate(dateString) {
        const date = new Date(dateString);
        const options = { year: 'numeric', month: '2-digit', day: '2-digit' };
        return date.toLocaleDateString('th-TH', options);
        },
    },
validations: {
  benefitForm: { //benefit
    company_name: { required },
    job_position: { required },
    salary: { required },
    benefit: { required }
  },
  reviewForm: { //review
    reviewComment: { required },
    reviewRating: { required }
  },
  reportForm: { //report
    reportDescription: { required },
    reportOptions: { required }
  },
    
}
};
</script>
<style scoped>
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
.stars .fa {
  color: #ccc;
}

.stars .fa.is-rated {
  color: gold;
}
.rating-text{
    color: rgba(255, 217, 0, 0.908);
}
</style>

  


