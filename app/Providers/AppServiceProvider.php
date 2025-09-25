<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use Illuminate\Support\Facades\URL;
use Inertia\Inertia;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {

        if (config('app.env') === 'production') {
            URL::forceScheme('https');
        }
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
        Inertia::share([
            'auth' => function () {
                if (auth()->check()) {
                    $user = auth()->user();
                    // chỉ gửi những trường cần thiết
                    return [
                        'id' => $user->id,
                        'username' => $user->username,
                        'name' => $user->name,
                        'role' => $user->role->name ?? null,
                        'avatar' => $user->avatar,
                    ];
                }
                return null;
            }
        ]);
    }
}
