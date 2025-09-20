<template>
  <Dialog :open="isOpen" @update:open="$emit('close')">
    <DialogContent class="sm:max-w-[400px]">
      <DialogHeader>
        <DialogTitle class="flex items-center gap-2">
          <AlertTriangle class="h-5 w-5 text-red-500" />
          Xác nhận xóa
        </DialogTitle>
        <DialogDescription>
          {{ isBulk ? `Bạn có chắc chắn muốn xóa ${selectedCount} sản phẩm đã chọn?` : 'Bạn có chắc chắn muốn xóa sản phẩm này?' }}
        </DialogDescription>
      </DialogHeader>

      <div v-if="!isBulk && product" class="p-4 bg-muted rounded-lg">
        <div class="flex items-center gap-3">
          <div class="w-12 h-12 bg-background rounded-md flex items-center justify-center">
            <span class="text-xs font-medium">{{ product.id }}</span>
          </div>
          <div>
            <div class="font-medium">{{ product.name }}</div>
            <div class="text-sm text-muted-foreground">SKU: {{ product.sku }}</div>
          </div>
        </div>
      </div>

      <div v-if="isBulk" class="p-4 bg-muted rounded-lg">
        <div class="text-sm text-muted-foreground">
          Thao tác này không thể hoàn tác. Tất cả dữ liệu liên quan đến {{ selectedCount }} sản phẩm sẽ bị xóa vĩnh viễn.
        </div>
      </div>

      <DialogFooter>
        <Button variant="outline" @click="$emit('close')">
          Hủy
        </Button>
        <Button variant="destructive" @click="handleConfirm" :disabled="isLoading">
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
  product?: any
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
