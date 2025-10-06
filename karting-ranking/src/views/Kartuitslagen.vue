<template>
  <!--
    Kartuitslagen Pagina

    Deze pagina toont uitslagen per jaar in dropdown formaat.
    Gebruikers kunnen het Excel bestand bekijken in een iframe en exporteren als PDF.
  -->
  <div class="kartuitslagen">
    <!-- Page Header -->
    <section class="page-header bg-dark text-white py-5">
      <div class="container">
        <h1 class="display-4 fw-bold">
          <i class="bi bi-file-earmark-spreadsheet me-3"></i>
          Kartuitslagen
        </h1>
        <p class="lead">Bekijk de race uitslagen per jaar</p>
      </div>
    </section>

    <div class="container my-5">
      <!-- Loading State -->
      <div v-if="loading" class="text-center py-5">
        <div class="spinner-border text-warning" role="status">
          <span class="visually-hidden">Laden...</span>
        </div>
        <p class="text-muted mt-3">Uitslagen laden...</p>
      </div>

      <!-- Content -->
      <div v-else>
        <!-- Jaar Selectie -->
        <div class="row mb-4">
          <div class="col-md-6 col-lg-4">
            <label for="yearSelect" class="form-label fw-bold">
              <i class="bi bi-calendar3 me-2"></i>
              Selecteer Jaar
            </label>
            <select
              id="yearSelect"
              v-model="selectedYear"
              class="form-select form-select-lg shadow-sm"
              @change="onYearChange"
            >
              <option value="">-- Kies een jaar --</option>
              <option
                v-for="result in yearResults"
                :key="result.year"
                :value="result.year"
              >
                {{ result.year }}
              </option>
            </select>
          </div>
        </div>

        <!-- Geselecteerd Jaar Info -->
        <div v-if="selectedYearData" class="card shadow-lg border-0 mb-4">
          <div class="card-header bg-warning text-dark">
            <h4 class="mb-0">
              <i class="bi bi-trophy me-2"></i>
              Uitslagen {{ selectedYear }}
            </h4>
          </div>
          <div class="card-body">
            <div class="d-flex flex-wrap gap-3 mb-4">
              <!-- Download Knop -->
              <a
                :href="selectedYearData.file_url"
                target="_blank"
                class="btn btn-warning btn-lg"
              >
                <i class="bi bi-download me-2"></i>
                Download Excel
              </a>

              <!-- Instructies -->
              <div class="alert alert-info mb-0 flex-grow-1">
                <i class="bi bi-info-circle me-2"></i>
                <strong>Tip:</strong> Download het Excel bestand om alle tabbladen te bekijken.
                Het bestand kan je lokaal openen of exporteren naar PDF.
              </div>
            </div>

            <!-- Excel Viewer (iframe voor Google Sheets preview) -->
            <div v-if="isGoogleSheetsLink" class="excel-viewer-container">
              <h5 class="mb-3">
                <i class="bi bi-eye me-2"></i>
                Preview
              </h5>
              <div class="ratio ratio-16x9 shadow rounded overflow-hidden">
                <iframe
                  :src="getGoogleSheetsPreviewUrl"
                  frameborder="0"
                  allowfullscreen
                ></iframe>
              </div>
              <p class="text-muted small mt-2">
                <i class="bi bi-lightbulb me-1"></i>
                Gebruik de tabs onderaan om tussen verschillende tabbladen te navigeren
              </p>
            </div>

            <!-- Alternatieve weergave voor niet-Google Sheets links -->
            <div v-else class="alert alert-warning">
              <i class="bi bi-exclamation-triangle me-2"></i>
              Voor de beste ervaring, gebruik de download knop om het Excel bestand te openen.
            </div>
          </div>
        </div>

        <!-- Geen jaar geselecteerd -->
        <div v-else-if="yearResults.length > 0" class="text-center py-5">
          <i class="bi bi-hand-index text-warning" style="font-size: 4rem;"></i>
          <h4 class="mt-3 text-muted">Selecteer een jaar hierboven</h4>
          <p class="text-muted">Kies een jaar uit de dropdown om de uitslagen te bekijken</p>
        </div>

        <!-- Geen uitslagen beschikbaar -->
        <div v-if="yearResults.length === 0" class="text-center py-5">
          <i class="bi bi-inbox text-muted" style="font-size: 4rem;"></i>
          <h4 class="mt-3 text-muted">Geen uitslagen beschikbaar</h4>
          <p class="text-muted">Er zijn momenteel nog geen kartuitslagen gepubliceerd</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
