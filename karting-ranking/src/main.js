/**
 * Main Entry Point
 *
 * Dit is het startpunt van de Vue applicatie.
 * Hier worden alle globale imports en configuraties geladen.
 */

import { createApp } from 'vue'
import App from './App.vue'
import router from './router'

// Bootstrap CSS en JavaScript
import 'bootstrap/dist/css/bootstrap.min.css'
import 'bootstrap/dist/js/bootstrap.bundle.min.js'
import 'bootstrap-icons/font/bootstrap-icons.css'

// Custom styles
import './style.css'

// Maak de Vue app aan en mount deze
const app = createApp(App)
app.use(router)
app.mount('#app')
