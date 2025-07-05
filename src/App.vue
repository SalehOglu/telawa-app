<script setup>
import HelloWorld from './components/HelloWorld.vue'
import AudioPlayer from './components/AudioPlayer.vue'
import Playlist from './components/Playlist.vue'
import recitersData from './data/reciters.json'
import suwarData from './data/suwar.json'
</script>

<template>
  <header>
    <div class="wrapper">
      <HelloWorld msg="Telawa App" />

      <div class="trackPlayer">
        <AudioPlayer
          :track="current"
          :isPlaying="isPlaying"
          @togglePlay="togglePlay"
          @nextTrack="nextTrack"
          @prevTrack="prevTrack"
          @ready="onWaveformReady"
        />

        <div class="trackInfo">
          <div class="trackTitle">{{ current.title }}</div>
          <div class="trackArtist">{{ current.artist }}</div>
        </div>
      </div>
      <Playlist
        :tracks="tracks"
        :current="current"
        :isPlaying="isPlaying"
        @playTrack="togglePlay"
      />
    </div>
  </header>
</template>

<script>
export default {
  name: 'App',
  data() {
    return {
      isPlaying: false,
      current: {},
      index: 0,
      tracks: [],
    }
  },
  created() {
    const targetReciter = recitersData.reciters.find((reciter) => Number(reciter.id) === 17)

    if (targetReciter && targetReciter.moshaf.length > 0) {
      const moshaf = targetReciter.moshaf[0]
      const baseUrl = moshaf.server
      const surahList = moshaf.surah_list.split(',')

      this.tracks = surahList.map((surahNumber) => {
        const padded = String(surahNumber).padStart(3, '0')
        const surah = suwarData.suwar.find((s) => s.id === parseInt(surahNumber, 10))

        return {
          title: surah ? `${surah.id}. ${surah.name}` : `Surah ${surahNumber}`,
          artist: targetReciter.name,
          src: `${baseUrl}${padded}.mp3`,
        }
      })

      this.index = 0
      this.current = this.tracks[0]
    } else {
      console.warn('Reciter or Mushaf not found.')
    }
  },
  methods: {
    preloadTrack(track) {
      const audio = new Audio()
      audio.src = track.src
      audio.preload = 'auto'
    },
    onWaveformReady() {
      if (this.isPlaying) {
        this.isPlaying = true
      }
    },
    togglePlay(track) {
      if (track && track !== this.current) {
        this.current = track
        this.index = this.tracks.findIndex((t) => t.src === track.src)
        this.isPlaying = true
      } else if (!track) {
        this.isPlaying = !this.isPlaying
      }
    },
    nextTrack() {
      this.index = (this.index + 1) % this.tracks.length
      this.current = this.tracks[this.index]
      this.isPlaying = true
      // Preload the next-next track for smoother experience
      const nextIndex = (this.index + 1) % this.tracks.length
      this.preloadTrack(this.tracks[nextIndex])
    },
    prevTrack() {
      this.index = (this.index - 1 + this.tracks.length) % this.tracks.length
      this.current = this.tracks[this.index]
      this.isPlaying = true
      // Preload previous track’s previous track
      const prevIndex = (this.index - 1 + this.tracks.length) % this.tracks.length
      this.preloadTrack(this.tracks[prevIndex])
    },
  },
}
</script>

<style scoped>
.trackPlayer {
  max-width: 1200px;
  margin: 20px auto;
  padding: 20px;
  max-width: 480px;
  border-radius: 8px;
  background: #fffaee;
  border: 1px solid #fff3eb;
  box-shadow:
    0 2px 2px rgba(255, 107, 0, 0.25),
    0 4px 4px rgba(255, 107, 0, 0.2),
    0 8px 8px rgba(255, 107, 0, 0.15),
    0 16px 16px rgba(255, 107, 0, 0.1),
    0 24px 24px rgba(255, 107, 0, 0.05);
}

.trackInfo {
  text-align: center;
  margin-bottom: 20px;
}
</style>
