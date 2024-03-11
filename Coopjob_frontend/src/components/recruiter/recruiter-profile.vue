<template>

      <div class="container card-content">
        
        <button v-show="!modify_profile" class="button is-small mb-3 is-info" @click="modify_profile = !modify_profile" ><i class="fa-regular fa-pen-to-square"> แก้ไข</i></button>
      <fieldset :disabled="!modify_profile">
        <label class="label">ผู้ติดต่อ</label>
          <div class="notification contactperson is-rounded">
            <div class="columns">
            <div class="column is-6">
              <div class="field">
                <label class="label">ชื่อผู้ติดต่อ</label>
                <div class="control">
                  <input class="input" type="text"  v-model="$v.contact_person_name.$model"/>
                </div>
        
              </div>
            </div>
            <div class="column is-6">
              <div class="field">
                <label class="label">แผนก</label>
                <div class="control">
                  <div class="control">
                    <input class="input" type="text" v-model="contact_person_department"/>
                </div>
                </div>
              </div>
            </div>
      </div>
          <div class="columns">
        <div class="column is-6">
          <div class="field">
            <label class="label">เบอร์ติดต่อ</label>
            <div class="control">
              <input class="input" type="text" v-model="$v.contact_phone_number.$model" />
            </div>
            <template v-if="$v.contact_phone_number.$error">
              <p v-if="$v.contact_phone_number.$error" class="help is-danger">โปรดกรอกเบอร์โทรศัพท์</p>
            </template>
          </div>
        </div>
        <div class="column is-6">
          <div class="field">
            <label class="label">อีเมลติดต่อ</label>
            <div class="control">
              <div class="control">
                <input class="input" type="text" v-model="$v.contact_email.$model"/>
            </div>
            <template v-if="$v.contact_email.$error">
              <p v-if="$v.contact_email.$error" class="help is-danger">โปรดกรอกอีเมล</p>
            </template>
            </div>
          </div>
        </div>
      </div>
          </div>

          <div class="notification contactperson is-rounded">
        
              <figure class="image">
                <img :src="CoverimagePath(cover_image)" alt="Cover Image" class="image-preview cover_image" v-if="cover_image && !modify_profile"/>
                <img :src="CoverimagePath(cover_image)" alt="Cover Image" class="image-preview cover_image" v-if="cover_image && modify_profile && !cover_image_preview"/>
                <img :src="cover_image_preview" alt="Cover Image" class="image-preview cover_image" v-if="cover_image_preview && modify_profile"/>
                <div class="overlay-icon" v-if="modify_profile">
                  <label class="file-label">
                    <button class="button is-dark">
                      <span class="icon is-large">
                        <i class="fa-regular fa-camera"></i>
                      </span>
                    </button>
                  </label>
                  <input class="file-input" name="cover_image" type="file" @change="handleCoverImageUpload" accept="image/*" />
                </div>
              </figure>
            
     
      
    <div class="card-content">
      <div class="media">
        <div class="media-left">
          <div class="container overlay-container">
            <figure class="image">
              <img  :src="imagePath(profile_image)" alt="Profile Image" class="image-preview profile_image" v-if="profile_image && !modify_profile"  >
              <img :src="imagePath(profile_image)" alt="Profile Image" class="image-preview profile_image"  v-if="profile_image && modify_profile && !profile_image_preview"/>
              <img :src="profile_image_preview" alt="Profile Image" class="image-preview profile_image" v-if="profile_image_preview && modify_profile"/>
              <div class="overlay-icon" v-if="modify_profile">
                <label class="file-label">
                  <button class="button is-dark">
                    <span class="icon is-large">
                      <i class="fa-regular fa-camera"></i>
                    </span>
                  </button>
                </label>
                <input class="file-input" name="profile_image" type="file" @change="handleProfileImageUpload" accept="image/*" />
                
              </div>
            </figure>
          </div>
        </div>

        <div class="media-content">
          <label class="label">ชื่อบริษัท</label>
          <input class="input" type="text"  v-model="$v.company_name.$model" :class="{ 'is-danger': $v.company_name.$error }"/>
          <template v-if="$v.company_name.$error">
            <p class="help is-danger" v-if="!$v.company_name.required">โปรดกรอกข้อมูลในช่องนี้</p>
          </template>
          
          <label class="label">ประเภทธุกิจ</label>
          <multiselect v-model="business_type"  placeholder="Search or add a tag" label="title" track-by="title" :options="options" :multiple="true" :taggable="true" @tag="addTag"></multiselect>
        </div>
      </div>

      <div class="columns">
        <div class="column is-6">
          <div class="field">
            <label class="label">เบอร์โทรศัพท์บริษัท</label>
            <div class="control">
              <input class="input" type="text" v-model="$v.company_phone_number.$model" />
            </div>
            <template v-if="$v.company_phone_number.$error">
              <p v-if="$v.company_phone_number.$error" class="help is-danger">โปรดกรอกคุณสมบัติ</p>
            </template>
          </div>
        </div>
        <div class="column is-6">
          <div class="field">
            <label class="label">เว็บไซต์</label>
            <div class="control">
              <div class="control">
                <input class="input" type="text" v-model="website"/>
            </div>
            </div>
          </div>
        </div>
      </div>
      <div class="columns">
        <div class="column is-3">
          <div class="field">
            <label class="label">บ้านเลขที่ / ซอย</label>
            <div class="control">
              <input class="input" type="text" v-model="$v.address.$model" />
            </div>
            <template v-if="$v.address.$error">
              <p v-if="$v.address.$error" class="help is-danger">โปรดกรอกคุณสมบัติ</p>
            </template>
          </div>
        </div>

        <div class="column is-9">
  <div class="field ">
    <label class="label">ที่อยู่</label>
    <div class="control location">
      <span>ตำบล {{ location[2].tambon }} อำเภอ {{ location[1].amphure }} จังหวัด {{ location[0].province }} {{ location[3].zip_code }}</span>
    
    </div>
  </div>
