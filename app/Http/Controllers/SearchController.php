<?php

namespace App\Http\Controllers;

use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class SearchController extends Controller
{
    public function suggest(Request $request)
    {
        $query = (string) $request->query('q', '');
        $limit = (int) $request->query('limit', 8);

        if ($query === '') {
            return response()->json([]);
        }

        $normalized = Str::lower($query);

        $products = Product::query()
            ->select(['id', 'name', 'price'])
            ->whereRaw('LOWER(name) LIKE ?', ['%' . $normalized . '%'])
            ->orderBy('name')
            ->limit(max(1, min(20, $limit)))
            ->get();

        return response()->json($products);
    }
}


