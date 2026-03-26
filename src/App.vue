<script setup>
import { ref, computed, onMounted } from 'vue'
import AudioPlayer from './components/AudioPlayer.vue'
import Playlist from './components/Playlist.vue'
import CustomSelect from './components/CustomSelect.vue'
import recitersData from './data/reciters.json'
import suwarData from './data/suwar.json'

import { arabicSuwar, uiTranslations } from './locales/translations'

// State
const isPlaying = ref(false)
const current = ref({})
const index = ref(0)
const tracks = ref([])
const selectedReciterId = ref('17')
const isSidebarOpen = ref(false)
const locale = ref('en')

const t = computed(() => uiTranslations[locale.value])

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
      const surahIndex = parseInt(surahNumber, 10)
      const surah = suwarData.suwar.find((s) => s.id === surahIndex)
      
      let title = surah ? surah.name : `Surah ${surahNumber}`
      if (locale.value === 'ar') {
        title = arabicSuwar[surahIndex - 1] || title
      }

      return {
        id: surahNumber,
        title: locale.value === 'ar' ? `${surahNumber}. ${title}` : `${surahNumber}. ${title}`,
        qare2: targetReciter.name,
        src: `${baseUrl}${padded}.mp3`,
        rewaya: moshaf.name,
      }
    })

    index.value = 0
    current.value = tracks.value[0]
  }
}

const toggleLocale = () => {
  locale.value = locale.value === 'en' ? 'ar' : 'en'
  document.documentElement.setAttribute('dir', locale.value === 'ar' ? 'rtl' : 'ltr')
  document.documentElement.setAttribute('lang', locale.value)
  loadReciter(selectedReciterId.value)
}

