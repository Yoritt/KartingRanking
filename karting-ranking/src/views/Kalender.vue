<template>
  <!--
    Kalender Pagina

    Deze pagina toont alle geplande race evenementen in een kalender overzicht.
    Gebruikers kunnen zien wanneer wedstrijden plaatsvinden met bijbehorende details.
  -->
  <div class="kalender">
    <!-- Page Header -->
    <section class="page-header bg-dark text-white py-5">
      <div class="container">
        <h1 class="display-4 fw-bold">
          <i class="bi bi-calendar-event me-3"></i>
          Race Kalender
        </h1>
        <p class="lead">Overzicht van alle geplande karting wedstrijden</p>
      </div>
    </section>

    <div class="container my-5">
      <!-- Loading State -->
      <div v-if="loading" class="text-center py-5">
        <div class="spinner-border text-warning" role="status">
          <span class="visually-hidden">Laden...</span>
        </div>
        <p class="text-muted mt-3">Kalender laden...</p>
      </div>

      <!-- Calendar Content -->
      <div v-else>
        <!-- Filter Knoppen -->
        <div class="mb-4 d-flex gap-2 flex-wrap">
          <button
            @click="filterEvents('all')"
            :class="['btn', filter === 'all' ? 'btn-warning' : 'btn-outline-secondary']"
          >
            <i class="bi bi-calendar3 me-2"></i>
            Alle Evenementen
          </button>
          <button
            @click="filterEvents('upcoming')"
            :class="['btn', filter === 'upcoming' ? 'btn-warning' : 'btn-outline-secondary']"
          >
            <i class="bi bi-calendar-check me-2"></i>
            Komende Wedstrijden
          </button>
          <button
            @click="filterEvents('past')"
            :class="['btn', filter === 'past' ? 'btn-warning' : 'btn-outline-secondary']"
          >
            <i class="bi bi-calendar-x me-2"></i>
            Afgelopen Wedstrijden
          </button>
        </div>

        <!-- Events List -->
        <div v-if="filteredEvents.length > 0" class="row g-4">
          <div
            v-for="event in filteredEvents"
            :key="event.id"
            class="col-md-6 col-lg-4"
          >
            <div class="event-card card h-100 shadow-sm border-0">
              <div class="card-header text-white" :class="getEventHeaderClass(event.date)">
                <h5 class="mb-0">
                  <i class="bi bi-flag-fill me-2"></i>
                  {{ event.title }}
                </h5>
              </div>
              <div class="card-body">
                <!-- Datum -->
                <div class="mb-3">
                  <h6 class="text-muted mb-2">
                    <i class="bi bi-calendar-date me-2"></i>
                    Datum
                  </h6>
                  <p class="fw-bold fs-5 text-dark mb-0">
                    {{ formatDate(event.date) }}
                  </p>
                  <small :class="getEventStatusClass(event.date)">
                    {{ getEventStatus(event.date) }}
                  </small>
                </div>

                <!-- Beschrijving -->
                <div v-if="event.description">
                  <h6 class="text-muted mb-2">
                    <i class="bi bi-info-circle me-2"></i>
                    Details
                  </h6>
                  <p class="card-text">{{ event.description }}</p>
                </div>

                <!-- Dagen tot evenement -->
                <div v-if="getDaysUntilEvent(event.date) > 0" class="mt-3">
                  <div class="alert alert-warning py-2 mb-0">
                    <i class="bi bi-clock me-2"></i>
                    <strong>{{ getDaysUntilEvent(event.date) }}</strong>
                    {{ getDaysUntilEvent(event.date) === 1 ? 'dag' : 'dagen' }} te gaan
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Geen evenementen -->
        <div v-else class="text-center py-5">
          <i class="bi bi-calendar-x text-muted" style="font-size: 4rem;"></i>
          <h4 class="mt-3 text-muted">Geen evenementen gevonden</h4>
          <p class="text-muted">
            Er zijn momenteel geen wedstrijden gepland
            {{ filter !== 'all' ? 'in deze categorie' : '' }}
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
/**
 * Kalender Pagina Script
 *
 * Haalt race evenementen op en toont deze in een overzichtelijke kalender.
 * Gebruikers kunnen filteren op komende/afgelopen evenementen.
 */
import { ref, computed, onMounted } from 'vue'
import { supabase } from '../supabaseClient'

// Reactive state
const events = ref([])
const loading = ref(true)
const filter = ref('all') // 'all', 'upcoming', 'past'

/**
 * Haal alle race evenementen op uit de database
 */
const fetchEvents = async () => {
  try {
    loading.value = true

    const { data, error } = await supabase
      .from('race_calendar')
      .select('*')
      .order('date', { ascending: true })

    if (error) {
      console.error('Fout bij ophalen evenementen:', error)
      return
    }

    events.value = data || []
  } catch (err) {
    console.error('Onverwachte fout:', err)
  } finally {
    loading.value = false
  }
}

/**
 * Filter evenementen op basis van geselecteerd filter
 */
const filteredEvents = computed(() => {
  const today = new Date()
  today.setHours(0, 0, 0, 0)

  if (filter.value === 'upcoming') {
    return events.value.filter(event => new Date(event.date) >= today)
  } else if (filter.value === 'past') {
    return events.value.filter(event => new Date(event.date) < today)
  }

  return events.value
})

/**
 * Verander het filter
 */
const filterEvents = (newFilter) => {
  filter.value = newFilter
}

/**
 * Formatteer datum naar leesbaar Nederlands formaat
 */
const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('nl-BE', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

/**
 * Bepaal of evenement in verleden, heden of toekomst is
 */
const getEventStatus = (dateString) => {
  const eventDate = new Date(dateString)
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  eventDate.setHours(0, 0, 0, 0)

  if (eventDate < today) {
    return 'Afgelopen'
  } else if (eventDate.getTime() === today.getTime()) {
    return 'Vandaag!'
  } else {
    return 'Komend'
  }
}

/**
 * CSS class voor event status badge
 */
const getEventStatusClass = (dateString) => {
  const status = getEventStatus(dateString)
  if (status === 'Afgelopen') return 'text-muted'
  if (status === 'Vandaag!') return 'text-danger fw-bold'
  return 'text-success fw-bold'
}

/**
 * CSS class voor card header op basis van datum
 */
const getEventHeaderClass = (dateString) => {
  const status = getEventStatus(dateString)
  if (status === 'Afgelopen') return 'bg-secondary'
  if (status === 'Vandaag!') return 'bg-danger'
  return 'bg-warning text-dark'
}

/**
 * Bereken aantal dagen tot evenement
 */
const getDaysUntilEvent = (dateString) => {
  const eventDate = new Date(dateString)
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  eventDate.setHours(0, 0, 0, 0)

  const diffTime = eventDate - today
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))

  return diffDays > 0 ? diffDays : 0
}

// Laad evenementen bij component mount
onMounted(() => {
  fetchEvents()
})
</script>

<style scoped>
/**
 * Kalender Pagina Custom Styling
 */

/* Page Header */
.page-header {
  background: linear-gradient(135deg, #1a1a1a 0%, #333333 100%);
  border-bottom: 4px solid #ffc107;
}

/* Event Card Hover */
.event-card {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  border-left: 4px solid #ffc107;
}

.event-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2) !important;
}

/* Card Header */
.card-header {
  font-weight: 600;
}

/* Filter Buttons */
.btn {
  transition: all 0.3s ease;
}

.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

/* Responsive */
@media (max-width: 768px) {
  .page-header h1 {
    font-size: 2rem;
  }

  .page-header p {
    font-size: 1rem;
  }
}
</style>
