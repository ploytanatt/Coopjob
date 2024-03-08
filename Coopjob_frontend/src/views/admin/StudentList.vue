<template>
    <div class="">
      
      <div class="columns">
        
        <sideMenu></sideMenu>
        <div class="column">
         <span>รายชื่อนักศึกษาทั้งหมด</span>
        </div>
      </div>

    
    </div>
</template>
  
  <script>
  //import { Bar } from 'vue-chartjs'
  import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'
  import sideMenu from '@/components/admin/side-menu.vue'
  ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)
  
  export default {
    name: 'BarChart',
   components: { sideMenu },
    data() {
      return {
        chartData: {
          labels: [ 'January', 'February', 'March' ],
          datasets: [ { data: [40, 20, 12] } ]
        },
        chartOptions: {
          responsive: true
        }
      }
    }
  }
  </script>