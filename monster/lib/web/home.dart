import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 放置 Logo 圖片的標籤
              Image.asset(
                'assets/image/icon_main.png', // Logo 圖片路徑
                height: 120, // 設定圖片高度
                fit: BoxFit.contain, // 確保圖片按比例顯示
              ),
              SizedBox(height: 30), // 與下方文字的間距
              Text(
                '歡迎來到會員系統',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 300), // 限制按鈕最大寬度
                child: ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: Text('登入'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50), // 高度固定
                  ),
                ),
              ),
              SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 300), // 限制按鈕最大寬度
                child: ElevatedButton(
                  onPressed: () => context.go('/register'),
                  child: Text('註冊'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50), // 高度固定
                  ),
                ),
              ),
              SizedBox(height: 10),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 300), // 限制按鈕最大寬度
                child: ElevatedButton.icon(
                  onPressed: () {
                    print('Google 登入邏輯尚未實現'); // 暫時替代功能
                  },
                  icon: Icon(Icons.g_mobiledata), // Google 圖標
                  label: Text('使用 Google 登入'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // 設定背景顏色
                    foregroundColor: Colors.white, // 文字顏色
                    minimumSize: Size(double.infinity, 50), // 高度固定
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
