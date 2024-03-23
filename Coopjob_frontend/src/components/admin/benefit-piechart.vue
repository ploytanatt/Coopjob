<template>
  <div id="app">
    <div class="columns">
      <div class="column is-flex is-justify-content-flex-end">
        <div class="select">
          <select v-model="selectedYear" @change="filterDataByYear">
            <option v-for="year in years" :key="year" :value="year">{{ year }}</option>
          </select>
        </div>
      </div>
    </div>
    <apexchart type="pie" width="380" :options="chartOptions" :series="chartSeries"></apexchart>
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
      selectedYear: '',
      years: [],
      originalData: [],
      chartSeries: [],
      chartOptions: {
        chart: {
          width: 380,
          type: 'pie',
        },
        colors: ['#61A3BA', '#FFCCCC'],
        labels: ['ได้รับค่าแรง', 'ไม่ได้รับค่าแรง'],
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
        }]
      }
    };
  },
  mounted() {
    this.fetchData();
  },
  methods: {
    fetchData() {
      axios.get('http://localhost:3000/admin/BenefitList')
        .then(response => {
          this.originalData = response.data;
          this.years = [...new Set(this.originalData.map(item => new Date(item.created_at).getFullYear()))];
          this.selectedYear = this.years[0];
          this.filterDataByYear();
        })
        .catch(error => console.error('Error fetching data:', error));
    },
    filterDataByYear() {
      const filteredData = this.originalData.filter(item => new Date(item.created_at).getFullYear() === parseInt(this.selectedYear));
      const withSalary = filteredData.filter(item => parseFloat(item.salary) > 0).length;
      const withoutSalary = filteredData.length - withSalary;
      this.chartSeries = [withSalary, withoutSalary];
    }
  }
}
</script>
<style>
.select {
  margin: 20px 0;
}
#chart {
  max-width: 650px;
  margin: 35px auto;
}
</style>
