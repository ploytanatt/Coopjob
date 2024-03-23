<template>
  <div>
    <!-- Chart will only render if there is data -->
    <apexchart
      v-if="chartData.length"
      type="bar"
      height="350"
      :options="chartOptions"
      :series="chartData"
    ></apexchart>
  </div>
</template>

<script>
import axios from "axios";
import VueApexCharts from "vue-apexcharts";

export default {
  components: {
    apexchart: VueApexCharts,
  },
  data() {
    return {
      chartData: [],
      chartOptions: {
        chart: {
          type: "bar",
          height: 350,
        },
        plotOptions: {
          bar: {
            horizontal: true,
          },
        },
        colors: ['#FF5722', '#FFC93C', '#8BCDCD'],
        dataLabels: {
          enabled: false,
        },
        xaxis: {
          categories: [],
        },
      },
    };
  },
  mounted() {
    this.fetchData();
  },
  methods: {
    fetchData() {
      axios.get("http://localhost:3000/admin/getAllJobs")
        .then((response) => {
          this.processData(response.data);
        })
        .catch((error) => {
          console.error(error);
        });
    },
    processData(jobData) {
      // Filter out invalid data
      const validJobs = jobData.filter((job) => job.salary !== null);

      // Calculate stats for each company
      let companyStats = validJobs.reduce((acc, { company_name, salary }) => {
        if (!acc[company_name]) {
          acc[company_name] = {
            name: company_name,
            salaries: [salary],
          };
        } else {
          acc[company_name].salaries.push(salary);
        }
        return acc;
      }, {});

      // Convert to array and calculate min, avg, and max
      let seriesData = Object.values(companyStats).map((company) => {
        let min = Math.min(...company.salaries);
        let max = Math.max(...company.salaries);
        let avg = company.salaries.reduce((a, b) => a + b, 0) / company.salaries.length;
        return {
          name: company.name,
          data: [min, avg, max],
        };
      });

      // Update chart data
      this.chartData = [
        {
          name: "Min Salary",
          data: seriesData.map((data) => data.data[0]),
        },
        {
          name: "Avg Salary",
          data: seriesData.map((data) => data.data[1]),
        },
        {
          name: "Max Salary",
          data: seriesData.map((data) => data.data[2]),
        },
      ];

      // Update chart categories
      this.chartOptions.xaxis.categories = seriesData.map((data) => data.name);
    },
  },
};
</script>

<style>
/* Add any additional styling you want here */
</style>
