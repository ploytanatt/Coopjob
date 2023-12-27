<template>
  <div class="p-6 card">
    <h1 class="title">อัพโหลดไฟล์</h1>
    <div class="field">
      <div class="file is-medium is-boxed has-name">
        <label class="file-label">
          <input class="file-input" type="file" name="resume" />
          <span class="file-cta">
            <span class="file-icon">
              <i class="fas fa-upload"></i>
            </span>
            <span class="file-label"> Upload File </span>
          </span>
          <span class="file-name"> </span>
        </label>
      </div>
      <div class="field">
        <label class="label">เว็บไซต์ของบริษัท</label>
        <div class="control">
          <textarea class="textarea"></textarea>
        </div>
      </div>
      <label class="label">ชื่องาน</label>
      <div class="control">
        <input class="input" type="text" />
      </div>
      <p v-if="$v.title.$error" class="help is-danger">โปรดกรอกชื่องาน</p>
    </div>

    <div class="field">
      <label class="label">สถานะ</label>
      <div class="control">
        <div class="select">
          <select v-model="status">
            <option value="open">เปิดรับสมัคร</option>
            <option value="close">ปิดรับสมัคร</option>
          </select>
        </div>
      </div>
    </div>
    <div class="field">
      <label class="label">รายละเอียดเพิ่มเติม</label>
      <div class="control">
        <textarea class="textarea"></textarea>
      </div>
    </div>
    <div class="field is-grouped">
      <div class="control">
        <button class="button is-primary">บันทึก</button>
      </div>
      <div class="control">
        <button class="button is-link" @click="cancel">ยกเลิก</button>
      </div>
    </div>
  </div>
</template>

<script>
import { required, minValue } from "vuelidate/lib/validators";
//import axios from 'axios';
//import Swal from "sweetalert2";
export default {
  data() {
    return {
      title: "",
      status: "open",
      detail: "",
      companyURL: "",
    };
  },
  methods: {
    cancel() {
      this.$router.push("/recruiterJob");
    },
  },
  validations: {
    title: {
      required,
    },
    location: {
      required,
    },
    salary: {
      required,
      minValue: minValue(0),
    },
    description: {
      required,
    },
    qualifications: {
      required,
    },
    internship_duration: {
      required,
      minValue: minValue(0),
    },
  },
};
</script>

<style scoped>
.card {
  width: 60%;
  margin: 0 auto;
}
</style>
