import Vue from 'vue'
import App from './App.vue'
import router from './router/index'
import Vuelidate from 'vuelidate'
import 'bulma/css/bulma.css'
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { fas } from '@fortawesome/free-solid-svg-icons';


Vue.use(Vuelidate)
library.add(fas);
Vue.config.productionTip = false
/* eslint-disable */
Vue.component('FontAwesomeIcon', FontAwesomeIcon)
new Vue({
  router,  // add router here
  render: h => h(App),
}).$mount('#app')