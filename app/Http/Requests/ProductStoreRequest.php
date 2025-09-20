<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ProductStoreRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'category_id' => ['required', 'integer', 'exists:categories,id'],
            'name' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
            'price' => ['required', 'numeric', 'min:0'],
            'stock' => ['required', 'integer', 'min:0'],
            'status' => ['required', 'integer', 'in:0,1'],
        ];
    }

    public function messages(): array
    {
        return [
            'category_id.required' => 'Danh mục là bắt buộc.',
            'category_id.exists' => 'Danh mục không hợp lệ.',
            'name.required' => 'Tên sản phẩm là bắt buộc.',
            'price.required' => 'Giá là bắt buộc.',
            'price.min' => 'Giá không được âm.',
            'stock.required' => 'Tồn kho là bắt buộc.',
            'stock.min' => 'Tồn kho không được âm.',
            'status.in' => 'Trạng thái không hợp lệ.',
        ];
    }
}


