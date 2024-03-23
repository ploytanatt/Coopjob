<template>
  <div id="app">
    <div id="chart">
      <apexchart type="polarArea" width="380" :options="chartOptions" :series="series"></apexchart>
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
      // Initialize with empty series and labels for the four statuses
      series: [],
      chartOptions: {
        chart: {
          type: 'polarArea',
          width: 380,
        },
        colors: ['#FEB019', '#00E396', '#FF4560', '#775DD0'],
        labels: ['Pending', 'Approved', 'Declined', 'Canceled'],
        fill: {
          opacity: 1
        },
        stroke: {
          width: 1
        },
        legend: {
          position: 'bottom'
        },
        theme: {
          monochrome: {
            enabled: false,
            shadeTo: 'light',
            shadeIntensity: 0.6
          }
        }
      }
    };
  },
  mounted() {
    this.fetchApplicationData();
  },
  methods: {
    fetchApplicationData() {
      axios.get('http://localhost:3000/admin/ApplicationList')
        .then(response => {
          this.processApplicationData(response.data);
        })
        .catch(error => console.error('Error fetching data:', error));
    },
    processApplicationData(data) {
      // Initialize status counts
      const statusCounts = {
        'pending': 0,
        'approve': 0,
        'declined': 0,
        'canceled': 0,
      };

      // Count occurrences of each status
      data.forEach(({ application_status }) => {
        if (application_status in statusCounts) {
          statusCounts[application_status]++;
        }
      });

      // Update the series data for the chart
      this.series = Object.values(statusCounts);
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
