<script setup lang="ts">
import MainLayout from '@/layouts/MainLayout.vue';
import HeroSection from '../components/landing_page/HeroSection.vue';
import ProductSection from '../components/landing_page/ProductSection.vue';
import Newsletter from '../components/landing_page/Newsletter.vue';
import ContactForm from '../components/landing_page/ContactForm.vue';
import CategoryrSection from '../components/landing_page/CategorySection.vue';
import { ref } from 'vue';

// Dữ liệu mock-up (có thể thay bằng API call)
const categories = [
  { id: 1, name: 'Nhẫn', image: 'https://picsum.photos/1200/600?random=5' },
  { id: 2, name: 'Dây chuyền', image: 'https://picsum.photos/1200/600?random=6' },
  { id: 3, name: 'Vòng tay', image: 'https://picsum.photos/1200/600?random=7' },
  { id: 4, name: 'Khuyên tai', image: 'https://picsum.photos/1200/600?random=8' },
];

const products = [
  { id: 1, name: 'Nhẫn vàng đơn giản', price: '₫499,000', image: 'https://picsum.photos/1200/600?random=9' },
  { id: 2, name: 'Dây chuyền ngọc trai', price: '₫699,000', image: 'https://picsum.photos/1200/600?random=10' },
  { id: 3, name: 'Vòng tay da unisex', price: '₫299,000', image: 'https://picsum.photos/1200/600?random=11' },
  { id: 4, name: 'Khuyên tai bạc đính đá', price: '₫199,000', image: 'https://picsum.photos/1200/600?random=12' },
];
const cartCount = ref(0);
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