<template>
  <Dialog :open="isOpen" @update:open="$emit('close')">
    <DialogContent class="sm:max-w-[600px]">
      <DialogHeader>
        <DialogTitle>{{ isEdit ? 'Chỉnh sửa sản phẩm' : 'Thêm sản phẩm mới' }}</DialogTitle>
        <DialogDescription>
          {{ isEdit ? 'Cập nhật thông tin sản phẩm' : 'Nhập thông tin sản phẩm mới' }}
        </DialogDescription>
      </DialogHeader>

      <form @submit.prevent="handleSubmit" class="space-y-4">
        <div class="space-y-2">
          <Label for="name">Tên sản phẩm</Label>
          <Input
            id="name"
            v-model="form.name"
            placeholder="Nhập tên sản phẩm"
            :class="{ 'border-red-500': hasFieldError('name') }"
            required
          />
          <p v-if="hasFieldError('name')" class="text-sm text-red-500">{{ getFieldError('name') }}</p>
        </div>

        <div class="grid grid-cols-2 gap-4">
          <div class="space-y-2">
            <Label for="category">Danh mục</Label>
            <select
              id="category"
              v-model="form.category_id"
              :class="['h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm', { 'border-red-500': hasFieldError('category_id') }]"
            >
              <option value="" disabled>Chọn danh mục</option>
               <option v-for="category in props.categories" :key="category.id" :value="category.id">
                 {{ category.name }}
               </option>
            </select>
            <p v-if="hasFieldError('category_id')" class="text-sm text-red-500">{{ getFieldError('category_id') }}</p>
          </div>
          <div class="space-y-2">
            <Label for="status">Trạng thái</Label>
            <select
              id="status"
              v-model="form.status"
              :class="['h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm', { 'border-red-500': hasFieldError('status') }]"
            >
              <option value="" disabled>Chọn trạng thái</option>
              <option :value="1">Hoạt động</option>
              <option :value="0">Tạm dừng</option>
            </select>
            <p v-if="hasFieldError('status')" class="text-sm text-red-500">{{ getFieldError('status') }}</p>
          </div>
        </div>

        <div class="space-y-2">
          <Label for="description">Mô tả</Label>
          <textarea
            id="description"
            v-model="form.description"
            placeholder="Nhập mô tả sản phẩm"
            rows="3"
            :class="['w-full rounded-md border border-input bg-background px-3 py-2 text-sm', { 'border-red-500': hasFieldError('description') }]"
          />
          <p v-if="hasFieldError('description')" class="text-sm text-red-500">{{ getFieldError('description') }}</p>
        </div>

        <div class="grid grid-cols-2 gap-4">
          <div class="space-y-2">
            <Label for="price">Giá bán</Label>
            <Input
              id="price"
              v-model.number="form.price"
              type="number"
              placeholder="0"
              :class="{ 'border-red-500': hasFieldError('price') }"
              required
            />
            <p v-if="hasFieldError('price')" class="text-sm text-red-500">{{ getFieldError('price') }}</p>
          </div>
          <div class="space-y-2">
            <Label for="stock">Tồn kho</Label>
            <Input
              id="stock"
              v-model.number="form.stock"
              type="number"
              placeholder="0"
              :class="{ 'border-red-500': hasFieldError('stock') }"
              required
            />
            <p v-if="hasFieldError('stock')" class="text-sm text-red-500">{{ getFieldError('stock') }}</p>
          </div>
        </div>

        <DialogFooter>
          <Button type="button" variant="outline" @click="$emit('close')">
            Hủy
          </Button>
          <Button type="submit">
            {{ isEdit ? 'Cập nhật' : 'Thêm mới' }}
          </Button>
        </DialogFooter>
      </form>
    </DialogContent>
  </Dialog>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import { usePage } from '@inertiajs/vue3'
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from '@/components/ui/dialog'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'

interface Props {
  isOpen: boolean
  product?: any
  isEdit?: boolean
  categories?: Array<{
    id: number
    name: string
  }>
}

const props = withDefaults(defineProps<Props>(), {
  isEdit: false,
  categories: () => []
})

const emit = defineEmits<{
  close: []
  submit: [data: any]
}>()

const page = usePage()
const errors = computed(() => page.props.errors || {})

const form = ref({
  category_id: 1,
  name: '',
  description: '',
  price: 0,
  stock: 0,
  status: 1
})

// Categories come from props (fetched from database)

// Helper function to get error message for a field
const getFieldError = (field: string) => {
  return errors.value[field] || ''
}

// Helper function to check if field has error
const hasFieldError = (field: string) => {
  return !!errors.value[field]
}



const resetForm = () => {
  form.value = {
    category_id: 1,
    name: '',
    description: '',
    price: 0,
    stock: 0,
    status: 1
  }
}

// Watch for product changes
watch(() => props.product, (newProduct) => {
  console.log('ProductModal received product:', newProduct);
  if (newProduct) {
    form.value = {
      category_id: newProduct.category_id || 1,
      name: newProduct.name || '',
      description: newProduct.description || '',
      price: newProduct.price || 0,
      stock: newProduct.stock || 0,
      status: newProduct.status || 1
    }
    console.log('Form filled with:', form.value);
  } else {
    resetForm()
  }
}, { immediate: true })

// Watch for modal open/close to reset form
watch(() => props.isOpen, (isOpen) => {
  if (!isOpen) {
    // Reset form when modal closes
    resetForm()
  }
})

const handleSubmit = async () => {
  emit('submit', { ...form.value })
}
</script>