/**
 * Kartuitslagen Pagina Script
 *
 * Toont uitslagen per jaar met mogelijkheid om Excel te bekijken en downloaden.
 * Ondersteunt Google Sheets links voor inline preview.
 */
import { ref, computed, onMounted } from 'vue'
import { supabase } from '../supabaseClient'

// Reactive state
const yearResults = ref([])
const selectedYear = ref('')
const loading = ref(true)

/**
 * Haal alle beschikbare jaren met uitslagen op
 */
const fetchYearResults = async () => {
  try {
    loading.value = true

    const { data, error } = await supabase
      .from('race_results')
      .select('*')
      .order('year', { ascending: false })

    if (error) {
      console.error('Fout bij ophalen uitslagen:', error)
      return
    }

    yearResults.value = data || []

    // Selecteer automatisch het meest recente jaar
    if (yearResults.value.length > 0) {
      selectedYear.value = yearResults.value[0].year
    }
  } catch (err) {
    console.error('Onverwachte fout:', err)
  } finally {
    loading.value = false
  }
}

/**
 * Get data voor geselecteerd jaar
 */
const selectedYearData = computed(() => {
  if (!selectedYear.value) return null
  return yearResults.value.find(result => result.year === selectedYear.value)
})

/**
 * Check of de link een Google Sheets link is
 */
const isGoogleSheetsLink = computed(() => {
  if (!selectedYearData.value) return false
  const url = selectedYearData.value.file_url
  return url.includes('docs.google.com/spreadsheets') || url.includes('drive.google.com')
})

/**
 * Converteer Google Sheets link naar preview URL
 */
const getGoogleSheetsPreviewUrl = computed(() => {
  if (!selectedYearData.value) return ''

  let url = selectedYearData.value.file_url

  // Converteer verschillende Google Sheets URL formaten naar embed formaat
  if (url.includes('/edit')) {
    url = url.replace('/edit', '/preview')
  } else if (!url.includes('/preview')) {
    // Voeg /preview toe als het er nog niet is
    const docId = extractGoogleDocId(url)
    if (docId) {
      url = `https://docs.google.com/spreadsheets/d/${docId}/preview`
    }
  }

  return url
})

/**
 * Extract Google Doc ID uit URL
 */
const extractGoogleDocId = (url) => {
  const match = url.match(/\/d\/([a-zA-Z0-9-_]+)/)
  return match ? match[1] : null
}

/**
 * Handler voor jaar wijziging
 */
const onYearChange = () => {
  // Scroll naar de content
  if (selectedYearData.value) {
    window.scrollTo({ top: 300, behavior: 'smooth' })
  }
}

// Laad data bij component mount
onMounted(() => {
  fetchYearResults()
})
</script>

<style scoped>
/**
 * Kartuitslagen Pagina Custom Styling
 */

/* Page Header */
.page-header {
  background: linear-gradient(135deg, #1a1a1a 0%, #333333 100%);
  border-bottom: 4px solid #ffc107;
}

/* Year Select Dropdown */
.form-select {
  border: 2px solid #dee2e6;
  transition: all 0.3s ease;
}

.form-select:focus {
  border-color: #ffc107;
  box-shadow: 0 0 0 0.2rem rgba(255, 193, 7, 0.25);
}

/* Card Styling */
.card {
  transition: transform 0.3s ease;
}

/* Excel Viewer */
.excel-viewer-container {
  background: #f8f9fa;
  padding: 1.5rem;
  border-radius: 8px;
}

.excel-viewer-container iframe {
  border: 3px solid #dee2e6;
  border-radius: 8px;
}

/* Button Hover */
.btn-warning {
  transition: all 0.3s ease;
}

.btn-warning:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(255, 193, 7, 0.4);
}

/* Responsive */
@media (max-width: 768px) {
  .page-header h1 {
    font-size: 2rem;
  }

  .excel-viewer-container {
    padding: 1rem;
  }
}
</style>
