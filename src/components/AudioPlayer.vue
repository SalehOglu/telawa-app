<template>
  <div class="audio-player">
    <div class="waveform-container">
      <div v-if="isLoading" class="loading-overlay">
        <div class="pulse-rings">
          <span></span><span></span><span></span>
        </div>
        <p class="loading-label">Loading Audio...</p>
      </div>
      <div v-show="waveformReady" ref="waveform" class="waveform"></div>
    </div>

    <!-- Live progress & time display -->
    <div class="player-bottom-controls">
      <div class="time-display">
        <span class="time-now">{{ formattedCurrent }}</span>
        <div class="time-divider">/</div>
        <span class="time-total">{{ formattedDuration }}</span>
      </div>

      <div class="action-controls">
        <MusicControls
          :isPlaying="isPlaying"
          @togglePlay="$emit('togglePlay')"
          @prevTrack="$emit('prevTrack')"
          @nextTrack="$emit('nextTrack')"
        />
      </div>

      <!-- Spacer for balance -->
      <div class="controls-spacer"></div>
    </div>
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
      currentTime: 0,
      duration: 0,
    }
  },
  computed: {
    formattedCurrent() { return this.formatTime(this.currentTime) },
    formattedDuration() { return this.formatTime(this.duration) },
  },
  watch: {
    track: {
      handler(newTrack) {
        if (!newTrack?.src || !this.wavesurfer) return
        this.isLoading = true
        this.waveformReady = false
        this.currentTime = 0
        this.duration = 0
        if (this.wavesurfer.isPlaying()) this.wavesurfer.stop()
        this.wavesurfer.load(newTrack.src)
      },
    },
    isPlaying(newVal) {
      if (!this.wavesurfer || !this.waveformReady) return
      const currentlyPlaying = this.wavesurfer.isPlaying()
      if (newVal && !currentlyPlaying) {
        this.wavesurfer.play().catch((err) => console.warn('Play error:', err))
      } else if (!newVal && currentlyPlaying) {
        this.wavesurfer.pause()
      }
    },
  },
  mounted() {
    this.$nextTick(() => {
      this.wavesurfer = WaveSurfer.create({
        container: this.$refs.waveform,
        waveColor: 'rgba(255, 255, 255, 0.06)',
        progressColor: 'rgba(200, 121, 65, 0.9)',
        cursorColor: '#c87941',
        cursorWidth: 2,
        barWidth: 4,
        barGap: 3,
        barRadius: 4,
        height: 80,
        normalize: true,
        responsive: true,
        backend: 'WebAudio',
      })

      if (this.track?.src) {
        this.isLoading = true
        this.wavesurfer.load(this.track.src)
      }

      this.wavesurfer.on('ready', () => {
        this.waveformReady = true
        this.isLoading = false
        this.duration = this.wavesurfer.getDuration()
        this.$emit('ready')
        if (this.isPlaying) this.wavesurfer.play()
      })

      this.wavesurfer.on('audioprocess', () => {
        this.currentTime = this.wavesurfer.getCurrentTime()
      })

      this.wavesurfer.on('seek', () => {
        this.currentTime = this.wavesurfer.getCurrentTime()
      })

      this.wavesurfer.on('finish', () => {
        this.$emit('nextTrack')
      })
    })
  },
  beforeUnmount() {
    if (this.wavesurfer) this.wavesurfer.destroy()
  },
  methods: {
    formatTime(seconds) {
      if (!seconds || isNaN(seconds)) return '00:00'
      const m = Math.floor(seconds / 60)
      const s = Math.floor(seconds % 60)
      return `${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`
    },
  },
}
</script>

<style scoped>
.audio-player { width: 100%; }

.waveform-container {
  background: rgba(255, 255, 255, 0.02);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  padding: 24px;
  margin-bottom: 24px;
  min-height: 128px;
  display: flex;
  align-items: center;
  justify-content: center;
  position: relative;
  overflow: hidden;
}

.waveform { width: 100%; cursor: pointer; }

/* Pulse loading */
.loading-overlay { display: flex; flex-direction: column; align-items: center; gap: 20px; }
.pulse-rings { position: relative; width: 44px; height: 44px; display: flex; align-items: center; justify-content: center; }
.pulse-rings span { position: absolute; border: 2.5px solid var(--accent); border-radius: 50%; animation: pulse-out 1.5s ease-out infinite; opacity: 0; }
.pulse-rings span:nth-child(1) { width: 100%; height: 100%; animation-delay: 0s; }
.pulse-rings span:nth-child(2) { width: 70%; height: 70%; animation-delay: 0.4s; }
.pulse-rings span:nth-child(3) { width: 40%; height: 40%; animation-delay: 0.8s; background: var(--accent); opacity: 0.55; animation: none; }

@keyframes pulse-out { 0% { transform: scale(0.5); opacity: 0.8; } 100% { transform: scale(1.4); opacity: 0; } }
.loading-label { font-size: 11px; color: var(--text-muted); letter-spacing: 2px; text-transform: uppercase; font-weight: 500; }

/* Bottom controls and time */
.player-bottom-controls {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 4px;
}

.time-display {
  display: flex;
  align-items: center;
  gap: 8px;
  font-variant-numeric: tabular-nums;
  color: var(--text-muted);
  font-size: 14px;
  font-weight: 500;
  width: 120px;
}

.time-now { color: var(--text-primary); }
.time-divider { opacity: 0.4; }
.time-total { opacity: 0.6; }

.action-controls {
  flex: 1;
  display: flex;
  justify-content: center;
}

.controls-spacer {
  width: 120px; /* matched width to time-display for perfect centering of controls */
}

@media (max-width: 600px) {
  .player-bottom-controls { flex-direction: column; gap: 24px; }
  .time-display { width: auto; justify-content: center; }
  .controls-spacer { display: none; }
}
</style>
