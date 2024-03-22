<template>
  <div class="">
    <main class="column">
      <div class="level">
        <div class="level-left">
          <div class="level-item">
            <div class="title">Overview</div>
          </div>
        </div>
        <div class="level-right">
          <div class="level-item">
            <button type="button" class="button is-small">
              March 8, 2017 - April 6, 2017
            </button>
          </div>
        </div>
      </div>

      <section class="info-tiles">
        <div class="tile is-ancestor has-text-centered">
          <div class="tile is-parent">
            <article class="tile is-child box">
              <p class="title">10</p>
              <p class="subtitle">จำนวนผู้ใช้งานทั้งหมด</p>
            </article>
          </div>
          <div class="tile is-parent">
            <article class="tile is-child box">
              <p class="title">7</p>
              <p class="subtitle">จำนวนนักศึกษา</p>
            </article>
          </div>
          <div class="tile is-parent">
            <article class="tile is-child box">
              <p class="title">3</p>
              <p class="subtitle">จำนวนบริษัท</p>
            </article>
          </div>
          <div class="tile is-parent">
            <article class="tile is-child box">
              <p class="title">7</p>
              <p class="subtitle">จำนวนงานที่ประกาศ</p>
            </article>
          </div>
        </div>
      </section>

      <div class="columns is-multiline">
 <div class="column is-6">
    <div class="card events-card">
      <header class="card-header">
        <p class="card-header-title">คำร้องเรียนที่รอดำเนินการ ({{ reportLists.length }})</p>
      </header>
      <div class="card-table">
        <div class="content">
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
              <tr v-for="(report, index) in reportLists" :key="report.report_id">
                <td>{{ index + 1 }}</td>
                <td>{{ report.report_title }}</td>
                <td>{{ report.report_description }}</td>
                <td>{{ formatDate(report.date_posted) }}</td>
                <td>{{ report.report_status }}</td>
                <td><button class="button is-info">ดูรายละเอียด</button></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
        <div class="column is-6">
          <div class="card">
            <header class="card-header">
              <p class="card-header-title">ค่าแรงและสวัสดิการ</p>
              <a href="#" class="card-header-icon" aria-label="more options">
                <span class="icon">
                  <i class="fa fa-angle-down" aria-hidden="true"></i>
                </span>
              </a>
            </header>
            <div class="card-content">
              <div class="content">
                <div class="control has-icons-left has-icons-right">
                  <p>นักศึกษาที่ฝึกงานฝสหกิจศึกษาทั้งหมด {{}} คน</p>
                  <p>ฝึกงาน {{}} คน</p>
                  <p>สหกิจศึกษา {{}} คน</p>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="column is-6">
          <div class="panel">
            <p class="panel-heading">Expenses: Daily - $700</p>
            <Bar id="my-chart-id" :options="chartOptions" :data="chartData" />
          </div>
        </div>
        <div class="column is-6">
          <div class="panel">
            <p class="panel-heading">Refunds: Daily - $200</p>
            <div class="panel-block">
              <figure class="image is-16x9">
                <img src="https://placehold.it/1280x720" />
              </figure>
            </div>
          </div>
        </div>
        <div class="column is-6">
          <div class="panel">
            <p class="panel-heading">Something</p>
            <div class="panel-block">
              <figure class="image is-16x9">
                <img src="https://placehold.it/1280x720" />
              </figure>
            </div>
          </div>
        </div>
        <div class="column is-6">
          <div class="panel">
            <p class="panel-heading">Something Else</p>
            <div class="panel-block">
              <figure class="image is-16x9">
                <img src="https://placehold.it/1280x720" />
              </figure>
            </div>
          </div>
        </div>
      </div>
    </main>
    <div class="columns">
      <div class="column is-9">
        <div class="columns"></div>
      </div>
    </div>
  </div>
</template>

<script>
import { Bar } from "vue-chartjs";
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale,
} from "chart.js";
import axios from "axios";
ChartJS.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale
);

export default {
  name: "BarChart",
  components: { Bar },
  data() {
    return {
      reportLists: [],
sortKey: 'job_title',
      chartData: {
        labels: ["January", "February", "March"],
        datasets: [{ data: [40, 20, 12] }],
      },
      chartOptions: {
        responsive: true,
      },
    };
  },
  mounted() {
    this.getReportList();
  },
  methods: {
    getReportList() {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      axios
        .get("http://localhost:3000/admin/ReportList", config)
        .then((response) => {
          this.reportLists = response.data;
          console.log(this.reportLists); // Debug: Log the fetched data
        })
        .catch((error) => {
          console.error('Error fetching report list:', error);
        });
    },
    formatDate(date) {
      return new Date(date).toLocaleDateString();
    },
      sortReports(key) {
  if (this.sortKey === key) {
    this.sortOrder = this.sortOrder === 'asc' ? 'desc' : 'asc';
  } else {
    this.sortKey = key;
    this.sortOrder = 'asc';
  }
},
  },
};
</script>
