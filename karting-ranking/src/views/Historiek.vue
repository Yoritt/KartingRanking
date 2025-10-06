<template>
  <!--
    Historiek Pagina

    Deze pagina toont de eindklassementen per jaar.
    Twee klassementen naast elkaar:
    1. Snelste rondetijden
    2. Beste gemiddelde
    Gerangschikt van recent naar oud.
  -->
  <div class="historiek">
    <!-- Page Header -->
    <section class="page-header bg-dark text-white py-5">
      <div class="container">
        <h1 class="display-4 fw-bold">
          <i class="bi bi-clock-history me-3"></i>
          Historiek
        </h1>
        <p class="lead">Eindklassementen door de jaren heen</p>
      </div>
    </section>

    <div class="container my-5">
      <!-- Loading State -->
      <div v-if="loading" class="text-center py-5">
        <div class="spinner-border text-warning" role="status">
          <span class="visually-hidden">Laden...</span>
        </div>
        <p class="text-muted mt-3">Klassementen laden...</p>
      </div>

      <!-- Content -->
      <div v-else>
        <!-- Loop door elk jaar (van recent naar oud) -->
        <div
          v-for="year in sortedYears"
          :key="year"
          class="year-section mb-5"
        >
          <!-- Jaar Header -->
          <div class="year-header text-center mb-4">
            <h2 class="display-5 fw-bold text-warning">
              <i class="bi bi-trophy-fill me-2"></i>
              Einduitslag {{ year }}
            </h2>
            <hr class="border-warning border-2 opacity-75 w-25 mx-auto">
          </div>

          <!-- Twee Klassementen Naast Elkaar -->
          <div class="row g-4">
            <!-- Klassement 1: Snelste Rondetijden -->
            <div class="col-lg-6">
              <div class="ranking-card card h-100 shadow-lg border-0">
                <div class="card-header bg-warning text-dark">
                  <h4 class="mb-0 text-center">
                    <i class="bi bi-speedometer2 me-2"></i>
                    Snelste Rondetijden
                  </h4>
                </div>
                <div class="card-body">
                  <!-- Ranking Lijst -->
                  <div v-if="getFastestLapRanking(year).length > 0" class="ranking-list">
                    <div
                      v-for="(entry, index) in getFastestLapRanking(year)"
                      :key="entry.id"
                      class="ranking-item d-flex align-items-center py-3 border-bottom"
                      :class="getPositionClass(entry.position)"
                    >
                      <!-- Positie Badge -->
                      <div class="position-badge me-3">
                        <span class="badge fs-5" :class="getPositionBadgeClass(entry.position)">
                          {{ entry.position }}
                        </span>
                      </div>

                      <!-- Rijder Info -->
                      <div class="flex-grow-1">
                        <h5 class="mb-0 fw-bold">{{ entry.driver_name }}</h5>
                        <small class="text-muted">
                          <i class="bi bi-stopwatch me-1"></i>
                          {{ entry.value }}
                        </small>
                      </div>

                      <!-- Medaille voor top 3 -->
                      <div v-if="entry.position <= 3" class="medal ms-2">
                        <i :class="getMedalIcon(entry.position)" style="font-size: 1.5rem;"></i>
                      </div>
                    </div>
                  </div>

                  <!-- Geen data -->
                  <div v-else class="text-center py-4 text-muted">
                    <i class="bi bi-inbox" style="font-size: 2rem;"></i>
                    <p class="mt-2">Geen data beschikbaar</p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Klassement 2: Beste Gemiddelde -->
            <div class="col-lg-6">
              <div class="ranking-card card h-100 shadow-lg border-0">
                <div class="card-header bg-success text-white">
                  <h4 class="mb-0 text-center">
                    <i class="bi bi-graph-up me-2"></i>
                    Beste Gemiddelde
                  </h4>
                </div>
                <div class="card-body">
                  <!-- Ranking Lijst -->
                  <div v-if="getBestAverageRanking(year).length > 0" class="ranking-list">
                    <div
                      v-for="(entry, index) in getBestAverageRanking(year)"
                      :key="entry.id"
                      class="ranking-item d-flex align-items-center py-3 border-bottom"
                      :class="getPositionClass(entry.position)"
                    >
                      <!-- Positie Badge -->
                      <div class="position-badge me-3">
                        <span class="badge fs-5" :class="getPositionBadgeClass(entry.position)">
                          {{ entry.position }}
                        </span>
                      </div>

                      <!-- Rijder Info -->
                      <div class="flex-grow-1">
                        <h5 class="mb-0 fw-bold">{{ entry.driver_name }}</h5>
                        <small class="text-muted">
                          <i class="bi bi-bar-chart me-1"></i>
                          {{ entry.value }}
                        </small>
                      </div>

                      <!-- Medaille voor top 3 -->
                      <div v-if="entry.position <= 3" class="medal ms-2">
                        <i :class="getMedalIcon(entry.position)" style="font-size: 1.5rem;"></i>
                      </div>
                    </div>
                  </div>

                  <!-- Geen data -->
                  <div v-else class="text-center py-4 text-muted">
                    <i class="bi bi-inbox" style="font-size: 2rem;"></i>
                    <p class="mt-2">Geen data beschikbaar</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Geen historiek beschikbaar -->
        <div v-if="sortedYears.length === 0" class="text-center py-5">
          <i class="bi bi-clock-history text-muted" style="font-size: 4rem;"></i>
          <h4 class="mt-3 text-muted">Geen historiek beschikbaar</h4>
          <p class="text-muted">Er zijn nog geen eindklassementen gepubliceerd</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
