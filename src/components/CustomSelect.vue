<template>
  <div class="custom-select" ref="selectContainer">
    <div class="select-label">Choose Reciter</div>
    <div 
      class="select-trigger" 
      :class="{ 'is-open': isOpen }" 
      @click="toggleSelect"
    >
      <div class="selected-value">
        <span class="value-text">{{ selectedLabel }}</span>
      </div>
      <div class="chevron">
        <svg viewBox="0 0 24 24" fill="currentColor">
          <path d="M7 10l5 5 5-5z"/>
        </svg>
      </div>
    </div>

    <transition name="dropdown">
      <div v-if="isOpen" class="options-menu">
        <div class="options-list">
          <div
            v-for="option in options"
            :key="option.value"
            class="option-item"
            :class="{ 'is-selected': option.value === modelValue }"
            @click="selectOption(option)"
          >
            <span class="option-label">{{ option.label }}</span>
            <div v-if="option.value === modelValue" class="check-icon">
              <svg viewBox="0 0 24 24" fill="currentColor">
                <path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/>
              </svg>
            </div>
          </div>
        </div>
      </div>
    </transition>
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
  mounted() {
    document.addEventListener('click', this.handleClickOutside)
  },
  beforeUnmount() {
    document.removeEventListener('click', this.handleClickOutside)
  },
  methods: {
    toggleSelect() {
      this.isOpen = !this.isOpen
    },
    selectOption(option) {
      this.$emit('update:modelValue', String(option.value))
      this.isOpen = false
    },
    handleClickOutside(event) {
      if (this.$refs.selectContainer && !this.$refs.selectContainer.contains(event.target)) {
        this.isOpen = false
      }
    }
  },
}
</script>

<style scoped>
.custom-select {
  width: 100%;
  position: relative;
  text-align: left;
  user-select: none;
}

.select-label {
  font-size: 10px;
  color: var(--text-muted);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-bottom: 6px;
  font-weight: 600;
  padding-left: 2px;
}

.select-trigger {
  height: 48px; /* Slightly more compact height for the new header position */
  width: 100%;
  background: var(--bg-glass);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  padding: 0 14px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.165, 0.84, 0.44, 1);
  color: var(--text-primary);
}

.select-trigger:hover {
  border-color: var(--border-accent);
  background: rgba(255, 255, 255, 0.08);
  transform: translateY(-1px);
}

.select-trigger.is-open {
  border-color: var(--accent);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

.selected-value {
  flex: 1;
  font-size: 14px;
  font-weight: 500;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.chevron {
  width: 18px;
  height: 18px;
  color: var(--text-muted);
  transition: transform 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.is-open .chevron { transform: rotate(180deg); color: var(--accent); }
.chevron svg { width: 100%; height: 100%; }

.options-menu {
  position: absolute;
  top: calc(100% + 10px);
  left: 0;
  right: 0;
  background: var(--bg-card);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  box-shadow: 0 16px 32px rgba(0, 0, 0, 0.6);
  z-index: 1000;
  overflow: hidden;
  backdrop-filter: blur(40px);
}

.options-list { max-height: 240px; overflow-y: auto; padding: 6px; }
.options-list::-webkit-scrollbar { width: 3px; }
.options-list::-webkit-scrollbar-thumb { background: var(--text-muted); border-radius: 99px; }

.option-item {
  padding: 10px 14px;
  border-radius: var(--radius-sm);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: space-between;
  transition: all 0.2s;
  font-size: 13.5px;
  color: var(--text-secondary);
  margin-bottom: 2px;
}

.option-item:hover { background: var(--bg-glass); color: var(--text-primary); }
.option-item.is-selected { background: var(--accent-dim); color: var(--accent); }
.check-icon { width: 14px; height: 14px; color: var(--accent); }
.check-icon svg { width: 100%; height: 100%; }

/* Transitions */
.dropdown-enter-active, .dropdown-leave-active { transition: all 0.25s cubic-bezier(0.165, 0.84, 0.44, 1); }
.dropdown-enter-from, .dropdown-leave-to { opacity: 0; transform: translateY(-12px) scale(0.98); }
</style>
