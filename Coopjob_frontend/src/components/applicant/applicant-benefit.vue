<template>
  <div class="columns">
    <applicantSideMenu></applicantSideMenu>
    
    <div class="mt-4 card column" id="benefit_form">
      <section class="hero is-dark welcome is-small">
        <div class="hero-body">
          
            <p class="is-size-2">แบบฟอร์มค่าแรงและสวัสดิการ</p>
   
        </div>
      </section>
      <div class="job-card card mt-4">
        <div class="job-card-header">
          <span class="job-date">แบบฟอร์มค่าแรงและสวัสดิการ</span>
          <span class="job-date">{{ formatDate(benefit_history.created_at) }}</span>
        </div>
        <hr>
        <fieldset :disabled="!modify_benefit">
          <div class="job-card-body mt-3">
            <div class="field">
              <label class="label">ชื่อบริษัท</label>
              <div class="control">
                <input class="input" type="text" v-model="company_name" />
              </div>
            </div>

            <div class="field">
              <label class="label">ตำแหน่ง</label>
              <div class="control">
                <input class="input" type="text" v-model="job_position" />
              </div>
            </div>



            <div class="field">
              <label class="label">ค่าตอบแทนที่ได้รับจริง</label>
              <div class="control">
                <div class="field has-addons">
                  <div class="control">
                    <input class="input" type="text" v-model="salary" />
                  </div>
                  <div class="control">
                    <a class="button is-static">บาท/วัน</a>
                  </div>
                </div>
              </div>
            </div>

            <div class="field">
              <label class="label">สวัสดิการที่ได้รับจริง</label>
              <div class="control">
                <input class="input" type="text" v-model="benefit" />
              </div>
            </div>
          </div>

          <div class="field">
              <label class="label">คำอธิบาย</label>
              <div class="control">
                <textarea class="textarea" v-model="description"></textarea>
              </div>
            </div>
        </fieldset>

        <button class="button is-info is-small" v-if="!modify_benefit" @click="modify_benefit = true">
          <i class="fa-solid fa-pen-to-square mr-1"></i>แก้ไข
        </button>
        <div v-if="modify_benefit" class="mt-2 modify_benefit">
          <button class="button ml-0 m-3 is-success is-small" @click="saveBenefit">บันทึก</button>
          <button class="button mb-3 mt-3 is-danger is-small" @click="resetBenefit">ยกเลิก</button>
        </div>
      </div>
    </div>
  </div>
</template>

  
<script>
import { required } from 'vuelidate/lib/validators';
import axios from 'axios';
import Swal from "sweetalert2";
import applicantSideMenu from './applicant-side-menu.vue';

export default {
  components:{
    applicantSideMenu
  },
  data() {
    return {
      company_name:'',
      job_id: this.$route.query.job_id || '',
      job_position: '',
      description: '',
      salary: 0,
      benefit: '',
      modify_benefit: false,
      benefit_history:[],
      benefit_id:''
    };
  },

  mounted() {
    // เรียกใช้งาน checkBenefitHistory เมื่อ component ถูกโหลด
    this.getBenefitHistory()
  },

  methods: {
    getBenefitHistory(){
            const token = localStorage.getItem("token");
            const config = {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            };
            axios.get("http://localhost:3000/application/getBenefitHistory", config)
                .then((res) => {
                    this.benefit_history = res.data[0];
                    this.company_name = res.data[0].company_name
                    this.job_position = res.data[0].position;
                    this.description = res.data[0].description;
                    this.salary = res.data[0].salary;
                    this.benefit = res.data[0].benefit;
                    this.benefit_id = res.data[0].benefit_id;
                })
                .catch((error) => {
                    console.error(error);
                });
        },
        saveBenefit() {
    const token = localStorage.getItem("token");
    const config = {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    };

    const benefitData = {
      company_name: this.company_name,
      job_position: this.job_position,
      description: this.description,
      salary: this.salary,
      benefit: this.benefit,
      benefit_id: this.benefit_id
    };

    axios.put("http://localhost:3000/application/updateBenefit", benefitData, config)
      .then(response => {
        Swal.fire({
          icon: 'success',
          title: 'บันทึกข้อมูลเรียบร้อย',
          text: response.data.message,
          confirmButtonText: 'ตกลง'
        });

        this.modify_benefit = false;
      })
      .catch(error => {
        // มีข้อผิดพลาดในการบันทึกข้อมูล
        console.error('Error saving benefit:', error);
        Swal.fire({
          icon: 'error',
          title: 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
          text: 'ไม่สามารถบันทึกข้อมูลได้',
          confirmButtonText: 'ตกลง'
        });
      });
  },

  resetBenefit() {
    // คืนค่าในฟอร์มให้เป็นข้อมูลเดิม
    this.getBenefitHistory();
    this.modify_benefit = false;
  },
    formatDate(dateString) {
      const date = new Date(dateString);
      const options = {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hour12: false
      };
      return date.toLocaleDateString('en-EN', options);
    },
  },
  validations: {
    company_name: {
      required,
    },
    job_position: {
      required,
    },
    description: {
      required,
    },
    salary: {
      required,
    },
    benefit: {
      required,
    },
  },
};
</script>
  
<style scoped>
.job-card {
  background-color: #F8F8FD;
  border-radius: 6px;
  padding: 16px;
  box-shadow: 0 2px 4px #0000002d;
  
  margin-right: 16px;
  margin-bottom: 16px; 
  width: 380px; 
}

.job-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px; 
}

.job-title {
  font-weight: bold;
  color: #333;
}

.job-date {
  color: #666; 
  font-size: 0.875rem;
}

.job-card-body p {
  margin: 0;
  
}

.job-role {
  font-size: 1.125rem;
  font-weight: bold;
  margin-bottom: 4px;
}

.job-details {
  font-size: 0.875rem;
  color: #666; 
}

hr {
  border: none;
  height: 1px;
  background-color: #ddd; 
  margin-bottom: 8px; 
}

.CompanyLogo{
width: 100px;
border: 1px solid rgb(240, 240, 240);
border-radius: 5px;
transition: width 0.3s ease-in-out;
}
</style>
  