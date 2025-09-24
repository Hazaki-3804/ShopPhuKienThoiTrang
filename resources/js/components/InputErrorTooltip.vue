<template>
  <div v-if="message" class="relative flex items-center group">
    <!-- icon cảnh báo -->
    <svg
      class="ml-2 h-5 w-5 text-red-500 cursor-help"
      fill="none"
      stroke="currentColor"
      viewBox="0 0 24 24"
    >
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M12 9v2m0 4h.01m-6.938 4h13.856C18.944 19 20 17.97 20 16.5V7.5C20 6.03 18.944 5 17.918 5H6.082C5.056 5 4 6.03 4 7.5v9c0 1.47 1.056 2.5 2.082 2.5z"
      />
    </svg>

    <!-- tooltip -->
    <div
  class="absolute left-full top-1/2 z-10 ml-2 hidden w-max -translate-y-1/2 
         rounded-lg bg-red-600 px-3 py-1.5 text-xs text-white shadow-lg 
         opacity-0 transition-opacity duration-200 group-hover:block group-hover:opacity-100"    >
      * {{ message }}
      <!-- mũi tên -->
        <div class="absolute top-1/2 left-0 -translate-y-1/2 -translate-x-full border-y-8 border-y-transparent border-r-8 border-r-red-600"></div>
    </div>
  </div>
</template>

<script setup lang="ts">
defineProps<{ message?: string }>()
</script>
