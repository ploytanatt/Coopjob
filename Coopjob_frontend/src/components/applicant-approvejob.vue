<template>
    <div>
        <div v-for="application in applications" :key="application.student_job_id">
            <div class="card px-5 py-3" v-if="application.status === 'approve'">
                <div class="pt-3" style="border-top: 0.5px solid gray">
                    <div class="columns p-4">
                        <div class="column">
                            <img :src="application.company.profile_image" alt="Company Logo"
                                style="max-width: 100px; max-height: 100px;">
                        </div>
                        <div class="column">
                            <p class="is-size-5 has-text-weight-bold"> ชื่อบริษัท: {{ application.company.company_name }}
                            </p>
                            <p class="is-size-5 has-text-weight-bold"> ชื่องาน: {{ application.job.title }}</p>
                        </div>
                    </div>
                    <div class="columns p-4">
                        <div class="column">
                            <p class="is-size-5 has-text-weight-bold"> ตำแหน่ง: {{ application.job.job_position }} </p>
                        </div>
                        <div class="column">
                            <p class="is-size-5 has-text-weight-bold"> สถานะ: {{ application.status }}</p>
                        </div>
                    </div>
                    <div class="buttons mt-3">
                        <button class="button is-danger" @click="showReportPopup(application.job.job_id)">
                            รายงาน
                        </button>
                        <button class="button is-primary"
                            @click="gotobenefit(application.company.company_name, application.job.job_id)">
                            กรอกค่าแรงและสวัสดิการ
                        </button>
                        <button class="button is-light">
                            ดูใบตอบรับ
                        </button>
                        <button class="button is-info" @click="showReviewPopup(application.job.job_id)">
                            ให้คะแนน
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
import axios from "axios";
import Swal from "sweetalert2";
export default {
    data() {
        return {
            applications: [],
            user: [],
            selectedJobId: null, // เพิ่ม property ใหม่
        };
    },
    mounted() {
        this.getJobApplications();
        this.getUser();
    },
    updated() {
        console.log(this.applications); // ล็อกแอปพลิเคชันเพื่อตรวจสอบโครงสร้าง
    },
    methods: {
        gotobenefit(companyName, job_id) {
            this.$router.push({
                path: "/benefitReport",
                query: {
                    companyName,
                    job_id,
                },
            });
            this.closeAddJobModal();
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


        showReportPopup(jobId) {
            this.selectedJobId = jobId;
            (async () => {
                const result = await Swal.fire({
                    title: 'Report',
                    html:
                        '<div>' +
                        '<label for="report-title">Title: </label>' +
                        '<input type="hidden" id="report-title" class="swal2-input">' +
                        '<label><input type="radio" name="report-option" value="job" checked> Job </label>' +
                        '<label><input type="radio" name="report-option" value="company"> Company </label>' +
                        '<label><input type="radio" name="report-option" value="mentor"> Mentor </label>' +
                        '<label><input type="radio" name="report-option" value="work"> Work </label>' +
                        '<label><input type="radio" name="report-option" value="other"> Other </label>' +
                        '</div><br>' +
                        '<label for="report-description">Description:</label><br>' +
                        '<textarea id="report-description" class="swal2-input" placeholder="Description"></textarea>',
                    showCancelButton: true,
                    confirmButtonText: 'Submit Report',
                    cancelButtonText: 'Cancel',
                    showLoaderOnConfirm: true,
                    preConfirm: async () => {
                        const reportOption = document.querySelector('input[name="report-option"]:checked').value;
                        const title = this.getReportTitle(reportOption);
                        const description = document.getElementById('report-description').value;

                        const token = localStorage.getItem('token');
                        const config = {
                            headers: {
                                Authorization: `Bearer ${token}`,
                            },
                        };

                        const data = {
                            job_id: this.selectedJobId,
                            user_id: this.user.user_id,
                            title,
                            description,
                        };

                        try {
                            const res = await axios.post('http://localhost:3000/application/sendReport', data, config);
                            console.log(res.data.message);
                            return { success: true };
                        } catch (error) {
                            console.error(error);
                            return {
                                success: false,
                                errorMessage: 'Failed to submit report. Please try again later.',
                            };
                        }
                    },
                });

                if (result.isConfirmed && result.value.success) {
                    Swal.fire({
                        title: 'Report submitted successfully',
                        icon: 'success',
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: result.value.errorMessage,
                    });
                }
            })();
        },





        getReportTitle(option) {
            // Define how you want to map the option to a title
            // For example, you can have a mapping object or use a switch statement
            switch (option) {
                case 'job':
                    return 'Job';
                case 'company':
                    return 'Company';
                case 'mentor':
                    return 'Mentor';
                case 'work':
                    return 'Work';
                case 'other':
                    return 'Other';
                default:
                    return 'Unknown';
            }
        },


        BenefitReportPopup(jobId) {
            this.selectedJobId = jobId;
            // เริ่มต้นด้วยตัวแปรที่ใช้เก็บข้อมูลค่าแรงและสวัสดิการ
            let salaryAndBenefits = {
                companyName: '',
                position: '',
                jobDetails: '',
                salary: '',
                benefits: ''
            };

            Swal.fire({
                title: 'ค่าแรงและสวัสดิการที่ได้รับ',
                html:
                    '<div>' +
                    '<div style="margin-bottom: 10px;">' +
                    '<label for="company-name">ชื่อบริษัท:</label>' +
                    '<input type="text" id="company-name" class="swal2-input" v-model="salaryAndBenefits.companyName">' +
                    '</div>' +
                    '<div style="margin-bottom: 10px;">' +
                    '<label for="position">ตำแหน่ง:</label>' +
                    '<input type="text" id="position" class="swal2-input" v-model="salaryAndBenefits.position">' +
                    '</div>' +
                    '<div style="margin-bottom: 10px;">' +
                    '<label for="job-details">รายละเอียดงาน:</label>' +
                    '<textarea id="job-details" class="swal2-input" v-model="salaryAndBenefits.jobDetails"></textarea>' +
                    '</div>' +
                    '<div style="margin-bottom: 10px;">' +
                    '<label for="salary">ค่าแรงที่ได้รับ (ต่อวัน):</label>' +
                    '<input type="text" id="salary" class="swal2-input" v-model="salaryAndBenefits.salary">' +
                    '</div>' +
                    '<div style="margin-bottom: 10px;">' +
                    '<label for="benefits">สวัสดิการที่ได้รับ:</label>' +
                    '<textarea id="benefits" class="swal2-input" v-model="salaryAndBenefits.benefits"></textarea>' +
                    '</div>' +
                    '</div>',
                showCancelButton: true,
                confirmButtonText: 'Submit Report',
                cancelButtonText: 'Cancel',
                showLoaderOnConfirm: true,
                preConfirm: () => {
                    const reportOption = document.querySelector('input[name="report-option"]:checked').value;
                    const title = this.getReportTitle(reportOption);
                    const description = document.getElementById('report-description').value;

                    const token = localStorage.getItem('token');
                    const config = {
                        headers: {
                            Authorization: `Bearer ${token}`,
                        },
                    };

                    const data = {
                        job_id: this.selectedJobId,
                        user_id: this.user.user_id,
                        title,
                        description,
                        salaryAndBenefits: salaryAndBenefits, // ส่งข้อมูลค่าแรงและสวัสดิการไปที่ backend
                    };

                    // Send the report data to the backend
                    return axios.post('http://localhost:3000/application/sendReport', data, config)
                        .then((res) => {
                            console.log(res.data.message);
                            return {
                                success: true,
                            };
                        })
                        .catch((error) => {
                            console.error(error);
                            return {
                                success: false,
                                errorMessage: 'Failed to submit report. Please try again later.',
                            };
                        });
                },
            }).then((result) => {
                if (result.success) {
                    Swal.fire({
                        title: 'Report submitted successfully',
                        icon: 'success',
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: result.errorMessage,
                    });
                }
            });
        },


        /*showReviewPopup(jobId) {
            /*window.addEventListener('DOMContentLoaded', () => {
                
            })
            Swal.fire({
                title: 'ให้คะแนนและเขียนรีวิว',
                html:
                    '<div>' +
                    '<div style="margin-bottom: 10px;">' +
                    '<label for="rating">ให้คะแนน:</label><br>' +
                    '<span class="star" data-value="1"><i class="fas fa-star"></i></span>' +
                    '<span class="star" data-value="2"><i class="fas fa-star"></i></span>' +
                    '<span class="star" data-value="3"><i class="fas fa-star"></i></span>' +
                    '<span class="star" data-value="4"><i class="fas fa-star"></i></span>' +
                    '<span class="star" data-value="5"><i class="fas fa-star"></i></span>' +
                    '<font-awesome-icon icon="heart" />'+
                    '<input type="hidden" id="rating">' +
                    '</div>' +
                    '<div style="margin-bottom: 10px;">' +
                    '<label for="comment">เขียนคอมเม้น:</label>' +
                    '<textarea id="comment" class="swal2-input"></textarea>' +
                    '</div>' +
                    '</div>',
                showCancelButton: true,
                confirmButtonText: 'Submit Review',
                cancelButtonText: 'Cancel',
                showLoaderOnConfirm: true,
                didRender: () => {
                    // เพิ่ม event listener เมื่อป๊อปอัพถูกแสดง
                    const stars = document.querySelectorAll('.star');
                    stars.forEach(star => {
                        star.addEventListener('click', () => {
                            const value = star.getAttribute('data-value');
                            document.getElementById('rating').value = value;
                            stars.forEach(s => {
                                if (s.getAttribute('data-value') <= value) {
                                    s.classList.add('selected');
                                } else {
                                    s.classList.remove('selected');
                                }
                            });
                        });
                    });
                },
                preConfirm: () => {
                    const rating = document.getElementById('rating').value;
                    const comment = document.getElementById('comment').value;

                    const token = localStorage.getItem('token');
                    const config = {
                        headers: {
                            Authorization: `Bearer ${token}`,
                        },
                    };

                    const data = {
                        job_id: jobId,
                        user_id: this.user.user_id,
                        rating,
                        comment,
                    };

                    // Send the review data to the backend
                    return axios.post('http://localhost:3000/application/sendReview', data, config)
                        .then((res) => {
                            console.log(res.data.message);
                            return {
                                success: true,
                            };
                        })
                        .catch((error) => {
                            console.error(error);
                            return {
                                success: false,
                                errorMessage: 'Failed to submit review. Please try again later.',
                            };
                        });
                },
            }).then((result) => {
                if (result.success) {
                    Swal.fire({
                        title: 'Review submitted successfully',
                        icon: 'success',
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: result.errorMessage,
                    });
                }
            });
        },*/

        showReviewPopup(jobId) {
            Swal.fire({
                title: 'ให้คะแนนและรีวิว',
                html:
                    `<div>
                <label for="rating">เลือกคะแนน (1-5):</label>
                <select id="rating" class="swal2-input">
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                </select>
                <label for="comment">ความคิดเห็น:</label>
                <textarea id="comment" class="swal2-input" placeholder="แสดงความคิดเห็นของคุณ"></textarea>
            </div>`,
                showCancelButton: true,
                confirmButtonText: 'Submit',
                cancelButtonText: 'Cancel',
                showLoaderOnConfirm: true,
                preConfirm: () => {
                    const rating = document.getElementById('rating').value;
                    const comment = document.getElementById('comment').value;

                    const token = localStorage.getItem('token');
                    const config = {
                        headers: {
                            Authorization: `Bearer ${token}`,
                        },
                    };

                    const data = {
                        job_id: jobId,
                        user_id: this.user.user_id,
                        rating: rating,
                        comment: comment,
                    };

                    return axios.post('http://localhost:3000/application/sendReview', data, config)
                        .then((res) => {
                            console.log(res.data.message);
                            return {
                                success: true,
                            };
                        })
                        .catch((error) => {
                            console.error(error);
                            return {
                                success: false,
                                errorMessage: 'Failed to submit review. Please try again later.',
                            };
                        });
                },
            }).then((result) => {
                if (result.success) {
                    Swal.fire({
                        title: 'Review submitted successfully',
                        icon: 'success',
                    });
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Already Review',
                        text: result.errorMessage,
                    });
                }
            });
        },






    },
};
</script>
<style scoped></style>
  