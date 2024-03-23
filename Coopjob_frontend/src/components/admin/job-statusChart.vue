<template>
  <div id="app">
    <div id="chart">
      <apexchart type="pie" width="380" :options="chartOptions" :series="series"></apexchart>
    </div>
  </div>
</template>

<script>
import VueApexCharts from 'vue-apexcharts';
import axios from 'axios';

export default {
  components: {
    apexchart: VueApexCharts,
  },
  data() {
    return {
      series: [],
      chartOptions: {
        chart: {
          width: 380,
          type: 'pie',
        },
        colors: ['#A1EEBD', '#D04848'],
        labels: ['Open', 'Close'],
        responsive: [{
          breakpoint: 480,
          options: {
            chart: {
              width: 200
            },
            legend: {
              position: 'bottom'
            }
          }
        }],
        legend: {
          position: 'right'
        },
      }
    };
  },
  mounted() {
    this.fetchJobData();
  },
  methods: {
    fetchJobData() {
      axios.get('http://localhost:3000/admin/getAllJobs')
        .then(response => {
          this.processJobData(response.data);
        })
        .catch(error => console.error('Error fetching data:', error));
    },
    processJobData(jobs) {
      const jobStatusCount = {
        open: jobs.filter(job => job.job_status === 'open').length,
        close: jobs.filter(job => job.job_status === 'close').length
      };

      this.series = [jobStatusCount.open, jobStatusCount.close];
    }
  }
};
</script>

<style>
#chart {
  max-width: 380px;
  margin: 35px auto;
}
</style>
