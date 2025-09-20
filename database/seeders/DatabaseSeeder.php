<?php

namespace Database\Seeders;

use App\Models\User;
// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // User::factory(10)->create();

        User::factory()->create([
            'username' => 'Hazaki',
            'name' => 'Trịnh Khắc Nhựt',
            'password' => bcrypt('admin'),
            'email' => 'khacnhut2004vlg@gmail.com',
            'role_id' => 1,
            'status' => 1,
            'phone' => '+84967523456',
            'address' => 'xã Cái Nhum, tỉnh Vĩnh Long, Việt Nam',
        ]);

        // Seed categories and products
        $this->call([
            CategorySeeder::class,
            ProductSeeder::class,
        ]);
    }
}
