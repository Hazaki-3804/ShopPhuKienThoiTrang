<template>
  <Dialog :open="isOpen" @update:open="$emit('close')">
    <DialogContent class="sm:max-w-[800px]">
      <DialogHeader>
        <DialogTitle>Chi tiết sản phẩm</DialogTitle>
        <DialogDescription>
          Thông tin chi tiết về sản phẩm
        </DialogDescription>
      </DialogHeader>

      <div v-if="product" class="space-y-6">
        <!-- Product Info -->
        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div class="space-y-4">
            <div>
              <h3 class="text-lg font-semibold">{{ product.name }}</h3>
              <p class="text-sm text-muted-foreground">SKU: {{ product.sku }}</p>
            </div>
            
            <div class="space-y-2">
              <div class="flex justify-between">
                <span class="text-sm font-medium">Danh mục:</span>
                <Badge variant="outline">{{ product.category.name }}</Badge>
              </div>
              <div class="flex justify-between">
                <span class="text-sm font-medium">Trạng thái:</span>
                <Badge :class="getStatusColor(product.status)">
                  {{ getStatusText(product.status) }}
                </Badge>
              </div>
              <div class="flex justify-between">
                <span class="text-sm font-medium">Tồn kho:</span>
                <Badge :class="getStockColor(product.stock)">
                  {{ product.stock }} - {{ getStockText(product.stock) }}
                </Badge>
              </div>
            </div>
          </div>

          <div class="space-y-4">
            <div class="space-y-2">
              <div class="flex justify-between">
                <span class="text-sm font-medium">Giá bán:</span>
                <span class="font-semibold text-lg">{{ formatPrice(product.price) }}</span>
              </div>
              <div class="flex justify-between">
                <span class="text-sm font-medium">Giá gốc:</span>
                <span class="text-muted-foreground line-through">{{ formatPrice(product.originalPrice) }}</span>
              </div>
              <div class="flex justify-between">
                <span class="text-sm font-medium">Đánh giá:</span>
                <div class="flex items-center gap-1">
                  <Star class="h-4 w-4 fill-yellow-400 text-yellow-400" />
                  <span class="font-medium">{{ product.rating }}</span>
                </div>
              </div>
              <div class="flex justify-between">
                <span class="text-sm font-medium">Đã bán:</span>
                <span class="font-medium">{{ product.sales }} sản phẩm</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Description -->
        <div v-if="product.description">
          <h4 class="text-sm font-medium mb-2">Mô tả</h4>
          <p class="text-sm text-muted-foreground">{{ product.description }}</p>
        </div>

        <!-- Stats -->
        <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
          <Card>
            <CardContent class="p-4">
              <div class="text-2xl font-bold">{{ product.stock }}</div>
              <p class="text-xs text-muted-foreground">Tồn kho</p>
            </CardContent>
          </Card>
          <Card>
            <CardContent class="p-4">
              <div class="text-2xl font-bold">{{ product.sales }}</div>
              <p class="text-xs text-muted-foreground">Đã bán</p>
            </CardContent>
          </Card>
          <Card>
            <CardContent class="p-4">
              <div class="text-2xl font-bold">{{ product.rating }}</div>
              <p class="text-xs text-muted-foreground">Đánh giá</p>
            </CardContent>
          </Card>
          <Card>
            <CardContent class="p-4">
              <div class="text-2xl font-bold">{{ formatPrice(product.price) }}</div>
              <p class="text-xs text-muted-foreground">Giá bán</p>
            </CardContent>
          </Card>
        </div>
      </div>

      <DialogFooter>
        <Button variant="outline" @click="$emit('close')">
          Đóng
        </Button>
      </DialogFooter>
    </DialogContent>
  </Dialog>
</template>

<script setup lang="ts">
import { Star } from 'lucide-vue-next'
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from '@/components/ui/dialog'
import { Button } from '@/components/ui/button'
import { Badge } from '@/components/ui/badge'
import { Card, CardContent } from '@/components/ui/card'

interface Props {
  isOpen: boolean
  product?: any
}

defineProps<Props>()

const emit = defineEmits<{
  close: []
  edit: [product: any]
}>()

const formatPrice = (price: number) => {
  return new Intl.NumberFormat('vi-VN', {
    style: 'currency',
    currency: 'VND'
  }).format(price)
}

const getStatusColor = (status: string) => {
  return status === 'active' ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
}

const getStatusText = (status: string) => {
  return status === 'active' ? 'Hoạt động' : 'Tạm dừng'
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
