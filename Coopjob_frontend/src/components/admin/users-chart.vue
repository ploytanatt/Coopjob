<template>
  <div>
    <apexchart type="bar" height="350" :options="chartOptions" :series="chartSeries"></apexchart>
  </div>
</template>

<script>
import VueApexCharts from 'vue-apexcharts'
import axios from 'axios'

export default {
  components: {
    apexchart: VueApexCharts,
  },
  data() {
    return {
      chartOptions: {
        colors: ['#B2EBF2', '#64B2CD'],
        chart: {
          type: 'bar',
          height: 350
        },
        plotOptions: {
          bar: {
            horizontal: false,
            columnWidth: '55%',
            endingShape: 'rounded'
          },
        },
        dataLabels: {
          enabled: false
        },
        stroke: {
          show: true,
          width: 2,
          colors: ['transparent']
        },
        xaxis: {
        categories: [],
   
        },
        yaxis: {
          title: {
            text: 'Number of Users'
          }
        },
        fill: {
          opacity: 1
        },
        legend: {
          position: 'right',
          offsetY: 40
        },
        title: {
          text: 'Number of Users by Role per Year',
          align: 'center'
        },
      },
      chartSeries: []
    }
  },
  mounted() {
    this.loadUserData();
  },
  methods: {
    async loadUserData() {
      try {
        const response = await axios.get('http://localhost:3000/admin/Allusers');
        this.processUserData(response.data);
      } catch (error) {
        console.error('Error loading user data:', error);
      }
    },
  processUserData(users) {
      let dataMap = {
        recruiter: {},
        applicant: {}
      };

      users.forEach(user => {
        const year = new Date(user.created_at).getFullYear();
        
        if (!dataMap[user.role][year]) {
          dataMap[user.role][year] = 0;
        }
        dataMap[user.role][year]++;
      });

      let years = [...new Set(Object.keys(dataMap.recruiter).concat(Object.keys(dataMap.applicant)))].sort();

      let series = [
        {
          name: 'Recruiter',
          data: years.map(year => dataMap.recruiter[year] || 0)
        },
        {
          name: 'Applicant',
          data: years.map(year => dataMap.applicant[year] || 0)
        }
      ];

      // Update xaxis categories with sorted years

     this.chartOptions = {
    ...this.chartOptions,
    xaxis: {
      ...this.chartOptions.xaxis,
      categories: years
    }
  };
  this.chartSeries = series;
    }
  

  }
}
</script>
