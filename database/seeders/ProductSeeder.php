<?php

namespace Database\Seeders;

use App\Models\Product;
use Illuminate\Database\Seeder;

class ProductSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $products = [
            [
                'category_id' => 1,
                'name' => 'Áo thun nam cao cấp',
                'description' => 'Áo thun nam chất liệu cotton cao cấp',
                'price' => 299000,
                'stock' => 45,
                'status' => 1,
            ],
            [
                'category_id' => 2,
                'name' => 'Quần jean nữ slim fit',
                'description' => 'Quần jean nữ slim fit chất liệu denim',
                'price' => 599000,
                'stock' => 32,
                'status' => 1,
            ],
            [
                'category_id' => 3,
                'name' => 'Giày sneaker Adidas',
                'description' => 'Giày sneaker Adidas chính hãng',
                'price' => 1299000,
                'stock' => 28,
                'status' => 0,
            ],
            [
                'category_id' => 4,
                'name' => 'Túi xách da thật',
                'description' => 'Túi xách da thật cao cấp',
                'price' => 899000,
                'stock' => 15,
                'status' => 1,
            ],
            [
                'category_id' => 5,
                'name' => 'Đồng hồ thông minh',
                'description' => 'Đồng hồ thông minh đa chức năng',
                'price' => 2499000,
                'stock' => 67,
                'status' => 1,
            ],
            [
                'category_id' => 5,
                'name' => 'Kính mắt Ray-Ban',
                'description' => 'Kính mắt Ray-Ban chính hãng',
                'price' => 1899000,
                'stock' => 23,
                'status' => 1,
            ],
            [
                'category_id' => 1,
                'name' => 'Áo khoác denim',
                'description' => 'Áo khoác denim nam nữ',
                'price' => 799000,
                'stock' => 18,
                'status' => 1,
            ],
            [
                'category_id' => 2,
                'name' => 'Quần short nữ',
                'description' => 'Quần short nữ thể thao',
                'price' => 299000,
                'stock' => 35,
                'status' => 1,
            ],
        ];

        foreach ($products as $product) {
            Product::create($product);
        }
    }
}