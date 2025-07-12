<template>
  <div>
    <div v-if="isLoading" class="loading-container">
      <div class="spinner"></div>
      <div class="loading-text">Loading waveform...</div>
    </div>

    <div v-show="waveformReady" ref="waveform" class="waveform"></div>

    <MusicControls
      :isPlaying="isPlaying"
      @togglePlay="$emit('togglePlay')"
      @prevTrack="$emit('prevTrack')"
      @nextTrack="$emit('nextTrack')"
    />
  </div>
</template>

<script>
import WaveSurfer from 'wavesurfer.js'
import MusicControls from './MusicControls.vue'

export default {
  name: 'AudioPlayer',
  components: { MusicControls },
  props: {
    isPlaying: Boolean,
    track: Object,
  },
  data() {
    return {
      wavesurfer: null,
      waveformReady: false,
      isLoading: false,
    }
  },
  watch: {
    track: {
      handler(newTrack) {
        if (!newTrack?.src || !this.wavesurfer) return
        this.isLoading = true
        this.waveformReady = false
        if (this.wavesurfer.isPlaying()) {
          this.wavesurfer.stop()
        }
        this.wavesurfer.load(newTrack.src)
      },
    },
    isPlaying(newVal) {
      if (!this.wavesurfer || !this.waveformReady) return

      const currentlyPlaying = this.wavesurfer.isPlaying()

      if (newVal && !currentlyPlaying) {
        this.wavesurfer.play().catch((err) => {
          console.warn('Play error:', err)
        })
      } else if (!newVal && currentlyPlaying) {
        this.wavesurfer.pause()
      }
    },
  },
  mounted() {
    this.$nextTick(() => {
      this.wavesurfer = WaveSurfer.create({
        container: this.$refs.waveform,
        waveColor: '#d9dcff',
        progressColor: '#f26600',
        height: 80,
        responsive: true,
      })

      if (this.track?.src) {
        this.waveformReady = false
        this.isLoading = true
        this.wavesurfer.load(this.track.src)
      }

      this.wavesurfer.on('ready', () => {
        this.waveformReady = true
        this.isLoading = false
        this.$emit('ready')
        if (this.isPlaying) {
          this.wavesurfer.play().catch((err) => console.warn('Autoplay error:', err))
        }
      })

      this.wavesurfer.on('finish', () => {
        // this.$emit('togglePlay', false)
        this.$emit('nextTrack')
        // this.$emit('togglePlay', true)
      })
    })
  },
  beforeUnmount() {
    if (this.wavesurfer) {
      this.wavesurfer.destroy()
    }
  },
}
</script>

<style scoped>
.waveform {
  margin-bottom: 20px;
  cursor: pointer;
}
.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-bottom: 20px;
}

.spinner {
  width: 32px;
  height: 32px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #f26600;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 10px;
}

.loading-text {
  font-size: 14px;
  color: #555;
}

@keyframes spin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>
