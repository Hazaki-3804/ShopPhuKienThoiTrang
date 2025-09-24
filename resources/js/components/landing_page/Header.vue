<script setup>
import { ref } from 'vue';
import { dashboard, login, register } from '@/routes';
import { Link } from '@inertiajs/vue3';
import { useCart } from '@/composables/useCart';

const props = defineProps({
  cartCount: {
    type: Number,
    default: 0
  },
  page: {
    type: Object,
    required: true
  }
});

const mobileMenuOpen = ref(false);
const toggleMobileMenu = () => {
  mobileMenuOpen.value = !mobileMenuOpen.value;
};

const { viewCart, isAuthenticated } = useCart();

// Hàm chuyển hướng đến giỏ hàng với auth check
const goToCart = () => {
  viewCart();
};
</script>

<template>
  <header class="sticky top-0 bg-white shadow-md z-50 transition-all duration-300">
    <div class="max-w-7xl mx-auto flex justify-between items-center px-4 py-3">
      <div class="text-2xl font-extrabold text-pink-600">FashionShop</div>

      <nav class="hidden lg:flex items-center space-x-8">
        <a href="#" class="text-gray-600 hover:text-pink-600 font-medium transition duration-200">Trang chủ</a>
        <a href="#" class="text-gray-600 hover:text-pink-600 font-medium transition duration-200">Sản phẩm</a>
        <a href="#" class="text-gray-600 hover:text-pink-600 font-medium transition duration-200">Bộ sưu tập</a>
        <a href="#" class="text-gray-600 hover:text-pink-600 font-medium transition duration-200">Blog</a>
        <a href="#contact" class="text-gray-600 hover:text-pink-600 font-medium transition duration-200">Liên hệ</a>
      </nav>
      <!-- Search Bar -->
      <input type="text" placeholder="Tìm kiếm..." class="hidden md:block border border-gray-300 rounded-full px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-pink-500 transition-all duration-300">

    <div class="flex items-center gap-4">
      <Link
        v-if="$page.props.auth?.user.role_id === 1 || $page.props.auth?.user.role_id === 2"
        :href="dashboard()"
        class="px-5 py-2 rounded-full bg-pink-600 text-black font-semibold shadow-lg hover:bg-pink-700 transition duration-300"
      >
        Dashboard
      </Link>

      <template v-else>
        <Link
          :href="login()"
          class="hidden md:inline-block px-5 py-2 rounded-full border-2 border-pink-600 text-pink-600 font-semibold hover:bg-pink-50 transition duration-300"
        >
          Đăng nhập
        </Link>
        <Link
          :href="register()"
          class="hidden md:inline-block px-5 py-2 rounded-full bg-pink-600 text-white font-semibold shadow-lg hover:bg-pink-700 transition duration-300"
        >
          Đăng ký
        </Link>
      </template>
      <button
        v-if="isAuthenticated"
        @click="goToCart"
        class="relative px-3 py-2 rounded-full bg-white border border-pink-600 text-pink-600 hover:bg-pink-50 transition duration-300"
      >
        🛒
        <span v-if="cartCount > 0" class="absolute top-0 right-0 bg-pink-600 text-white rounded-full px-2 text-xs font-bold">{{ cartCount }}</span>
      </button>
<!-- Mobile Hamburger -->
        <button
          class="lg:hidden text-pink-600 focus:outline-none"
          @click="toggleMobileMenu"
          aria-label="Mở menu"
        >
          <svg width="32" height="32" fill="none" viewBox="0 0 24 24">
            <rect y="6" width="24" height="2" rx="1" fill="currentColor"/>
            <rect y="11" width="24" height="2" rx="1" fill="currentColor"/>
            <rect y="16" width="24" height="2" rx="1" fill="currentColor"/>
          </svg>
        </button>
      </div>
    </div>
  </header>
  <transition name="slide-fade">
    <nav
      v-if="mobileMenuOpen"
      class="lg:hidden absolute top-[64px] left-0 w-full bg-white shadow-md z-50 overflow-hidden"
    >
      <ul class="flex flex-col py-4 px-6 space-y-2">
        <li><a href="#" class="text-gray-700 font-medium py-2 hover:text-pink-600">Trang chủ</a></li>
        <li><a href="#" class="text-gray-700 font-medium py-2 hover:text-pink-600">Sản phẩm</a></li>
        <li><a href="#" class="text-gray-700 font-medium py-2 hover:text-pink-600">Bộ sưu tập</a></li>
        <li><a href="#" class="text-gray-700 font-medium py-2 hover:text-pink-600">Blog</a></li>
        <li><a href="#contact" class="text-gray-700 font-medium py-2 hover:text-pink-600">Liên hệ</a></li>
        <li>
          <Link :href="login()" class="block text-gray-700 font-semibold py-2 hover:text-pink-600">Đăng nhập</Link>
        </li>
        <li>
          <Link :href="register()" class="block text-pink-600 font-semibold py-2 hover:text-pink-700">Đăng ký</Link>
        </li>
      </ul>
    </nav>
  </transition>
</template>
<style scoped>
.slide-fade-enter-active, .slide-fade-leave-active {
  transition: max-height 0.4s cubic-bezier(.4,0,.2,1), opacity 0.3s;
}
.slide-fade-enter-from, .slide-fade-leave-to {
  max-height: 0;
  opacity: 0;
}
.slide-fade-enter-to, .slide-fade-leave-from {
  max-height: 500px;
  opacity: 1;
}
</style>