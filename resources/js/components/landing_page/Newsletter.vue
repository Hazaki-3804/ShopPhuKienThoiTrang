<script setup>
import { ref } from 'vue';

const email = ref('');
const success = ref(false);
const loading = ref(false);

const subscribe = async () => {
  if (!email.value) return;
  loading.value = true;
  success.value = false;
  try {
    await new Promise(r => setTimeout(r, 1500));
    console.log('Subscribed with email:', email.value);
    success.value = true;
    email.value = '';
  } catch (e) {
    alert('Đăng ký thất bại, vui lòng thử lại!');
  } finally {
    loading.value = false;
  }
};
</script>

<template>
  <section class="max-w-6xl mx-auto mt-16 px-4">
    <div class="bg-gradient-to-r from-pink-500 to-pink-600 text-white rounded-2xl shadow-xl overflow-hidden md:flex items-center p-8 md:p-12">
      <div class="md:w-1/2 text-center md:text-left mb-6 md:mb-0">
        <h2 class="text-3xl md:text-4xl font-extrabold mb-2 leading-tight">Đừng bỏ lỡ ưu đãi!</h2>
        <p class="text-pink-100 text-lg">Nhận thông tin về các sản phẩm và chương trình khuyến mãi độc quyền từ FashionShop.</p>
      </div>
      <div class="md:w-1/2 flex justify-center">
        <div class="w-full max-w-md">
          <form @submit.prevent="subscribe" class="flex flex-col md:flex-row gap-3">
            <input type="email" v-model="email" placeholder="Nhập email của bạn..." class="flex-1 px-5 py-3 rounded-full text-gray-800 bg-white focus:outline-none focus:ring-2 focus:ring-pink-300 transition-all placeholder:text-gray-500" />
            <button type="submit" :disabled="loading" class="bg-white text-pink-600 font-bold px-6 py-3 rounded-full shadow-md hover:bg-gray-100 transition disabled:opacity-50 disabled:cursor-not-allowed">
              <span v-if="loading">Đang đăng ký...</span>
              <span v-else>Đăng ký ngay</span>
            </button>
          </form>
          <p v-if="success" class="text-green-200 mt-3 text-sm font-semibold text-center md:text-left animate-fade-in">Đăng ký thành công! Chào mừng bạn đến với FashionShop. ✓</p>
        </div>
      </div>
    </div>
  </section>
</template>