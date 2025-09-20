<script setup lang="ts">
import { Head, router, useForm } from '@inertiajs/vue3';
import AppLayout from '@/layouts/AppLayout.vue';
import { Plus, Search, Filter, MoreHorizontal, Eye, Edit, Trash2, Folder, FolderOpen, Grid2x2 } from 'lucide-vue-next';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import DataTable from '@/components/DataTable.vue';
import CategoryCells from '@/components/CategoryCells.vue';
import CategoryModal from '@/components/modals/categories/CategoryModal.vue';
import CategoryDetailModal from '@/components/modals/categories/CategoryDetailModal.vue';
import DeleteConfirmModal from '@/components/modals/categories/DeleteConfirmModal.vue';
import { type BreadcrumbItem } from '@/types';
import { ref, computed, h } from 'vue';
import type { ColumnDef } from '@tanstack/vue-table';


interface Category {
  id: number
  name: string
  description?: string
  parent_id?: number
  created_at: string
  updated_at: string
  products_count?: number
  parent?: {
    id: number
    name: string
  }
}

interface Props {
  categories: {
    data: Category[]
    current_page: number
    last_page: number
    per_page: number
    total: number
    from: number
    to: number
  }
  parentCategories: Array<{
    id: number
    name: string
  }>
  filters: {
    search?: string
    parent_id?: number
  }
}

const props = defineProps<Props>()

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Quản lý sản phẩm', href: '#' },
    { title: 'Danh mục sản phẩm', href: '/categories' },
];

// Define columns for DataTable
const columns: ColumnDef<any>[] = [
  {
    accessorKey: 'category',
    header: 'Danh mục',
    cell: ({ getValue, row }) => h(CategoryCells, { type: 'category', getValue, row })
  },
  {
    accessorKey: 'parent',
    header: 'Danh mục cha',
    cell: ({ getValue, row }) => h(CategoryCells, { type: 'parent', getValue, row })
  },
  {
    accessorKey: 'products_count',
    header: 'Số sản phẩm',
    cell: ({ getValue }) => h(CategoryCells, { type: 'productCount', getValue })
  },
  {
    accessorKey: 'created_at',
    header: 'Ngày tạo',
    cell: ({ getValue }) => h(CategoryCells, { type: 'createdAt', getValue })
  },
  {
    id: 'actions',
    header: '',
    cell: ({ row }) => h(CategoryCells, { type: 'actions', row })
  }
];

// Modal states
const isCategoryModalOpen = ref(false);
const isDetailModalOpen = ref(false);
const isDeleteModalOpen = ref(false);
const selectedCategory = ref<any>(null);
const isEditMode = ref(false);
const isBulkDelete = ref(false);

// Computed properties for stats
const totalItems = computed(() => props.categories.total);
const allCategories = computed(() => props.categories.data);
const parentCategories = computed(() => props.parentCategories);

// Modal handlers
const openAddModal = () => {
  selectedCategory.value = null;
  isEditMode.value = false;
  isCategoryModalOpen.value = true;
};

const openEditModal = (category?: any) => {
  selectedCategory.value = category || null;
  isEditMode.value = !!category;
  isCategoryModalOpen.value = true;
};

const openDetailModal = (category: any) => {
  selectedCategory.value = category;
  isDetailModalOpen.value = true;
};

const openDeleteModal = (category: any = null) => {
  selectedCategory.value = category;
  isBulkDelete.value = !category;
  isDeleteModalOpen.value = true;
};

const handleCategorySubmit = (data: any) => {
  if (isEditMode.value && selectedCategory.value) {
    // Update existing category
    router.put(`/categories/${selectedCategory.value.id}`, data, {
      onSuccess: () => {
        isCategoryModalOpen.value = false;
        selectedCategory.value = null;
        isEditMode.value = false;
      },
      onError: (errors) => {
        console.error('Validation errors:', errors);
      }
    });
  } else {
    // Add new category
    router.post('/categories', data, {
      onSuccess: () => {
        isCategoryModalOpen.value = false;
        selectedCategory.value = null;
        isEditMode.value = false;
      },
      onError: (errors) => {
        console.error('Validation errors:', errors);
      }
    });
  }
};

const handleDeleteConfirm = () => {
  if (isBulkDelete.value) {
    // Handle bulk delete - this would need to be implemented with selected rows
    console.log('Bulk delete not implemented yet');
    isDeleteModalOpen.value = false;
  } else if (selectedCategory.value) {
    // Delete single category
    router.delete(`/categories/${selectedCategory.value.id}`, {
      onSuccess: () => {
        isDeleteModalOpen.value = false;
        selectedCategory.value = null;
        isBulkDelete.value = false;
      },
      onError: (errors) => {
        console.error('Delete error:', errors);
      }
    });
  }
};
</script>

