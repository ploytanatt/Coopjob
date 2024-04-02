<template>
    <div class="p">
      
      <div class="columns">
        
        <sideMenu></sideMenu>
         <main class="column Overview">
      <div class="level">
        <div class="level-left">
          <div class="level-item">
            <div class="title">Overview</div>
          </div>
        </div>

      </div>

      <section class="info-tiles">
        <div class="tile is-ancestor has-text-centered">
          <div class="tile is-parent">
            <article class="tile is-child box" style="background-color: #FFBFBF;">
              <p class="title">{{ userLists.length }}</p>
              <p class="subtitle">จำนวนผู้ใช้งานทั้งหมด</p>
            </article>
          </div>
          <div class="tile is-parent">
            <article class="tile is-child box"  style="background-color: #FFD28F;">
              <p class="title">{{ totalStudentCount }}</p>
              <p class="subtitle">จำนวนนักศึกษา</p>
            </article>
          </div>
          <div class="tile is-parent">
            <article class="tile is-child box"  style="background-color: #C1F2B0;">
              <p class="title">{{ totalCompanyCount }}</p>
              <p class="subtitle">จำนวนบริษัท</p>
            </article>
          </div>
          <div class="tile is-parent">
            <article class="tile is-child box"  style="background-color: #B4BDFF;">
              <p class="title">{{ jobLists.length }}</p>
              <p class="subtitle">จำนวนงานที่ประกาศ</p>
            </article>
          </div>
        </div>
      </section>

      <div class="tile is-ancestor">
        <div class="tile is-vertical is-8">
        <!-- คำร้องเรียนที่รอดำเนินการ -->
        <div class="tile is-parent">
            <article class="tile is-child notification card">
              <p class="title">คำร้องเรียนที่รอดำเนินการ({{ reportLists.length }}) </p>
            <div class="card-table">
              <div class="table-container">
                <table class="table is-fullwidth is-striped">
                  <thead>
                    <tr>
                      <th>#</th>
                      <th>หัวข้อการรายงาน</th>
                      <th>คำอธิบาย</th>
                      <th>วันที่รายงาน</th>
                      <th>สถานะ</th>
                      <th>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(report) in reportLists" :key="report.report_id">
                      <td>#{{ report.report_id }}</td>
                      <td>{{ report.report_title }}</td>
                      <td>{{ report.report_description }}</td>
                      <td>{{ formatDate(report.date_posted) }}</td>
                      <td>{{ report.report_status }}</td>
                             
                      <td>
                       <router-link :to="'/reportDetail/' + report.report_id" >
                      <button class="button is-info">ดูรายละเอียด</button>
                               </router-link>
                      </td>
             
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
      
            </article>
        </div>
        
      
            <div class="tile is-parent">
              <article class="tile is-child notification card">
                <p class="title">กราฟค่าแรงของแต่ละบริษัท</p>
                <benefitChart></benefitChart>
              </article>
            </div>
       
        </div>

        <!-- ค่าแรงและสวัสดิการ -->
        <div class="tile is-parent is-4">
          <article class="tile is-child notification card">
            <div class="content">      
       
              <div class="card-content ">
              <p class="title">ค่าแรงและสวัสดิการ</p>
                <div class="content">
                  <div class="columns is-mobile">
                    <div class="column is-9">
                      <p>นักศึกษาที่ฝึกงาน/สหกิจศึกษาทั้งหมด</p>
                    </div>
                    <div class="column has-text-right">
                      <p>{{ applications.length }} คน</p>
                    </div>
                  </div>
                  <div class="columns is-mobile">
                    <div class="column is-9">
                      <p>ฝึกงาน</p>
                    </div>
                    <div class="column has-text-right">
                      <p> {{ totalInternCount}} คน</p>
                    </div>
                  </div>
                  <div class="columns is-mobile">
                    <div class="column is-9">
                      <p>สหกิจศึกษา</p>
                    </div>
                    <div class="column has-text-right">
                      <p>{{ totalCoopCount}} คน</p>
                    </div>
                  </div>
                
                </div>
                <hr>
                <div class="">   
                    <div class="card-content">
                      <!-- Your chart will go here -->
                   <benefitPieChart></benefitPieChart>
                    </div>
                  </div>
          
              </div>
            </div>
          </article>
        </div>

        
      </div>

<div class="tile is-ancestor">
  <div class="tile is-vertical is-12">
    <div class="tile">
      <div class="tile is-parent is-vertical is-8">
        <article class="tile is-child notification card">
          <p class="title">จำนวนผู้ใช้ในแต่ละปีการศึกษา</p>
        
          <userChart></userChart>
        </article>

      </div>
      <div class="tile is-parent">
        <article class="tile is-child notification card">
          <p class="title">สถานะของงานทั้งหมด</p>
          <jobStatusChart></jobStatusChart>
        </article>
      </div>
    </div>

  </div>
  
