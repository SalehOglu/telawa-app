<script setup>
import { ref, computed, onMounted } from 'vue'
import AudioPlayer from './components/AudioPlayer.vue'
import Playlist from './components/Playlist.vue'
import CustomSelect from './components/CustomSelect.vue'
import recitersData from './data/reciters.json'
import suwarData from './data/suwar.json'

// State
const isPlaying = ref(false)
const current = ref({})
const index = ref(0)
const tracks = ref([])
const selectedReciterId = ref('17')

// Computed
const reciterOptions = computed(() => {
  return recitersData.reciters.map((reciter) => ({
    label: reciter.name,
    value: String(reciter.id),
  }))
})

// Methods
const loadReciter = (id) => {
  const targetReciter = recitersData.reciters.find((r) => String(r.id) === String(id))
  if (targetReciter && targetReciter.moshaf && targetReciter.moshaf.length > 0) {
    const moshaf = targetReciter.moshaf[0]
    const baseUrl = moshaf.server
    const surahList = moshaf.surah_list.split(',')
    
    tracks.value = surahList.map((surahNumber) => {
      const padded = String(surahNumber).padStart(3, '0')
      const surah = suwarData.suwar.find((s) => s.id === parseInt(surahNumber, 10))
      
      return {
        title: surah ? `${surah.id}. ${surah.name}` : `Surah ${surahNumber}`,
        qare2: targetReciter.name,
        src: `${baseUrl}${padded}.mp3`,
        rewaya: moshaf.name,
      }
    })
    
    index.value = 0
    current.value = tracks.value[0]
  }
}

const togglePlay = (track) => {
  if (track && track.src !== current.value.src) {
    current.value = track
    index.value = tracks.value.findIndex((t) => t.src === track.src)
    isPlaying.value = true
  } else {
    isPlaying.value = !isPlaying.value
  }
}

const nextTrack = () => {
  index.value = (index.value + 1) % tracks.value.length
  current.value = tracks.value[index.value]
  isPlaying.value = true
}

const prevTrack = () => {
  index.value = (index.value - 1 + tracks.value.length) % tracks.value.length
  current.value = tracks.value[index.value]
  isPlaying.value = true
}

const onReciterChange = (id) => {
  selectedReciterId.value = id
  loadReciter(id)
  isPlaying.value = false
}

onMounted(() => {
  loadReciter(17)
})
</script>

<template>
  <div class="app-shell">
    <!-- Background Decor -->
    <div class="orb orb-1"></div>
    <div class="orb orb-2"></div>

    <!-- NEW MAIN TOP HEADER -->
    <header class="main-page-header">
      <div class="logo">
        <span class="logo-icon">☽</span>
        <span class="logo-text">تلاوة</span>
      </div>
    </header>

    <!-- Main Layout Container -->
    <div class="app-container">
      <!-- SIDEBAR: Surah Chapters -->
      <aside class="sidebar">
        <div class="sidebar-content">
          <Playlist
            :tracks="tracks"
            :current="current"
            :isPlaying="isPlaying"
            @playTrack="togglePlay"
          />
        </div>
      </aside>

      <!-- MAIN AREA: Player -->
      <main class="main-stage">
        <div class="scroll-wrapper">
          <section class="top-player-section">
            <div class="player-card">
              <div class="player-header-row">
                <div class="track-info-group">
                  <span class="now-playing-label">Now Playing • Surah {{ index + 1 }}</span>
                  <h1 class="chapter-name">{{ current.title }}</h1>
                  <div class="meta-tag-pills">
                    <span class="meta-pill">{{ current.rewaya }}</span>
                    <span class="meta-pill meta-pill--gold">{{ current.qare2 }}</span>
                  </div>
                </div>
                
                <div class="reciter-dropdown-container">
                  <CustomSelect
                    :options="reciterOptions"
                    :modelValue="selectedReciterId"
                    @update:modelValue="onReciterChange"
                  />
                </div>
              </div>

              <div class="player-visualizer-container">
                <AudioPlayer
                  :track="current"
                  :isPlaying="isPlaying"
                  @togglePlay="togglePlay"
                  @nextTrack="nextTrack"
                  @prevTrack="prevTrack"
                />
              </div>
            </div>
          </section>
        </div>
      </main>
    </div>
  </div>