</div>
      </div>
      <label class="label">แก้ไขที่อยู่</label>
      <div class="select">
              <select v-model="selectedLocation" @change="loadLocationData">
          <option value="">จังหวัด</option>
          <option v-for="province in locations" :key="province.id" :value="province.id">
            {{ province.name_th }}
          </option>
        </select>       
            </div>
            <div class="select">
                <select v-model="selectedAmphure2" @change="loadAmphureData" >
                  <option value="">อำเภอ</option>
                  <option v-for="amphure in selectedProvince.amphure" :key="amphure.id" :value="amphure.id">
                    {{amphure.name_th}}
                  </option>
                </select>
            </div>
            <div class="select">
              <select v-model="selectedTambon2"  @change="loadTambonData">
                <option value="">ตำบล  - รหัสไปรษณี</option>
                <option v-for="tambon in selectedAmphure.tambon" :key="tambon.id" :value="tambon.id">
                  {{ tambon.name_th }} - {{ tambon.zip_code }}
                </option>
              </select>
            </div>

      <div>
        <label class="label">คำอธิบาย</label>
        <textarea class="textarea" v-model="$v.description.$model" :class="{ 'is-danger': $v.description.$error }"></textarea>
        <template v-if="$v.description.$error">
          <p class="help is-danger" v-if="!$v.description.required">โปรดกรอกข้อมูลในช่องนี้</p>
        </template>
      </div>

        <div class="field" >
          <label class="label">วิธีการเดินทาง</label>
          <div class="control">
            <input class="input" type="text" v-model="expedition" />
          </div>
        </div>

        <label class="label">วิดีโอของบริษัท</label>
          <div class="field" v-show="modify_profile">
            <div class="control">
             
              <input class="input" type="text" v-model="company_video" placeholder="url ของยูทูป เช่น https://www.youtube.com/watch?v=A3sBZ5Nr4hc"/>
            </div>
          </div>
            
          <div class="field is-horizontals" >
            <p class="is-size-6"></p>
            <iframe 
                  :src="'https://www.youtube.com/embed/' + getVideoId(company_video)"
                  width="560" 
                  height="315" 
                  frameborder="0" 
                  allowfullscreen
                  v-if="company_video"
                />
          </div>
    </div>
  </div> 
    </fieldset>
      <div class="mt-6 modify_profile">
        <button v-show="!modify_profile" class="button is-small mb-3 is-info" @click="modify_profile = !modify_profile" ><i class="fa-regular fa-pen-to-square"> แก้ไข</i></button>
        <button v-show="modify_profile" class="button is-medium is-success" @click="saveProfile" :disabled="$v.$error">บันทึก</button>
        <button v-show="modify_profile" class="button is-medium is-danger" @click="resetProfile">ยกเลิก</button>
      </div>
      </div>
