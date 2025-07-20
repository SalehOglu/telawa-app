<template>
  <div class="new-select">
    <div class="selection" :class="{ open: isOpen }" @click="toggleSelect">
      <p>
        <span>{{ selectedLabel }}</span>
      </p>
      <span></span>
    </div>

    <div class="optionsContainer" v-show="isOpen">
      <div
        v-for="(option, index) in options"
        :key="option.value"
        class="new-option"
        :class="{ reveal: isOpen }"
        @click="selectOption(option)"
      >
        <p>{{ option.label }}</p>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CustomSelect',
  props: {
    options: {
      type: Array,
      required: true,
    },
    modelValue: {
      type: String,
      required: true,
    },
  },
  data() {
    return {
      isOpen: false,
    }
  },
  computed: {
    selectedLabel() {
      const selected = this.options.find((opt) => opt.value === this.modelValue)
      return selected ? selected.label : 'Select Your Reciter'
    },
  },
  methods: {
    toggleSelect() {
      this.isOpen = !this.isOpen
    },
    selectOption(option) {
      this.$emit('update:modelValue', String(option.value))
      this.isOpen = false
    },
    getOptionStyle(index) {
      const count = this.options.length
      if (!this.isOpen) {
        if (index < count - 3) return { top: '0', boxShadow: 'none' }
        else if (index === count - 3) return { top: '3px' }
        else if (index === count - 2) return { top: '7px', left: '2px', right: '2px' }
        else if (index === count - 1) return { top: '11px', left: '4px', right: '4px' }
      } else {
        const optionHeight = 50 // adjust if your .new-option height differs
        return {
          top: `${(index + 1) * (optionHeight + 1)}px`,
          boxShadow: '0 1px 1px rgba(0,0,0,0.1)',
          left: '0',
          right: '0',
        }
      }
      return {}
    },
  },
}
</script>

<style>
.old-select {
  position: absolute;
  top: -9999px;
  left: -9999px;
}
.new-select {
  width: 100%;
  max-width: 300px;
  height: 40px;
  margin: auto;
  margin-top: 20px;
  text-align: center;
  color: #444;
  line-height: 40px;
  position: relative;
}

.new-select .optionsContainer {
  position: absolute;
  top: 100%;
  left: 0;
  right: 0;
  z-index: 10;
  max-height: 230px; /* adjust as needed */
  overflow-y: auto;
  background: white;
  border: 1px solid #ccc;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

.optionsContainer::-webkit-scrollbar {
  width: 6px;
}

.optionsContainer::-webkit-scrollbar-thumb {
  background: #ccc;
  border-radius: 3px;
}

.new-select .selection:active {
  transform: rotateX(42deg);
  transform-style: preserve-3d;
  transform-origin: top;
  transition: transform 200ms ease-in-out;
}

.new-select .selection {
  width: 100%;
  height: 100%;
  background-color: #fff;
  box-shadow: 0 1px 1px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  position: relative;
  z-index: 20;
  transform: rotateX(0deg);
  transform-style: preserve-3d;
  transform-origin: top;
  transition: transform 200ms ease-in-out;
}

.new-select .selection p {
  width: calc(100% - 60px);
  position: relative;

  transition: all 200ms ease-in-out;
}

.new-select .selection:hover,
.new-select .selection.open {
  background-color: #e2e2e2;
  color: #f26600;
}

.new-select .selection > span {
  display: block;
  width: 0;
  height: 0;
  border-style: solid;
  border-width: 14px 8px 0 8px; /* Height: 14px / Width: 16px */
  border-color: #bbb transparent transparent transparent;
  position: absolute;
  top: 13px; /* 40 / 2 - 14 / 2 */
  right: 22px; /* 60 / 2 - 16 / 2 */
}

.new-select .selection.open > span {
  width: 0;
  height: 0;
  border-style: solid;
  border-width: 0 8px 14px 8px;
  border-color: transparent transparent #bbb transparent;
}

.new-option {
  text-align: center;
  background-color: #fff;
  cursor: pointer;
  box-shadow: 0 1px 1px rgba(0, 0, 0, 0.1);
  position: relative;
  margin-top: 1px;
  transition: all 300ms ease-in-out;
}

.new-option.reveal:hover {
  background-color: #ffc9ae;
  color: #333;
}
</style>