</template>

<style scoped>
.app-shell {
  min-height: 100vh;
  width: 100vw;
  background: var(--bg-primary);
  color: var(--text-primary);
  overflow: hidden;
  display: flex;
  flex-direction: column; /* Stack header on top of the container */
  position: relative;
}

/* Background effects */
.orb { position: absolute; border-radius: 50%; filter: blur(120px); pointer-events: none; z-index: 0; }
.orb-1 { width: 600px; height: 600px; background: radial-gradient(circle, rgba(200, 121, 65, 0.1) 0%, transparent 70%); top: -100px; right: -50px; }
.orb-2 { width: 400px; height: 400px; background: radial-gradient(circle, rgba(212, 169, 74, 0.06) 0%, transparent 70%); bottom: -50px; left: 5%; }

/* Main Top Header */
.main-page-header {
  height: 100px;
  display: flex;
  justify-content: center;
  align-items: center;
  border-bottom: 1px solid var(--border);
  background: rgba(13, 13, 20, 0.6);
  backdrop-filter: blur(24px);
  position: relative;
  z-index: 20;
  flex-shrink: 0;
}

.logo { display: flex; align-items: center; gap: 14px; }
.logo-icon { font-size: 28px; color: var(--gold); }
.logo-text { font-family: 'Amiri', serif; font-size: 42px; font-weight: 700; background: linear-gradient(135deg, var(--gold) 0%, var(--accent-light) 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }

.app-container {
  display: flex;
  width: 100%;
  flex: 1; /* Take up remaining space below header */
  position: relative;
  z-index: 1;
  overflow: hidden;
}

/* Sidebar Styling */
.sidebar {
  width: 380px;
  background: rgba(13, 13, 20, 0.8);
  border-right: 1px solid var(--border);
  display: flex;
  flex-direction: column;
  backdrop-filter: blur(24px);
  flex-shrink: 0;
}

.sidebar-content {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
}

/* Main Area Styling */
.main-stage {
  flex: 1;
  min-width: 0;
  position: relative;
  overflow: hidden;
}

.scroll-wrapper {
  height: 100%;
  overflow-y: auto;
  overflow-x: hidden;
  padding-bottom: 80px;
}

.top-player-section {
  padding: 60px 40px;
  max-width: 1200px;
  margin: 0 auto;
}

.player-card {
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  padding: 48px;
  box-shadow: 0 40px 80px rgba(0, 0, 0, 0.5);
}

.player-header-row {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 60px;
  margin-bottom: 48px;
}

.track-info-group {
  flex: 1;
}

.now-playing-label {
  font-size: 12px;
  color: var(--accent);
  letter-spacing: 2px;
  text-transform: uppercase;
  font-weight: 600;
  display: block;
  margin-bottom: 12px;
}

.chapter-name {
  font-size: 42px;
  font-weight: 700;
  letter-spacing: -0.5px;
  margin-bottom: 24px;
  line-height: 1.1;
}

.meta-tag-pills {
  display: flex;
  gap: 12px;
}

.meta-pill {
  padding: 8px 18px;
  border-radius: 99px;
  background: var(--bg-glass);
  border: 1px solid var(--border);
  font-size: 13px;
  color: var(--text-secondary);
  font-weight: 500;
}

.meta-pill--gold {
  background: var(--gold-dim);
  border-color: rgba(212, 169, 74, 0.3);
  color: var(--gold);
}

.reciter-dropdown-container {
  width: 320px;
  flex-shrink: 0;
}

.player-visualizer-container {
  width: 100%;
}

/* Responsive Overrides */
@media (max-width: 1200px) {
  .player-header-row { flex-direction: column; gap: 32px; }
  .reciter-dropdown-container { width: 100%; }
}

@media (max-width: 820px) {
  .app-container { flex-direction: column; overflow-y: auto; height: auto; }
  .sidebar { width: 100%; height: auto; max-height: 40vh; border-right: none; border-bottom: 1px solid var(--border); }
  .main-page-header { height: 80px; }
  .logo-text { font-size: 32px; }
  .top-player-section { padding: 30px 20px; }
  .player-card { padding: 30px; }
}
</style>
