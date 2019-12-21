require("@rails/ujs").start()
require("turbolinks").start()

window.axios = require('axios')

let token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
axios.defaults.headers.common['X-CSRF-Token'] = token
axios.defaults.headers.common['Accept'] = 'application/json'

import TurbolinksAdapter from 'vue-turbolinks'
import App from '../application/app.js'
import Vue from 'vue/dist/vue.esm'
import TicketCheckout from '../application/components/TicketCheckout.vue'

Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
      components: {
          TicketCheckout,
      },
  })

  app.$mount('#app')
})
