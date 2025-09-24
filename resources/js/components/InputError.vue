<script setup lang="ts">
defineProps<{
    message?: string;
}>();
</script>

<template>
    <!-- <div v-show="message">
        <p class="text-sm text-red-600 dark:text-red-500">
            {{ message }}
        </p>
    </div> -->
    <p v-if="message" class="mt-1 flex items-center text-[12px] text-red-600">
    <svg
      class="mr-1 h-4 w-4 flex-shrink-0 text-red-500"
      fill="none"
      stroke="currentColor"
      viewBox="0 0 24 24"
    >
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
        d="M12 9v2m0 4h.01m-6.938 4h13.856C18.944 19 20 17.97 20 16.5V7.5C20 6.03 18.944 5 17.918 5H6.082C5.056 5 4 6.03 4 7.5v9c0 1.47 1.056 2.5 2.082 2.5z" />
    </svg>
    {{ message }}
  </p>
</template>
