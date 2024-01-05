<template>
   <div>
     <div v-for="report in reports" :key="report.report_id">
       <div class="card px-5 py-3">
         <div class="pt-3" style="border-top: 0.5px solid gray">
           <div class="columns p-4">
             <div class="column">
               <p class="is-size-5 has-text-weight-bold"> Report ID: {{ report.report_id }} </p>
             </div>
             <div class="column">
               <p class="is-size-5 has-text-weight-bold"> หัวข้อ: {{ report.title }} </p>
             </div>
             <div class="column">
               <p class="is-size-5 has-text-weight-bold"> รายละเอียด: {{ report.description }} </p>
             </div>
             <div class="column">
               <p class="is-size-5 has-text-weight-bold"> วันที่รายงาน: {{ report.created_at }} </p>
             </div>
           </div>
         </div>
       </div>
     </div>
   </div>
 </template>
 
 <script>
 import axios from "axios";
 export default {
   data() {
     return {
       reports: [],
     };
   },
   mounted() {
     this.getReports();
   },
   methods: {
     async getReports() {
       try {
         const token = localStorage.getItem("token");
         const config = {
           headers: {
             Authorization: `Bearer ${token}`,
           },
         };
 
         const response = await axios.get("http://localhost:3000/application/getReports", config);
         
         // ใช้ JSON.parse(JSON.stringify()) เพื่อ deep clone และลบ Observer ทิ้ง
         this.reports = JSON.parse(JSON.stringify(response.data));
         console.log(this.reports); 
       } catch (error) {
         console.error(error);
       }
     },
   },
 };
 </script>
 
 <style scoped>
 </style>
 