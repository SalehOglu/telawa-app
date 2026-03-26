<template>
  <div class="controls-container">
    <div class="main-controls">
      <!-- Previous Track -->
      <button class="btn btn-prev" @click="$emit('prevTrack')" title="Previous Surah">
        <svg viewBox="0 0 24 24" fill="currentColor">
          <path d="M6 6h2v12H6zm3.5 6L18 18V6z"/>
        </svg>
      </button>

      <!-- Toggle Play -->
      <div class="play-pause-btn-wrap" :class="{ 'is-playing': isPlaying }">
        <button class="btn btn-play-pause" @click="$emit('togglePlay')" :title="isPlaying ? 'Pause' : 'Play'">
          <div v-if="!isPlaying" class="icon icon-play">
            <svg viewBox="0 0 24 24" fill="currentColor">
              <path d="M8 5v14l11-7z"/>
            </svg>
          </div>
          <div v-else class="icon icon-pause">
            <svg viewBox="0 0 24 24" fill="currentColor">
              <path d="M6 19h4V5H6v14zm8-14v14h4V5h-4z"/>
            </svg>
          </div>
        </button>
      </div>

      <!-- Next Track -->
      <button class="btn btn-next" @click="$emit('nextTrack')" title="Next Surah">
        <svg viewBox="0 0 24 24" fill="currentColor">
          <path d="M6 18l8.5-6L6 6v12zM16 6v12h2V6h-2z"/>
        </svg>
      </button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'MusicControls',
  props: {
    isPlaying: {
      type: Boolean,
      default: false,
    },
  },
}
</script>

<style scoped>
.controls-container {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 10px 0;
}

.main-controls {
  display: flex;
  align-items: center;
  gap: 20px;
}

.btn {
  background: none;
  border: none;
  cursor: pointer;
  color: var(--text-muted);
  transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 8px;
  border-radius: 50%;
}

.btn svg {
  width: 28px;
  height: 28px;
}

.btn:hover {
  color: var(--text-primary);
  background: var(--bg-glass);
  transform: scale(1.1);
}

.btn:active {
  transform: scale(0.9);
}

/* Play/Pause Button Specifics */
.play-pause-btn-wrap {
  position: relative;
  width: 72px;
  height: 72px;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 5;
}

.play-pause-btn-wrap::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: var(--accent);
  border-radius: 50%;
  opacity: 0.15;
  filter: blur(8px);
  transition: all 0.4s ease;
}

.play-pause-btn-wrap.is-playing::before {
  opacity: 0.35;
  transform: scale(1.1);
  filter: blur(12px);
}

.btn-play-pause {
  width: 100%;
  height: 100%;
  background: linear-gradient(135deg, var(--accent) 0%, var(--accent-light) 100%);
  color: white;
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.4), 0 4px 8px var(--accent-glow);
  position: relative;
  z-index: 10;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.btn-play-pause:hover {
  background: linear-gradient(135deg, var(--accent-light) 0%, var(--accent) 100%);
  transform: scale(1.05);
  color: white;
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.5), 0 4px 12px var(--accent-glow);
}

.btn-play-pause svg {
  width: 38px;
  height: 38px;
  filter: drop-shadow(0 2px 4px rgba(0,0,0,0.25));
}

.icon-play {
  margin-left: 4px; /* compensate for play triangle shape */
}

/* Sub-controls like shuffle/repeat could be added here in the future if needed */
</style>
