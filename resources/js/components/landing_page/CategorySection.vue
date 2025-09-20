<script setup lang="ts">
import { usePage } from '@inertiajs/vue3';
interface CategoryItem {
  id: number;
  name: string;
  image: string;
}

const props = defineProps<{
  title: string;
  items: CategoryItem[];
  type: string; // 'categories' hoặc 'products'
}>();

const page = usePage();
</script>
<template>
     <section class="max-w-7xl mx-auto mt-16 px-4">
      <h2 class="text-3xl font-bold text-center mb-8">Danh mục sản phẩm</h2>
      <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
        <div 
          v-for="cat in items" 
          :key="cat.id" 
          class="relative rounded-xl overflow-hidden shadow-lg group cursor-pointer transition-transform duration-300 hover:scale-105"
        >
          <img :src="cat.image" class="w-full h-56 object-cover transition-transform group-hover:scale-110">
          <div class="absolute inset-0 bg-black bg-opacity-30 opacity-0 group-hover:opacity-70 flex flex-col items-center justify-center text-white transition-opacity duration-300">
            <h3 class="text-xl font-bold mb-2">{{ cat.name }}</h3>
            <button class="bg-pink-600 px-5 py-2 rounded-full font-semibold hover:bg-pink-700 transition">Xem ngay</button>
          </div>
        </div>
      </div>
    </section>
</template>