</div>


<div class="tile is-ancestor">
  <div class="tile is-vertical is-12">
    <div class="tile">
      <div class="tile is-parent is-vertical is-6">
        <article class="tile is-child notification card ">
          <p class="title">ประเภทของการสมัคร</p>
          <p class="subtitle">Top tile</p>
          <jobTypeChart></jobTypeChart>
        </article>

      </div>
      <div class="tile is-parent">
        <article class="tile is-child notification card">
          <p class="title">ผลการสมัครของนักศึกษา</p>
            <applicationChart></applicationChart>
        </article>
      </div>
    </div>

  </div>
  
</div>

      <div class="tile is-ancestor">
        <div class="tile is-vertical is-8">
        <!-- Top 5 JOBS -->
        <div class="tile is-parent">
            <article class="tile is-child notification card">
              <p class="title">5 อันดับงานที่มีคนยื่นสมัครมากที่สุด </p>
            <div class="card-table">
              <div class="table-container">
                <table class="table is-fullwidth is-striped">
                  <thead>
                    <tr>
                      <th>#</th>
                      <th class="">
                        <button class="button is-small is-white" @click="sortApplications('company_name')">
                          <span class="has-text-grey">ชื่อบริษัท</span>&nbsp;
                          <i class="fa-solid fa-angles-up-down"></i>
                        </button>
                      </th>
                      <th class="" @click="sortApplications('job_title')">
                        <button class="button is-small is-white" >
                          <span class="has-text-grey">ตำแหน่ง </span>&nbsp;
                          <i class="fa-solid fa-angles-up-down"></i>
                        </button>
                      </th>
                       <th class="" @click="sortApplications('job_type')">
                        <button class="button is-small is-white" >
                          <span class="has-text-grey">รูปแบบงาน </span>&nbsp;
                          <i class="fa-solid fa-angles-up-down"></i>
                        </button>
                      </th>
                      <th @click="sortApplications('total_applications')">
                        <button class="button is-small is-white" >
                          <span class="has-text-grey">สรุปผลการสมัคร</span>&nbsp;
                          <i class="fa-solid fa-angles-up-down"></i>
                        </button>
                      </th>

                      <th class="px-6 py-3 has-text-grey">Action</th>
                  </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(job, index) in topFiveJobs" :key="job.job_id">
                      <td>{{ index + 1 }}</td>
                      <td>
                        <router-link :to="'/company/' + job.user_id">
                          <img :src="imagePath(job.profile_image)" alt="Company Logo" class="CompanyLogo">
                          <p>{{ job.company_name }}</p>
                          
                        </router-link>
                      </td>

                      <td>{{ job.job_title }}</td>
                      <td>{{ job.job_type }}</td>
                      <td>จำนวนคนสมัคร: {{ job.total_applications }} จำนวนที่รับแล้ว: {{ job.approve_applications }}</td>
                      <td>
              
                      <button class="button is-info">ดูรายละเอียด</button>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
      
            </article>
        </div>
        </div>

       <!-- Top 5 Company -->
        <div class="tile is-parent">
          <article class="tile is-child notification card">
            <p class="title">บริษัทที่มีคนยื่นสมัครมากที่สุด</p>
                      <div class="card-table">
              <div class="table-container">
                <table class="table is-fullwidth is-striped">
                  <thead>
                     <tr>
                      <th>#</th>
                      <th>
                        <button class="button is-small is-white">
                          <span class="has-text-grey">ชื่อบริษัท</span>
                        </button>
                      </th>
                      <th>
                        <button class="button is-small is-white" >
                          <span class="has-text-grey">จำนวนผู้สมัคร</span>
                        </button>
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(company, index) in topFiveCompanies" :key="company.company_id">
                      <td>{{ index + 1 }}</td>
                      <td>
                        <router-link :to="'/company/' + company.user_id">
                          <img :src="imagePath(company.profile_image)" alt="Company Logo" class="CompanyLogo">
                          <p>{{ company.company_name }}</p>
                        </router-link>
                      </td>
                      <td>จำนวนคนสมัคร: {{ company.total_applications }}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

          </article>
        </div>
      </div>

    </main>
      </div>

    
    </div>
