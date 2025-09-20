<template>
  <div class="w-full">
    <!-- Search Bar and Bulk Actions -->
    <div class="mb-4 space-y-4">
      <div v-if="showSearch" class="relative">
        <Search class="absolute left-3 top-1/2 h-4 w-4 -translate-y-1/2 text-muted-foreground" />
        <Input
          v-model="globalFilter"
          :placeholder="searchPlaceholder"
          class="pl-10"
        />
      </div>
      
      <!-- Bulk Actions -->
      <div v-if="showBulkActions && table.getSelectedRowModel().rows.length > 0" class="flex items-center gap-2 p-3 bg-muted rounded-lg">
        <span class="text-sm font-medium">
          {{ table.getSelectedRowModel().rows.length }} sản phẩm đã chọn
        </span>
        <div class="flex items-center gap-2 ml-auto">
          <Button variant="outline" size="sm" @click="$emit('bulk-edit')">
            <Edit class="h-4 w-4 mr-1" />
            Sửa
          </Button>
          <Button variant="outline" size="sm" @click="$emit('bulk-delete')">
            <Trash2 class="h-4 w-4 mr-1" />
            Xóa
          </Button>
          <Button variant="outline" size="sm" @click="table.resetRowSelection()">
            Bỏ chọn
          </Button>
        </div>
      </div>
    </div>

    <!-- Table -->
    <div class="rounded-md border overflow-x-auto">
      <table class="w-full caption-bottom text-sm ">
        <thead class="[&_tr]:border-b">
          <tr
            v-for="headerGroup in table.getHeaderGroups()"
            :key="headerGroup.id"
            class="border-b transition-colors hover:bg-muted/50"
          >
            <!-- Selection checkbox header -->
            <th v-if="enableRowSelection" class="h-12 px-4 text-left align-middle font-medium text-muted-foreground">
              <Checkbox
                :checked="table.getIsAllPageRowsSelected()"
                :indeterminate="table.getIsSomePageRowsSelected()"
                @update:checked="table.getToggleAllPageRowsSelectedHandler()?.($event)"
              />
            </th>
            
            <th
              v-for="header in headerGroup.headers"
              :key="header.id"
              :class="[
                'h-12 px-4 text-left align-middle font-medium text-muted-foreground [&:has([role=checkbox])]:pr-0',
                header.column.getCanSort() ? 'cursor-pointer select-none' : '',
                header.column.getIsSorted() === 'asc' ? 'text-foreground' : '',
                header.column.getIsSorted() === 'desc' ? 'text-foreground' : ''
              ]"
              @click="header.column.getToggleSortingHandler()?.($event)"
            >
              <div class="flex items-center space-x-2">
                <span>{{ header.isPlaceholder ? null : header.column.columnDef.header }}</span>
                <div v-if="header.column.getCanSort()" class="flex flex-col">
                  <svg
                    v-if="header.column.getIsSorted() === 'asc'"
                    class="h-4 w-4"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7" />
                  </svg>
                  <svg
                    v-else-if="header.column.getIsSorted() === 'desc'"
                    class="h-4 w-4"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                  </svg>
                  <svg
                    v-else
                    class="h-4 w-4 opacity-50"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16V4m0 0L3 8m4-4l4 4m6 0v12m0 0l4-4m-4 4l-4-4" />
                  </svg>
                </div>
              </div>
            </th>
          </tr>
        </thead>
        <tbody class="[&_tr:last-child]:border-0">
          <tr
            v-for="row in table.getRowModel().rows"
            :key="row.id"
            class="border-b transition-colors hover:bg-muted/50 data-[state=selected]:bg-muted"
          >
            <!-- Selection checkbox cell -->
            <td v-if="enableRowSelection" class="p-4 align-middle">
              <Checkbox
                :checked="row.getIsSelected()"
                :disabled="!row.getCanSelect()"
                @update:checked="row.getToggleSelectedHandler()?.($event)"
              />
            </td>
            
            <td
              v-for="cell in row.getVisibleCells()"
              :key="cell.id"
              class="p-4 align-middle [&:has([role=checkbox])]:pr-0"
            >
              <component 
                :is="cell.column.columnDef.cell" 
                v-bind="cell.getContext()"
                @view="(product: any) => emit('row-view', product)"
                @edit="(product: any) => emit('row-edit', product)"
                @delete="(product: any) => emit('row-delete', product)"
              />
            </td>
          </tr>
          
          <!-- No data message -->
          <tr v-if="table.getRowModel().rows.length === 0">
            <td :colspan="enableRowSelection ? table.getAllColumns().length + 1 : table.getAllColumns().length" class="p-8 text-center">
              <div class="flex flex-col items-center justify-center space-y-2">
                <div class="text-4xl">🔍</div>
                <div class="text-lg font-medium text-muted-foreground">
                  {{ globalFilter ? 'Không tìm thấy kết quả nào' : 'Không có dữ liệu' }}
                </div>
                <div v-if="globalFilter" class="text-sm text-muted-foreground">
                  Thử tìm kiếm với từ khóa khác hoặc xóa bộ lọc
                </div>
                <Button 
                  v-if="globalFilter" 
                  variant="outline" 
                  size="sm" 
                  @click="clearSearch"
                  class="mt-2"
                >
                  Xóa bộ lọc
                </Button>
              </div>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Pagination -->
    <div v-if="table.getRowModel().rows.length > 0" class="flex items-center justify-between px-2 py-4">
      <div class="text-sm text-muted-foreground">
        Hiển thị {{ table.getState().pagination.pageIndex * table.getState().pagination.pageSize + 1 }} đến 
        {{ Math.min((table.getState().pagination.pageIndex + 1) * table.getState().pagination.pageSize, table.getFilteredRowModel().rows.length) }} 
        trong tổng số {{ table.getFilteredRowModel().rows.length }} kết quả
        <span v-if="globalFilter" class="text-blue-600">
          (tìm kiếm: "{{ globalFilter }}")
        </span>
      </div>
      
      <div class="flex items-center space-x-6 lg:space-x-8">
        <div class="flex items-center space-x-2">
          <p class="text-sm font-medium">Số dòng mỗi trang</p>
          <select
            :value="table.getState().pagination.pageSize"
            @change="table.setPageSize(Number(($event.target as HTMLSelectElement).value))"
            class="h-8 w-[70px] rounded border border-input bg-background px-3 py-1 text-sm"
          >
            <option v-for="pageSize in [10, 20, 30, 40, 50]" :key="pageSize" :value="pageSize">
              {{ pageSize }}
            </option>
          </select>
        </div>
        
        <div class="flex items-center space-x-2">
          <p class="text-sm font-medium">
            Trang {{ table.getState().pagination.pageIndex + 1 }} / {{ table.getPageCount() }}
          </p>
          <div class="flex items-center space-x-2">
            <button
              :disabled="!table.getCanPreviousPage()"
              @click="table.setPageIndex(0)"
              class="h-8 w-8 rounded border border-input bg-background px-3 py-1 text-sm disabled:opacity-50"
            >
              «
            </button>
            <button
              :disabled="!table.getCanPreviousPage()"
              @click="table.previousPage()"
              class="h-8 w-8 rounded border border-input bg-background px-3 py-1 text-sm disabled:opacity-50"
            >
              ‹
            </button>
            <button
              :disabled="!table.getCanNextPage()"
              @click="table.nextPage()"
              class="h-8 w-8 rounded border border-input bg-background px-3 py-1 text-sm disabled:opacity-50"
            >
              ›
            </button>
            <button
              :disabled="!table.getCanNextPage()"
              @click="table.setPageIndex(table.getPageCount() - 1)"
              class="h-8 w-8 rounded border border-input bg-background px-3 py-1 text-sm disabled:opacity-50"
            >
              »
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { Search, Edit, Trash2 } from 'lucide-vue-next'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { Checkbox } from '@/components/ui/checkbox'
import {
  useVueTable,
  getCoreRowModel,
  getSortedRowModel,
  getPaginationRowModel,
  getFilteredRowModel,
  type ColumnDef,
  type SortingState,
  type PaginationState,
  type ColumnFiltersState,
  type RowSelectionState,
} from '@tanstack/vue-table'

