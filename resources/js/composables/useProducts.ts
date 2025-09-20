import { ref, reactive } from 'vue'
import axios from 'axios'

export interface Product {
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

export interface ProductFormData {
    category_id: number
    name: string
    description?: string
    price: number
    stock: number
    status: number
}

export interface ApiResponse<T> {
    data: T
    message?: string
}

export interface PaginatedResponse<T> {
    data: T[]
    current_page: number
    last_page: number
    per_page: number
    total: number
    from: number
    to: number
}

export interface ValidationError {
    message: string
    errors: Record<string, string[]>
}

export function useProducts() {
    const products = ref<Product[]>([])
    const loading = ref(false)
    const error = ref<string | null>(null)
    const validationErrors = ref<Record<string, string[]>>({})

    // Fetch products with pagination and filters
    const fetchProducts = async (params: {
        page?: number
        per_page?: number
        search?: string
        status?: number
        category_id?: number
    } = {}) => {
        loading.value = true
        error.value = null

        try {
            const response = await axios.get('/api/products', { params })
            products.value = response.data.data
            return response.data as PaginatedResponse<Product>
        } catch (err: any) {
            error.value = err.response?.data?.message || 'Có lỗi xảy ra khi tải danh sách sản phẩm'
            throw err
        } finally {
            loading.value = false
        }
    }

    // Create new product
    const createProduct = async (data: ProductFormData) => {
        loading.value = true
        error.value = null
        validationErrors.value = {}

        try {
            const response = await axios.post('/api/products', data)
            return response.data as ApiResponse<Product>
        } catch (err: any) {
            if (err.response?.status === 422) {
                validationErrors.value = err.response.data.errors
                error.value = 'Dữ liệu không hợp lệ'
            } else {
                error.value = err.response?.data?.message || 'Có lỗi xảy ra khi tạo sản phẩm'
            }
            throw err
        } finally {
            loading.value = false
        }
    }

    // Update product
    const updateProduct = async (id: number, data: Partial<ProductFormData>) => {
        loading.value = true
        error.value = null
        validationErrors.value = {}

        try {
            const response = await axios.put(`/api/products/${id}`, data)
            return response.data as ApiResponse<Product>
        } catch (err: any) {
            if (err.response?.status === 422) {
                validationErrors.value = err.response.data.errors
                error.value = 'Dữ liệu không hợp lệ'
            } else {
                error.value = err.response?.data?.message || 'Có lỗi xảy ra khi cập nhật sản phẩm'
            }
            throw err
        } finally {
            loading.value = false
        }
    }

    // Get single product
    const getProduct = async (id: number) => {
        loading.value = true
        error.value = null

        try {
            const response = await axios.get(`/api/products/${id}`)
            return response.data as Product
        } catch (err: any) {
            error.value = err.response?.data?.message || 'Có lỗi xảy ra khi tải thông tin sản phẩm'
            throw err
        } finally {
            loading.value = false
        }
    }

    // Delete product
    const deleteProduct = async (id: number) => {
        loading.value = true
        error.value = null

        try {
            const response = await axios.delete(`/api/products/${id}`)
            return response.data as ApiResponse<null>
        } catch (err: any) {
            error.value = err.response?.data?.message || 'Có lỗi xảy ra khi xóa sản phẩm'
            throw err
        } finally {
            loading.value = false
        }
    }

    // Clear validation errors
    const clearValidationErrors = () => {
        validationErrors.value = {}
        error.value = null
    }

    return {
        products,
        loading,
        error,
        validationErrors,
        fetchProducts,
        createProduct,
        updateProduct,
        getProduct,
        deleteProduct,
        clearValidationErrors
    }
}
