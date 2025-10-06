<template>
  <!--
    Media Pagina

    Deze pagina toont alle foto's en video's van karting evenementen.
    Media wordt gerangschikt van recent naar oud.
  -->
  <div class="media-page">
    <!-- Page Header -->
    <section class="page-header bg-dark text-white py-5">
      <div class="container">
        <h1 class="display-4 fw-bold">
          <i class="bi bi-camera-fill me-3"></i>
          Media Galerij
        </h1>
        <p class="lead">Foto's en video's van onze karting evenementen</p>
      </div>
    </section>

    <div class="container my-5">
      <!-- Filter Knoppen -->
      <div class="mb-4 d-flex gap-2 flex-wrap justify-content-center">
        <button
          @click="filterMedia('all')"
          :class="['btn btn-lg', filter === 'all' ? 'btn-warning' : 'btn-outline-secondary']"
        >
          <i class="bi bi-grid-3x3-gap me-2"></i>
          Alles
        </button>
        <button
          @click="filterMedia('photo')"
          :class="['btn btn-lg', filter === 'photo' ? 'btn-warning' : 'btn-outline-secondary']"
        >
          <i class="bi bi-image me-2"></i>
          Foto's
        </button>
        <button
          @click="filterMedia('video')"
          :class="['btn btn-lg', filter === 'video' ? 'btn-warning' : 'btn-outline-secondary']"
        >
          <i class="bi bi-play-circle me-2"></i>
          Video's
        </button>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="text-center py-5">
        <div class="spinner-border text-warning" role="status">
          <span class="visually-hidden">Laden...</span>
        </div>
        <p class="text-muted mt-3">Media laden...</p>
      </div>

      <!-- Media Grid -->
      <div v-else>
        <div v-if="filteredMedia.length > 0" class="row g-4">
          <div
            v-for="item in filteredMedia"
            :key="item.id"
            class="col-sm-6 col-md-4 col-lg-3"
          >
            <!-- Foto Card -->
            <div v-if="item.type === 'photo'" class="media-card">
              <div class="media-wrapper">
                <img
                  :src="item.url"
                  :alt="item.description || 'Karting foto'"
                  class="media-image"
                  @click="openLightbox(item)"
                />
                <div class="media-overlay">
                  <div class="overlay-content">
                    <i class="bi bi-zoom-in fs-1 text-white mb-2"></i>
                    <p class="text-white mb-1 fw-bold">{{ formatDate(item.date) }}</p>
                    <p v-if="item.description" class="text-white-50 small mb-0">
                      {{ item.description }}
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <!-- Video Card -->
            <div v-else-if="item.type === 'video'" class="media-card">
              <div class="media-wrapper">
                <!-- Thumbnail of video -->
                <div class="video-thumbnail" @click="openVideo(item)">
                  <img
                    v-if="item.thumbnail_url"
                    :src="item.thumbnail_url"
                    :alt="item.description || 'Karting video'"
                    class="media-image"
                  />
                  <div v-else class="video-placeholder">
                    <i class="bi bi-play-circle-fill text-white" style="font-size: 4rem;"></i>
                  </div>
                  <div class="play-button">
                    <i class="bi bi-play-fill"></i>
                  </div>
                </div>
                <div class="media-info p-2 bg-dark text-white">
                  <small class="d-block">
                    <i class="bi bi-calendar3 me-1"></i>
                    {{ formatDate(item.date) }}
                  </small>
                  <small v-if="item.description" class="text-white-50">
                    {{ item.description }}
                  </small>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Geen media beschikbaar -->
        <div v-else class="text-center py-5">
          <i class="bi bi-images text-muted" style="font-size: 4rem;"></i>
          <h4 class="mt-3 text-muted">Geen media gevonden</h4>
          <p class="text-muted">
            Er zijn momenteel geen {{ filter === 'all' ? 'items' : filter === 'photo' ? "foto's" : "video's" }} beschikbaar
          </p>
        </div>
      </div>
    </div>

    <!-- Lightbox Modal voor foto's -->
    <div
      v-if="lightboxItem"
      class="lightbox"
      @click="closeLightbox"
    >
      <div class="lightbox-content">
        <button class="lightbox-close" @click="closeLightbox">
          <i class="bi bi-x-lg"></i>
        </button>
        <img
          :src="lightboxItem.url"
          :alt="lightboxItem.description || 'Karting foto'"
          class="lightbox-image"
        />
        <div class="lightbox-info">
          <p class="text-white mb-1">{{ formatDate(lightboxItem.date) }}</p>
          <p v-if="lightboxItem.description" class="text-white-50">
            {{ lightboxItem.description }}
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
/**
 * Media Pagina Script
 *
 * Toont foto's en video's in een grid layout met filter mogelijkheden.
 * Foto's kunnen in een lightbox worden bekeken.
 * Video's openen in nieuwe tab.
 */
