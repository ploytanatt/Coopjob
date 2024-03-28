<template>
  <div class="card">
          <div class="column is-12">
              <div class="columns">
                  <div class="column is-5 mt-4">
                    <div class=" column p-2  card">
                      <div class="mt-2 modify_profile" style="display: flex; flex-direction: column; align-items: flex-end;" >
                        <button class="button mb-3 is-info "  v-show="!modify_profile" @click="modify_profile = !modify_profile"><i class="fa-solid fa-pen-to-square mr-1"></i>แก้ไข</button>
                      </div>
                      <fieldset :disabled="!modify_profile" class="">
                        
                        <div class="field is-horizontal">
                          <div class="field-label is-normal">
                            <label class="label">ปีการศึกษา</label>
                          </div>
                          <div class="field-body ">
                            <!-- ปีการศึกษา -->
                            <div class="field">
                              <p class="control">
                                <input class="input" type="text" v-model="$v.academic_year.$model" :class="{ 'is-danger': $v.academic_year.$error }" placeholder="25xx"/>
                              </p>
                              <template v-if="$v.academic_year.$error">
                                <p class="help is-danger" v-if="!$v.academic_year.required"> โปรดกรอกข้อมูลในช่องนี้</p>
                              </template>
                            </div>
                          </div>
                        </div>
                        
                        <!-- รหัสนักศึกษา -->
                        <div class="field is-horizontal">
                          <div class="field-label is-normal">
                            <label class="label">รหัสนักศึกษา</label>
                          </div>
                          <div class="field-body">        
                            <div class="field">
                              <p class="control">
                                <input class="input" type="text" v-model="$v.studentID.$model" :class="{ 'is-danger': $v.studentID.$error }"/>
                              </p>
                              <template v-if="$v.studentID.$error">
                                <p class="help is-danger" v-if="!$v.studentID.required"> โปรดกรอกข้อมูลในช่องนี้</p>
                              </template>
                            </div>
                          </div>
                        </div>
                        <!-- firstName -->
                        <div class="field is-horizontal">
                          <div class="field-label is-normal">
                            <label class="label">ชื่อ</label>
                          </div>
                          <div class="field-body ">
                            <!-- firstName -->
                            <div class="field">
                              <p class="control">
                                <input class="input" type="text" v-model="$v.firstName.$model" :class="{ 'is-danger': $v.firstName.$error }"/>
                              </p>
                              <template v-if="$v.firstName.$error">
                                <p class="help is-danger" v-if="!$v.firstName.required"> โปรดกรอกข้อมูลในช่องนี้</p>
                              </template>
                            </div>
                            <!-- lastName -->
                            <div class="field">
                              <p class="control">
                                <input class="input" type="text" v-model="$v.lastName.$model" :class="{ 'is-danger': $v.lastName.$error }" />
                              </p>
                              <template v-if="$v.lastName.$error">
                                <p class="help is-danger" v-if="!$v.lastName.required">โปรดกรอกข้อมูลในช่องนี้</p>
                              </template>
                            </div>
                          </div>
                        </div>
                        <!-- Email -->


                        <!-- วันเกิด -->
                        <div class="field is-horizontal">
                          <div class="field-label is-normal">
                            <label class="label">วันเกิด</label>
                          </div>
                          <div class="field-body">
                            <div class="field">
                              <div class="control">
                                <input v-model="$v.birthdate.$model" :class="{ 'is-danger': $v.birthdate.$error }" class="input" type="date" />
                              </div>
                              <template v-if="$v.birthdate.$error">
                                <p class="help is-danger" v-if="!$v.birthdate.required">โปรดกรอกข้อมูลในช่องนี้</p>
                              </template>
                            </div>
                          </div>
                        </div>

                        <!-- เพศ -->
                        <div class="field is-horizontal">
                          <div class="field-label">
                            <label class="label">เพศ</label>
                          </div>
                          <div class="field-body">
                            <div class="field is-narrow">
                              <div class="control">
                                <label class="radio">
                                  <input v-model="$v.gender.$model" :class="{ 'is-danger': $v.gender.$error }" value="ชาย" type="radio" />ชาย
                                </label>
                                <label class="radio">
                                  <input v-model="$v.gender.$model" :class="{ 'is-danger': $v.gender.$error }" value="หญิง" type="radio"/>หญิง</label>
                              </div>
                              <template v-if="$v.gender.$error">
                                <p class="help is-danger" v-if="!$v.gender.required">โปรดกรอกข้อมูลในช่องนี้</p>
                              </template>
                            </div>
                          </div>
                        </div>

                        <!-- ที่อยู่ -->
                        <div class="field is-horizontal">
                          <div class="field-label is-normal">
                            <label class="label">ที่อยู่</label>
                          </div>
                          <div class="field-body">
                            <div class="field">
                              <div class="control">
                                <textarea v-model="$v.address.$model" :class="{ 'is-danger': $v.address.$error }" class="textarea" type="text"></textarea>
                              </div>
                              <template v-if="$v.address.$error">
                                <p class="help is-danger" v-if="!$v.address.required">ปรดกรอกข้อมูลในช่องนี้</p>
                              </template>
                            </div>
                          </div>
                        </div>

                        <!-- เบอร์โทรศัพท์ -->
                        <div class="field is-horizontal">
                          <div class="field-label is-normal">
                            <label class="label">เบอร์ติดต่อ</label>
                          </div>
                          <div class="field-body">
                            <div class="field">
                              <div class="control">
                                <input v-model="$v.phone_number.$model" :class="{ 'is-danger': $v.phone_number.$error }" class="input" type="text"/>
                              </div>
                              <template v-if="$v.phone_number.$error">
                                <p class="help is-danger" v-if="!$v.phone_number.required">โปรดกรอกข้อมูลในช่องนี้</p>
                                <p class="help is-danger" v-if="!$v.phone_number.numeric">โปรดกรอกเป็นตัวเลขเท่านั้น</p>
                                <p class="help is-danger" v-if="!$v.phone_number.minLength">โปรดกรอกตัวเลข 10 หลัก</p>
                                <p class="help is-danger" v-if="!$v.phone_number.maxLength">โปรดกรอกตัวเลข 10 หลัก</p>
                              </template>
                            </div>
                          </div>
                        </div>
                        
                      </fieldset>    
                      <div class="mt-2 modify_profile" >
                        <button class="button m-3 is-success" v-show="modify_profile" @click="saveProfile" :disabled="$v.$error">บันทึก</button>
                        <button class="button mb-3 mt-3 is-danger" v-show="modify_profile" @click="resetProfile">ยกเลิก</button>
                      </div>
                    </div>      
                  </div>
                  <!-- ส่วนของการอัพโหลด -->
                  <div class="column  mt-4 mr-3">
                    <div class="card">
                        <div class="content ">
                            <div class="tabs  is-boxed  mb-0 ">
                              <ul class="mt-0 pl-2 pr-2">
                                <li :class="[select_option === 'resume' ? 'is-active' : '']" @click="select_option = 'resume'">
                                  <a><span>Resume</span></a>
                                </li>
                                <li :class="[select_option === 'transcript' ? 'is-active' : '']" @click="select_option = 'transcript'">
                                  <a><span>Transcript</span></a>
                                </li>
                                <li :class="[select_option === 'portfolio' ? 'is-active' : '']" @click="select_option = 'portfolio'">
                                  <a><span>Portfolio</span>
                                  </a>
                                </li>
                              </ul>
                            </div>
                            <div class="p-2 mt-4">
                              <uploadResume v-if="select_option === 'resume'" ></uploadResume>
                              <uploadTranscript v-if="select_option === 'transcript'"></uploadTranscript>
                              <uploadPortfolio v-if="select_option === 'portfolio'" ></uploadPortfolio>   
                            </div>
                        </div>
                      </div>
                  </div>
              </div>
          </div>
      </div>
