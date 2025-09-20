<script setup>
import { ref } from 'vue';

const contactForm = ref({
  name: '',
  email: '',
  message: ''
});
const contactLoading = ref(false);
const contactSuccess = ref(false);

const submitContact = async () => {
  if (!contactForm.value.name || !contactForm.value.email || !contactForm.value.message) {
    alert('Vui lòng điền đầy đủ thông tin vào các trường có đánh dấu *');
    return;
  }
  contactLoading.value = true;
  contactSuccess.value = false;

  try {
    await new Promise(r => setTimeout(r, 1500));
    console.log('Contact form submitted:', contactForm.value);
    contactSuccess.value = true;
    contactForm.value = { name: '', email: '', message: '' };
  } catch (e) {
    alert('Có lỗi xảy ra khi gửi tin nhắn, vui lòng thử lại.');
  } finally {
    contactLoading.value = false;
  }
};
</script>

<template>
  <section id="contact" class="max-w-7xl mx-auto mt-20 px-4">
    <div class="bg-gray-50 rounded-2xl shadow-xl overflow-hidden md:flex">
      <div class="md:w-1/2 bg-gray-900 text-white p-8 md:p-12">
        <h3 class="text-3xl font-bold mb-4 text-pink-500">Liên hệ</h3>
        <p class="text-gray-300 mb-6">Chúng tôi luôn sẵn lòng lắng nghe và hỗ trợ bạn. Vui lòng điền thông tin vào form hoặc liên hệ trực tiếp với chúng tôi qua các kênh dưới đây.</p>
        <div class="space-y-4 text-sm text-gray-200">
          <div class="flex items-center gap-3"><svg class="w-6 h-6 text-pink-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg><div><span class="font-semibold text-gray-100">Địa chỉ:</span><br>123 Đường Thời Trang, Quận 1, TP. Hồ Chí Minh</div></div>
          <div class="flex items-center gap-3"><svg class="w-6 h-6 text-pink-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"></path></svg><div><span class="font-semibold text-gray-100">Điện thoại:</span><br>+84 123 456 789</div></div>
          <div class="flex items-center gap-3"><svg class="w-6 h-6 text-pink-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"></path></svg><div><span class="font-semibold text-gray-100">Email:</span><br>contact@fashionshop.com</div></div>
        </div>
      </div>
      <div class="md:w-1/2 p-8 md:p-12">
        <h3 class="text-3xl font-bold mb-6 text-center text-gray-800">Gửi tin nhắn cho chúng tôi</h3>
        <form @submit.prevent="submitContact" class="flex flex-col gap-5">
          <input v-model="contactForm.name" type="text" placeholder="Họ và tên *" class="border border-gray-300 px-4 py-3 rounded-lg focus:outline-none focus:ring-2 focus:ring-pink-500 transition-all placeholder:text-gray-500" required/>
          <input v-model="contactForm.email" type="email" placeholder="Email *" class="border border-gray-300 px-4 py-3 rounded-lg focus:outline-none focus:ring-2 focus:ring-pink-500 transition-all placeholder:text-gray-500" required/>
          <textarea v-model="contactForm.message" rows="5" placeholder="Nội dung tin nhắn *" class="border border-gray-300 p-4 rounded-lg focus:outline-none focus:ring-2 focus:ring-pink-500 transition-all placeholder:text-gray-500" required></textarea>
          <button type="submit" :disabled="contactLoading" class="bg-pink-600 text-white py-3 rounded-lg font-semibold hover:bg-pink-700 transition disabled:opacity-50 disabled:cursor-not-allowed">
            <span v-if="contactLoading">Đang gửi...</span>
            <span v-else>Gửi tin nhắn</span>
          </button>
        </form>
        <p v-if="contactSuccess" class="text-green-600 mt-4 text-center font-semibold animate-fade-in">Tin nhắn của bạn đã được gửi thành công. Chúng tôi sẽ phản hồi sớm nhất có thể. ✓</p>
      </div>
    </div>
  </section>
</template>