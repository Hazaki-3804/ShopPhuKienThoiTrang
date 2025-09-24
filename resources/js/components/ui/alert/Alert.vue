<template>
  <div v-if="message" :class="alertClasses" class="flex items-center gap-2 p-3 rounded-lg mb-4 text-sm">
    <component :is="icon" class="w-5 h-5" />
    <span>{{ message }}</span>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { CheckCircle, XCircle } from 'lucide-vue-next'

const props = defineProps({
  message: String,
  type: {
    type: String,
    default: 'success' // 'success' | 'error'
  }
})

const alertClasses = computed(() => {
  return props.type === 'success'
    ? 'bg-green-100 text-green-700'
    : 'bg-red-100 text-red-700'
})

const icon = computed(() => {
  return props.type === 'success' ? CheckCircle : XCircle
})
</script>
