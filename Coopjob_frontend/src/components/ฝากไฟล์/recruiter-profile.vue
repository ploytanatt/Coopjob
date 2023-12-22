<template>
  <div>
  <div>
  <label class="typo__label">ประเภทธุกิจ</label>
  <multiselect v-model="value"  placeholder="Search or add a tag" label="title" track-by="title" :options="options" :multiple="true" :taggable="true" @tag="addTag"></multiselect>

</div>
</div>
</template>

<script>
  import Multiselect from 'vue-multiselect'

  export default {
    components: { Multiselect },
    data () {
      return {
      value: [],
      options: [
        { title: 'Vue.js'},
        { title: 'Javascript'},
        { title: 'Open Source'}
      ]
      
    }
  }
}
</script>

<!-- New step!
     Add Multiselect CSS. Can be added as a static asset or inside a component. -->
<style src="vue-multiselect/dist/vue-multiselect.min.css"></style>
