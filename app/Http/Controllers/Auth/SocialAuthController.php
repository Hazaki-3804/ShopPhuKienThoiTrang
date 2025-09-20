<?php


namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;

/**
 * @method static \Laravel\Socialite\Contracts\Provider stateless()
 */

use Laravel\Socialite\Facades\Socialite;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;

class SocialAuthController extends Controller
{
    // Route để lấy URL redirect đến Facebook
    public function redirectToProvider($provider)
    {
        $url = Socialite::driver($provider)
            ->stateless()
            ->redirect()
            ->getTargetUrl();

        return response()->json(['url' => $url]);
    }

    // Callback sau khi user xác thực trên provider (Facebook hoặc Google)
    public function handleProviderCallback($provider)
    {
        try {
            $user = Socialite::driver($provider)
                ->stateless()
                ->user();

            // Tìm user tồn tại hoặc tạo mới
            $existingUser = User::where('email', $user->getEmail())->first();
            if ($existingUser) {
                $existingUser->update([
                    'name' => $user->getName(),
                    'avatar' => $user->getAvatar(),
                ]);
                Auth::login($existingUser);
            } else {
                $newUser = User::create([
                    'name' => $user->getName(),
                    'email' => $user->getEmail(),
                    'password' => Hash::make('default_password'), // Hoặc không cần password
                    // 'provider' => $provider,
                    // 'provider_id' => $user->getId(),
                    'avatar' => $user->getAvatar(),
                ]);
                Auth::login($newUser);
            }

            $token = auth()->user()->createToken('api')->plainTextToken; // Nếu dùng Sanctum

            return view('auth.callback', [
                'provider' => $provider,
                'token' => $token
            ]);
        } catch (\Exception $e) {
            return response()->json(['error' => ucfirst($provider) . ' login failed: ' . $e->getMessage()], 500);
        }
    }
}
