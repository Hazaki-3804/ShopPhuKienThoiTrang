<?php

use App\Http\Controllers\ProductController;
use App\Http\Controllers\CategoryController;
use App\Models\Category;
use App\Models\Product;
use App\Http\Controllers\SearchController;
use Illuminate\Support\Facades\Route;
use Inertia\Inertia;

Route::get('/', function () {
    $categories = Category::query()
        ->select(['id','name'])
        ->orderBy('name')
        ->limit(8)
        ->get()
        ->map(fn($c) => [
            'id' => $c->id,
            'name' => $c->name,
            'image' => 'https://picsum.photos/600/600?category=' . $c->id,
        ]);

    $products = Product::query()
        ->select(['id','name','price'])
        ->orderByDesc('id')
        ->limit(8)
        ->get()
        ->map(function ($p) {
            $image = $p->product_images()->value('image_url');
            return [
                'id' => $p->id,
                'name' => $p->name,
                'price' => number_format($p->price, 0, ',', '.'),
                'image' => $image ?: 'https://picsum.photos/600/600?random=' . $p->id,
            ];
        });

    return Inertia::render('Welcome', [
        'categories' => $categories,
        'products' => $products,
    ]);
})->name('home');

// Search suggest
Route::get('/search/suggest', [SearchController::class, 'suggest'])->name('search.suggest');

Route::middleware('auth', 'verified')->group(function () {
    Route::get('dashboard', function () {
        return Inertia::render('Dashboard');
    })->name('dashboard');

    Route::get('categories', [CategoryController::class, 'index'])->name('categories.index');
    Route::post('categories', [CategoryController::class, 'store'])->name('categories.store');
    Route::get('categories/{category}', [CategoryController::class, 'show'])->name('categories.show');
    Route::put('categories/{category}', [CategoryController::class, 'update'])->name('categories.update');
    Route::delete('categories/{category}', [CategoryController::class, 'destroy'])->name('categories.destroy');

    Route::get('products', [ProductController::class, 'index'])->name('products.index');
    Route::post('products', [ProductController::class, 'store'])->name('products.store');
    Route::get('products/{product}', [ProductController::class, 'show'])->name('products.show');
    Route::put('products/{product}', [ProductController::class, 'update'])->name('products.update');
    Route::delete('products/{product}', [ProductController::class, 'destroy'])->name('products.destroy');
});

// Other route files
require __DIR__ . '/settings.php';
require __DIR__ . '/auth.php';
require __DIR__ . '/api.php';
