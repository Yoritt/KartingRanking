<template>
  <!--
    Home Pagina

    Deze pagina toont:
    - Een grote banner met welkomstboodschap
    - Link naar het huidige jaar Excel bestand met kartuitslagen
    - 4 Random foto's uit de media database
  -->
  <div class="home">
    <!-- Hero Banner Sectie -->
    <section class="hero-banner">
      <div class="hero-overlay">
        <div class="container">
          <div class="hero-content text-center text-white">
            <h1 class="display-3 fw-bold mb-4 animate-fade-in">
              Welkom bij Karting Ranking
            </h1>
            <p class="lead mb-4 animate-fade-in-delay">
              Volg alle karting wedstrijden, bekijk klassementen en blijf op de hoogte!
            </p>
            <div class="d-flex gap-3 justify-content-center animate-fade-in-delay-2">
              <router-link to="/kalender" class="btn btn-warning btn-lg">
                <i class="bi bi-calendar-event me-2"></i>
                Bekijk Kalender
              </router-link>
              <router-link to="/kartuitslagen" class="btn btn-outline-light btn-lg">
                <i class="bi bi-file-earmark-spreadsheet me-2"></i>
                Kartuitslagen
              </router-link>
            </div>
          </div>
        </div>
      </div>
    </section>

    <div class="container my-5">
      <!-- Huidige Jaar Uitslagen Sectie -->
      <section class="current-results mb-5">
        <div class="card shadow-lg border-0">
          <div class="card-body p-5 text-center">
            <h2 class="card-title mb-3">
              <i class="bi bi-trophy-fill text-warning me-2"></i>
              Kartuitslagen {{ currentYear }}
            </h2>
            <p class="text-muted mb-4">
              Bekijk de meest recente uitslagen van dit jaar
            </p>

            <!-- Als er een uitslag is voor dit jaar -->
            <div v-if="currentYearResult">
              <a
                :href="currentYearResult.file_url"
                target="_blank"
                class="btn btn-warning btn-lg"
              >
                <i class="bi bi-download me-2"></i>
                Download Uitslagen {{ currentYear }}
              </a>
            </div>

            <!-- Als er nog geen uitslag is -->
            <div v-else>
              <p class="text-muted">
                <i class="bi bi-info-circle me-2"></i>
                Uitslagen voor {{ currentYear }} zijn nog niet beschikbaar
              </p>
              <router-link to="/historiek" class="btn btn-outline-secondary">
                Bekijk Vorige Jaren
              </router-link>
            </div>
          </div>
        </div>
      </section>

      <!-- Random Foto's Sectie -->
      <section class="random-photos">
        <h2 class="text-center mb-4">
          <i class="bi bi-images me-2"></i>
          Recente Momenten
        </h2>

        <!-- Loading state -->
        <div v-if="loading" class="text-center py-5">
          <div class="spinner-border text-warning" role="status">
            <span class="visually-hidden">Laden...</span>
          </div>
        </div>

        <!-- Foto grid -->
        <div v-else-if="randomPhotos.length > 0" class="row g-4">
          <div
            v-for="photo in randomPhotos"
            :key="photo.id"
            class="col-md-6 col-lg-3"
          >
            <div class="photo-card">
              <img
                :src="photo.url"
                :alt="photo.description || 'Karting foto'"
                class="img-fluid rounded shadow"
              />
              <div class="photo-overlay">
                <p class="text-white mb-0">
                  {{ formatDate(photo.date) }}
                </p>
              </div>
            </div>
          </div>
        </div>

        <!-- Geen foto's beschikbaar -->
        <div v-else class="text-center py-5">
          <i class="bi bi-camera-fill text-muted" style="font-size: 3rem;"></i>
          <p class="text-muted mt-3">Nog geen foto's beschikbaar</p>
        </div>

        <!-- Link naar media pagina -->
        <div class="text-center mt-4">
          <router-link to="/media" class="btn btn-outline-warning btn-lg">
            <i class="bi bi-arrow-right-circle me-2"></i>
            Bekijk Alle Media
          </router-link>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup>
