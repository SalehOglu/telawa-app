<template>
  <div class="controls">
    <button @click="$emit('prevTrack')">Previous</button>
    <button @click="$emit('togglePlay')">{{ isPlaying ? 'Pause' : 'Play' }}</button>
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
</style>
