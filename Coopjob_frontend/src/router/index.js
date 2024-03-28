import Vue from 'vue'
import VueRouter from 'vue-router'
import jobListingUpload from "@/components/recruiter/job-listing-upload.vue"
import jobListFormVue from "@/components/recruiter/job-listing-form.vue"
import applicationEachJob from "@/components/recruiter/application-eachjob.vue"
import applicantPreview from '@/components/applicant/applicant-preview.vue'
import applicantFavorite from '@/components/applicant/applicant-favorite.vue'
import applicantReport from '@/components/applicant/applicant-report.vue'

Vue.use(VueRouter)

const routes = [
//ใช้ร่วมกัน
  {
    path: '/',
    name: 'HomePage',
    meta: { title: 'หน้าแรก' },
    component: () => import('../views/HomePage.vue') // set home as path '/'
  },
  {
    path: '/signup',
    name: 'signUp',
    meta: {title: 'สมัครสมาชิก'},
    component: () => import('../views/SignUp.vue')
  },
  {
    path: '/signin',
    name: 'signIn',
    meta: {title: 'เข้าสู่ระบบ'},
    component: () => import('../views/SignIn.vue')
  },
  {
    path: '/company/:companyId',
    name: 'CompanyDetails',
    meta: {title: 'บริษัท'},
    component: () => import('../views/CompanyDetails.vue')
  },
  {
    path: '/job/:jobId',
    name: 'JobDetails',
    meta: { title:'ชื่องาน'},
    component: () => import('../views/JobDetail.vue')
  },
  {
    path: '/jobsearch',
    name: 'jobsearch',
    meta: {title: 'บริษัท'},
    component: () => import('../views/JobSearch.vue')
  },

  //applicant ผู้สมัคร
  {
    path: '/myApproveJob',
    name: 'myApproveJob',
    meta: { login: true },
    component: () => import('@/components/applicant/applicant-approvejob.vue')
  },
  {
    path: '/applicantProfile',
    name: 'applicantProfile',
    meta: { login: true },
    component: () => import('../views/applicant/ApplicantProfilePage.vue')
  },
  {
    path: '/MyJobsPage',
    name: 'MyJobsPage',
    meta: { login: true ,title:'งานที่สมัคร'},
    component: () => import('../views/applicant/MyJobsPage.vue')
  },
  {
    path: '/MyFavoriteJobs',
    name: 'MyFavoriteJobs',
    meta: { login: true ,title:'งานที่สนใจ'},
    component: applicantFavorite
  },
  {
    path: '/report-history',
    name: 'report-history',
    meta: { login: true ,title:'การรายงาน'},
    component: applicantReport
  },
  {
    path: '/benefitReport',
    name: 'benefitReport',
    meta: { login: true },
    component: () => import('../components/applicant/applicant-benefit.vue')
  },
  {
    path: '/review-history',
    name: 'review-history',
    meta: { login: true },
    component: () => import('../components/applicant/applicant-review-history.vue')
  },
  
  { 
    path: '/coopFile',
    name: 'coopFile',
    meta: { login: true },
    component: () => import('../components/applicant/applicant-coop.vue')
  },
  {
    path: '/applicantPreview',
    name: 'applicantPreview',
    meta: { login: true },
    component:applicantPreview
  },
  {
    path: '/applicantAccount',
    name: 'applicantAccount',
    meta: { login: true },
    component: () => import('../views/applicant/ApplicantAccount.vue')
  },


  //recruiter ฝั่งบริษัท
  {
    path: '/recruiterProfile',
    name: 'recruiterProfile',
    meta: { login: true , title:'ข้อมูลบริษัท'},
    component: () => import('../views/recruiter/RecruiterProfilePage.vue')
  },
  {
    path: '/recruiterJob',
    name: 'recruiterJob',
    meta: { login: true , title:'งานที่ประกาศ'},
    component: () => import('../views/recruiter/RecruiterJobPage.vue')
  },
  {
    path: '/recruiterAddJob',
    name: 'recruiterAddJob',
    meta: { login: true },
    component: () => import('../views/recruiter/RecruiterAddJob.vue')
  },
  {
    path: '/recruiterAddJobByUpload',
    name: 'recruiterAddJobByUpload',
    meta: { login: true },
    component: () => import('../views/recruiter/RecruiterAddJobByUpload.vue')
  },
  {
    path: '/edit-job/:jobId',
    name: 'RecruiterJobEdit',
    meta: { login: true },
    component: () => import('../views/recruiter/RecruiterJobEdit.vue')
  },
  {
    path: '/edit-uploadjob/:jobId',
    name: 'RecruiterJob-uploadEdit',
    meta: { login: true },
    component: () => import('../views/recruiter/RecruiterJobUploadEdit .vue')
  },
    {
    path: '/recruiterAccount',
    name: 'recruiterAccount',
    meta: { login: true },
    component: () => import('../views/recruiter/RecruiterAccount.vue')
  },
  {
    path: '/applicantList',
    name: 'applicantList',
    meta: { login: true, title:'คนที่มายื่นสมัคร'},
    component: () => import('../views/recruiter/Applicant-list.vue')
  },
  {
    path: '/getApplicationByJob/:jobId',
    name: 'applicantListJob',
    meta: { login: true, title:'คนที่มายื่นสมัคร'},
    component: applicationEachJob
  },
  {
    path: '/applicantDetail/:applicationId',
    name: 'applicantDetail',
    meta: { login: true },
    component: () => import('../views/recruiter/Applicant-detail.vue')
  },
  {
    path: '/job-listing-form',
    name: 'job-listing-form',
    meta: {title: ''},
    component:jobListFormVue
  },
  {
    path: '/job-listing-upload',
    name: 'job-listing-upload',
    meta: {title: ''},
    component:jobListingUpload
  },

  //ฝั่งAdmin
  {
    path: '/adminSignin',
    name: 'admin-signin',
    meta: {title: 'admin เข้าสู่ระบบ'},
    component: () => import('../views/admin/AdminSignIn.vue')
  },
  {
    path: '/adminOverview',
    name: 'adminOverview',
    meta: {title: 'Overview'},
    component: () => import('../views/admin/DashboardPage.vue')
  },
  {
    path: '/studentList',
    name: 'studentList',
    meta: {title: 'รายชื่อนักศึกษา'},
    component: () => import('../views/admin/StudentList.vue')
  },
  {
    path: '/studentDetail/:id',
    name: 'StudentDetails',
    component: () => import('../views/admin/StudentDetails.vue')
  },
  {
    path: '/companyList',
    name: 'companyList',
    meta: {title: 'รายชื่อนักศึกษา'},
    component: () => import('../views/admin/CompanyList.vue')
  },
    {
    path: '/companyDetail/:id',
    name: 'Admin-companyDetails',
    component: () => import('../views/admin/CompanyDetail.vue')
  },
  {
    path: '/companyjobList',
    name: 'Admin-companyjobList',
    component: () => import('../views/admin/JobList.vue')
  },
  {
    path: '/reportList',
    name: 'Admin-reportList',
    component: () => import('../views/admin/ReportList.vue')
  },
  {
    path: '/reportDetail/:id',
    name: 'Admin-reportDetailDetails',
    component: () => import('../views/admin/ReportDetails.vue')
  },
    {
    path: '/applicationList',
    name: 'Admin-applicationList',
    component: () => import('../views/admin/ApplicationList.vue')
  },
    {
    path: '/BenefitResult',
    name: 'Admin-BenefitResult',
    component: () => import('../views/admin/BenefitList.vue')
  },
  {
    path: '/benefitDetail/:id',
    name: 'Admin-benefitResultDetail',
    component: () => import('../views/admin/BenefitDetails.vue')
  },
  {
    path: '/CompanyRating',
    name: 'Admin-CompanyRating',
    component: () => import('../views/admin/CompanyRating.vue')
  },
  {
    path: '/CompanyRatingDetail/:id',
    name: 'Admin-CompanyRatingDetail',
    component: () => import('../views/admin/CompanyReviewDetail.vue')
  },

    {
    path: '/draggable-list',
    name: 'Admin-draggable-list',
    component: () => import('../components/admin/draggable-list.vue')
  },

]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

router.beforeEach((to, from, next) => {
  const isLoggedIn = !!localStorage.getItem("token");

  if (to.meta.login && !isLoggedIn) {
    alert("Please login first!");
    next({ path: "/signin" });
  }

  if (to.meta.guess && isLoggedIn) {
    alert("You've already logged in");
    next({ path: "/" });
  }

  // ถ้ามีค่า meta.title ในเส้นทาง (route) กำหนดค่าให้กับ title ของหน้าเว็บไซต์
  if (to.meta.title) {
    document.title = to.meta.title + " | ITJS";
  }

  next();
});


export default router