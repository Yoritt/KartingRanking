<template>
  <!--
    App.vue - Hoofd Layout Component

    Dit is de hoofdcomponent van de applicatie.
    Bevat de layout met Navbar, NotificationBar, inhoud en Footer.
  -->
  <div id="app" class="d-flex flex-column min-vh-100">
    <!-- Navigatiebalk -->
    <Navbar />

    <!-- Mededelingsbalk -->
    <NotificationBar />

    <!-- Hoofdinhoud - Router View -->
    <main class="flex-grow-1">
      <router-view />
    </main>

    <!-- Footer -->
    <Footer />
  </div>
</template>

<script setup>
/**
 * App Component Script
 *
 * Importeert alle layout componenten
 */
import Navbar from './components/Navbar.vue'
import NotificationBar from './components/NotificationBar.vue'
import Footer from './components/Footer.vue'
</script>

<style>
/**
 * Globale Styling
 *
 * Deze styles zijn van toepassing op de hele applicatie
 */

/* Reset en basis styling */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

/* Body styling */
body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: #f8f9fa;
  color: #212529;
}

/* Smooth scrolling */
html {
  scroll-behavior: smooth;
}

/* Main content padding */
main {
  min-height: 60vh;
}

/* Custom scrollbar */
::-webkit-scrollbar {
  width: 10px;
}

::-webkit-scrollbar-track {
  background: #f1f1f1;
}

::-webkit-scrollbar-thumb {
  background: #888;
  border-radius: 5px;
}

::-webkit-scrollbar-thumb:hover {
  background: #555;
}
</style>
