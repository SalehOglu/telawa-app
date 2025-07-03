<script setup>
import HelloWorld from './components/HelloWorld.vue'
import MusicControls from './components/MusicControls.vue'
import Playlist from './components/Playlist.vue'
import recitersData from './data/reciters.json'
import suwarData from './data/suwar.json'
</script>

<template>
  <header>
    <div class="wrapper">
      <HelloWorld msg="Telawa App" />

      <div class="trackPlayer">
        <MusicControls
          :isPlaying="isPlaying"
          @togglePlay="togglePlay(current)"
          @nextTrack="nextTrack"
          @prevTrack="prevTrack"
        />

        <div class="trackInfo">
          <div class="trackTitle">{{ current.title }}</div>
          <div class="trackArtist">{{ current.artist }}</div>

          <Playlist
            :tracks="tracks"
            :current="current"
            :isPlaying="isPlaying"
            @playTrack="togglePlay"
          />
        </div>
      </div>
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
      player: new Audio(),
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
      this.player.src = this.current.src
      this.player.addEventListener('ended', this.nextTrack)
    } else {
      console.warn('Reciter or Mushaf not found.')
    }
  },
  beforeUnmount() {
    this.player.removeEventListener('ended', this.nextTrack)
  },
  methods: {
    togglePlay(track) {
      if (track && track !== this.current) {
        this.current = track
        this.index = this.tracks.findIndex((t) => t.src === track.src)
        this.player.src = this.current.src
        this.player.load()
        this.player.play()
        this.isPlaying = true
        return
      }

      if (!this.player.src) {
        this.current = this.tracks[this.index]
        this.player.src = this.current.src
      }

      if (this.isPlaying) {
        this.player.pause()
        this.isPlaying = false
      } else {
        this.player.play()
        this.isPlaying = true
      }
    },
    nextTrack() {
      this.index++
      if (this.index > this.tracks.length - 1) {
        this.index = 0
      }
      this.current = this.tracks[this.index]
      this.player.src = this.current.src
      if (this.isPlaying) this.player.play()
    },
    prevTrack() {
      this.index--
      if (this.index < 0) {
        this.index = this.tracks.length - 1
      }
      // this.index = (this.index - 1 + this.tracks.length) % this.tracks.length
      this.current = this.tracks[this.index]
      this.player.src = this.current.src
      this.player.load() // ensures the new track is ready to play
      if (this.isPlaying) this.player.play()
    },
  },
}
</script>

<style scoped>
.trackPlayer {
  max-width: 1200px;
  margin: 20px auto;
  padding: 20px;
  background: #f5f5f5;
  border-radius: 8px;
}

.trackInfo {
  text-align: center;
  margin-bottom: 20px;
}
</style>
