<!DOCTYPE html>
<html>

<head>
    <title>Đăng nhập thành công</title>
</head>

<body>
    <script>
        // Gửi thông tin về cửa sổ cha
        window.opener.postMessage({
            type: "{{ strtoupper($provider) }}_LOGIN_SUCCESS",
            user: @json(Auth::user()),
            token: "{{ $token ?? '' }}"
        }, '*');
        window.close();
    </script>
    <p>Đăng nhập thành công! Bạn có thể đóng cửa sổ này.</p>
</body>

</html>