</template>
<script>
import {
  required,
  email,
  numeric,
  minLength,
  maxLength,
} from "vuelidate/lib/validators";
import axios from "@/plugins/axios";
import Swal from "sweetalert2";
import uploadResume from "./upload-resume.vue";
import uploadPortfolio from "./upload-portfolio.vue";
import uploadTranscript from "./upload-transcript.vue";
export default {
  components:{
    uploadResume,
    uploadPortfolio,
    uploadTranscript
  },
  data() {
    return {
      firstName: "",
      lastName: "",
      birthdate: "",
      phone_number: "",
      gender: "",
      email: "",
      address: "",
      modify_profile: false,
      resume: "",
      transript:"",
      portfolio:"",
      studentID: "",
      academic_year: "",
      select_option:'resume'
    };
  },
  mounted() {
    this.getUserProfile();

  },
  methods: {
    getUserProfile() {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };

      axios
        .get("http://localhost:3000/applicant/getData", config)
        .then((res) => {
          const user = res.data;
          // console.log("getappProfile",user)
          this.firstName = user[0].firstName;
          this.lastName = user[0].lastName;
          this.birthdate = new Date(user[0].birthdate)
            .toISOString()
            .split("T")[0];
          this.academic_year = user[0].academic_year;
          this.phone_number = user[0].phone_number;
          this.gender = user[0].gender;
          this.email = user[0].email;
          this.address = user[0].address;
          this.studentID = user[0].studentID;
          this.resume = user[0].resume;
          this.transript = user[0].transript;
          this.portfolio = user[0].portfolio;
        });
    },
    saveProfile() {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      this.$v.$touch();
      if (!this.$v.$error) {
      const data = {
        academic_year: this.academic_year,
        studentID: this.studentID,
        firstName: this.firstName,
        lastName: this.lastName,
        birthdate: this.birthdate,
        phone_number: this.phone_number,
        gender: this.gender,
        email: this.email,
        address: this.address,
      };
      axios
        .post("http://localhost:3000/applicant/editProfile", data, config)
        .then((res) => {
          this.$emit("auth-change");
          console.log(res);
          Swal.fire({
            position: "center",
            icon: "success",
            title: "แก้ไขข้อมูลสำเร็จ",
            showConfirmButton: false,
          });
         
        })
        .catch((error) => {
          if (error.response) {
            console.log(error.response.data);
            Swal.fire({
              position: "center",
              icon: "error",
              title: "โปรดกรอกข้อมูลให้ถูกต้อง",
              showConfirmButton: false,
            });
          }
        });
         } 
    },
    resetProfile() {
      this.getUserProfile();
      this.modify_profile = false;
    },
  },
  validations: {
    studentID:{
      required
    },
    firstName: {
      required,
    },
    lastName: {
      required,
    },
    birthdate: {
      required,
    },
    phone_number: {
      required,
      minLength: minLength(10),
      maxLength: maxLength(10),
      numeric,
    },
    gender: {
      required,
    },
    email: {
      required,
      email,
    },
    address: {
      required,
    },
    academic_year:{
      required
    }
  },
};
</script>

<style scoped>
.preview-pdf {
  width: 100%; 
  display: flex;
  justify-content: center; 
  background-color: #424242;
}

.pdf {
  width:80%; 
  height: 1080px;
}

.content ul{
  margin-left: 0;
}
</style>
