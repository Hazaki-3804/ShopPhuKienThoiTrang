<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\CartItem;
use Inertia\Inertia;

class ShareCartCount
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next)
    {
        // Share cart count với tất cả Inertia responses
        Inertia::share([
            'cartCount' => function () {
                if (!Auth::check()) {
                    return 0;
                }

                return CartItem::where('user_id', Auth::id())->sum('quantity');
            }
        ]);

        return $next($request);
    }
}
