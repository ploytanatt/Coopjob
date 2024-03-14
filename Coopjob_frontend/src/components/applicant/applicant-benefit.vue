<template>
  <div class="p-6 card" id="benefit_form">
    <h1 class="title">แบบฟอร์มค่าแรงและสวัสดิการ</h1>

    <div class="field">
      <label class="label">ชื่อบริษัท</label>
      <div class="control">
        <input class="input" type="text" v-model="$v.company_name.$model" />
      </div>
      <p v-if="$v.company_name.$error" class="help is-danger">โปรดกรอกชื่อบริษัท</p>
    </div>

    <div class="field">
      <label class="label">ตำแหน่ง</label>
      <div class="control">
        <input class="input" type="text" v-model="$v.job_position.$model" />
      </div>
      <p v-if="$v.job_position.$error" class="help is-danger">โปรดกรอกตำแหน่ง</p>
    </div>

    <div class="field">
      <label class="label">คำอธิบาย</label>
      <div class="control">
        <textarea class="textarea" v-model="$v.description.$model"></textarea>
      </div>
      <p v-if="$v.description.$error" class="help is-danger">โปรดกรอกคำอธิบาย</p>
    </div>

    <div class="field">
      <label class="label">ค่าตอบแทน</label>
      <div class="control">
        <div class="field has-addons">
          <div class="control">
            <input class="input" type="number" v-model="$v.salary.$model" />
          </div>
          <div class="control">
            <a class="button is-static">บาท/วัน</a>
          </div>
        </div>
      </div>
      <p v-if="$v.salary.$error" class="help is-danger">โปรดกรอกค่าตอบแทน</p>
    </div>

    <div class="field">
      <label class="label">สวัสดิการ</label>
      <div class="control">
        <input class="input" type="text" v-model="$v.benefit.$model" />
      </div>
      <p v-if="$v.benefit.$error" class="help is-danger">โปรดกรอกข้อมูลสวัสดิการ</p>
    </div>

    <div class="field is-grouped">
      <div class="control">
        <button class="button is-primary" @click="addBenefit()">บันทึก</button>
      </div>
      <div class="control">
        <button class="button is-link" @click="cancel">ยกเลิก</button>
      </div>
    </div>
  </div>
</template>
  
<script>
import { required } from 'vuelidate/lib/validators';
import axios from 'axios';
import Swal from "sweetalert2";

export default {
  data() {
    return {
      company_name: this.$route.query.companyName || '',
      job_id: this.$route.query.job_id || '',
      job_position: '',
      description: '',
      salary: 0,
      benefit: '',
      existingBenefitData: null,
    };
  },

  mounted() {
    // เรียกใช้งาน checkBenefitHistory เมื่อ component ถูกโหลด
    this.checkBenefitHistory(this.job_id);
  },

  methods: {
    async checkBenefitHistory(jobId) {
      try {
        const token = localStorage.getItem('token');
        const config = {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        };

        const response = await axios.get(`http://localhost:3000/application/checkBenefitHistory?jobId=${jobId}`, config);

        if (response.data.benefitHistory) {
          const benefitData = response.data.benefitHistory;
          // ทำอะไรกับข้อมูลที่ได้รับ เช่น alert หรือแสดงบนหน้าเว็บ
          console.log('Benefit History:', benefitData);
          // ตัวอย่างการแสดงข้อมูลใน Alert
          Swal.fire({
            title: 'คุณกรอกข้อมูลค่าแรงและสวัสดิการเรียบร้อยแล้ว',
            html: `
            <p>ข้อมูลของคุณ:</p>
            <ul>
              <li>ชื่อบริษัท: ${benefitData[0].company_name}</li>
              <li>ตำแหน่ง: ${benefitData[0].position}</li>
              <li>คำอธิบาย: ${benefitData[0].description}</li>
              <li>ค่าตอบแทน: ${benefitData[0].salary}</li>
              <li>สวัสดิการ: ${benefitData[0].benefit}</li>
            </ul>
          `,
            icon: 'info',
            confirmButtonText: 'OK'
          }).then((result) => {
            if (result.isConfirmed) {
              this.$router.push('/MyJobs');
            }
          });


          document.getElementById('benefit_form').style.display = 'none';
        } else {
          console.log('No benefit information found.');
        }
      } catch (error) {
        console.error(error);
        // Handle error
      }
    },

    addBenefit() {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      this.$v.$touch();
      if (!this.$v.$error) {
        const data = {
          company_name: this.company_name,
          job_position: this.job_position,
          description: this.description,
          salary: this.salary,
          benefit: this.benefit,
          job_id: this.job_id, // รวม job_id ในข้อมูล
        };


        axios
          .post("http://localhost:3000/application/addBenefitReport", data, config)
          .then((res) => {
            const message = res.data.message;
            Swal.fire({
              position: "center",
              icon: "success",
              title: "กรอกข้อมูลค่าแรงเรียบร้อย",
              showConfirmButton: message,
            });

            this.$router.push('/MyJobs');

          })
          .catch((error) => {
            if (error.response) {
              console.log("response.data", error.response.data);
            }
          });
      }
    },
    cancel() {
      this.$router.push('/myApproveJob');
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
.card {
  width: 50%;
  margin: 0 auto;
  background-color: #eeeeee;
}

/* Add your existing styles here */
</style>
  