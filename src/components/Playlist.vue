<template>
  <div class="playlist">
    <h2>The Playlist</h2>
    <div class="tracksContainer">
      <div
        v-for="(track, index) in tracks"
        :key="index"
        class="item"
        @click="$emit('playTrack', track)"
        :class="{ playing: isPlaying && current === track, active: current === track }"
      >
        {{ track.title }}
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
.playlist {
  margin: 10px auto;
  padding: 10px;
}

.playlist h2 {
  text-align: center;
  margin-bottom: 20px;
}

.playlist .item {
  background-color: peru;
  cursor: pointer;
  display: inline-block;
  min-width: 135px;
  padding: 5px;
  margin: 5px;
  color: white;
}
.playlist .item:hover {
  background: #444;
}

.playlist .item.active {
  background-color: hsla(160, 100%, 37%, 1);
}
.playlist .item.playing {
  background: linear-gradient(to right, #cc2e5d, #ff5858);
}
</style>
