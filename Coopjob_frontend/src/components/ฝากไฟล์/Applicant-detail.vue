<template>
  <section class="flex flex-col items-start px-10 pt-12 pb-8 rounded backdrop-blur-[50px] bg-white bg-opacity-80 max-md:px-5">
    <header class="self-stretch mt-10 text-3xl font-bold text-black max-md:mt-10 max-md:max-w-full">
      หากต้องการรับผู้สมัครประเภทสหกิจศึกษา กรุณาทำตามขั้นตอนการรับสมัครเพิ่มเติมดังนี้<br /><br />
    </header>
    <main>
      <section class="mt-4 ml-8 text-3xl font-bold text-black max-md:max-w-full">
        ดาวน์โหลดแบบตอบรับและเสนองานนักศึกษาสหกิจศึกษา <br />
      </section>
      <button class="items-center px-16 pt-2.5 pb-4 mt-4 ml-20 max-w-full text-2xl leading-10 text-black whitespace-nowrap bg-blue-200 rounded w-[485px] max-md:px-5" tabindex="0">
        คลิกที่นี่เพื่อดาวน์โหลดไฟล์ 
      </button>
      <section class="mt-6 ml-9 text-3xl font-bold text-black max-md:max-w-full">
        ทำการกรอกข้อมูลลงในแบบฟอร์มและอัพโหลดไฟล์ลงในช่องด้านล่าง <br />
      </section>
      <section class="mt-6 ml-20 max-w-full w-[846px]">
        <div class="flex gap-5 max-md:flex-col max-md:gap-0 max-md">
          <div class="flex flex-col w-[45%] max-md:ml-0 max-md:w-full">
            <div class="flex flex-col grow px-3 py-7 w-full font-bold whitespace-nowrap bg-white rounded shadow-sm max-md:mt-10">
              <div class="self-center text-2xl text-center text-stone-950">Upload</div>
              <img loading="lazy" src="https://cdn.builder.io/api/v1/image/assets/TEMP/809c51f9c9ec7da16bd54997ea3cf1acbf01197e2a6b604f3e6549a642026311?apiKey=f4177b8746c0432898aa4e4c9932e5c6&" class="self-center mt-2.5 aspect-[1.14] w-[69px]" alt="Upload icon" />
              <div class="mt-3.5 text-xs leading-5 text-center text-stone-500">Supported formats: JPEG, PNG, GIF, MP4, PDF, PSD, AI, Word, PPT</div>
              <button class="justify-center items-center px-16 py-2.5 mt-10 text-sm leading-5 text-white uppercase bg-indigo-800 rounded max-md:px-5" tabindex="0">Upload Files</button>
            </div>
          </div>
          <div class="flex flex-col ml-5 w-[55%] max-md:ml-0 max-md:w-full">
            <div class="flex flex-col mt-3.5 text-center whitespace-nowrap max-md:mt-10 max-md:max-w-full">
              <div class="text-xl font-bold text-black max-md:max-w-full">Uploaded</div>
              <div class="flex gap-5 justify-between px-2.5 py-2.5 mt-4 text-xs leading-5 bg-white rounded border border-green-600 border-solid text-stone-950 max-md:flex-wrap max-md:max-w-full">
                <div class="flex-auto">document-name.PDF</div>
                <img loading="lazy" src="https://cdn.builder.io/api/v1/image/assets/TEMP/b93a1afbb85a8018b26950e21f7ddaaaab9c31f63747a193f69cd070635abe02?apiKey=f4177b8746c0432898aa4e4c9932e5c6&" class="self-start w-4 aspect-square" alt="Delete icon" />
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>
    <footer class="mt-10 ml-7 text-3xl font-bold text-black max-md:max-w-full">
      กด Submit เพื่อส่งเอกสารแบบตอบรับและเสนองานนักศึกษาสหกิจศึกษา <br />
    </footer>
    <div class="flex gap-1.5 self-end mt-28 text-xl text-white whitespace-nowrap max-md:mt-10">
      <button class="grow justify-center px-5 py-4 bg-emerald-400 rounded-2xl" tabindex="0">Submit</button>
      <button class="grow justify-center px-5 py-4 rounded-2xl bg-neutral-700" tabindex="0">Cancel</button>
    </div>
  </section>
</template>
  <script>
  import axios from "@/plugins/axios";
  import Swal from "sweetalert2";
  export default {
    data() {
      return {
        applicationJob: null,
      };
    },
    mounted() {
      // Get application details
      const applicationId = this.$route.params.applicationId;
      this.getApplicationDetails(applicationId);
    },
    methods: {
      getApplicationDetails(applicationId) {
        const token = localStorage.getItem("token");
        const config = {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        };
        axios
          .get(`http://localhost:3000/application/getApplicationDetails/${applicationId}`, config)
          .then((response) => {
            this.applicationJob = response.data[0];
          })
          .catch((error) => {
            console.error(error);
          });
      },
        imagePath(resume) {
        if (resume) {
            return "http://localhost:3000/" + resume.replace(/\\/g, '/').replace('static', '');
        } else {
            return "https://bulma.io/images/placeholders/640x360.png";
        }
        },
      acceptApplicant(applicationJob) {
        const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      const status = 'approve'
        axios.put(
        `http://localhost:3000/application/updateStatus/${applicationJob}`,
        { status },
        config
        )
        .then((res) => {
          Swal.fire(res.data.message, "", "success");
        })
        .catch((error) => {
          console.error(error);
        });
      },
      declineApplicant(applicationJob) {
        const token = localStorage.getItem("token");
      const config = {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      };
      const status = 'reject'
        axios.put(
        `http://localhost:3000/application/updateStatus/${applicationJob}`,
        { status },
        config
        )
        .then((res) => {
          Swal.fire(res.data.message, "", "success");
        })
        .catch((error) => {
          console.error(error);
        });
      },
    },
  };
</script>
  <style scoped>
.preview-pdf {
  width: 100%;
  height: 1000px;
}
  </style>
  