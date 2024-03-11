<template>
  <div class="p-6 card">
    <fieldset :disabled="!modify_profile">
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">ชื่อ</label>
        </div>
        <div class="field-body">
          <div class="field">
            <p class="control">
              <input
                class="input"
                type="text"
                v-model="$v.firstName.$model"
                :class="{ 'is-danger': $v.firstName.$error }"
              />
            </p>
            <template v-if="$v.firstName.$error">
              <p class="help is-danger" v-if="!$v.user.firstName.required">
                โปรดกรอกข้อมูลในช่องนี้
              </p>
            </template>
          </div>
          <div class="field">
            <p class="control">
              <input
                class="input"
                type="text"
                v-model="$v.lastName.$model"
                :class="{ 'is-danger': $v.lastName.$error }"
              />
            </p>
            <template v-if="$v.lastName.$error">
              <p class="help is-danger" v-if="!$v.lastName.required">
                โปรดกรอกข้อมูลในช่องนี้
              </p>
            </template>
          </div>
        </div>
      </div>
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">อีเมล</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control">
              <input
                v-model="$v.email.$model"
                :class="{ 'is-danger': $v.email.$error }"
                class="input"
                type="text"
              />
            </div>
            <template v-if="$v.email.$error">
              <p class="help is-danger" v-if="!$v.email.required">
                โปรดกรอกข้อมูลในช่องนี้
              </p>
              <p class="help is-danger" v-else-if="!$v.email.email">
                รูปแบบอีเมลไม่ถูกต้อง
              </p>
            </template>
          </div>
        </div>
      </div>
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">วันเกิด</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control">
              <input
                v-model="$v.birthdate.$model"
                :class="{ 'is-danger': $v.birthdate.$error }"
                class="input"
                type="date"
              />
            </div>
            <template v-if="$v.birthdate.$error">
              <p class="help is-danger" v-if="!$v.birthdate.required">
                โปรดกรอกข้อมูลในช่องนี้
              </p>
            </template>
          </div>
        </div>
      </div>
      <div class="field is-horizontal">
        <div class="field-label">
          <label class="label">เพศ</label>
        </div>
        <div class="field-body">
          <div class="field is-narrow">
            <div class="control">
              <label class="radio">
                <input
                  v-model="$v.gender.$model"
                  :class="{ 'is-danger': $v.gender.$error }"
                  value="ชาย"
                  type="radio"
                />ชาย
              </label>
              <label class="radio">
                <input
                  v-model="$v.gender.$model"
                  :class="{ 'is-danger': $v.gender.$error }"
                  value="หญิง"
                  type="radio"
                />หญิง</label
              >
            </div>
            <template v-if="$v.gender.$error">
              <p class="help is-danger" v-if="!$v.gender.required">
                โปรดกรอกข้อมูลในช่องนี้
              </p>
            </template>
          </div>
        </div>
      </div>
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">ที่อยู่</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control">
              <textarea
                v-model="$v.address.$model"
                :class="{ 'is-danger': $v.address.$error }"
                class="textarea"
                type="text"
              ></textarea>
            </div>
            <template v-if="$v.address.$error">
              <p class="help is-danger" v-if="!$v.address.required">
                โปรดกรอกข้อมูลในช่องนี้
              </p>
            </template>
          </div>
        </div>
      </div>
      <div class="field is-horizontal">
        <div class="field-label is-normal">
          <label class="label">เบอร์ติดต่อ</label>
        </div>
        <div class="field-body">
          <div class="field">
            <div class="control">
              <input
                v-model="$v.phone_number.$model"
                :class="{ 'is-danger': $v.phone_number.$error }"
                class="input"
                type="text"
              />
            </div>
            <template v-if="$v.phone_number.$error">
              <p class="help is-danger" v-if="!$v.phone_number.required">
                โปรดกรอกข้อมูลในช่องนี้
              </p>
              <p class="help is-danger" v-if="!$v.phone_number.numeric">
                โปรดกรอกเป็นตัวเลขเท่านั้น
              </p>
              <p class="help is-danger" v-if="!$v.phone_number.minLength">
                โปรดกรอกตัวเลข 10 หลัก
              </p>
              <p class="help is-danger" v-if="!$v.phone_number.maxLength">
                โปรดกรอกตัวเลข 10 หลัก
              </p>
            </template>
          </div>
        </div>
      </div>
    </fieldset>
    <div class="mt-6 modify_profile">
      <button
        v-show="!modify_profile"
        class="button is-medium ml-2 is-info"
        @click="modify_profile = !modify_profile"
      >
        แก้ไข
      </button>
      <button
        v-show="modify_profile"
        class="button is-medium ml-2 is-success"
        @click="saveProfile"
      >
        บันทึก
      </button>
      <button
        v-show="modify_profile"
        class="button is-medium ml-2 is-danger"
        @click="resetProfile"
      >
        ยกเลิก
      </button>
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
export default {
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
          this.phone_number = user[0].phone_number;
          this.gender = user[0].gender;
          this.email = user[0].email;
          this.address = user[0].address;
        });
    },
    saveProfile() {
      const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      const data = {
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
          this.modify_profile = false;
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
    },
    resetProfile() {
      this.getUserProfile();
      this.modify_profile = false;
    },
  },
  validations: {
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
  },
};
</script>

<style scoped>
/* สไตล์ CSS สำหรับฟอร์ม */
</style>
