<template>
  <button
    v-show="visible"
    @click="scrollToTop"
    class="fixed bottom-6 w-12 h-12  left-6 p-3 rounded-full bg-blue-400 text-white shadow-lg hover:bg-blue-500 transition"
  >
    ↑
  </button>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

const visible = ref(false)

const toggleVisibility = () => {
  visible.value = window.scrollY > 200 // hiện nút khi scroll xuống >200px
}

const scrollToTop = () => {
  window.scrollTo({
    top: 0,
    behavior: 'smooth'
  })
}

onMounted(() => {
  window.addEventListener('scroll', toggleVisibility)
})

onUnmounted(() => {
  window.removeEventListener('scroll', toggleVisibility)
})
</script>
