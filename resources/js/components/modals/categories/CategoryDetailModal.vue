<template>
  <Dialog :open="isOpen" @update:open="$emit('close')">
    <DialogContent class="sm:max-w-[600px]">
      <DialogHeader>
        <DialogTitle>Chi tiết danh mục</DialogTitle>
        <DialogDescription>
          Thông tin chi tiết về danh mục sản phẩm
        </DialogDescription>
      </DialogHeader>

      <div v-if="category" class="space-y-6">
        <!-- Category Info -->
        <div class="flex items-start gap-4">
          <div class="w-16 h-16 bg-primary/10 rounded-lg flex items-center justify-center">
            <span class="text-2xl font-bold text-primary">
              {{ category.name?.charAt(0) || 'N/A' }}
            </span>
          </div>
          <div class="flex-1">
            <h3 class="text-xl font-semibold">{{ category.name }}</h3>
            <p class="text-muted-foreground mt-1">
              {{ category.description || 'Không có mô tả' }}
            </p>
            <div class="flex items-center gap-4 mt-2">
              <Badge variant="secondary">
                {{ category.products_count || 0 }} sản phẩm
              </Badge>
              <Badge v-if="category.parent" variant="outline">
                Danh mục con của: {{ category.parent.name }}
              </Badge>
              <Badge v-else variant="default">
                Danh mục gốc
              </Badge>
            </div>
          </div>
        </div>

        <!-- Category Details -->
        <div class="grid grid-cols-2 gap-4">
          <div class="space-y-2">
            <Label class="text-sm font-medium">ID danh mục</Label>
            <p class="text-sm text-muted-foreground">{{ category.id }}</p>
          </div>
          <div class="space-y-2">
            <Label class="text-sm font-medium">Ngày tạo</Label>
            <p class="text-sm text-muted-foreground">
              {{ formatDate(category.created_at) }}
            </p>
          </div>
          <div class="space-y-2">
            <Label class="text-sm font-medium">Cập nhật lần cuối</Label>
            <p class="text-sm text-muted-foreground">
              {{ formatDate(category.updated_at) }}
            </p>
          </div>
          <div class="space-y-2">
            <Label class="text-sm font-medium">Danh mục cha</Label>
            <p class="text-sm text-muted-foreground">
              {{ category.parent?.name || 'Không có' }}
            </p>
          </div>
        </div>

        <!-- Description -->
        <div v-if="category.description" class="space-y-2">
          <Label class="text-sm font-medium">Mô tả</Label>
          <p class="text-sm text-muted-foreground bg-muted p-3 rounded-md">
            {{ category.description }}
          </p>
        </div>
      </div>

      <DialogFooter>
        <Button variant="outline" @click="$emit('close')">
          Đóng
        </Button>
        <Button @click="$emit('edit', category)">
          <Edit class="h-4 w-4 mr-2" />
          Chỉnh sửa
        </Button>
      </DialogFooter>
    </DialogContent>
  </Dialog>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from '@/components/ui/dialog'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Label } from '@/components/ui/label'
import { Edit } from 'lucide-vue-next'

interface Props {
  isOpen: boolean
  category?: any
}

const props = defineProps<Props>()

const emit = defineEmits<{
  close: []
  edit: [category: any]
}>()

const formatDate = (date: string) => {
  if (!date) return 'N/A'
  return new Date(date).toLocaleDateString('vi-VN', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}
</script>
