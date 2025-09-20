<script setup lang="ts">
import { Head, router, useForm } from '@inertiajs/vue3';
import AppLayout from '@/layouts/AppLayout.vue';
import { Plus, Search, Filter, MoreHorizontal, Eye, Edit, Trash2, Star, Rows4, CircleX, CirclePlus, Banknote, CircleDollarSign, Package } from 'lucide-vue-next';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import DataTable from '@/components/DataTable.vue';
import ProductCells from '@/components/ProductCells.vue';
import ProductModal from '@/components/modals/products/ProductModal.vue';
import ProductDetailModal from '@/components/modals/products/ProductDetailModal.vue';
import DeleteConfirmModal from '@/components/modals/products/DeleteConfirmModal.vue';
import { type BreadcrumbItem } from '@/types';
import { ref, computed, h } from 'vue';
import type { ColumnDef } from '@tanstack/vue-table';
import { Award } from 'lucide-vue-next';

interface Product {
  id: number
  category_id: number
  name: string
  description?: string
  price: number
  stock: number
  status: number
  created_at: string
  updated_at: string
  category?: {
    id: number
    name: string
  }
}

interface Props {
  products: {
    data: Product[]
    current_page: number
    last_page: number
    per_page: number
    total: number
    from: number
    to: number
  }
  categories: Array<{
    id: number
    name: string
  }>
  filters: {
    search?: string
    status?: number
    category_id?: number
  }
}

const props = defineProps<Props>()

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Quản lý sản phẩm', href: '#' },
    { title: 'Sản phẩm', href: '/products' },
];

// Define columns for DataTable
const columns: ColumnDef<any>[] = [
  {
    accessorKey: 'product',
    header: 'Sản phẩm',
    cell: ({ getValue, row }) => h(ProductCells, { type: 'product', getValue, row })
  },
  {
    accessorKey: 'sku',
    header: 'SKU',
    cell: ({ getValue }) => h(ProductCells, { type: 'sku', getValue })
  },
  {
    accessorKey: 'category',
    header: 'Danh mục',
    cell: ({ getValue }) => h(ProductCells, { type: 'category', getValue })
  },
  {
    accessorKey: 'price',
    header: 'Giá',
    cell: ({ getValue, row }) => h(ProductCells, { type: 'price', getValue, row })
  },
  {
    accessorKey: 'stock',
    header: 'Tồn kho',
    cell: ({ getValue }) => h(ProductCells, { type: 'stock', getValue })
  },
  {
    accessorKey: 'rating',
    header: 'Đánh giá',
    cell: ({ getValue }) => h(ProductCells, { type: 'rating', getValue })
  },
  {
    accessorKey: 'status',
    header: 'Trạng thái',
    cell: ({ getValue }) => h(ProductCells, { type: 'status', getValue })
  },
  {
    accessorKey: 'sales',
    header: 'Bán hàng',
    cell: ({ getValue }) => h(ProductCells, { type: 'sales', getValue })
  },
  {
    id: 'actions',
    header: '',
    cell: ({ row }) => h(ProductCells, { type: 'actions', row })
  }
];

const getStatusColor = (status: number) => {
  return status === 1 ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800';
};

const getStatusText = (status: number) => {
  return status === 1 ? 'Hoạt động' : 'Tạm dừng';
};

const formatPrice = (price: number) => {
  return new Intl.NumberFormat('vi-VN', {
    style: 'currency',
    currency: 'VND'
  }).format(price);
};

const getStockColor = (stock: number) => {
  if (stock === 0) return 'bg-red-100 text-red-800';
  if (stock < 10) return 'bg-yellow-100 text-yellow-800';
  return 'bg-green-100 text-green-800';
};

const getStockText = (stock: number) => {
  if (stock === 0) return 'Hết hàng';
  if (stock < 10) return 'Sắp hết';
  return 'Còn hàng';
};

