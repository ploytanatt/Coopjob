import Vue from 'vue'
import App from './App.vue'
import router from './router/index'
import Vuelidate from 'vuelidate'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import 'bulma/css/bulma.css'; 
import 'bulma-switch/dist/css/bulma-switch.min.css';
import store from '/store/store';
import VueApexCharts from 'vue-apexcharts'


Vue.use(VueApexCharts)
Vue.component('apexChart', VueApexCharts)
Vue.use(Vuelidate)
Vue.component('font-awesome-icon', FontAwesomeIcon)
// Add XLSX to the Vue prototype


new Vue({
  store,
  router,
  render: h => h(App),
}).$mount('#app')
