<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import { Icon } from '@iconify/vue';

const loading = ref(false);
const error = ref('');
const user = ref(null);

const apiUrl = import.meta.env.VITE_APP_URL || 'http://localhost:8000';

const loginWithProvider = async (provider) => {
  try {
    loading.value = true;
    error.value = '';
    // Lấy URL đăng nhập từ backend
    const response = await axios.get(`${apiUrl}/login/${provider}/redirect`);
    const providerUrl = response.data.url;
    // Mở popup để đăng nhập
    const popup = window.open(providerUrl, `${provider}-login`, 'width=500,height=600,scrollbars=yes');

    const handleMessage = (event) => {
      if (event.data.type === 'FACEBOOK_LOGIN_SUCCESS' || event.data.type === 'GOOGLE_LOGIN_SUCCESS') {
        user.value = event.data.user;
        // Lưu token vào localStorage
        const token = event.data.token;
        localStorage.setItem('auth_token', token);
        window.location='/dashboard';
        // Đóng popup sau khi nhận được thông tin
        popup.close();
        window.removeEventListener('message', handleMessage);
      }
    };
    window.addEventListener('message', handleMessage);
    // Đặt timeout để tránh treo popup quá lâu
    setTimeout(() => {
      if (popup.closed) {
        window.removeEventListener('message', handleMessage);
      }
    }, 10000);
  
  } catch (err) {
    error.value = 'Lỗi đăng nhập: ' + err.message;
  } finally {
    loading.value = false;
  }
};
// Kiểm tra nếu đã đăng nhập (có token trong localStorage)
onMounted(() => {
  const token = localStorage.getItem('auth_token');
  if (token) {
    // axios.get(`${apiUrl}/user`).then(res => user.value = res.data);
  }
});
</script>

<template>
  <div class="flex flex-col items-center gap-4 mt-3">
    <button
      @click="loginWithProvider('facebook')"
      :disabled="loading"
      class="flex items-center justify-center w-full gap-2 px-6 py-2 rounded-lg border text-sm border-gray-300 text-gray-700 hover:bg-gray-100 disabled:opacity-60"
    >
      <Icon icon="logos:facebook" class="w-6 h-6" />
      <span>{{ loading ? 'Đang đăng nhập...' : 'Đăng nhập với Facebook' }}</span>
    </button>

    <button
      @click="loginWithProvider('google')"
      :disabled="loading"
      class="flex items-center justify-center w-full gap-2 px-6 py-2 rounded-lg border text-sm border-gray-300 text-gray-700 hover:bg-gray-100 disabled:opacity-60"
    >
      <Icon icon="logos:google-icon" class="w-6 h-6" />
      <span>{{ loading ? 'Đang đăng nhập...' : 'Đăng nhập với Google' }}</span>
    </button>
  </div>

</template>
