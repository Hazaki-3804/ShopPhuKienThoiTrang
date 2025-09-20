
<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Chatbot\ChatbotController;
use App\Http\Controllers\Api\CartController;
use App\Http\Controllers\ProductController;


/*
|-------------------------------------------------------------------------- 
| API Routes
|--------------------------------------------------------------------------
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::post('api/chatbot', [ChatbotController::class, 'chat'])->name('chatbot.chat');

// Cart API routes - require authentication
Route::middleware('auth')->group(function () {
    Route::post('/cart/add', [CartController::class, 'addToCart'])->name('cart.add');
    Route::delete('/cart/remove/{productId}', [CartController::class, 'removeFromCart'])->name('cart.remove');
    Route::put('/cart/update/{productId}', [CartController::class, 'updateCartQuantity'])->name('cart.update');
    Route::get('/cart', [CartController::class, 'getCartItems'])->name('cart.items');
});
Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('products', ProductController::class);
});