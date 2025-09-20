<script setup lang="ts">
import { useAppearance } from '@/composables/useAppearance';
import { Moon, Sun } from 'lucide-vue-next';

const { appearance, updateAppearance } = useAppearance();

const toggleTheme = () => {
  updateAppearance(appearance.value === 'dark' ? 'light' : 'dark');
};
</script>

<template>
  <button
    @click="toggleTheme"
    class="rounded-full p-2 transition hover:bg-neutral-200 dark:hover:bg-neutral-700 cursor-pointer"
  >
    <Sun v-if="appearance === 'light'" class="h-5 w-5 text-yellow-500" />
    <Moon v-else class="h-5 w-5 text-gray-800 dark:text-gray-200" />
  </button>
</template>
