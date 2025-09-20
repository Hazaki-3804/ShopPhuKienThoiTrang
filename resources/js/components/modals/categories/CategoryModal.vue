<template>
  <Dialog :open="isOpen" @update:open="$emit('close')">
    <DialogContent class="sm:max-w-[500px]">
      <DialogHeader>
        <DialogTitle>{{ isEdit ? 'Chỉnh sửa danh mục' : 'Thêm danh mục mới' }}</DialogTitle>
        <DialogDescription>
          {{ isEdit ? 'Cập nhật thông tin danh mục' : 'Nhập thông tin danh mục mới' }}
        </DialogDescription>
      </DialogHeader>

      <form @submit.prevent="handleSubmit" class="space-y-4">
        <div class="space-y-2">
          <Label for="name">Tên danh mục</Label>
          <Input
            id="name"
            v-model="form.name"
            placeholder="Nhập tên danh mục"
            :class="{ 'border-red-500': hasFieldError('name') }"
            required
          />
          <p v-if="hasFieldError('name')" class="text-sm text-red-500">{{ getFieldError('name') }}</p>
        </div>

        <div class="space-y-2">
          <Label for="parent">Danh mục cha</Label>
          <select
            id="parent"
            v-model="form.parent_id"
            :class="['h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm', { 'border-red-500': hasFieldError('parent_id') }]"
          >
            <option value="">Chọn danh mục cha (tùy chọn)</option>
            <option v-for="parent in parentCategories" :key="parent.id" :value="parent.id">
              {{ parent.name }}
            </option>
          </select>
          <p v-if="hasFieldError('parent_id')" class="text-sm text-red-500">{{ getFieldError('parent_id') }}</p>
        </div>

        <div class="space-y-2">
          <Label for="description">Mô tả</Label>
          <textarea
            id="description"
            v-model="form.description"
            placeholder="Nhập mô tả danh mục"
            rows="3"
            :class="['w-full rounded-md border border-input bg-background px-3 py-2 text-sm', { 'border-red-500': hasFieldError('description') }]"
          />
          <p v-if="hasFieldError('description')" class="text-sm text-red-500">{{ getFieldError('description') }}</p>
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
  category?: any
  isEdit?: boolean
  parentCategories?: Array<{
    id: number
    name: string
  }>
}

const props = withDefaults(defineProps<Props>(), {
  isEdit: false,
  parentCategories: () => []
})

const emit = defineEmits<{
  close: []
  submit: [data: any]
}>()

const page = usePage()
const errors = computed(() => page.props.errors || {})

const form = ref({
  name: '',
  description: '',
  parent_id: null as number | null
})

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
    name: '',
    description: '',
    parent_id: null
  }
}

// Watch for category changes
watch(() => props.category, (newCategory) => {
  if (newCategory) {
    form.value = {
      name: newCategory.name || '',
      description: newCategory.description || '',
      parent_id: newCategory.parent_id || null
    }
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
