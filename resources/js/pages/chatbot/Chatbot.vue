<script setup lang="ts">
import { ref, nextTick, watch } from 'vue';
import axios from 'axios';

// Chatbot Gemini API
type ChatMessage = {
  role: string;
  content: string;
  links?: Record<string, string>;
};

const chatHistory = ref<ChatMessage[]>([
  { role: 'bot', content: 'Chào bạn, tôi là trợ lý ảo của FashionShop. Bạn cần hỗ trợ gì không?' }
]);
const chatInput = ref('')
const showChat = ref(false)
const chatLoading = ref(false)

const chatContainer = ref<HTMLElement | null>(null); // <-- Thêm ref này

const toggleChat = () => showChat.value = !showChat.value

const sendMessage = async () => {
  if (!chatInput.value.trim()) return

  const userMessage = chatInput.value.trim()
  chatHistory.value.push({ role: 'user', content: userMessage })
  chatInput.value = ''
  chatLoading.value = true

  try {
    const res = await axios.post('/api/chatbot', { message: userMessage })
    chatHistory.value.push({ 
        role: 'bot', 
        content: res.data.message, 
        links: res.data.links || {} 
    })
  } catch (e) {
    console.error(e)
    chatHistory.value.push({ role: 'bot', content: 'Có lỗi xảy ra, thử lại sau.' })
  } finally {
    chatLoading.value = false
  }
}

// Hàm cuộn
const scrollToBottom = () => {
  if (chatContainer.value) {
    chatContainer.value.scrollTop = chatContainer.value.scrollHeight;
  }
};

// Theo dõi thay đổi của chatHistory và cuộn
watch(chatHistory, () => {
  nextTick(() => {
    scrollToBottom();
  });
}, { deep: true });
</script>

<template>
    <div class="fixed bottom-6 right-6 z-50">
      <button @click="toggleChat" class="bg-pink-600 text-white p-4 rounded-full shadow-lg hover:scale-110 transition-transform duration-300">💬</button>
      <div 
        v-if="showChat" 
        class="w-80 h-96 bg-white rounded-lg shadow-xl flex flex-col overflow-hidden mt-4 origin-bottom-right animate-scale-up"
      >
        <div class="bg-pink-600 text-white p-3 flex justify-between items-center font-bold">
          <span>Fashion Assistant</span>
          <button @click="toggleChat" class="text-white hover:text-gray-200">✕</button>
        </div>
        
        <div class="flex-1 p-4 overflow-y-auto space-y-4 custom-scrollbar" ref="chatContainer">
          <div 
            v-for="(msg, index) in chatHistory" 
            :key="index" 
            :class="msg.role === 'user' ? 'flex justify-end' : 'flex justify-start'"
          >
             <span class="mr-1">
        {{ msg.role === 'user' ? '👤' : '🤖' }}
      </span>
            <div 
              class="inline-block p-3 rounded-lg max-w-[80%]" 
              :class="msg.role === 'user' ? 'bg-pink-100 text-pink-800' : 'bg-gray-200 text-gray-800'"
            >
              {{ msg.content }}
              
              <div v-if="msg.links && Object.keys(msg.links).length > 0" class="mt-2 flex flex-wrap gap-2">
                <a 
                  v-for="(url, key) in msg.links"
                  :key="key"
                  :href="url"
                  target="_blank"
                  class="bg-pink-500 text-white text-xs px-3 py-1 rounded-full hover:bg-pink-600 transition-colors"
                >
                  {{ key.charAt(0).toUpperCase() + key.slice(1) }}
                </a>
              </div>
            </div>
          </div>
          <div v-if="chatLoading" class="text-center text-gray-500">...</div>
        </div>

        <div class="p-3 border-t flex gap-2">
          <input 
            v-model="chatInput" 
            @keyup.enter="sendMessage" 
            placeholder="Nhập tin nhắn..." 
            class="flex-1 border border-gray-300 px-3 py-2 rounded-full focus:outline-none focus:ring-1 focus:ring-pink-500"
          />
          <button @click="sendMessage" class="bg-pink-600 px-4 rounded-full text-white font-semibold hover:bg-pink-700 transition">
            <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
                <path d="M10.894 2.553a1 1 0 00-1.788 0l-7 14a1 1 0 00.947 1.352L9 16.294V10a1 1 0 012 0v6.294l5.947 1.611a1 1 0 00.947-1.352l-7-14z"/>
            </svg>    
            </button>
        </div>
      </div>
    </div>
</template>
<style scoped>
/* Custom scrollbar for chat */
.custom-scrollbar::-webkit-scrollbar {
  width: 6px;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background: rgba(0, 0, 0, 0.2);
  border-radius: 3px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
</style>