<template>
  <div>
    <apexchart type="area" height="350" :options="chartOptions" :series="series"></apexchart>
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
          type: 'area',
          height: 350,
          stacked: true,
        },
        colors: ['#EFB495', '#D8B4F8'],
        dataLabels: {
          enabled: false
        },
        stroke: {
          curve: 'smooth'
        },
        fill: {
          type: 'gradient',
          gradient: {
            opacityFrom: 0.6,
            opacityTo: 0.8,
          }
        },
        legend: {
          position: 'top',
          horizontalAlign: 'left'
        },
        xaxis: {
          type: 'datetime',
          categories: [] // we will populate this with our dates
        },
      }
    };
  },
  mounted() {
    this.fetchData();
  },
  methods: {
    fetchData() {
      axios.get('http://localhost:3000/admin/ApplicationList')
        .then(response => {
          this.processData(response.data);
        })
        .catch(error => console.error('Error fetching data:', error));
    },
    processData(data) {
    // Group the data by date and job type
    let groupedData = data.reduce((acc, d) => {
      const date = new Date(d.applied_datetime).toDateString();
      const jobType = d.job_type;
      if (!acc[date]) {
        acc[date] = { internship: 0, cooperative: 0 };
      }
      acc[date][jobType]++;
      return acc;
    }, {});

    // Create series data from the grouped data
    let internshipSeries = [];
    let cooperativeSeries = [];

    Object.entries(groupedData).forEach(([date, counts]) => {
      internshipSeries.push([new Date(date).getTime(), counts.internship]);
      cooperativeSeries.push([new Date(date).getTime(), counts.cooperative]);
    });

    // Sort series data by date
    internshipSeries.sort((a, b) => a[0] - b[0]);
    cooperativeSeries.sort((a, b) => a[0] - b[0]);

    // Extract categories from the series data
    let categories = internshipSeries.map(item => item[0]);

    this.series = [
      { name: 'Internship', data: internshipSeries },
      { name: 'Cooperative', data: cooperativeSeries },
    ];

    this.chartOptions.xaxis.categories = categories;
  }
  }
};
</script>

<style>
#chart {
  max-width: 650px;
  margin: 35px auto;
}
</style>
