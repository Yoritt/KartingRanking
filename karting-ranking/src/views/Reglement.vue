<template>
  <!--
    Reglement Pagina

    Deze pagina toont de regels en voorwaarden voor de karting wedstrijden.
    Reglementen worden opgehaald uit de database en kunnen HTML bevatten.
  -->
  <div class="reglement">
    <!-- Page Header -->
    <section class="page-header bg-dark text-white py-5">
      <div class="container">
        <h1 class="display-4 fw-bold">
          <i class="bi bi-file-text me-3"></i>
          Reglement
        </h1>
        <p class="lead">Regels en voorwaarden voor deelname</p>
      </div>
    </section>

    <div class="container my-5">
      <!-- Loading State -->
      <div v-if="loading" class="text-center py-5">
        <div class="spinner-border text-warning" role="status">
          <span class="visually-hidden">Laden...</span>
        </div>
        <p class="text-muted mt-3">Reglement laden...</p>
      </div>

      <!-- Content -->
      <div v-else>
        <!-- Reglement Sectie -->
        <div v-if="rules.length > 0" class="rules-container">
          <div
            v-for="(rule, index) in rules"
            :key="rule.id"
            class="rule-section mb-4"
          >
            <div class="card shadow-sm border-0">
              <div class="card-body p-4">
                <!-- Rule nummer indicator -->
                <div class="rule-number mb-3">
                  <span class="badge bg-warning text-dark fs-5">
                    <i class="bi bi-hash"></i>{{ index + 1 }}
                  </span>
                </div>

                <!-- Rule content (HTML toegestaan) -->
                <div class="rule-content" v-html="rule.content"></div>
              </div>
            </div>
          </div>

          <!-- Belangrijke notitie -->
          <div class="alert alert-warning mt-5" role="alert">
            <h5 class="alert-heading">
              <i class="bi bi-exclamation-triangle-fill me-2"></i>
              Belangrijk
            </h5>
            <p class="mb-0">
              Alle deelnemers dienen zich te houden aan bovenstaande regels.
              Bij overtreding kunnen sancties worden opgelegd.
            </p>
          </div>

          <!-- Contact Info -->
          <div class="card bg-light border-0 mt-4">
            <div class="card-body text-center p-4">
              <h5 class="mb-3">
                <i class="bi bi-question-circle me-2"></i>
                Vragen over het reglement?
              </h5>
              <p class="text-muted mb-3">
                Neem contact met ons op voor verduidelijking
              </p>
              <a
                href="mailto:info@kartingranking.be"
                class="btn btn-warning"
              >
                <i class="bi bi-envelope-fill me-2"></i>
                Contact
              </a>
            </div>
          </div>
        </div>

        <!-- Geen reglement beschikbaar -->
        <div v-else class="text-center py-5">
          <i class="bi bi-file-earmark-text text-muted" style="font-size: 4rem;"></i>
          <h4 class="mt-3 text-muted">Geen reglement beschikbaar</h4>
          <p class="text-muted">Het reglement wordt binnenkort gepubliceerd</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
/**
 * Reglement Pagina Script
 *
 * Haalt reglementen op uit de database en toont deze in volgorde.
 * Ondersteunt HTML content voor rijkere opmaak.
 */
import { ref, onMounted } from 'vue'
import { supabase } from '../supabaseClient'

// Reactive state
const rules = ref([])
const loading = ref(true)

/**
 * Haal alle reglementen op uit de database
 */
const fetchRules = async () => {
  try {
    loading.value = true

    const { data, error } = await supabase
      .from('rules')
      .select('*')
      .order('order_index', { ascending: true })

    if (error) {
      console.error('Fout bij ophalen reglement:', error)
      return
    }

    rules.value = data || []
  } catch (err) {
    console.error('Onverwachte fout:', err)
  } finally {
    loading.value = false
  }
}

// Laad data bij component mount
onMounted(() => {
  fetchRules()
})
</script>

<style scoped>
/**
 * Reglement Pagina Custom Styling
 */

/* Page Header */
.page-header {
  background: linear-gradient(135deg, #1a1a1a 0%, #333333 100%);
  border-bottom: 4px solid #ffc107;
}

/* Rules Container */
.rules-container {
  max-width: 900px;
  margin: 0 auto;
}

/* Rule Section */
.rule-section {
  animation: fadeInUp 0.5s ease-out;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.rule-section .card {
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  border-left: 4px solid #ffc107;
}

.rule-section .card:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15) !important;
}

/* Rule Number Badge */
.rule-number {
  display: inline-block;
}

/* Rule Content Styling */
.rule-content {
  color: #333;
  line-height: 1.8;
}

/* Style HTML content binnen regel */
.rule-content :deep(h1),
.rule-content :deep(h2),
.rule-content :deep(h3),
.rule-content :deep(h4) {
  color: #212529;
  margin-top: 1.5rem;
  margin-bottom: 1rem;
  font-weight: 600;
}

.rule-content :deep(h1) {
  font-size: 1.75rem;
}

.rule-content :deep(h2) {
  font-size: 1.5rem;
}

.rule-content :deep(h3) {
  font-size: 1.25rem;
}

.rule-content :deep(p) {
  margin-bottom: 1rem;
}

.rule-content :deep(ul),
.rule-content :deep(ol) {
  margin-left: 1.5rem;
  margin-bottom: 1rem;
}

.rule-content :deep(li) {
  margin-bottom: 0.5rem;
}

.rule-content :deep(strong),
.rule-content :deep(b) {
  color: #212529;
  font-weight: 600;
}

.rule-content :deep(em),
.rule-content :deep(i) {
  font-style: italic;
}

.rule-content :deep(a) {
  color: #ffc107;
  text-decoration: none;
  font-weight: 500;
}

.rule-content :deep(a:hover) {
  text-decoration: underline;
}

/* Alert Styling */
.alert-warning {
  border-left: 4px solid #ffc107;
}

/* Responsive */
@media (max-width: 768px) {
  .page-header h1 {
    font-size: 2rem;
  }

  .rule-content {
    font-size: 0.95rem;
  }
}
</style>
