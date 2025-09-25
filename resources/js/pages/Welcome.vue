<script setup lang="ts">
import MainLayout from '@/layouts/MainLayout.vue';
import HeroSection from '../components/landing_page/HeroSection.vue';
import ProductSection from '../components/landing_page/ProductSection.vue';
import Newsletter from '../components/landing_page/Newsletter.vue';
import ContactForm from '../components/landing_page/ContactForm.vue';
import CategoryrSection from '../components/landing_page/CategorySection.vue';
import { onMounted, ref } from 'vue';

const categories = ref<Array<{ id:number; name:string; image:string }>>([]);
const products = ref<Array<{ id:number; name:string; price:string; image:string }>>([]);
const cartCount = ref(0);

onMounted(async () => {
  try {
    const [cRes, pRes] = await Promise.all([
      fetch('/api/home/categories', { credentials: 'same-origin' }),
      fetch('/api/home/products', { credentials: 'same-origin' }),
    ]);
    if (cRes.ok) categories.value = await cRes.json();
    if (pRes.ok) products.value = await pRes.json();
  } catch (_) {}
});
</script>

<template>
  <MainLayout>
    <HeroSection />
    <CategoryrSection title="Danh mục sản phẩm" :items="categories" type="categories" />
    <ProductSection title="Sản phẩm nổi bật" :items="products" type="products" :cart-count="cartCount"
  @add-to-cart="cartCount++" />
    <Newsletter />
    <ContactForm />
  </MainLayout>
</template>