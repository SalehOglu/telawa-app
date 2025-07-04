<template>
  <div class="controls">
    <button @click="$emit('prevTrack')">Previous</button>
    <button @click="$emit('togglePlay')" class="playBtn">
      <span class="icon" :class="isPlaying ? 'icon-pause' : 'icon-play'"></span>
    </button>
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
  align-items: center;
  border-radius: 24px;
  color: #565656;
  max-width: 480px;
  margin-bottom: 20px;
  position: relative;
}

.controls button {
  padding: 8px 16px;
  border-radius: 100%;
  border: none;
  cursor: pointer;
  background: linear-gradient(to bottom left, #fff8e7, #ffe1cc);
  color: #838383;
  vertical-align: middle;
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
  padding-block: 20px 15px !important;
  width: 70px;
  height: 70px;
}

.playBtn .icon {
  display: inline-block;
  width: 0;
  height: 0;
}

.playBtn .icon.icon-play {
  border-style: solid;
  border-width: 14px 0px 14px 28px;
  border-color: transparent transparent transparent #f26600;
}

.playBtn .icon.icon-pause {
  display: inline-block;
  width: 28px;
  height: 28px;
  position: relative;
  padding-inline: 10px;
}

.playBtn .icon.icon-pause::before,
.playBtn .icon.icon-pause::after {
  content: '';
  position: absolute;
  width: 9px;
  height: 100%;
  background-color: #f26600;
}

.playBtn .icon.icon-pause::before {
  left: 0;
}

.playBtn .icon.icon-pause::after {
  right: 0;
}

.controls button:hover {
  background: linear-gradient(to bottom left, #ffe1cc, #ffb899);
  color: #f26600;
}
</style>
