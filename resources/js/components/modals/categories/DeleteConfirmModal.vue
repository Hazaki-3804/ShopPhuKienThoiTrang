<template>
  <Dialog :open="isOpen" @update:open="$emit('close')">
    <DialogContent class="sm:max-w-[400px]">
      <DialogHeader>
        <DialogTitle class="flex items-center gap-2">
          <AlertTriangle class="h-5 w-5 text-red-500" />
          Xác nhận xóa
        </DialogTitle>
        <DialogDescription>
          {{ isBulk ? `Bạn có chắc chắn muốn xóa ${selectedCount} danh mục đã chọn?` : 'Bạn có chắc chắn muốn xóa danh mục này?' }}
        </DialogDescription>
      </DialogHeader>

      <div v-if="!isBulk && category" class="p-4 bg-muted rounded-lg">
        <div class="flex items-center gap-3">
          <div class="w-12 h-12 bg-background rounded-md flex items-center justify-center">
            <span class="text-xs font-medium">{{ category.name?.charAt(0) || 'N/A' }}</span>
          </div>
          <div>
            <div class="font-medium">{{ category.name }}</div>
            <div class="text-sm text-muted-foreground">
              {{ category.products_count || 0 }} sản phẩm
            </div>
          </div>
        </div>
      </div>

      <div v-if="isBulk" class="p-4 bg-muted rounded-lg">
        <div class="text-sm text-muted-foreground">
          Thao tác này không thể hoàn tác. Tất cả dữ liệu liên quan đến {{ selectedCount }} danh mục sẽ bị xóa vĩnh viễn.
        </div>
      </div>

      <div v-if="!isBulk && category && (category.products_count > 0 || category.categories_count > 0)" class="p-4 bg-yellow-50 border border-yellow-200 rounded-lg">
        <div class="flex items-start gap-2">
          <AlertTriangle class="h-5 w-5 text-yellow-600 mt-0.5" />
          <div class="text-sm text-yellow-800">
            <p class="font-medium">Cảnh báo!</p>
            <p v-if="category.products_count > 0">Danh mục này có {{ category.products_count }} sản phẩm.</p>
            <p v-if="category.categories_count > 0">Danh mục này có {{ category.categories_count }} danh mục con.</p>
            <p class="mt-1">Bạn cần xóa tất cả sản phẩm và danh mục con trước khi xóa danh mục này.</p>
          </div>
        </div>
      </div>

      <DialogFooter>
        <Button variant="outline" @click="$emit('close')">
          Hủy
        </Button>
        <Button 
          variant="destructive" 
          @click="handleConfirm" 
          :disabled="isLoading || (!isBulk && category && (category.products_count > 0 || category.categories_count > 0))"
        >
          <Trash2 class="h-4 w-4" />
          {{ isLoading ? 'Đang xóa...' : 'Xóa' }}
        </Button>
      </DialogFooter>
    </DialogContent>
  </Dialog>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { AlertTriangle, Trash2 } from 'lucide-vue-next'
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from '@/components/ui/dialog'
import { Button } from '@/components/ui/button'

interface Props {
  isOpen: boolean
  category?: any
  isBulk?: boolean
  selectedCount?: number
}

const props = withDefaults(defineProps<Props>(), {
  isBulk: false,
  selectedCount: 0
})

const emit = defineEmits<{
  close: []
  confirm: []
}>()

const isLoading = ref(false)

const handleConfirm = async () => {
  isLoading.value = true
  try {
    emit('confirm')
  } finally {
    isLoading.value = false
  }
}
</script>
