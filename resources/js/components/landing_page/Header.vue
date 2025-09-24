<script setup lang="ts">
import { ref, watch, onMounted, onBeforeUnmount } from 'vue';
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
// Search suggest state
const search = ref('');
const showSuggest = ref(false);
const suggestions = ref<Array<{ id: number; name: string; price: number }>>([]);

function debounceFn<T extends (...args: any[]) => void>(fn: T, wait = 250) {
  let t: any;
  return (...args: Parameters<T>) => {
    clearTimeout(t);
    t = setTimeout(() => fn(...args), wait);
  };
}

const fetchSuggest = async (q: string) => {
  if (!q.trim()) {
    suggestions.value = [];
    return;
  }
  try {
    const url = `/search/suggest?q=${encodeURIComponent(q)}&limit=8`;
    const res = await fetch(url, { credentials: 'same-origin' });
    if (!res.ok) return;
    const data = await res.json();
    suggestions.value = data;
  } catch (e) {
    // silent
  }
};

const debouncedFetch = debounceFn((q: string) => fetchSuggest(q), 250);

watch(search, (q) => {
  showSuggest.value = !!q;
  debouncedFetch(q);
});

const handleClickOutside = (e: MouseEvent) => {
  const target = e.target as HTMLElement;
  if (!target.closest?.('#search-box')) {
    showSuggest.value = false;
  }
};

onMounted(() => {
  document.addEventListener('click', handleClickOutside);
});
onBeforeUnmount(() => {
  document.removeEventListener('click', handleClickOutside);
});

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
      <!-- Search Bar with Suggest -->
      <div id="search-box" class="relative hidden md:block w-72">
        <input
          v-model="search"
          type="text"
          placeholder="Tìm kiếm sản phẩm..."
          class="w-full border border-gray-300 rounded-full px-4 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-pink-500 transition-all duration-300"
          @focus="showSuggest = !!search"
        />
        <div
          v-if="showSuggest && suggestions.length"
          class="absolute mt-2 w-full bg-white border border-gray-200 rounded-lg shadow-lg z-50 overflow-hidden"
        >
          <ul class="max-h-80 overflow-auto divide-y divide-gray-100">
            <li
              v-for="item in suggestions"
              :key="item.id"
              class="px-4 py-2 hover:bg-pink-50 cursor-pointer flex items-center justify-between"
              @mousedown.prevent
            >
              <Link :href="`/products/${item.id}`" class="flex-1 pr-2 truncate">
                {{ item.name }}
              </Link>
              <span class="text-pink-600 font-semibold whitespace-nowrap">
                {{ new Intl.NumberFormat('vi-VN').format(item.price) }}₫
              </span>
            </li>
            <li v-if="suggestions.length === 0" class="px-4 py-2 text-gray-500">Không có kết quả</li>
          </ul>
        </div>
      </div>

    <div class="flex items-center gap-4">
      <Link
        v-if="isAuthenticated"
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