/**
 * Home Pagina Script
 *
 * Haalt data op voor:
 * - Huidige jaar kartuitslagen
 * - Random foto's uit de database
 */
import { ref, onMounted } from 'vue'
import { supabase } from '../supabaseClient'

// Reactive state
const currentYear = new Date().getFullYear()
const currentYearResult = ref(null)
const randomPhotos = ref([])
const loading = ref(true)

/**
 * Haal de uitslag van het huidige jaar op
 */
const fetchCurrentYearResult = async () => {
  try {
    const { data, error } = await supabase
      .from('race_results')
      .select('*')
      .eq('year', currentYear)
      .maybeSingle()

    if (error) {
      console.error('Fout bij ophalen uitslagen:', error)
      return
    }

    currentYearResult.value = data
  } catch (err) {
    console.error('Onverwachte fout:', err)
  }
}

/**
 * Haal 4 random foto's op uit de database
 */
const fetchRandomPhotos = async () => {
  try {
    loading.value = true

    // Haal alle foto's op en sorteer op datum (nieuwste eerst)
    const { data, error } = await supabase
      .from('media')
      .select('*')
      .eq('type', 'photo')
      .order('date', { ascending: false })
      .limit(12) // Haal meer op dan we nodig hebben voor betere randomness

    if (error) {
      console.error('Fout bij ophalen foto\'s:', error)
      return
    }

    // Selecteer 4 random foto's uit de resultaten
    if (data && data.length > 0) {
      const shuffled = data.sort(() => 0.5 - Math.random())
      randomPhotos.value = shuffled.slice(0, 4)
    }
  } catch (err) {
    console.error('Onverwachte fout:', err)
  } finally {
    loading.value = false
  }
}

/**
 * Formatteer datum naar leesbaar formaat
 */
const formatDate = (dateString) => {
  const date = new Date(dateString)
  return date.toLocaleDateString('nl-BE', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
}

// Laad data bij component mount
onMounted(() => {
  fetchCurrentYearResult()
  fetchRandomPhotos()
})
</script>

<style scoped>
/**
 * Home Pagina Custom Styling
 */

/* Hero Banner */
.hero-banner {
  position: relative;
  height: 500px;
  background: linear-gradient(135deg, #1a1a1a 0%, #333333 100%);
  background-size: cover;
  background-position: center;
  background-attachment: fixed;
  display: flex;
  align-items: center;
  justify-content: center;
}

.hero-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
}

.hero-content {
  z-index: 1;
}

/* Animaties */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in {
  animation: fadeIn 1s ease-out;
}

.animate-fade-in-delay {
  animation: fadeIn 1s ease-out 0.3s backwards;
}

.animate-fade-in-delay-2 {
  animation: fadeIn 1s ease-out 0.6s backwards;
}

/* Foto Cards */
.photo-card {
  position: relative;
  overflow: hidden;
  border-radius: 8px;
  transition: transform 0.3s ease;
  cursor: pointer;
}

.photo-card:hover {
  transform: scale(1.05);
}

.photo-card img {
  width: 100%;
  height: 250px;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.photo-card:hover img {
  transform: scale(1.1);
}

.photo-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(to top, rgba(0, 0, 0, 0.8), transparent);
  padding: 1rem;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.photo-card:hover .photo-overlay {
  opacity: 1;
}

/* Card hover effect */
.card {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15) !important;
}

/* Responsive */
@media (max-width: 768px) {
  .hero-banner {
    height: 400px;
  }

  .hero-content h1 {
    font-size: 2rem;
  }

  .hero-content .lead {
    font-size: 1rem;
  }

  .d-flex.gap-3 {
    flex-direction: column;
    gap: 1rem !important;
  }
}
</style>
