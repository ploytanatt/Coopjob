import Vue from 'vue'
import VueRouter from 'vue-router'

Vue.use(VueRouter)

const routes = [

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
    path: '/applicantProfile',
    name: 'applicantProfile',
    meta: { login: true },
    component: () => import('../views/applicant/ApplicantProfilePage.vue')
  },
  {
    path: '/applicantAccount',
    name: 'applicantAccount',
    meta: { login: true },
    component: () => import('../views/applicant/ApplicantAccount.vue')
  },
  {
    path: '/MyJobs',
    name: 'MyJobs',
    meta: { login: true ,title:'งานที่สมัคร'},
    component: () => import('../views/applicant/MyJobsPage.vue')
  },
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
    component: () => import('../views/recruiter/RcruiterAddJob.vue')
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
    path: '/recruiterAccount',
    name: 'recruiterAccount',
    meta: { login: true },
    component: () => import('../views/recruiter/RecruiterAccount.vue')
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
    path: '/applicantList',
    name: 'applicantList',
    meta: { login: true, title:'คนที่มายื่นสมัคร'},
    component: () => import('../views/recruiter/Applicant-list.vue')
  },
  {
    path: '/applicantDetail/:applicationId',
    name: 'applicantDetail',
    meta: { login: true },
    component: () => import('../views/recruiter/Applicant-detail.vue')
  },
  {
    path: '/benefitReport',
    name: 'benefitReport',
    meta: { login: true },
    component: () => import('../components/applicant-benefit.vue')
  },

  {
    path: '/jobsearch',
    name: 'jobsearch',
    meta: {title: 'บริษัท'},
    component: () => import('../views/JobSearch.vue')
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