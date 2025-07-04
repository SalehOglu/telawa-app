<template>
  <div class="controls">
    <button @click="$emit('prevTrack')">Previous</button>
    <button @click="$emit('togglePlay')" class="playBtn">{{ isPlaying ? 'Pause' : 'Play' }}</button>
    <button @click="$emit('nextTrack')">Next</button>
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

<style>
.controls {
  display: flex;
  justify-content: center;
  gap: 10px;
  margin: 40px auto;
  align-items: center;
  background: #fffaee;
  border: 1px solid #fff3eb;
  border-radius: 24px;
  color: #565656;
  max-width: 480px;
  padding: 24px;
  position: relative;
  box-shadow:
    0 2px 2px rgba(255, 107, 0, 0.25),
    0 4px 4px rgba(255, 107, 0, 0.2),
    0 8px 8px rgba(255, 107, 0, 0.15),
    0 16px 16px rgba(255, 107, 0, 0.1),
    0 24px 24px rgba(255, 107, 0, 0.05);
}

.controls button {
  padding: 8px 16px;
  border-radius: 100%;
  border: none;
  cursor: pointer;
  min-width: 70px;
  background: linear-gradient(to bottom left, #fff8e7, #ffe1cc);
  color: #838383;
}
.playBtn {
  background: linear-gradient(to bottom left, #ffffff, #fff8e7);
  border: 1px solid #fff3eb !important;
  box-shadow:
    -1px 1px 1px rgba(255, 195, 153, 0.25),
    1px -1px 1px rgba(255, 255, 255, 0.25),
    -2px 2px 2px rgba(255, 195, 153, 0.2),
    2px -2px 2px rgba(255, 255, 255, 0.2),
    -4px 4px 4px rgba(255, 195, 153, 0.15),
    4px -4px 4px rgba(255, 255, 255, 0.15),
    -8px 8px 8px rgba(255, 195, 153, 0.1),
    8px -8px 8px rgba(255, 255, 255, 0.1),
    -16px 16px 16px rgba(255, 195, 153, 0.05),
    16px -16px 16px rgba(255, 255, 255, 0.05);
  color: #f26600 !important;
  padding: 20px !important;
}

.controls button:hover {
  background: linear-gradient(to bottom left, #ffe1cc, #ffb899);
  color: #f26600;
}
</style>
