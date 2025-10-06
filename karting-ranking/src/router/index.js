/**
 * Vue Router Configuratie
 *
 * Dit bestand definieert alle routes voor de applicatie.
 * Elke route koppelt een URL pad aan een Vue component.
 */

import { createRouter, createWebHistory } from 'vue-router'

// Importeer alle view components
import Home from '../views/Home.vue'
import Kalender from '../views/Kalender.vue'
import Kartuitslagen from '../views/Kartuitslagen.vue'
import Historiek from '../views/Historiek.vue'
import Reglement from '../views/Reglement.vue'
import Media from '../views/Media.vue'

/**
 * Route definities
 *
 * Elke route heeft:
 * - path: De URL (bijv. '/kalender')
 * - name: Een unieke naam voor de route
 * - component: De Vue component die getoond wordt
 */
const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/kalender',
    name: 'Kalender',
    component: Kalender
  },
  {
    path: '/kartuitslagen',
    name: 'Kartuitslagen',
    component: Kartuitslagen
  },
  {
    path: '/historiek',
    name: 'Historiek',
    component: Historiek
  },
  {
    path: '/reglement',
    name: 'Reglement',
    component: Reglement
  },
  {
    path: '/media',
    name: 'Media',
    component: Media
  }
]

/**
 * Maak de router instantie aan
 */
const router = createRouter({
  history: createWebHistory(),
  routes,
  // Scroll naar boven bij route wijziging
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else {
      return { top: 0 }
    }
  }
})

export default router