// Modal states
const isProductModalOpen = ref(false);
const isDetailModalOpen = ref(false);
const isDeleteModalOpen = ref(false);
const selectedProduct = ref<any>(null);
const isEditMode = ref(false);
const isBulkDelete = ref(false);

// Computed properties for stats
const totalItems = computed(() => props.products.total);
const totalStock = computed(() => props.products.data.reduce((acc, p) => acc + p.stock, 0));
const allProducts = computed(() => props.products.data);

// Modal handlers
const openAddModal = () => {
  selectedProduct.value = null;
  isEditMode.value = false;
  isProductModalOpen.value = true;
};

const openEditModal = (product?: any) => {
  selectedProduct.value = product || null;
  isEditMode.value = !!product; // true nếu có product, false nếu không có
  isProductModalOpen.value = true;
};

const openDetailModal = (product: any) => {
  selectedProduct.value = product;
  isDetailModalOpen.value = true;
};

const openDeleteModal = (product: any = null) => {
  selectedProduct.value = product;
  isBulkDelete.value = !product;
  isDeleteModalOpen.value = true;
};

const handleProductSubmit = (data: any) => {
  if (isEditMode.value && selectedProduct.value) {
    // Update existing product
    router.put(`/products/${selectedProduct.value.id}`, data, {
      onSuccess: () => {
        isProductModalOpen.value = false;
        selectedProduct.value = null;
        isEditMode.value = false;
      },
      onError: (errors) => {
        console.error('Validation errors:', errors);
        // Errors will be automatically available in the modal via usePage()
      }
    });
  } else {
    // Add new product
    router.post('/products', data, {
      onSuccess: () => {
        isProductModalOpen.value = false;
        selectedProduct.value = null;
        isEditMode.value = false;
      },
      onError: (errors) => {
        console.error('Validation errors:', errors);
        // Errors will be automatically available in the modal via usePage()
      }
    });
  }
};

