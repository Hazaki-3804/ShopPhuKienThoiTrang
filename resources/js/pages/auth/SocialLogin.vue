<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import { Icon } from '@iconify/vue';

const loading = ref(false);
const error = ref('');
const user = ref(null);

function loginWithProvider(provider) {
  loading.value = true;
  window.location.href = `/api/login/${provider}/redirect`;
}
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
