<template>
  <!-- Product Cell -->
  <div v-if="type === 'product'" class="flex items-center gap-3">
    <div class="w-12 h-12 bg-muted rounded-md flex items-center justify-center">
      <span class="text-xs font-medium">{{ (getRowData().name || 'N').charAt(0) }}</span>
    </div>
    <div>
      <div class="font-medium">{{ getRowData().name || 'N/A' }}</div>
      <div class="text-sm text-muted-foreground">ID: {{ getRowData().id || 'N/A' }}</div>
    </div>
  </div>

  <!-- SKU Cell -->
  <span v-else-if="type === 'sku'" class="font-mono text-sm">{{ getValue() }}</span>

  <!-- Category Cell -->
  <Badge v-else-if="type === 'category'" variant="outline">
    {{ getRowData()?.category?.name || getValue().name || 'N/A' }}
  </Badge>

  <!-- Price Cell -->
  <div v-else-if="type === 'price'" class="space-y-1">
    <div class="font-medium">{{ formatPrice(getRowData().price || 0) }}</div>
  </div>

  <!-- Stock Cell -->
  <Badge v-else-if="type === 'stock'" :class="getStockColor(getValue())">
    {{ getValue() }} - {{ getStockText(getValue()) }}
  </Badge>

  <!-- Rating Cell -->
  <div v-else-if="type === 'rating'" class="flex items-center gap-1">
    <Star class="h-4 w-4 fill-yellow-400 text-yellow-400" />
    <span class="text-sm font-medium">{{ getValue() }}</span>
  </div>

  <!-- Status Cell -->
  <Badge v-else-if="type === 'status'" :class="getStatusColor(getValue())">
    {{ getStatusText(getValue()) }}
  </Badge>

  <!-- Sales Cell -->
  <div v-else-if="type === 'sales'" class="text-sm font-medium">
    {{ getValue() }}
    <div class="text-xs text-muted-foreground">đã bán</div>
  </div>

  <!-- Actions Cell -->
  <div v-else-if="type === 'actions'" class="flex items-center">
    <DropdownMenu>
      <DropdownMenuTrigger as-child>
        <Button variant="ghost" size="sm">
          <MoreHorizontal class="h-4 w-4" />
        </Button>
      </DropdownMenuTrigger>
      <DropdownMenuContent align="end">
        <DropdownMenuItem class="flex items-center gap-2" @click="$emit('view', getRowData())">
          <Eye class="h-4 w-4" />
          Xem chi tiết
        </DropdownMenuItem>
        <DropdownMenuItem class="flex items-center gap-2" @click="$emit('edit', getRowData())">
          <Edit class="h-4 w-4" />
          Chỉnh sửa
        </DropdownMenuItem>
        <DropdownMenuItem class="text-red-600 flex items-center gap-2" @click="$emit('delete', getRowData())">
          <Trash2 class="h-4 w-4" />
          Xóa
        </DropdownMenuItem>
      </DropdownMenuContent>
    </DropdownMenu>
  </div>

  <!-- Default Cell -->
  <span v-else>{{ getValue() }}</span>
</template>

<script setup lang="ts">
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from '@/components/ui/dropdown-menu'
import { Eye, Edit, Trash2, Star, MoreHorizontal } from 'lucide-vue-next'

interface Props {
  type: 'product' | 'sku' | 'category' | 'price' | 'stock' | 'rating' | 'status' | 'sales' | 'actions'
  getValue?: () => any
  row?: any
  value?: any
}

const props = defineProps<Props>()

const emit = defineEmits<{
  view: [product: any]
  edit: [product: any]
  delete: [product: any]
}>()

// Get value from cell context or direct value
const getValue = () => {
  if (props.getValue) {
    return props.getValue()
  }
  return props.value
}

const getRowData = () => {
  if (props.row) {
    return props.row.original || {}
  }
  return props.value || {}
}

const formatPrice = (price: number) => {
  return new Intl.NumberFormat('vi-VN', {
    style: 'currency',
    currency: 'VND'
  }).format(price)
}

const getStatusColor = (status: number) => {
  return status === 1 ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
}

const getStatusText = (status: number) => {
  return status === 1 ? 'Hoạt động' : 'Tạm dừng'
}

const getStockColor = (stock: number) => {
  if (stock === 0) return 'bg-red-100 text-red-800'
  if (stock < 10) return 'bg-yellow-100 text-yellow-800'
  return 'bg-green-100 text-green-800'
}

const getStockText = (stock: number) => {
  if (stock === 0) return 'Hết hàng'
  if (stock < 10) return 'Sắp hết'
  return 'Còn hàng'
}
</script>
