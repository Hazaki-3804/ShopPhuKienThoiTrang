import { computed, ref } from 'vue';
import { usePage, router } from '@inertiajs/vue3';
import { login } from '@/routes';

export function useCart() {
    const page = usePage();
    const isLoading = ref(false);

    // Cart count từ Inertia shared data
    const cartCount = computed(() => {
        return page.props.auth?.user ? page.props.cartCount || 0 : 0;
    });

    // Check nếu user đã login
    const isAuthenticated = computed(() => {
        return !!page.props.auth?.user;
    });

    // Thêm sản phẩm vào giỏ hàng
    const addToCart = async (productId: number, quantity: number = 1) => {
        // Nếu chưa login -> redirect to login
        if (!isAuthenticated.value) {
            router.visit(login(), {
                data: {
                    redirect: window.location.pathname // Redirect back sau khi login
                }
            });
            return;
        }

        isLoading.value = true;

        try {
            await router.post('/api/cart/add', {
                product_id: productId,
                quantity: quantity
            }, {
                preserveScroll: true,
                onSuccess: () => {
                    // Inertia sẽ tự động update cartCount qua shared data
                    console.log('Product added to cart successfully');
                },
                onError: (errors) => {
                    console.error('Failed to add product to cart:', errors);
                }
            });
        } finally {
            isLoading.value = false;
        }
    };

    // Xóa sản phẩm khỏi giỏ hàng
    const removeFromCart = async (productId: number) => {
        if (!isAuthenticated.value) return;

        isLoading.value = true;

        try {
            await router.delete(`/api/cart/remove/${productId}`, {
                preserveScroll: true,
                onSuccess: () => {
                    console.log('Product removed from cart');
                }
            });
        } finally {
            isLoading.value = false;
        }
    };

    // Cập nhật số lượng sản phẩm
    const updateCartQuantity = async (productId: number, quantity: number) => {
        if (!isAuthenticated.value) return;

        isLoading.value = true;

        try {
            await router.put(`/api/cart/update/${productId}`, {
                quantity: quantity
            }, {
                preserveScroll: true
            });
        } finally {
            isLoading.value = false;
        }
    };

    // Xem giỏ hàng
    const viewCart = () => {
        if (!isAuthenticated.value) {
            router.visit(login());
            return;
        }

        router.visit('/cart');
    };

    return {
        cartCount,
        isAuthenticated,
        isLoading,
        addToCart,
        removeFromCart,
        updateCartQuantity,
        viewCart
    };
}