const togglePlay = (track) => {
  if (track && track.src !== current.value.src) {
    current.value = track
    index.value = tracks.value.findIndex((t) => t.src === track.src)
    isPlaying.value = true
    isSidebarOpen.value = false // Close sidebar on mobile after selection
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
      <div class="header-inner">
        <button class="menu-toggle" @click="isSidebarOpen = !isSidebarOpen" aria-label="Toggle Sidebar">
          <span class="burger-icon" :class="{ 'is-active': isSidebarOpen }">
            <span></span>
            <span></span>
            <span></span>
          </span>
        </button>

        <div class="logo">
          <span class="logo-text">{{ locale === 'en' ? 'Telawah' : 'تلاوة' }}</span>
          <span class="logo-icon">☽</span>
        </div>

        <button class="lang-switch-btn" @click="toggleLocale">
          {{ t.langName }}
        </button>
      </div>
    </header>

    <!-- Main Layout Container -->
    <div class="app-container">
      <!-- SIDEBAR: Surah Chapters -->
      <aside class="sidebar" :class="{ 'is-open': isSidebarOpen }">
        <div class="sidebar-header mobile-only">
          <span class="sidebar-title">Surah Chapters</span>
          <button class="close-btn" @click="isSidebarOpen = false">&times;</button>
        </div>
        <div class="sidebar-content">
          <Playlist
            :tracks="tracks"
            :current="current"
            :isPlaying="isPlaying"
            :locale="locale"
            :translations="t"
            @playTrack="togglePlay"
          />
        </div>
      </aside>
      <div class="sidebar-overlay" :class="{ 'is-visible': isSidebarOpen }" @click="isSidebarOpen = false"></div>

      <!-- MAIN AREA: Player -->
      <main class="main-stage">
        <div class="scroll-wrapper">
          <section class="top-player-section">
            <div class="player-card">
              <div class="player-header-row">
                <div class="track-info-group">
                  <span class="now-playing-label">
                    {{ t.nowPlaying }} {{ index + 1 }}
                  </span>
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
                    :placeholder="t.chooseReciter"
                    @update:modelValue="onReciterChange"
                  />
                </div>
              </div>

              <div class="player-visualizer-container">
                <AudioPlayer
                  :track="current"
                  :isPlaying="isPlaying"
                  :loadingLabel="t.loading"
                  :prevLabel="t.prev"
                  :nextLabel="t.next"
                  :playLabel="t.play"
                  :pauseLabel="t.pause"
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
  width: 100%;
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
  background: rgba(13, 13, 20, 0.75);
  backdrop-filter: blur(24px);
  position: sticky;
  top: 0;
  z-index: 100;
  flex-shrink: 0;
}

.header-inner {
  width: 100%;
  max-width: 1400px;
  padding: 0 40px;
  display: flex;
  align-items: center;
  position: relative; /* For centering logo */
  height: 100%;
}

.logo { 
  display: flex; 
  align-items: center; 
  gap: 14px; 
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
  pointer-events: none;
}

:where([dir="rtl"]) .logo-icon {
  transform: rotate(180deg);
}

.logo-icon { font-size: 55px; color: var(--gold); transition: transform 0.3s ease; }
.logo-text { 
  font-family: 'Outfit', sans-serif; 
  font-size: 60px; 
  font-weight: 700; 
  background: linear-gradient(135deg, var(--gold) 0%, var(--accent-light) 100%); 
  -webkit-background-clip: text; 
  -webkit-text-fill-color: transparent; 
}

:where([lang="ar"]) .logo-text {
  font-family: 'Cairo', sans-serif;
  font-size: 54px; /* Slight adjustment for Cairo's visual size */
  font-weight: 800;
}

.header-spacer { flex: 1; }

.lang-switch-btn {
  background: var(--bg-glass);
  border: 1px solid var(--border);
  color: var(--text-primary);
  padding: 8px 16px;
  border-radius: var(--radius-sm);
  cursor: pointer;
  font-family: inherit;
  font-size: 14px;
  transition: all 0.3s ease;
  z-index: 101;
  position: absolute;
  right: 40px;
}

.lang-switch-btn:hover {
  background: var(--gold-dim);
  border-color: var(--gold);
  color: var(--gold);
}
.menu-toggle {
  background: none;
  border: none;
  cursor: pointer;
  padding: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 101;
  display: none; /* Hidden on desktop */
  position: absolute;
  left: 40px;
}

.burger-icon {
  width: 24px;
  height: 18px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  position: relative;
}

.burger-icon span {
  display: block;
  width: 100%;
  height: 2px;
  background-color: var(--gold);
  border-radius: 2px;
  transition: 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.burger-icon.is-active span:nth-child(1) {
  transform: translateY(8px) rotate(45deg);
}

.burger-icon.is-active span:nth-child(2) {
  opacity: 0;
}

.burger-icon.is-active span:nth-child(3) {
  transform: translateY(-8px) rotate(-45deg);
}

.app-container {
  display: flex;
  width: 100%;
  flex: 1; /* Take up remaining space below header */
  position: relative;
  z-index: 1;
  overflow: hidden;
  overflow-x: hidden;
}

/* Sidebar Styling */
.sidebar {
  width: 330px;
  height: calc(100vh - 100px);
  background: rgba(13, 13, 20, 0.8);
  border-right: 1px solid var(--border);
  display: flex;
  flex-direction: column;
  backdrop-filter: blur(24px);
  flex-shrink: 0;
  transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

:where([dir="rtl"]) .sidebar {
  border-right: none;
  border-left: 1px solid var(--border);
}

.sidebar-header {
  padding: 24px;
  display: none; /* Shown only on mobile */
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid var(--border);
}

.sidebar-title {
  font-size: 18px;
  font-weight: 600;
  color: var(--gold);
}

.close-btn {
  background: none;
  border: none;
  color: var(--text-secondary);
  font-size: 32px;
  line-height: 1;
  cursor: pointer;
  padding: 4px;
}

.sidebar-content {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
}

.sidebar-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.6);
  backdrop-filter: blur(4px);
  z-index: 90;
  opacity: 0;
  pointer-events: none;
  transition: opacity 0.3s ease;
}

.sidebar-overlay.is-visible {
  opacity: 1;
  pointer-events: auto;
}

.mobile-only {
  display: none !important;
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
  gap: 40px;
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
  flex-wrap: wrap;
}

.meta-pill {
  padding: 8px 14px;
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
  width: 280px;
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
  .menu-toggle { display: flex; left: 20px; }
  .lang-switch-btn { right: 20px; }
  .header-inner { padding: 0 20px; }
  .main-page-header { height: 70px; }
  .logo-text { font-size: 32px; }
  .logo-icon { font-size: 32px; }
  .logo { position: absolute; left: 50%; transform: translate(-50%, -50%); margin: 0; }
  .header-spacer { display: none; }

  .sidebar { 
    position: fixed;
    top: 0;
    left: 0;
    width: 280px;
    height: 100vh;
    z-index: 110;
    transform: translateX(-102%);
    border-right: 1px solid var(--border);
    box-shadow: 20px 0 50px rgba(0, 0, 0, 0.5);
  }

  :where([dir="rtl"]) .sidebar {
    left: auto;
    right: 0;
    transform: translateX(102%);
    border-right: none;
    border-left: 1px solid var(--border);
    box-shadow: -20px 0 50px rgba(0, 0, 0, 0.5);
  }

  .sidebar.is-open {
    transform: translateX(0);
  }

  .sidebar-header {
    display: flex;
  }

  .mobile-only {
    display: flex !important;
  }

  .app-container { flex-direction: column; }
  .main-stage { width: 100%; }
  .top-player-section { padding: 30px 20px; }
  .player-card { padding: 24px; }
  .chapter-name { font-size: 28px; }
}
</style>
