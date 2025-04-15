<script setup>
import HelloWorld from './components/HelloWorld.vue'
import recitersData from './data/reciters.json'
import suwarData from './data/suwar.json'
</script>

<template>
  <header>
    <div class="wrapper">
      <HelloWorld msg="Telawa App" />

      <div class="trackPlayer">
        <div class="controls">
          <button @click="prevTrack">Previous</button>
          <button @click="tooglePlay()">{{ isPlaying ? 'Pause' : 'Play' }}</button>
          <button @click="nextTrack">Next</button>
        </div>

        <div class="trackInfo">
          <div class="trackTitle">{{ current.title }}</div>
          <div class="trackArtist">{{ current.artist }}</div>
          <div class="playlist">
            <h2>The Playlist</h2>
            <div v-for="(track, index) in tracks" :key="index">
              <div
                class="item"
                @click="tooglePlay(track)"
                :class="{ playing: isPlaying && current === track, active: current === track }"
              >
                {{ track.title }}
              </div>
            </div>
          </div>
        </div>

        <div class="waves"></div>
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
    } else {
      console.warn('Reciter or Mushaf not found.')
    }
  },
  methods: {
    tooglePlay(track) {
      if (track && track !== this.current) {
        this.current = track
        this.player.src = this.current.src
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
      this.player.load // ensures the new track is ready to play
      if (this.isPlaying) this.player.play()
    },
  },
}
</script>

<style scoped>
.trackPlayer {
  max-width: 400px;
  margin: 20px auto;
  padding: 20px;
  background: #f5f5f5;
  border-radius: 8px;
}
.controls {
  display: flex;
  justify-content: center;
  gap: 10px;
  margin-bottom: 20px;
}
button {
  padding: 8px 16px;
  background-color: #007bff;
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  min-width: 70px;
}
button:hover {
  background-color: #0056b3;
}
.trackInfo {
  text-align: center;
  margin-bottom: 20px;
}
.playlist {
  margin: 10px auto;
  padding: 10px;
}
.playlist .item {
  background-color: peru;
  cursor: pointer;
  padding: 5px;
  margin: 5px 0;
  color: white;
}
.playlist .item:hover {
  background-color: hsla(160, 100%, 37%, 1);
}

.playlist .item.active {
  background: #444;
}
.playlist .item.playing {
  background: linear-gradient(to right, #cc2e5d, #ff5858);
}
</style>
