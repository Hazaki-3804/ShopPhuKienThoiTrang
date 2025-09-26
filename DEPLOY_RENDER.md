# 🚀 Hướng dẫn Deploy lên Render

## 📋 Checklist trước khi deploy

### ✅ Files đã được chuẩn bị:
- [x] `Dockerfile` - Đã được tối ưu cho Render
- [x] `render.yaml` - Cấu hình infrastructure
- [x] `.env.production.example` - Template environment variables

### 🔧 Chuẩn bị trước khi deploy:

1. **Generate APP_KEY**:
   ```bash
   php artisan key:generate --show
   ```
   Lưu key này để nhập vào Render environment variables.

2. **Kiểm tra database migrations**:
   ```bash
   php artisan migrate:status
   ```

3. **Test build locally** (optional):
   ```bash
   docker build -t shop-test .
   docker run -p 8080:80 shop-test
   ```

## 🌐 Các bước deploy trên Render

### Bước 1: Tạo tài khoản và kết nối GitHub
1. Đăng ký tại [render.com](https://render.com)
2. Kết nối với GitHub repository của bạn

### Bước 2: Deploy bằng render.yaml
1. Trong Render Dashboard, chọn **"New"** → **"Blueprint"**
2. Chọn repository chứa code của bạn
3. Render sẽ tự động đọc file `render.yaml` và tạo services

### Bước 3: Cấu hình Environment Variables
Trong Web Service settings, thêm các biến môi trường sau:

#### 🔑 Required Variables:
```
APP_KEY=base64:YOUR_GENERATED_KEY_HERE
APP_URL=https://your-app-name.onrender.com
```

#### 📧 Email Configuration (Optional):
```
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-app-password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=your-email@gmail.com
```

#### 🔐 Social Login (Optional):
```
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
```

### Bước 4: Database Setup
- Database sẽ được tự động tạo theo `render.yaml`
- Render sẽ tự động set `DATABASE_URL`
- Migrations sẽ chạy tự động khi deploy

### Bước 5: Deploy
1. Commit và push code lên GitHub
2. Render sẽ tự động build và deploy
3. Kiểm tra logs để đảm bảo deploy thành công

## 🔍 Troubleshooting

### ❌ Lỗi thường gặp:

1. **Build failed - npm install error**:
   - Kiểm tra `package.json` và `package-lock.json`
   - Đảm bảo Node version tương thích

2. **Migration failed**:
   - Kiểm tra database connection
   - Xem logs để debug SQL errors

3. **500 Internal Server Error**:
   - Kiểm tra `APP_KEY` đã được set chưa
   - Xem Apache error logs trong Render dashboard

4. **Static files không load**:
   - Đảm bảo `npm run build` chạy thành công
   - Kiểm tra `public/build` folder có được tạo không

### 📊 Monitoring:
- Xem logs realtime trong Render dashboard
- Set up health checks tại `/health` endpoint
- Monitor performance metrics

## 🎯 Production Optimizations

### 1. Upgrade Plans:
- Web Service: Upgrade từ Free → Starter ($7/month)
- Database: Upgrade từ Free → Starter ($7/month)

### 2. Performance:
- Enable Redis cho caching và sessions
- Sử dụng CDN cho static assets
- Optimize database queries

### 3. Security:
- Set up proper CORS policies
- Configure rate limiting
- Use HTTPS (tự động với Render)

## 📞 Support

Nếu gặp vấn đề:
1. Kiểm tra Render logs
2. Xem Laravel logs trong `/storage/logs`
3. Tham khảo [Render Documentation](https://render.com/docs)

---

**🎉 Chúc bạn deploy thành công!**