import { ref, computed, onMounted } from 'vue'
import { supabase } from '../supabaseClient'

// Reactive state
const mediaItems = ref([])
const loading = ref(true)
const filter = ref('all') // 'all', 'photo', 'video'
const lightboxItem = ref(null)

/**
 * Haal alle media items op uit de database
 */
const fetchMedia = async () => {
  try {
    loading.value = true

    const { data, error } = await supabase
      .from('media')
      .select('*')
      .order('date', { ascending: false })

    if (error) {
      console.error('Fout bij ophalen media:', error)
      return
    }

    mediaItems.value = data || []
  } catch (err) {
    console.error('Onverwachte fout:', err)
  } finally {
    loading.value = false
  }
}

/**
 * Filter media op basis van type
 */
const filteredMedia = computed(() => {
  if (filter.value === 'all') {
    return mediaItems.value
  }
  return mediaItems.value.filter(item => item.type === filter.value)
})

/**
 * Verander het filter
 */
const filterMedia = (newFilter) => {
  filter.value = newFilter
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

/**
 * Open foto in lightbox
 */
const openLightbox = (item) => {
  lightboxItem.value = item
  document.body.style.overflow = 'hidden'
}

/**
 * Sluit lightbox
 */
const closeLightbox = () => {
  lightboxItem.value = null
  document.body.style.overflow = 'auto'
}

/**
 * Open video in nieuwe tab
 */
const openVideo = (item) => {
  window.open(item.url, '_blank')
}

// Laad data bij component mount
onMounted(() => {
  fetchMedia()
})
</script>

<style scoped>
/**
 * Media Pagina Custom Styling
 */

/* Page Header */
.page-header {
  background: linear-gradient(135deg, #1a1a1a 0%, #333333 100%);
  border-bottom: 4px solid #ffc107;
}

/* Media Card */
.media-card {
  height: 100%;
  cursor: pointer;
}

.media-wrapper {
  position: relative;
  overflow: hidden;
  border-radius: 8px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.media-wrapper:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

/* Media Image */
.media-image {
  width: 100%;
  height: 250px;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.media-wrapper:hover .media-image {
  transform: scale(1.1);
}

/* Media Overlay */
.media-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s ease;
  padding: 1rem;
}

.media-wrapper:hover .media-overlay {
  opacity: 1;
}

.overlay-content {
  text-align: center;
}

/* Video Specific */
.video-thumbnail {
  position: relative;
  height: 250px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #000;
}

.video-placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, #1a1a1a 0%, #333333 100%);
}

.play-button {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  width: 60px;
  height: 60px;
  background: rgba(255, 193, 7, 0.9);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.3s ease;
}

.play-button i {
  font-size: 2rem;
  color: #000;
  margin-left: 4px;
}

.media-wrapper:hover .play-button {
  transform: translate(-50%, -50%) scale(1.1);
  background: rgba(255, 193, 7, 1);
}

/* Lightbox */
.lightbox {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.95);
  z-index: 9999;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.lightbox-content {
  position: relative;
  max-width: 90vw;
  max-height: 90vh;
}

.lightbox-image {
  max-width: 100%;
  max-height: 80vh;
  object-fit: contain;
  border-radius: 8px;
}

.lightbox-close {
  position: absolute;
  top: -50px;
  right: 0;
  background: transparent;
  border: none;
  color: white;
  font-size: 2rem;
  cursor: pointer;
  padding: 0.5rem;
  transition: transform 0.3s ease;
}

.lightbox-close:hover {
  transform: rotate(90deg);
}

.lightbox-info {
  position: absolute;
  bottom: -60px;
  left: 0;
  right: 0;
  text-align: center;
}

/* Filter Buttons */
.btn {
  transition: all 0.3s ease;
}

.btn:hover {
  transform: translateY(-2px);
}

/* Responsive */
@media (max-width: 768px) {
  .page-header h1 {
    font-size: 2rem;
  }

  .media-image,
  .video-thumbnail {
    height: 200px;
  }

  .lightbox {
    padding: 1rem;
  }

  .lightbox-info {
    position: static;
    margin-top: 1rem;
  }
}
</style>
