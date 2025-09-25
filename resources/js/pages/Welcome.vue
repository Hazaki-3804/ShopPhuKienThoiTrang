<script setup lang="ts">
import MainLayout from '@/layouts/MainLayout.vue';
import HeroSection from '../components/landing_page/HeroSection.vue';
import ProductSection from '../components/landing_page/ProductSection.vue';
import Newsletter from '../components/landing_page/Newsletter.vue';
import ContactForm from '../components/landing_page/ContactForm.vue';
import CategoryrSection from '../components/landing_page/CategorySection.vue';
import { ref } from 'vue';
import { usePage } from '@inertiajs/vue3';
import type { AppPageProps } from '@/types';

const page = usePage<AppPageProps<{ categories: Array<{ id:number; name:string; image:string|null }>; products: Array<{ id:number; name:string; price:string; image:string }> }>>();

const categories = page.props.categories ?? [];
const products = page.props.products ?? [];
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