<template>
  <Head title="Danh mục sản phẩm" />

  <AppLayout :breadcrumbs="breadcrumbs">
    <div class="flex flex-col gap-6 p-4">
      <!-- Header -->
      <div class="flex items-center justify-between">
        <div>
          <h1 class="text-3xl font-bold tracking-tight">Danh mục sản phẩm</h1>
          <p class="text-muted-foreground">
            Quản lý tất cả danh mục sản phẩm
          </p>
        </div>
      </div>
      <!-- Stats Cards -->
      <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card class="border-l-blue-500 border-l-6">
          <CardHeader class="flex flex-row items-center justify-between space-y-0">
            <CardTitle class="text-sm font-medium">Tổng danh mục</CardTitle>
            <div class="flex items-center justify-center h-10 w-10 bg-blue-100 rounded-md">
              <Grid2x2 class="h-4 w-4 text-blue-500 drop-shadow" />
            </div>
          </CardHeader>
          <CardContent>
            <div class="text-2xl font-bold">{{ totalItems }}</div>
            <p class="text-xs text-muted-foreground">+5% so với tháng trước</p>
          </CardContent>
        </Card>
        <Card class="border-l-green-500 border-l-6">
          <CardHeader class="flex flex-row items-center justify-between space-y-0">
            <CardTitle class="text-sm font-medium">Danh mục gốc</CardTitle>
            <div class="flex items-center justify-center h-10 w-10 bg-green-100 rounded-md">
              <Folder class="h-4 w-4 text-green-500 drop-shadow" />
            </div>
          </CardHeader>
          <CardContent>
            <div class="text-2xl font-bold">{{ allCategories.filter(c => !c.parent_id).length }}</div>
            <p class="text-xs text-muted-foreground">Danh mục chính</p>
          </CardContent>
        </Card>
        <Card class="border-l-orange-500 border-l-6">
          <CardHeader class="flex flex-row items-center justify-between space-y-0">
            <CardTitle class="text-sm font-medium">Danh mục con</CardTitle>
            <div class="flex items-center justify-center h-10 w-10 bg-orange-100 rounded-md">
              <FolderOpen class="h-4 w-4 text-orange-500 drop-shadow" />
            </div>
          </CardHeader>
          <CardContent>
            <div class="text-2xl font-bold">{{ allCategories.filter(c => c.parent_id).length }}</div>
            <p class="text-xs text-muted-foreground">Danh mục phụ</p>
          </CardContent>
        </Card>
        <Card class="border-l-purple-500 border-l-6">
          <CardHeader class="flex flex-row items-center justify-between space-y-0">
            <CardTitle class="text-sm font-medium">Tổng sản phẩm</CardTitle>
            <div class="flex items-center justify-center h-10 w-10 bg-purple-100 rounded-md">
              <Grid2x2 class="h-4 w-4 text-purple-500 drop-shadow" />
            </div>
          </CardHeader>
          <CardContent>
            <div class="text-2xl font-bold">{{ allCategories.reduce((acc, c) => acc + (c.products_count || 0), 0) }}</div>
            <p class="text-xs text-muted-foreground">Tổng sản phẩm</p>
          </CardContent>
        </Card>
      </div>

      <!-- Categories Table -->
      <Card>
        <CardHeader>
          <CardTitle>Danh sách danh mục</CardTitle>
          <CardDescription class="flex items-center justify-between">
            Tổng cộng {{ totalItems }} danh mục
            <Button class="flex items-center gap-2" @click="openAddModal">
          <Plus class="h-4 w-4" />
          Thêm danh mục
        </Button>      

          </CardDescription>
        </CardHeader>
        <CardContent>
          <DataTable
            :data="allCategories"
            :columns="columns"
            :initial-pagination="{ pageIndex: 0, pageSize: 10 }"
            :show-search="true"
            :enable-row-selection="true"
            :show-bulk-actions="true"
            search-placeholder="Tìm kiếm danh mục, mô tả..."
            @bulk-edit="openEditModal"
            @bulk-delete="openDeleteModal"
            @row-view="openDetailModal"
            @row-edit="openEditModal"
            @row-delete="openDeleteModal"
          />
        </CardContent>
      </Card>
    </div>

    <!-- Modals -->
    <CategoryModal
      :is-open="isCategoryModalOpen"
      :category="selectedCategory || undefined"
      :is-edit="isEditMode"
      :parent-categories="parentCategories"
      @close="isCategoryModalOpen = false"
      @submit="handleCategorySubmit"
    />

    <CategoryDetailModal
      :is-open="isDetailModalOpen"
      :category="selectedCategory"
      @close="isDetailModalOpen = false"
      @edit="openEditModal"
    />

    <DeleteConfirmModal
      :is-open="isDeleteModalOpen"
      :category="selectedCategory"
      :is-bulk="isBulkDelete"
      :selected-count="0"
      @close="isDeleteModalOpen = false"
      @confirm="handleDeleteConfirm"
    />
  </AppLayout>
</template>