interface Props {
  data: any[]
  columns: ColumnDef<any>[]
  initialSorting?: SortingState
  initialPagination?: PaginationState
  initialColumnFilters?: ColumnFiltersState
  showSearch?: boolean
  searchPlaceholder?: string
  enableRowSelection?: boolean
  showBulkActions?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  initialSorting: () => [],
  initialPagination: () => ({ pageIndex: 0, pageSize: 10 }),
  initialColumnFilters: () => [],
  showSearch: true,
  searchPlaceholder: 'Tìm kiếm...',
  enableRowSelection: false,
  showBulkActions: false
})

const sorting = ref<SortingState>(props.initialSorting)
const pagination = ref<PaginationState>(props.initialPagination)
const columnFilters = ref<ColumnFiltersState>(props.initialColumnFilters)
const rowSelection = ref<RowSelectionState>({})
const globalFilter = ref('')

const table = useVueTable({
  get data() {
    return props.data
  },
  get columns() {
    return props.columns
  },
  getCoreRowModel: getCoreRowModel(),
  getSortedRowModel: getSortedRowModel(),
  getPaginationRowModel: getPaginationRowModel(),
  getFilteredRowModel: getFilteredRowModel(),
  enableRowSelection: props.enableRowSelection,
  onSortingChange: (updaterOrValue) => {
    if (typeof updaterOrValue === 'function') {
      sorting.value = updaterOrValue(sorting.value)
    } else {
      sorting.value = updaterOrValue
    }
  },
  onPaginationChange: (updaterOrValue) => {
    if (typeof updaterOrValue === 'function') {
      pagination.value = updaterOrValue(pagination.value)
    } else {
      pagination.value = updaterOrValue
    }
  },
  onColumnFiltersChange: (updaterOrValue) => {
    if (typeof updaterOrValue === 'function') {
      columnFilters.value = updaterOrValue(columnFilters.value)
    } else {
      columnFilters.value = updaterOrValue
    }
  },
  onGlobalFilterChange: (updaterOrValue) => {
    if (typeof updaterOrValue === 'function') {
      globalFilter.value = updaterOrValue(globalFilter.value)
    } else {
      globalFilter.value = updaterOrValue
    }
  },
  onRowSelectionChange: (updaterOrValue) => {
    if (typeof updaterOrValue === 'function') {
      rowSelection.value = updaterOrValue(rowSelection.value)
    } else {
      rowSelection.value = updaterOrValue
    }
  },
  globalFilterFn: (row, columnId, value) => {
    // Custom global filter function
    const search = value.toLowerCase()
    return Object.values(row.original).some(val => 
      String(val).toLowerCase().includes(search)
    )
  },
  state: {
    get sorting() {
      return sorting.value
    },
    get pagination() {
      return pagination.value
    },
    get columnFilters() {
      return columnFilters.value
    },
    get globalFilter() {
      return globalFilter.value
    },
    get rowSelection() {
      return rowSelection.value
    },
  },
})

// Watch for globalFilter changes and update table
watch(globalFilter, (newValue) => {
  table.setGlobalFilter(newValue)
  // Reset to first page when searching
  table.setPageIndex(0)
})

// Expose methods for parent components
const setGlobalFilter = (value: string) => {
  globalFilter.value = value
}

const clearSearch = () => {
  globalFilter.value = ''
}

// Define emits
const emit = defineEmits<{
  'bulk-edit': []
  'bulk-delete': []
  'row-view': [product: any]
  'row-edit': [product: any]
  'row-delete': [product: any]
}>()
</script>