</template>

<script>
import { required,  email } from 'vuelidate/lib/validators';
import axios from '@/plugins/axios';
import Swal from 'sweetalert2';
import Multiselect from 'vue-multiselect';
import jsonData from '@/assets/api_province_with_amphure_tambon.json'
export default {
  components: {
    Multiselect,
  },
  data() {
    return {
      locations: jsonData,
      selectedLocation: '',
      selectedProvince: '',
      selectedAmphure: '',
      selectedAmphure2: '',
      selectedTambon: '',
      selectedTambon2: '',
      selectedZipCode:'',

      contact_person_name: '',
      contact_phone_number:'',
      contact_email:'',
      contact_person_department:'',

      company_name: '',
      business_type: [],
      company_phone_number:'',
      website:'',
      address:'',
      location:'',
      description: '',
      expedition:'',
      company_video: '',

      profile_image: '',
      profile_image_name: '',
      profile_image_preview: '',
      cover_image: '',
      cover_image_name: '',
      cover_image_preview: '',
      modify_profile: false,  
      status:"เปิด",
      options: [
        { title: 'โฆษณา / ประชาสัมพันธ์'},{ title: 'เกษตรกรรม / ป่าไม้'},
        { title: 'สายการบิน'},{ title: 'ความงาม / เครื่องสำอางค์'},{ title: 'เครื่องดื่ม / อาหาร / ภัตตาคาร'},
        { title: 'อุตสาหกรรมการท่องเที่ยว'},{ title: 'องค์กรการกุศล'},{ title: 'เคมีภัณฑ์ / ปิโตรเคมีภัณฑ์'},
        { title: 'เสื้อผ้า / รองเท้า / เครื่องตกแต่ง'},{ title: 'การก่อสร้าง / การตกแต่ง'},{ title: 'สินค้าอุปโภค / บริโภค'},
        { title: 'บริการพาณิชย์อิเล็กทรอนิกส์'},{ title: 'การศึกษา'},{ title: 'อิเล็คโทรนิกส์ / เครื่องใช้ไฟฟ้า'},
        { title: 'เครื่องจักร'},{ title: 'การเงิน / การธนาคาร / หลักทรัพย์'},{ title: 'เฟอร์นิเจอร์'},
        { title: 'หน่วยงานรัฐบาล'},{ title: 'กราฟฟิก ดีไซน์'},{ title: 'โรงพยาบาล'},{ title: 'โรงแรม / รีสอร์ท'},
        { title: 'ทรัพยากรบุคคล'},{ title: 'ไอที - ฮาร์ดแวร์'},{ title: 'ไอที - ซอฟต์แวร์ / โทรคมนาคม'},
        { title: 'อัญมณี / เครื่องประดับ'},{ title: 'กฎหมาย / ที่ปรึกษาทางธุรกิจ'},{ title: 'การผลิต'},
        { title: 'การตลาด'},{ title: 'การท่องเที่ยว'},{ title: 'กีฬา / นันทนาการ'},{ title: 'อื่นๆ'},
      ]
    };
  },
  mounted() {
  this.getUserProfile();
},
watch: {
    // Watch for changes in selectedLocation, selectedAmphure2, or other properties
    selectedLocation: 'combineData',
    selectedAmphure2: 'combineData',
    selectedTambon2: 'combineData'
  },
  methods: {

    loadLocationData() {
    this.selectedAmphure = '';
    this.selectedTambon = '';
    if (this.selectedLocation) {
      this.selectedProvince = this.locations.find(location => location.id === this.selectedLocation) || {};
    }
    else {
      this.selectedProvince = {};
    }
  },
  loadAmphureData() {
  this.selectedTambon = '';
  if (this.selectedAmphure2) {
    this.selectedAmphure = this.selectedProvince.amphure.find(amphure => amphure.id === this.selectedAmphure2) || {};
    console.log("จังหวัด อำเภอ", this.selectedAmphure)
  }
else {
    this.selectedAmphure = {};
  }
},
loadTambonData() {
  if (this.selectedTambon2) {
    this.selectedTambon = this.selectedAmphure.tambon.find(tambon => tambon.id === this.selectedTambon2) || {};
    console.log("ตำบล", this.selectedTambon)
  } else {
    this.selectedTambon = {};
  }
},
combineData() {
  // รวมข้อมูลจังหวัด, อำเภอ, และตำบล ลงใน property location ในรูปแบบของ array
  this.location = [
    { province: this.selectedProvince.name_th },
    { amphure: this.selectedAmphure.name_th },
    { tambon: this.selectedTambon.name_th },
    { zip_code: this.selectedTambon.zip_code },
  ];
},

    getUserProfile() {
      const token = localStorage.getItem('token');
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'multipart/form-data',
        },
      };
      axios.get('http://localhost:3000/recruiter/getData', config).then((res) => {
        const user = res.data; 
        this.contact_person_name = user[0].contact_person_name;
        this.contact_phone_number = user[0].contact_phone_number;
        this.contact_email = user[0].contact_email;
        this.contact_person_department = user[0].contact_person_department;
        if (user[0].profile_image) {
          this.profile_image = user[0].profile_image.replace(/\\/g, '/').replace('static', '');
          console.log("ชื่อรูปโปร" + this.profile_image)
        }
        if (user[0].cover_image) {
          this.cover_image = user[0].cover_image.replace(/\\/g, '/').replace('static', '');
        }
        this.company_name = user[0].company_name;
        this.company_phone_number = user[0].company_phone_number;
        this.website = user[0].website;
        this.address = user[0].address;
        this.location = JSON.parse(user[0].location);
       // this.location = user[0].location;
        this.expedition = user[0].expedition;
        this.description = user[0].description;
        this.business_type = JSON.parse(user[0].business_type);
        this.role = user[0].role;
        this.company_video = user[0].company_video;

      });
    },
    imagePath(previewProfileImage) {
      if (previewProfileImage) {
        return "http://localhost:3000" + previewProfileImage;
      } else {
        return "https://bulma.io/images/placeholders/640x360.png";
      }
    },

    CoverimagePath(previewCoverImage) {
      if (previewCoverImage) {
        return 'http://localhost:3000' + previewCoverImage;
      } else {
        return 'https://bulma.io/images/placeholders/640x360.png';
      }
    },
    locationArray() {
      try {
        return JSON.parse(this.location);
      } catch (error) {
        console.error('Error parsing location data:', error);
        return null;
      }
    },
    saveProfile() {
      const businessTypeString = JSON.stringify(this.business_type);
      const locationString = JSON.stringify(this.location);
      const token = localStorage.getItem('token');
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'multipart/form-data',
        },
      };
      
      const formData = new FormData();
      formData.append('contact_person_name', this.contact_person_name);
      formData.append('contact_phone_number', this.contact_phone_number);
      formData.append('contact_email', this.contact_email);
      formData.append('contact_person_department', this.contact_person_department);
      formData.append('company_name', this.company_name);
      formData.append('description', this.description);
      formData.append('company_phone_number', this.company_phone_number);
      formData.append('website', this.website);
      formData.append('address', this.address);
      formData.append('location', locationString);
      formData.append('expedition', this.expedition);
      // เพิ่มเงื่อนไขเพื่อตรวจสอบว่ามีการเลือกไฟล์รูปภาพใหม่หรือไม่
      if (this.profile_image && this.profile_image instanceof File) {
        formData.append('profile_image', this.profile_image, this.profile_image_name);
      }
      if (this.cover_image && this.cover_image instanceof File) {
        formData.append('cover_image', this.cover_image, this.cover_image_name);
      }
      formData.append('business_type', businessTypeString);
      formData.append('company_video', this.company_video);
      axios
        .post('http://localhost:3000/recruiter/editProfile', formData, config)
        .then((response) => {
          console.log('Save successful:', response);
          Swal.fire({
            position: 'center',
            icon: 'success',
            title: 'บันทึกข้อมูลสำเร็จ',
            showConfirmButton: false,
          });
          this.getUserProfile();
          this.modify_profile = false;
        })
        .catch((error) => {
          console.error('Save failed:', error);
          if (error.response) {
            console.log('Error response data:', error.response.data);
          }
          Swal.fire({
            position: 'center',
            icon: 'error',
            title: 'เกิดข้อผิดพลาดในการบันทึกข้อมูล',
            showConfirmButton: false,
          });
        });
  },
    handleProfileImageUpload(event) {
      const file = event.target.files[0];
      this.profile_image = file;
      this.profile_image_name = file.name;
      // แสดงตัวอย่างรูปภาพที่อัปโหลด
      const reader = new FileReader();
      reader.onload = () => {
        this.profile_image_preview = reader.result;
      };
      reader.readAsDataURL(file);
    },
    handleCoverImageUpload(event) {
      const file = event.target.files[0];
      this.cover_image = file;
      this.cover_image_name = file.name;
      // แสดงตัวอย่างรูปภาพที่อัปโหลด
      const reader = new FileReader();
      reader.onload = () => {
        this.cover_image_preview = reader.result;
      };
      reader.readAsDataURL(file);
  },
    resetProfile() {
      this.getUserProfile();
      this.modify_profile = false;
    },
    removeItem(item) {
      // ลบรายการที่ถูกเลือก
      this.selectedValues = this.selectedValues.filter(value => value !== item);
    },
    customLabel(option) {
      // กำหนด custom label สำหรับแสดงผลใน dropdown
      return `${option.name} (${option.id})`;
    },
    addTag(newTag) {
      // ฟังก์ชันที่ถูกเรียกเมื่อมีการเพิ่มแท็กใหม่
      console.log("Added new tag:", newTag);
      this.business_type.push({ title: newTag });
    },
    getVideoId(url) {
      const regExp = /^.*(youtu.be\/|v\/|e\/|u\/\w+\/|embed\/|v=)([^#&?]*).*/;
      const match = url.match(regExp);
      if (match && match[2].length === 11) {
        return match[2];
      } else {
        // Handle invalid YouTube URL
        return 'invalid_video_id';
      }
    }
  },
  validations: {
    contact_person_name:{
      required
    },
    contact_phone_number:{
      required,
  
    },
    contact_email:{
      required,
      email
    },
    company_name: {
      required,
    },
    company_phone_number:{
      required,
      
    },
    location:{
      required
    },
    address:{
      required,
    },  
    description: {
      required,
    },

  },
};
</script>
<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>
<style scoped>
.card {
  width: 100%; /* เพิ่มความกว้างของการ์ด ค่าที่เพิ่มขึ้นนี้ขึ้นอยู่กับความต้องการของคุณ */
  margin: 0 auto; /* ใช้ในการจัดวางการ์ดให้อยู่ตรงกลางหน้าจอ */
  background-color: #eeeeee;
}
.profile_image {
  width: 150px;
  height: 150px;
  border: 2px solid gray;
  border-radius: 25px;
}
.cover_image {
  height: 400px;

  border-radius: 10px; /* สามารถปรับค่า border-radius ตามที่ต้องการ */
}

.field.is-horizontals {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}
.selected-items {
  margin-top: 10px;
}
.tag {
  margin-right: 5px;
  margin-bottom: 5px;
}
.overlay-container {
      position: relative;
    }
.overlay-icon {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
.contactperson {
  background-color: rgb(255, 255, 255);
  border: 1px solid rgb(203, 203, 203);

}
.vs__selected-options {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
  }

  .vs__selected-single {
    flex: 1;
  }

.location{
 color: #909090;
  background-color: #f5f5f5;
  border-radius: 5px;
  height: auto;
  padding: 8px;
}
</style>