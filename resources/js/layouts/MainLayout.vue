<script setup>
import { dashboard, login, register } from '@/routes';
import { Link, usePage } from '@inertiajs/vue3';
import Chatbot from '@/pages/chatbot/Chatbot.vue';
import BackToTop from '@/pages/components/BackToTop.vue';
import Header from '../components/landing_page/Header.vue';
import Footer from '../components/landing_page/Footer.vue';
import { useCart } from '@/composables/useCart';

// Dữ liệu dùng chung cho layout
const page = usePage();
const { cartCount } = useCart();

</script>

<template>
  <div class="font-sans text-gray-800">
    <Header :cartCount="cartCount" :page="page" />
    <main>
      <slot />
    </main>
    <Footer />
    <Chatbot />
    <BackToTop />
  </div>
</template>