</template>
<script>
import axios from "axios";
import sideMenu from '@/components/admin/side-menu.vue'
import benefitChart from "@/components/admin/benefit-chart.vue";
import benefitPieChart from "@/components/admin/benefit-piechart.vue";
import userChart from "@/components/admin/users-chart.vue";
import jobTypeChart from "@/components/admin/job-typeChart.vue";
import applicationChart from "@/components/admin/application-chart.vue";
import jobStatusChart from "@/components/admin/job-statusChart.vue";

export default {
  name: "OverView",
  components:{
    sideMenu,
    benefitChart,
    benefitPieChart,
    userChart,
    jobTypeChart,
    applicationChart,
    jobStatusChart,
  },
  data() {
    return {
      userLists:[],
      reportLists: [],
      applications:[],
      jobLists:[],
      companyLists:[],

      sortKey: 'total_applications',
      sortOrder: 'desc',

     
    };
  },
  mounted() {
    this.getUsers();
    this.getReportList();
    this.getApproveApplicationList();
    this.getJobLists();
    this.getCompanyLists();
  },
  computed:{
    totalStudentCount() {
      return this.userLists.reduce((count, user) => {
        return user.role === 'applicant' ? count + 1 : count;
      }, 0);
    },
    totalCompanyCount() {
      return this.userLists.reduce((count, user) => {
        return user.role === 'recruiter' ? count + 1 : count;
      }, 0);
    },
    totalInternCount() {
      return this.applications.reduce((count, application) => {
        return application.job_type === 'internship' ? count + 1 : count;
      }, 0);
    },
    totalCoopCount() {
      return this.applications.reduce((count, application) => {
        return application.job_type === 'cooperative' ? count + 1 : count;
      }, 0);
    },
    topFiveJobs() {
      let sortedJobs = [...this.jobLists];
      sortedJobs.sort((a, b) => {
      let result = 0;
        if (a[this.sortKey] < b[this.sortKey]) {
          result = -1;
        } else if (a[this.sortKey] > b[this.sortKey]) {
          result = 1;
        }
        return this.sortOrder === 'asc' ? result : -result;
      });
    return sortedJobs.slice(0, 5);
  },
    topFiveCompanies() {
      const sortedCompanies = [...this.companyLists]
        .sort((a, b) => b.total_applications - a.total_applications)
        .slice(0, 5);
      return sortedCompanies;
    },
  },
  methods: {
    getUsers(){
      axios
        .get("http://localhost:3000/admin/Allusers")
        .then((response) => {
          this.userLists = response.data;
        })
        .catch((error) => {
          console.error(error);
        });
    },
    getReportList() {
      axios
        .get("http://localhost:3000/admin/ReportList")
        .then((response) => {
          this.reportLists = response.data;
          console.log(this.reportLists);
        })
        .catch((error) => {
          console.error('Error fetching report list:', error);
        });
    },
    getApproveApplicationList(){
      axios
        .get("http://localhost:3000/admin/ApproveApplicationList")
        .then((response) => {
          this.applications = response.data;
        })
        .catch((error) => {
          console.error(error);
        });
    },
    getJobLists(){
      axios
        .get("http://localhost:3000/admin/getAllJobs")
        .then((response) => {
          this.jobLists = response.data;
        })
        .catch((error) => {
          console.error(error);
        });
    },
    getCompanyLists(){
      axios
        .get("http://localhost:3000/admin/companyList")
        .then((response) => {
          this.companyLists = response.data;
        })
        .catch((error) => {
          console.error(error);
        });
    },
    formatDate(date) {
      return new Date(date).toLocaleDateString();
    },
    imagePath(companyProfileImage) {
      if (companyProfileImage) {
        return "http://localhost:3000" + companyProfileImage.replace(/\\/g, '/').replace('static', '');
      } else {
        return "https://bulma.io/images/placeholders/640x360.png";
      }
    },
    sortApplications(key) {
      if (this.sortKey === key) {
        this.sortOrder = this.sortOrder === 'asc' ? 'desc' : 'asc';
      } else {
        this.sortKey = key;
        this.sortOrder = 'asc';
      }
    },
    onPointSelected(event, chartContext, config) {
    console.log(config.seriesIndex, config.dataPointIndex, config.w.config.series[config.seriesIndex].data[config.dataPointIndex])
  }
  },
};
</script>

<style scoped>
.Overview {
  padding: 1rem;
}
.table td, .table th {
  text-align: center; /* จัดให้ข้อความอยู่ตรงกลาง */
  vertical-align: middle; /* จัดให้ข้อความอยู่กลางแนวตั้ง */
}
.CompanyLogo{
width: 60px;
border: 1px solid rgb(240, 240, 240);
border-radius: 5px;
transition: width 0.3s ease-in-out;
}
.CompanyLogo:hover{
width: 80px;
}
.p{
  background-color: #EEF5FF;
}
</style>

