import Vue from 'vue'
import App from './App.vue'
import router from './router/index'
import Vuelidate from 'vuelidate'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import 'bulma/css/bulma.css'; 
import 'bulma-switch/dist/css/bulma-switch.min.css';

Vue.use(Vuelidate)
Vue.component('font-awesome-icon', FontAwesomeIcon)

new Vue({
  router,
  render: h => h(App),
}).$mount('#app')


