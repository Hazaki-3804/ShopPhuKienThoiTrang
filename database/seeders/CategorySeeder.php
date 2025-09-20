<?php

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Seeder;

class CategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = [
            ['name' => 'Áo thun', 'description' => 'Các loại áo thun nam nữ'],
            ['name' => 'Quần jean', 'description' => 'Quần jean nam nữ các loại'],
            ['name' => 'Giày sneaker', 'description' => 'Giày thể thao, giày sneaker'],
            ['name' => 'Túi xách', 'description' => 'Túi xách, balo, ví nam nữ'],
            ['name' => 'Phụ kiện', 'description' => 'Đồng hồ, kính mắt, trang sức'],
        ];

        foreach ($categories as $category) {
            Category::create($category);
        }
    }
}