<template>
    <div>
        <div v-for="application in applications" :key="application.student_job_id">
            <div class="card px-5 py-3" v-if="application.status === 'approve'">
                <div class="pt-3" style="border-top: 0.5px solid gray">
                    <div class="columns p-4">
                        <div class="column">
                            <img :src="imagePath(application.company.profile_image)" alt="Company Logo"
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
                <!-- หน้าต่างแสดงให้เลือกคะแนนดาว -->
                <div id="reviewPopup" v-if="selectedJobId !== null">
                    <div class="reviewPopup-inner">
                        <div class="reviewPopup-header">
                            <h2>ให้คะแนน</h2>
                            <button class="close-button" @click="closeReviewPopup">×</button>
                        </div>
                        <div class="stars">
                            <!-- สร้างดาวให้เลือก -->
                            <span v-for="n in 5" :key="n" @click="selectRating(n)"
                                :class="{ yellow: n <= selectedRating }">★</span>
                        </div>
                        <h3>ความคิดเห็นเพิ่มเติม</h3>
                        <div class="comment">
                            <textarea name="" id="comment" cols="30" rows="10"></textarea>
                        </div>
                        <!-- ปุ่ม submit สำหรับส่งคะแนน -->
                        <div class="reviewPopup-footer">
                            <button id="submitReviewButton" @click="submitReview">Submit</button>
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
export default {
    data() {
        return {
            applications: [],
            user: [],
            selectedJobId: null, // เพิ่ม property ใหม่
            selectedRating: null, // เพิ่ม property เก็บคะแนนดาวที่เลือก
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
                        title: 'Cancel',
                        
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


        showReviewPopup(jobId) {
            this.selectedJobId = jobId;

            // Check review history before showing the popup
            this.checkReviewHistory(jobId);
        },

        checkReviewHistory(jobId) {
            const token = localStorage.getItem('token');
            const config = {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            };

            axios.get(`http://localhost:3000/application/checkReviewHistory?jobId=${jobId}`, config)
                .then((res) => {
                    const reviewHistory = res.data;

                    if (reviewHistory.length > 0) {
                        // If review history exists, populate the popup with rating and comment
                        const { rating, comment } = reviewHistory[0];
                        this.selectedRating = rating;
                        document.getElementById('comment').value = comment;

                        // Disable the stars so they cannot be clicked
                        const stars = document.querySelectorAll('.stars span');
                        stars.forEach(star => {
                            star.style.pointerEvents = 'none';
                        });

                        // Disable the textarea so it cannot be edited
                        document.getElementById('comment').disabled = true;

                        // Hide the submit button since the user has already reviewed this job
                        document.getElementById('submitReviewButton').style.display = 'none';

                        // Change the header text to display review history
                        document.querySelector('.reviewPopup-header h2').innerText = 'ประวัติการรีวิว';
                    } else {
                        // Show the submit button if there is no review history
                        document.getElementById('submitReviewButton').style.display = 'block';

                        // Enable the stars for rating
                        const stars = document.querySelectorAll('.stars span');
                        stars.forEach(star => {
                            star.style.pointerEvents = 'auto';
                        });

                        // Enable the textarea for comment
                        document.getElementById('comment').disabled = false;
                    }

                    // Show the review popup
                    document.getElementById('reviewPopup').style.display = 'block';
                })
                .catch((error) => {
                    console.error(error);
                    // If error occurs, still show the review popup
                    document.getElementById('reviewPopup').style.display = 'block';
                });
        },



        closeReviewPopup() {
            this.selectedJobId = null; // ล้างค่า selectedJobId เพื่อซ่อนป็อปอัพ
            this.selectedRating = null; // ล้างค่า selectedRating
        },
        // ส่งคะแนนดาว
        selectRating(rating) {
            this.selectedRating = rating;
        },
        // ส่งคะแนนดาว
        // ส่งคะแนนดาว
        submitReview() {
            // ตรวจสอบว่าคะแนนถูกเลือกหรือไม่
            if (!this.selectedRating) {
                // ถ้าไม่มีคะแนนที่ถูกเลือก
                Swal.fire({
                    icon: 'error',
                    title: 'Please select a rating',
                    text: 'Please select a rating before submitting the review.',
                });
                return;
            }

            // ถ้ามีคะแนนที่ถูกเลือก
            const comment = document.getElementById('comment').value;

            const token = localStorage.getItem('token');
            const config = {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            };

            const data = {
                job_id: this.selectedJobId,
                rating: this.selectedRating,
                comment: comment,
            };

            // ส่งข้อมูลรีวิวไปยังฐานข้อมูล
            axios.post('http://localhost:3000/application/sendReview', data, config)
                .then((res) => {
                    console.log(res.data.message);
                    // แสดงแจ้งเตือนเมื่อสำเร็จ
                    Swal.fire({
                        title: 'Review submitted successfully',
                        icon: 'success',
                    });
                    document.getElementById('reviewPopup').style.display = 'none';
                })
                .catch((error) => {
                    console.error(error);
                    // แสดงข้อผิดพลาดเมื่อไม่สำเร็จ
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'Failed to submit review. Please try again later.',
                    });
                    document.getElementById('reviewPopup').style.display = 'none';
                });
        },







    },
};
</script>
<style scoped>
/* สีเหลืองสำหรับดาวที่ถูกเลือก */
.yellow {
    color: yellow;
}

/* CSS สำหรับหน้าต่างแสดงให้เลือกคะแนนดาว */
#reviewPopup {
    display: none;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 999;
}

.reviewPopup-inner {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background-color: #fefefe;
    padding: 20px;
    border: 1px solid #888;
    border-radius: 5px;
    width: 80%;
    max-width: 500px;
}

.reviewPopup-header {
    text-align: center;
    margin-bottom: 20px;
}

.reviewPopup-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.close-button {
    background: none;
    border: none;
    font-size: 1.5em;
    cursor: pointer;
    color: #888;
}

.close-button:hover {
    color: #555;
}


.stars {
    text-align: center;
    margin-bottom: 20px;
}

.stars span {
    font-size: 24px;
    cursor: pointer;
    color: #ccc;
    transition: color 0.3s;
}

.stars span.yellow {
    color: gold;
}

.comment textarea {
    width: 100%;
    height: 100px;
    resize: vertical;
    margin-bottom: 20px;
    border: 1px solid #ccc;
    /* เพิ่ม border */
}

.reviewPopup-footer {
    text-align: center;
}

.reviewPopup-footer button {
    padding: 10px 20px;
    background-color: #4CAF50;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
}

.reviewPopup-footer button:hover {
    background-color: #45a049;
}

@media screen and (max-width: 600px) {
    .reviewPopup-inner {
        width: 90%;
    }
}
</style>

  