const handleDeleteConfirm = () => {
  if (isBulkDelete.value) {
    // Handle bulk delete - this would need to be implemented with selected rows
    console.log('Bulk delete not implemented yet');
    isDeleteModalOpen.value = false;
  } else if (selectedProduct.value) {
    // Delete single product
    router.delete(`/products/${selectedProduct.value.id}`, {
      onSuccess: () => {
        isDeleteModalOpen.value = false;
        selectedProduct.value = null;
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
  <Head title="Sản phẩm" />

  <AppLayout :breadcrumbs="breadcrumbs">
    <div class="flex flex-col gap-6 p-4">
      <!-- Header -->
      <div class="flex items-center justify-between">
        <div>
          <h1 class="text-3xl font-bold tracking-tight">Sản phẩm</h1>
          <p class="text-muted-foreground">
            Quản lý tất cả sản phẩm trong cửa hàng
          </p>
        </div>
      </div>

      <!-- Stats Cards -->
      <div class="grid grid-cols-1 md:grid-cols-5 gap-4">
        <Card class="border-l-blue-500 border-l-6 gap-0">
          <CardHeader class="flex flex-row items-center justify-between space-y-0">
            <CardTitle class="text-sm font-medium">Tổng sản phẩm</CardTitle>
            <div class="flex items-center justify-center h-10 w-10 flex-shrink-0 bg-blue-100 rounded-md">
            <Rows4 class="h-4 w-4 text-blue-500 drop-shadow" />
          </div>
          </CardHeader>
          <CardContent>
            <div class="text-2xl font-bold">{{ totalItems }}</div>
            <p class="text-xs text-muted-foreground">+12% so với tháng trước</p>
          </CardContent>
        </Card>
        <Card class="border-l-green-500 border-l-6 gap-0">
          <CardHeader class="flex flex-row items-center justify-between space-y-0" >
            <CardTitle class="text-sm font-medium">Sản phẩm tồn kho</CardTitle>
            <div class="flex items-center justify-center h-10 w-10 flex-shrink-0 bg-green-100 rounded-md">
            <Package class="h-4 w-4 text-green-500 drop-shadow" />
          </div>
          </CardHeader>
          <CardContent>
            <div class="text-2xl font-bold">{{ totalStock}}</div>
            <p class="text-xs text-muted-foreground">+10% so với tháng trước</p>
          </CardContent>
        </Card>
        <Card class="border-l-orange-500 border-l-6 gap-0">
          <CardHeader class="flex flex-row items-center justify-between space-y-0">
            <CardTitle class="text-sm font-medium">Hết hàng</CardTitle>
            <div class="flex items-center justify-center h-10 w-10 flex-shrink-0 bg-orange-100 rounded-md">
            <CircleX class="h-4 w-4 text-orange-500 drop-shadow" />
          </div>
          </CardHeader>
          <CardContent>
            <div class="text-2xl font-bold">{{ allProducts.filter(p => p.stock === 0).length }}</div>
            <p class="text-xs text-muted-foreground">Cần nhập thêm</p>
          </CardContent>
        </Card>
        <Card class="border-l-pink-500 border-l-6 gap-0">
          <CardHeader class="flex flex-row items-center justify-between space-y-0">
            <CardTitle class="text-sm font-medium">Sắp hết hàng</CardTitle>
            <div class="flex items-center justify-center h-10 w-10 flex-shrink-0 bg-pink-100 rounded-md">
            <CirclePlus class="h-4 w-4 text-pink-500 drop-shadow" />
          </div>
          </CardHeader>
          <CardContent>
            <div class="text-2xl font-bold">{{ allProducts.filter(p => p.stock < 10).length }}</div>
            <p class="text-xs text-muted-foreground">Sắp hết hàng</p>
          </CardContent>
        </Card>
        <Card class="border-l-yellow-500 border-l-6 gap-0">
          <CardHeader class="flex flex-row items-center justify-between space-y-0">
            <CardTitle class="text-sm font-medium">Tổng giá trị</CardTitle>
            <div class="flex items-center justify-center h-10 w-10 flex-shrink-0 bg-yellow-100 rounded-md">
            <CircleDollarSign class="h-4 w-4 text-yellow-500 drop-shadow" />
          </div>
          </CardHeader>
          <CardContent>
            <div class="text-2xl font-bold">{{ formatPrice(allProducts.reduce((acc, p) => acc + p.price, 0)) }}</div>
            <p class="text-xs text-muted-foreground">Tổng giá trị</p>
          </CardContent>
        </Card>
      </div>
      <!-- Products Table -->
      <Card>
        <CardHeader>
          <CardTitle class="flex items-center justify-between">Danh sách sản phẩm
            <Button class="flex items-center gap-0" @click="openAddModal">
              <Plus class="h-4 w-4" />
              Thêm sản phẩm
            </Button>
          </CardTitle>
          <CardDescription>
            Tổng cộng {{ totalItems }} sản phẩm
          </CardDescription>
        </CardHeader>
        <CardContent>
          <DataTable
            :data="allProducts"
            :columns="columns"
            :initial-pagination="{ pageIndex: 0, pageSize: 10 }"
            :show-search="true"
            :enable-row-selection="true"
            :show-bulk-actions="true"
            search-placeholder="Tìm kiếm sản phẩm, SKU, danh mục..."
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
            <ProductModal
              :is-open="isProductModalOpen"
              :product="selectedProduct || undefined"
              :is-edit="isEditMode"
              :categories="props.categories"
              @close="isProductModalOpen = false"
              @submit="handleProductSubmit"
            />

    <ProductDetailModal
      :is-open="isDetailModalOpen"
      :product="selectedProduct"
      @close="isDetailModalOpen = false"
      @edit="openEditModal"
    />

    <DeleteConfirmModal
      :is-open="isDeleteModalOpen"
      :product="selectedProduct"
      :is-bulk="isBulkDelete"
      :selected-count="0"
      @close="isDeleteModalOpen = false"
      @confirm="handleDeleteConfirm"
    />
  </AppLayout>
</template>
