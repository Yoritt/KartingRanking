<template>
  <!--
    Navigatiebalk Component

    Deze component toont de hoofdnavigatie van de website.
    Bevat links naar alle hoofdpagina's en is responsive met een hamburger menu op mobile.
  -->
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top shadow">
    <div class="container-fluid">
      <!-- Logo/Brand -->
      <router-link class="navbar-brand fw-bold" to="/">
        <i class="bi bi-flag-fill me-2"></i>
        Karting Ranking
      </router-link>

      <!-- Hamburger menu knop voor mobiel -->
      <button
        class="navbar-toggler"
        type="button"
        data-bs-toggle="collapse"
        data-bs-target="#navbarNav"
        aria-controls="navbarNav"
        aria-expanded="false"
        aria-label="Toggle navigation"
      >
        <span class="navbar-toggler-icon"></span>
      </button>

      <!-- Navigatie links -->
      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ms-auto">
          <!-- Home link -->
          <li class="nav-item">
            <router-link class="nav-link" to="/" exact-active-class="active">
              <i class="bi bi-house-fill me-1"></i>
              Home
            </router-link>
          </li>

          <!-- Kalender link -->
          <li class="nav-item">
            <router-link class="nav-link" to="/kalender" active-class="active">
              <i class="bi bi-calendar-event me-1"></i>
              Kalender
            </router-link>
          </li>

          <!-- Kartuitslagen link -->
          <li class="nav-item">
            <router-link class="nav-link" to="/kartuitslagen" active-class="active">
              <i class="bi bi-file-earmark-spreadsheet me-1"></i>
              Kartuitslagen
            </router-link>
          </li>

          <!-- Historiek link -->
          <li class="nav-item">
            <router-link class="nav-link" to="/historiek" active-class="active">
              <i class="bi bi-clock-history me-1"></i>
              Historiek
            </router-link>
          </li>

          <!-- Reglement link -->
          <li class="nav-item">
            <router-link class="nav-link" to="/reglement" active-class="active">
              <i class="bi bi-file-text me-1"></i>
              Reglement
            </router-link>
          </li>

          <!-- Media link -->
          <li class="nav-item">
            <router-link class="nav-link" to="/media" active-class="active">
              <i class="bi bi-camera-fill me-1"></i>
              Media
            </router-link>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</template>

<script setup>
/**
 * Navbar Component Script
 *
 * Geen complexe logica nodig - Bootstrap handelt de responsive functionaliteit af
 */
</script>

<style scoped>
/**
 * Navbar Custom Styling
 */

/* Active link styling */
.nav-link.active {
  color: #ffc107 !important;
  font-weight: 600;
}

/* Hover effect op nav links */
.nav-link {
  transition: color 0.3s ease;
  padding: 0.5rem 1rem;
}

.nav-link:hover {
  color: #ffc107 !important;
}

/* Brand styling */
.navbar-brand {
  font-size: 1.5rem;
  transition: transform 0.3s ease;
}

.navbar-brand:hover {
  transform: scale(1.05);
  color: #ffc107 !important;
}

/* Responsive spacing */
@media (max-width: 991px) {
  .navbar-nav {
    padding-top: 1rem;
  }

  .nav-item {
    text-align: center;
    padding: 0.25rem 0;
  }
}
</style>
