<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Dòng thông báo xác thực mặc định
    |--------------------------------------------------------------------------
    |
    | Các dòng sau chứa thông báo lỗi mặc định được dùng bởi lớp validator.
    | Bạn có thể tự do thay đổi cho phù hợp với ứng dụng của bạn.
    |
    */

    'accepted'             => ':attribute phải được chấp nhận.',
    'accepted_if'          => ':attribute phải được chấp nhận khi :other là :value.',
    'active_url'           => ':attribute không phải là một URL hợp lệ.',
    'after'                => ':attribute phải sau ngày :date.',
    'after_or_equal'       => ':attribute phải sau hoặc bằng ngày :date.',
    'alpha'                => ':attribute chỉ được chứa chữ cái.',
    'alpha_dash'           => ':attribute chỉ được chứa chữ cái, số, dấu gạch ngang và gạch dưới.',
    'alpha_num'            => ':attribute chỉ được chứa chữ cái và số.',
    'array'                => ':attribute phải là một mảng.',
    'ascii'                => ':attribute chỉ được chứa ký tự ASCII đơn.',
    'before'               => ':attribute phải trước ngày :date.',
    'before_or_equal'      => ':attribute phải trước hoặc bằng ngày :date.',
    'between'              => [
        'array'   => ':attribute phải có từ :min đến :max phần tử.',
        'file'    => ':attribute phải từ :min đến :max kilobytes.',
        'numeric' => ':attribute phải từ :min đến :max.',
        'string'  => ':attribute phải từ :min đến :max ký tự.',
    ],
    'boolean'              => ':attribute phải là true hoặc false.',
    'confirmed'            => ':attribute xác nhận không khớp.',
    'current_password'     => 'Mật khẩu không chính xác.',
    'date'                 => ':attribute không phải ngày hợp lệ.',
    'date_equals'          => ':attribute phải bằng ngày :date.',
    'date_format'          => ':attribute không khớp định dạng :format.',
    'decimal'              => ':attribute phải có :decimal chữ số thập phân.',
    'declined'             => ':attribute phải bị từ chối.',
    'declined_if'          => ':attribute phải bị từ chối khi :other là :value.',
    'different'            => ':attribute và :other phải khác nhau.',
    'digits'               => ':attribute phải gồm :digits chữ số.',
    'digits_between'       => ':attribute phải từ :min đến :max chữ số.',
    'dimensions'           => ':attribute có kích thước ảnh không hợp lệ.',
    'distinct'             => ':attribute có giá trị trùng lặp.',
    'doesnt_end_with'      => ':attribute không được kết thúc bằng một trong: :values.',
    'doesnt_start_with'    => ':attribute không được bắt đầu bằng một trong: :values.',
    'email'                => ':attribute phải là email hợp lệ.',
    'ends_with'            => ':attribute phải kết thúc bằng một trong: :values.',
    'enum'                 => ':attribute được chọn không hợp lệ.',
    'exists'               => ':attribute được chọn không hợp lệ.',
    'file'                 => ':attribute phải là tệp.',
    'filled'               => ':attribute không được để trống.',
    'gt'                   => [
        'array'   => ':attribute phải có nhiều hơn :value phần tử.',
        'file'    => ':attribute phải lớn hơn :value kilobytes.',
        'numeric' => ':attribute phải lớn hơn :value.',
        'string'  => ':attribute phải dài hơn :value ký tự.',
    ],
    'gte'                  => [
        'array'   => ':attribute phải có ít nhất :value phần tử.',
        'file'    => ':attribute phải lớn hơn hoặc bằng :value kilobytes.',
        'numeric' => ':attribute phải lớn hơn hoặc bằng :value.',
        'string'  => ':attribute phải dài hơn hoặc bằng :value ký tự.',
    ],
    'image'                => ':attribute phải là hình ảnh.',
    'in'                   => ':attribute được chọn không hợp lệ.',
    'in_array'             => ':attribute không tồn tại trong :other.',
    'integer'              => ':attribute phải là số nguyên.',
    'ip'                   => ':attribute phải là địa chỉ IP hợp lệ.',
    'ipv4'                 => ':attribute phải là địa chỉ IPv4 hợp lệ.',
    'ipv6'                 => ':attribute phải là địa chỉ IPv6 hợp lệ.',
    'json'                 => ':attribute phải là chuỗi JSON hợp lệ.',
    'lowercase'            => ':attribute phải viết thường.',
    'lt'                   => [
        'array'   => ':attribute phải có ít hơn :value phần tử.',
        'file'    => ':attribute phải nhỏ hơn :value kilobytes.',
        'numeric' => ':attribute phải nhỏ hơn :value.',
        'string'  => ':attribute phải ngắn hơn :value ký tự.',
    ],
    'lte'                  => [
        'array'   => ':attribute không được nhiều hơn :value phần tử.',
        'file'    => ':attribute phải nhỏ hơn hoặc bằng :value kilobytes.',
        'numeric' => ':attribute phải nhỏ hơn hoặc bằng :value.',
        'string'  => ':attribute phải ngắn hơn hoặc bằng :value ký tự.',
    ],
    'mac_address'          => ':attribute phải là địa chỉ MAC hợp lệ.',
    'max'                  => [
        'array'   => ':attribute không được nhiều hơn :max phần tử.',
        'file'    => ':attribute không được lớn hơn :max kilobytes.',
        'numeric' => ':attribute không được lớn hơn :max.',
        'string'  => ':attribute không được dài hơn :max ký tự.',
    ],
    'max_digits'           => ':attribute không được nhiều hơn :max chữ số.',
    'mimes'                => ':attribute phải là tệp loại: :values.',
    'mimetypes'            => ':attribute phải là tệp loại: :values.',
    'min'                  => [
        'array'   => ':attribute phải có ít nhất :min phần tử.',
        'file'    => ':attribute phải ít nhất :min kilobytes.',
        'numeric' => ':attribute phải ít nhất :min.',
        'string'  => ':attribute phải có ít nhất :min ký tự.',
    ],
    'min_digits'           => ':attribute phải có ít nhất :min chữ số.',
    'multiple_of'          => ':attribute phải là bội số của :value.',
    'not_in'               => ':attribute được chọn không hợp lệ.',
    'not_regex'            => ':attribute không đúng định dạng.',
    'numeric'              => ':attribute phải là số.',
    'password'             => [
        'letters'       => ':attribute phải chứa ít nhất một chữ cái.',
        'mixed'         => ':attribute phải chứa ít nhất một chữ hoa và một chữ thường.',
        'numbers'       => ':attribute phải chứa ít nhất một số.',
        'symbols'       => ':attribute phải chứa ít nhất một ký tự đặc biệt.',
        'uncompromised' => ':attribute đã xuất hiện trong rò rỉ dữ liệu. Vui lòng chọn mật khẩu khác.',
    ],
    'present'              => ':attribute phải có mặt.',
    'prohibited'           => ':attribute bị cấm.',
    'prohibited_if'        => ':attribute bị cấm khi :other là :value.',
    'prohibited_unless'    => ':attribute bị cấm trừ khi :other nằm trong :values.',
    'prohibits'            => ':attribute ngăn cản :other xuất hiện.',
    'regex'                => ':attribute không đúng định dạng.',
    'required'             => ':attribute không được để trống.',
    'required_array_keys'  => ':attribute phải chứa các khóa: :values.',
    'required_if'          => ':attribute bắt buộc khi :other là :value.',
    'required_if_accepted' => ':attribute bắt buộc khi :other được chấp nhận.',
    'required_unless'      => ':attribute bắt buộc trừ khi :other nằm trong :values.',
    'required_with'        => ':attribute bắt buộc khi có :values.',
    'required_with_all'    => ':attribute bắt buộc khi có tất cả :values.',
    'required_without'     => ':attribute bắt buộc khi không có :values.',
    'required_without_all' => ':attribute bắt buộc khi không có bất kỳ :values nào.',
    'same'                 => ':attribute và :other phải trùng nhau.',
    'size'                 => [
        'array'   => ':attribute phải chứa :size phần tử.',
        'file'    => ':attribute phải có kích thước :size kilobytes.',
        'numeric' => ':attribute phải bằng :size.',
        'string'  => ':attribute phải gồm :size ký tự.',
    ],
    'starts_with'          => ':attribute phải bắt đầu bằng một trong: :values.',
    'string'               => ':attribute phải là chuỗi.',
    'timezone'             => ':attribute phải là múi giờ hợp lệ.',
    'unique'               => ':attribute đã tồn tại.',
    'uploaded'             => ':attribute tải lên thất bại.',
    'uppercase'            => ':attribute phải viết hoa.',
    'url'                  => ':attribute phải là URL hợp lệ.',
    'ulid'                 => ':attribute phải là ULID hợp lệ.',
    'uuid'                 => ':attribute phải là UUID hợp lệ.',

    /*
    |--------------------------------------------------------------------------
    | Thông báo xác thực tùy chỉnh
    |--------------------------------------------------------------------------
    |
    | Ở đây bạn có thể tùy chỉnh thông báo lỗi cho các thuộc tính cụ thể.
    | Cú pháp: 'attribute.rule' => 'thông báo',
    |
    */

    'custom' => [
        'username' => [
            'required'   => 'Tên đăng nhập không được để trống.',
            'alpha_dash' => 'Tên đăng nhập chỉ được chứa chữ, số, gạch ngang và gạch dưới.',
            'min'        => 'Tên đăng nhập phải có ít nhất :min ký tự.',
            'max'        => 'Tên đăng nhập không được vượt quá :max ký tự.',
            'unique'     => 'Tên đăng nhập đã tồn tại.',
        ],
        'email' => [
            'required' => 'Email không được để trống.',
            'email'    => 'Email không hợp lệ.',
            'unique'   => 'Email đã được sử dụng.',
        ],
        'password' => [
            'required'   => 'Mật khẩu không được để trống.',
            'confirmed'  => 'Xác nhận mật khẩu không khớp.',
        ],
        'phone' => [
            'required' => 'Số điện thoại không được để trống.',
            'regex'    => 'Số điện thoại không hợp lệ (phải từ 10–13 số và bắt đầu bằng 0).',
        ],
        'address' => [
            'required' => 'Địa chỉ không được để trống.',
            'min'      => 'Địa chỉ phải có ít nhất :min ký tự.',
            'max'      => 'Địa chỉ không được vượt quá :max ký tự.',
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Thuộc tính
    |--------------------------------------------------------------------------
    |
    | Dùng để đổi tên các trường từ tiếng Anh sang tiếng Việt.
    |
    */

    'attributes' => [
        'username' => 'Tên đăng nhập',
        'name'     => 'Họ và tên',
        'email'    => 'Email',
        'password' => 'Mật khẩu',
        'phone'    => 'Số điện thoại',
        'address'  => 'Địa chỉ',
    ],

];
