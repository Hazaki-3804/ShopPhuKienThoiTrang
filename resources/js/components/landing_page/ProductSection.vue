<script setup>
import { usePage } from '@inertiajs/vue3';
import { login } from '@/routes';

const props = defineProps({
  title: String,  
  items: Array,
  type: String // 'categories' hoặc 'products'
});

const page = usePage();

const addToCart = (prod) => {
  if (!page.props.auth?.user) {
    alert('Bạn cần đăng nhập để thêm sản phẩm vào giỏ hàng!');
    window.location.href = login().url;
    return;
  }
  // Thêm logic cập nhật giỏ hàng thực tế
  alert(`Đã thêm sản phẩm "${prod.name}" vào giỏ hàng.`);
};
const addToWishlist = (prod) => alert(`Đã thêm sản phẩm "${prod.name}" vào danh sách yêu thích.`);
</script>
<template>
  <section class="max-w-7xl mx-auto mt-16 px-4">
    <h2 class="text-3xl font-bold text-center mb-8">{{ title }}</h2>
    <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
      <div v-for="prod in items" :key="prod.id" class="border border-gray-200 rounded-lg overflow-hidden relative group transition-shadow duration-300 hover:shadow-xl">
        <img :src="prod.image" class="w-full h-64 object-cover transition-transform duration-300 group-hover:scale-105">
        <div class="p-4">
          <h3 class="font-semibold text-lg truncate">{{ prod.name }}</h3>
          <p class="text-pink-600 font-bold text-xl mt-1">{{ prod.price }}</p>
        </div>
        <div class="absolute top-3 right-3 flex flex-col space-y-2 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
          <button @click="addToWishlist(prod)" title="Thêm yêu thích" class="p-2 bg-white rounded-full shadow-md text-pink-500 hover:text-pink-700 transition-colors">❤️</button>
          <button @click="addToCart(prod)" title="Thêm giỏ hàng" class="p-2 bg-white rounded-full shadow-md text-gray-600 hover:text-pink-600 transition-colors">🛒</button>
          <button title="Xem chi tiết" class="p-2 bg-white rounded-full shadow-md text-gray-600 hover:text-pink-600 transition-colors">👁</button>
        </div>
      </div>
    </div>
  </section>
</template>