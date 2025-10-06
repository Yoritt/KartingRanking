/**
 * Vite Configuratie
 *
 * Dit bestand configureert Vite voor de Vue.js applicatie
 */

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    port: 5173
  }
})
