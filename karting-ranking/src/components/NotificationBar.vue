<template>
  <!--
    Mededelingsbalk Component

    Deze component toont belangrijke mededelingen bovenaan de pagina (onder de navbar).
    Mededelingen worden opgehaald uit de Supabase database.
  -->
  <div v-if="activeNotification" class="notification-bar alert alert-warning mb-0" role="alert">
    <div class="container-fluid d-flex align-items-center justify-content-between">
      <!-- Mededeling icoon en tekst -->
      <div class="d-flex align-items-center">
        <i class="bi bi-megaphone-fill me-2"></i>
        <span>{{ activeNotification.message }}</span>
      </div>

      <!-- Sluit knop -->
      <button
        type="button"
        class="btn-close"
        @click="dismissNotification"
        aria-label="Sluit mededeling"
      ></button>
    </div>
  </div>
</template>

<script setup>
/**
 * NotificationBar Component Script
 *
 * Haalt actieve mededelingen op uit de database en toont deze.
 * Gebruiker kan de mededeling tijdelijk sluiten (wordt opgeslagen in localStorage).
 */
import { ref, onMounted } from 'vue'
import { supabase } from '../supabaseClient'

// Reactive state voor de actieve mededeling
const activeNotification = ref(null)

/**
 * Haal de actieve mededeling op uit de database
 */
const fetchNotification = async () => {
  try {
    // Check eerst of gebruiker de mededeling heeft gesloten
    const dismissedId = localStorage.getItem('dismissedNotificationId')

    // Haal de eerste actieve mededeling op
    const { data, error } = await supabase
      .from('notifications')
      .select('*')
      .eq('active', true)
      .order('created_at', { ascending: false })
      .limit(1)
      .maybeSingle()

    if (error) {
      console.error('Fout bij ophalen mededeling:', error)
      return
    }

    // Toon de mededeling alleen als deze niet eerder is gesloten
    if (data && data.id !== dismissedId) {
      activeNotification.value = data
    }
  } catch (err) {
    console.error('Onverwachte fout:', err)
  }
}

/**
 * Sluit de mededeling
 * Wordt opgeslagen in localStorage zodat deze niet opnieuw verschijnt
 */
const dismissNotification = () => {
  if (activeNotification.value) {
    localStorage.setItem('dismissedNotificationId', activeNotification.value.id)
    activeNotification.value = null
  }
}

// Haal mededeling op wanneer component wordt geladen
onMounted(() => {
  fetchNotification()
})
</script>

<style scoped>
/**
 * NotificationBar Custom Styling
 */

.notification-bar {
  border-radius: 0;
  border: none;
  border-bottom: 3px solid #ffc107;
  background: linear-gradient(135deg, #fff3cd 0%, #ffe69c 100%);
  animation: slideDown 0.5s ease-out;
}

/* Slide down animatie */
@keyframes slideDown {
  from {
    transform: translateY(-100%);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

/* Icon styling */
.notification-bar i {
  font-size: 1.2rem;
  color: #856404;
}

/* Close button styling */
.btn-close {
  opacity: 0.7;
}

.btn-close:hover {
  opacity: 1;
}

/* Responsive text */
@media (max-width: 768px) {
  .notification-bar {
    font-size: 0.9rem;
  }

  .notification-bar i {
    font-size: 1rem;
  }
}
</style>
