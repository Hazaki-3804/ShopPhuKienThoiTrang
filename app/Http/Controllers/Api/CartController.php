<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\CartItem;
use App\Models\Product;

class CartController extends Controller
{
    public function __construct()
    {
        if (!Auth::check()) {
            return route('login');
        }
    }

    /**
     * Thêm sản phẩm vào giỏ hàng
     */
    public function addToCart(Request $request)
    {
        $request->validate([
            'product_id' => 'required|exists:products,id',
            'quantity' => 'required|integer|min:1'
        ]);

        $userId = Auth::id();
        $productId = $request->product_id;
        $quantity = $request->quantity;

        // Check if product exists and is available
        $product = Product::findOrFail($productId);

        // Check if item already exists in cart
        $cartItem = CartItem::where('user_id', $userId)
            ->where('product_id', $productId)
            ->first();

        if ($cartItem) {
            // Update existing item
            $cartItem->quantity += $quantity;
            $cartItem->save();
        } else {
            // Create new cart item
            CartItem::create([
                'user_id' => $userId,
                'product_id' => $productId,
                'quantity' => $quantity
            ]);
        }

        return response()->json([
            'message' => 'Product added to cart successfully',
            'cart_count' => $this->getCartCount()
        ]);
    }

    /**
     * Xóa sản phẩm khỏi giỏ hàng
     */
    public function removeFromCart($productId)
    {
        $userId = Auth::id();

        CartItem::where('user_id', $userId)
            ->where('product_id', $productId)
            ->delete();

        return response()->json([
            'message' => 'Product removed from cart successfully',
            'cart_count' => $this->getCartCount()
        ]);
    }

    /**
     * Cập nhật số lượng sản phẩm trong giỏ hàng
     */
    public function updateCartQuantity(Request $request, $productId)
    {
        $request->validate([
            'quantity' => 'required|integer|min:1'
        ]);

        $userId = Auth::id();
        $quantity = $request->quantity;

        $cartItem = CartItem::where('user_id', $userId)
            ->where('product_id', $productId)
            ->first();

        if ($cartItem) {
            $cartItem->quantity = $quantity;
            $cartItem->save();
        }

        return response()->json([
            'message' => 'Cart updated successfully',
            'cart_count' => $this->getCartCount()
        ]);
    }

    /**
     * Lấy số lượng item trong giỏ hàng
     */
    public function getCartCount()
    {
        if (!Auth::check()) {
            return 0;
        }

        return CartItem::where('user_id', Auth::id())->sum('quantity');
    }

    /**
     * Lấy tất cả items trong giỏ hàng
     */
    public function getCartItems()
    {
        $userId = Auth::id();

        $cartItems = CartItem::with('product')
            ->where('user_id', $userId)
            ->get();

        return response()->json([
            'items' => $cartItems,
            'cart_count' => $this->getCartCount(),
            'total' => $cartItems->sum(function ($item) {
                return $item->quantity * $item->product->price;
            })
        ]);
    }
}
