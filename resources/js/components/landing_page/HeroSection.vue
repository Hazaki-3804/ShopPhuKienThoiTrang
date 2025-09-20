<script setup>
import { ref, onMounted, onUnmounted } from 'vue';

const banners = [
  'https://picsum.photos/1200/600?random=1',
  'https://picsum.photos/1200/600?random=2',
  'https://picsum.photos/1200/600?random=4'
];
const currentBanner = ref(0);
let bannerInterval = null;

const nextBanner = () => {
  currentBanner.value = (currentBanner.value + 1) % banners.length;
};
const prevBanner = () => {
  currentBanner.value = (currentBanner.value - 1 + banners.length) % banners.length;
};
const goToBanner = (i) => {
  currentBanner.value = i;
};

onMounted(() => {
  bannerInterval = setInterval(nextBanner, 5000);
});
onUnmounted(() => {
  if (bannerInterval) clearInterval(bannerInterval);
});
</script>

<template>
  <section class="relative w-full h-96 overflow-hidden">
    <div class="absolute inset-0 w-full h-full">
      <img v-for="(banner, i) in banners" :key="i" :src="banner" class="absolute top-0 left-0 w-full h-full object-cover transition-opacity duration-1000" :class="{'opacity-100 z-10': currentBanner === i, 'opacity-0 z-0': currentBanner !== i}">
    </div>
    <div class="absolute inset-0 bg-black bg-opacity-40 flex flex-col justify-center items-center text-white p-4">
      <h1 class="text-4xl md:text-5xl font-extrabold mb-4 text-center animate-fade-in-up">Phụ kiện thời trang</h1>
      <p class="text-lg md:text-xl mb-8 text-center animate-fade-in-up-delay">Khám phá vòng tay, nhẫn, dây chuyền hot trend 2025</p>
      <button class="bg-pink-600 px-8 py-3 rounded-full text-white font-semibold hover:bg-pink-700 transform hover:scale-105 transition-all duration-300 shadow-xl animate-pop-in">
        Xem bộ sưu tập
      </button>
    </div>
    ...
  </section>
</template>
<style scoped>

/* Animations using Tailwind's @keyframes */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes fadeInUp {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes popIn {
  from { opacity: 0; transform: scale(0.9); }
  to { opacity: 1; transform: scale(1); }
}

@keyframes scaleUp {
  from { transform: scale(0.8); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
}

.animate-fade-in {
  animation: fadeIn 0.5s ease-in-out forwards;
}
.animate-fade-in-up {
  animation: fadeInUp 0.6s ease-out forwards;
}
.animate-fade-in-up-delay {
  animation: fadeInUp 0.6s ease-out 0.2s forwards;
}
.animate-pop-in {
  animation: popIn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards;
}
.animate-scale-up {
  animation: scaleUp 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards;
}
</style>