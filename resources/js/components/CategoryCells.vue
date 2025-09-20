<template>
  <div v-if="type === 'category'" class="flex items-center gap-3">
    <div class="w-10 h-10 bg-primary/10 rounded-lg flex items-center justify-center">
      <span class="text-sm font-medium text-primary">
        {{ getRowData()?.name?.charAt(0) || 'N/A' }}
      </span>
    </div>
    <div>
      <div class="font-medium">{{ getRowData()?.name || 'N/A' }}</div>
      <div class="text-sm text-muted-foreground">
        {{ getRowData()?.description || 'Không có mô tả' }}
      </div>
    </div>
  </div>

  <div v-else-if="type === 'parent'" class="text-sm">
    {{ getRowData()?.parent?.name || 'Danh mục gốc' }}
  </div>

  <div v-else-if="type === 'productCount'" class="text-center">
    <Badge :class="getProductCountColor(getValue())">
      {{ getValue() || 0 }} sản phẩm
    </Badge>
  </div>

  <div v-else-if="type === 'createdAt'" class="text-sm text-muted-foreground">
    {{ formatDate(getValue()) }}
  </div>

  <div v-else-if="type === 'actions'" class="flex items-center gap-2">
    <Button variant="ghost" size="sm" @click="$emit('view', getRowData())">
      <Eye class="h-4 w-4" />
    </Button>
    <Button variant="ghost" size="sm" @click="$emit('edit', getRowData())">
      <Edit class="h-4 w-4" />
    </Button>
    <Button variant="ghost" size="sm" @click="$emit('delete', getRowData())">
      <Trash2 class="h-4 w-4" />
    </Button>
  </div>

  <div v-else>
    {{ getValue() || 'N/A' }}
  </div>
</template>

<script setup lang="ts">
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Eye, Edit, Trash2 } from 'lucide-vue-next'

interface Props {
  type: 'category' | 'parent' | 'productCount' | 'createdAt' | 'actions'
  getValue?: () => any
  row?: any
}

const props = defineProps<Props>()

const emit = defineEmits<{
  view: [category: any]
  edit: [category: any]
  delete: [category: any]
}>()

const getRowData = () => {
  return props.row?.original || {}
}

const getProductCountColor = (count: number) => {
  if (count === 0) return 'bg-gray-100 text-gray-800'
  if (count < 5) return 'bg-yellow-100 text-yellow-800'
  return 'bg-green-100 text-green-800'
}

const formatDate = (date: string) => {
  if (!date) return 'N/A'
  return new Date(date).toLocaleDateString('vi-VN')
}
</script>
