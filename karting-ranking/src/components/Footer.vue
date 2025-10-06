<template>
  <!--
    Footer Component

    Deze component toont de footer van de website met:
    - Copyright informatie
    - Inschrijfmogelijkheid voor kartuitslagen via email
    - Social media links (optioneel)
  -->
  <footer class="footer bg-dark text-light mt-auto">
    <div class="container py-5">
      <div class="row g-4">
        <!-- Kolom 1: Over -->
        <div class="col-md-4">
          <h5 class="text-warning mb-3">
            <i class="bi bi-flag-fill me-2"></i>
            Karting Ranking
          </h5>
          <p class="text-muted">
            Volg alle karting wedstrijden, uitslagen en klassementen.
            Blijf op de hoogte van het laatste nieuws!
          </p>
        </div>

        <!-- Kolom 2: Snelle Links -->
        <div class="col-md-4">
          <h5 class="text-warning mb-3">Snelle Links</h5>
          <ul class="list-unstyled">
            <li class="mb-2">
              <router-link to="/" class="footer-link">
                <i class="bi bi-chevron-right me-1"></i>
                Home
              </router-link>
            </li>
            <li class="mb-2">
              <router-link to="/kalender" class="footer-link">
                <i class="bi bi-chevron-right me-1"></i>
                Kalender
              </router-link>
            </li>
            <li class="mb-2">
              <router-link to="/kartuitslagen" class="footer-link">
                <i class="bi bi-chevron-right me-1"></i>
                Kartuitslagen
              </router-link>
            </li>
            <li class="mb-2">
              <router-link to="/historiek" class="footer-link">
                <i class="bi bi-chevron-right me-1"></i>
                Historiek
              </router-link>
            </li>
          </ul>
        </div>

        <!-- Kolom 3: Inschrijven -->
        <div class="col-md-4">
          <h5 class="text-warning mb-3">Inschrijven</h5>
          <p class="text-muted small">
            Ontvang automatisch de kartuitslagen via email
          </p>
          <!-- Email knop die email client opent -->
          <a
            :href="emailLink"
            class="btn btn-warning btn-lg w-100"
            target="_blank"
          >
            <i class="bi bi-envelope-fill me-2"></i>
            Inschrijven via Email
          </a>
          <p class="text-muted small mt-2">
            Klik om je email client te openen
          </p>
        </div>
      </div>

      <!-- Onderste sectie: Copyright -->
      <div class="row mt-4 pt-4 border-top border-secondary">
        <div class="col-md-6 text-center text-md-start">
          <p class="mb-0 text-muted">
            &copy; {{ currentYear }} Karting Ranking. Alle rechten voorbehouden.
          </p>
        </div>
        <div class="col-md-6 text-center text-md-end">
          <p class="mb-0 text-muted">
            Gemaakt met <i class="bi bi-heart-fill text-danger"></i> voor karting liefhebbers
          </p>
        </div>
      </div>
    </div>
  </footer>
</template>

<script setup>
/**
 * Footer Component Script
 *
 * Genereert een mailto link voor inschrijvingen
 * en toont het huidige jaar dynamisch
 */
import { computed } from 'vue'

// Huidig jaar voor copyright
const currentYear = new Date().getFullYear()

// Email configuratie - VERVANG DIT MET JOUW EMAIL ADRES
const recipientEmail = 'info@kartingranking.be' // Pas dit aan naar jouw email
const emailSubject = 'Inschrijven voor Kartuitslagen'
const emailBody = `Beste,

Ik wil mij graag inschrijven om automatisch de kartuitslagen te ontvangen via email.

Mijn gegevens:
Naam: [Vul hier je naam in]
Email: [Vul hier je email in]

Bedankt!`

// Mailto link met vooringevulde subject en body
const emailLink = computed(() => {
  return `mailto:${recipientEmail}?subject=${encodeURIComponent(emailSubject)}&body=${encodeURIComponent(emailBody)}`
})
</script>

<style scoped>
/**
 * Footer Custom Styling
 */

.footer {
  margin-top: 4rem;
  box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.1);
}

/* Footer links styling */
.footer-link {
  color: #adb5bd;
  text-decoration: none;
  transition: all 0.3s ease;
  display: inline-block;
}

.footer-link:hover {
  color: #ffc107;
  transform: translateX(5px);
}

/* Button hover effect */
.btn-warning {
  transition: all 0.3s ease;
}

.btn-warning:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(255, 193, 7, 0.4);
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .footer {
    text-align: center;
  }

  .footer .col-md-4 {
    margin-bottom: 2rem;
  }

  .footer-link {
    display: block;
  }
}
</style>
