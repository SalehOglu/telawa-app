<template>
  <div class="playlist-container">
    <div class="playlist-header">
      <h2 class="playlist-title">Surah Chapters</h2>
      <span class="track-count">{{ tracks.length }} Surahs</span>
    </div>

    <div class="tracks-list">
      <div
        v-for="(track, index) in tracks"
        :key="index"
        class="track-row"
        :class="{
          'is-active': current.src === track.src,
          'is-playing': isPlaying && current.src === track.src,
        }"
        @click="$emit('playTrack', track)"
      >
        <div class="track-number">
          <span v-if="isPlaying && current.src === track.src" class="playing-bars">
            <i></i><i></i><i></i>
          </span>
          <span v-else>{{ String(index + 1).padStart(2, '0') }}</span>
        </div>
        
        <div class="track-details">
          <div class="track-name">{{ track.title }}</div>
          <div class="track-info">
             <span class="qari-badge">{{ track.qare2 }}</span>
          </div>
        </div>

        <div class="track-actions">
           <div class="play-indicator">
             <span class="play-icon">▶</span>
           </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps({
  tracks: Array,
  current: Object,
  isPlaying: Boolean,
})
</script>

<style scoped>
.playlist-container {
  padding: 24px;
  height: 100%;
}

.playlist-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 1px solid var(--border);
}

.playlist-title {
  font-family: 'Amiri', serif;
  font-size: 20px;
  color: var(--text-primary);
  margin: 0;
}

.track-count {
  font-size: 10px;
  color: var(--text-muted);
  letter-spacing: 1px;
  text-transform: uppercase;
  font-weight: 500;
}

.tracks-list {
  display: flex;
  flex-direction: column;
  gap: 4px; /* Tighter gap for sidebar */
}

.track-row {
  display: flex;
  align-items: center;
  padding: 12px 16px;
  background: transparent;
  border-radius: var(--radius-md);
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  border: 1px solid transparent;
}

.track-row:hover {
  background: rgba(255, 255, 255, 0.05);
}

.track-row.is-active {
  background: var(--accent-dim);
  border-color: var(--border-accent);
}

.track-number {
  width: 32px;
  font-size: 13px;
  color: var(--text-muted);
  font-weight: 600;
  display: flex;
  align-items: center;
}

.track-row.is-active .track-number {
  color: var(--accent);
}

.track-details { flex: 1; min-width: 0; }
.track-name { font-size: 15px; font-weight: 500; color: var(--text-primary); margin-bottom: 2px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.track-info { font-size: 11px; color: var(--text-muted); opacity: 0.8; }

/* Playing Animation */
.playing-bars { display: flex; align-items: flex-end; gap: 2px; height: 10px; }
.playing-bars i { width: 2.5px; height: 100%; background-color: var(--accent); animation: equalize 1s infinite; border-radius: 1px; }
.playing-bars i:nth-child(2) { animation-delay: -0.4s; }
.playing-bars i:nth-child(3) { animation-delay: -0.7s; }

@keyframes equalize { 0% { height: 3px; } 50% { height: 10px; } 100% { height: 3px; } }

.play-indicator {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background: var(--bg-glass);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: all 0.3s;
  color: var(--accent);
  margin-left: 8px;
}

.track-row:hover .play-indicator,
.track-row.is-active .play-indicator { opacity: 1; }
.track-row.is-playing .play-icon { display: none; }
.play-icon { font-size: 10px; }

@media (max-width: 600px) { .playlist-container { padding: 16px; } }
</style>