/**
 * Historiek Pagina Script
 *
 * Haalt eindklassementen op per jaar en toont deze in twee kolommen:
 * - Snelste rondetijden
 * - Beste gemiddelde
 */
import { ref, computed, onMounted } from 'vue'
import { supabase } from '../supabaseClient'

// Reactive state
const rankings = ref([])
const loading = ref(true)

/**
 * Haal alle klassementen op uit de database
 */
const fetchRankings = async () => {
  try {
    loading.value = true

    const { data, error } = await supabase
      .from('year_rankings')
      .select('*')
      .order('year', { ascending: false })
      .order('position', { ascending: true })

    if (error) {
      console.error('Fout bij ophalen klassementen:', error)
      return
    }

    rankings.value = data || []
  } catch (err) {
    console.error('Onverwachte fout:', err)
  } finally {
    loading.value = false
  }
}

/**
 * Haal alle unieke jaren op (gesorteerd van recent naar oud)
 */
const sortedYears = computed(() => {
  const years = [...new Set(rankings.value.map(r => r.year))]
  return years.sort((a, b) => b - a)
})

/**
 * Haal snelste rondetijden ranking op voor een jaar
 */
const getFastestLapRanking = (year) => {
  return rankings.value
    .filter(r => r.year === year && r.ranking_type === 'fastest_lap')
    .sort((a, b) => a.position - b.position)
}

/**
 * Haal beste gemiddelde ranking op voor een jaar
 */
const getBestAverageRanking = (year) => {
  return rankings.value
    .filter(r => r.year === year && r.ranking_type === 'best_average')
    .sort((a, b) => a.position - b.position)
}

/**
 * CSS class voor positie highlight (top 3)
 */
const getPositionClass = (position) => {
  if (position === 1) return 'position-gold'
  if (position === 2) return 'position-silver'
  if (position === 3) return 'position-bronze'
  return ''
}

/**
 * Badge class op basis van positie
 */
const getPositionBadgeClass = (position) => {
  if (position === 1) return 'bg-warning text-dark'
  if (position === 2) return 'bg-secondary'
  if (position === 3) return 'bg-danger'
  return 'bg-dark'
}

/**
 * Medaille icon op basis van positie
 */
const getMedalIcon = (position) => {
  if (position === 1) return 'bi bi-trophy-fill text-warning'
  if (position === 2) return 'bi bi-trophy-fill text-secondary'
  if (position === 3) return 'bi bi-trophy-fill text-danger'
  return ''
}

// Laad data bij component mount
onMounted(() => {
  fetchRankings()
})
</script>

<style scoped>
/**
 * Historiek Pagina Custom Styling
 */

/* Page Header */
.page-header {
  background: linear-gradient(135deg, #1a1a1a 0%, #333333 100%);
  border-bottom: 4px solid #ffc107;
}

/* Year Section */
.year-section {
  padding: 2rem 0;
  border-bottom: 2px dashed #dee2e6;
}

.year-section:last-child {
  border-bottom: none;
}

/* Ranking Card */
.ranking-card {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.ranking-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.2) !important;
}

/* Ranking Item */
.ranking-item {
  transition: background-color 0.3s ease, transform 0.2s ease;
}

.ranking-item:hover {
  background-color: #f8f9fa;
  transform: translateX(5px);
}

.ranking-item:last-child {
  border-bottom: none !important;
}

/* Position Highlights */
.position-gold {
  background: linear-gradient(to right, rgba(255, 193, 7, 0.1), transparent);
}

.position-silver {
  background: linear-gradient(to right, rgba(108, 117, 125, 0.1), transparent);
}

.position-bronze {
  background: linear-gradient(to right, rgba(220, 53, 69, 0.1), transparent);
}

/* Position Badge */
.position-badge {
  min-width: 50px;
  text-align: center;
}

/* Medal Animation */
.medal i {
  animation: shine 2s infinite;
}

@keyframes shine {
  0%, 100% {
    transform: scale(1);
    opacity: 1;
  }
  50% {
    transform: scale(1.1);
    opacity: 0.8;
  }
}

/* Card Headers */
.card-header {
  font-weight: 600;
  border-bottom: 3px solid rgba(0, 0, 0, 0.1);
}

/* Responsive */
@media (max-width: 991px) {
  .col-lg-6:first-child {
    margin-bottom: 2rem;
  }
}

@media (max-width: 768px) {
  .page-header h1 {
    font-size: 2rem;
  }

  .year-header h2 {
    font-size: 1.75rem;
  }

  .ranking-item h5 {
    font-size: 1rem;
  }

  .position-badge .badge {
    font-size: 1rem !important;
  }
}
</style>
