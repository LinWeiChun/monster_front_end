import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monster/web/member/server/ApiService.dart';

import '../../config/DialogUtils.dart';
import '../../config/Validator.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  DateTime? _selectedDate;

  // 輸入框的控制器
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _submitLogin() async {
    if (!Validator.isValidAccount(_accountController.text)) {
      DialogUtils.showErrorDialog(context, '帳號只能由英數組合');
      return;
    }

    if (!Validator.isValidPassword(_passwordController.text)) {
      DialogUtils.showErrorDialog(context, '密碼需至少包含8個字符，且包含大小英文字母及特殊符號');
      return;
    }


    try {
      final response = await ApiService.login(
        mpAccount: _accountController.text,
        mpPassword: _passwordController.text,
      );

      final responseData = jsonDecode(response.body);
      // 確認回應狀態
      if (responseData['errorCode'] == 200) {
        DialogUtils.showSuccessDialogWithCallback(
          context: context,
          message: '登入成功！',
          onConfirmed: () {
            // 跳轉到登入頁面
            context.go('/profile');
          },
        );

      } else {
        // 嘗試解析回應中的錯誤訊息
        final errorMessage = responseData['message'] ?? '未知的錯誤';
        DialogUtils.showErrorDialog(context, '登入失敗：$errorMessage');
      }
    } catch (e) {
      // 捕捉網路錯誤或其他例外
      DialogUtils.showErrorDialog(context, '登入失敗，請檢查網路連線：$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '登入',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 500),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _accountController,
                        decoration: InputDecoration(
                          labelText: '帳號',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: '密碼',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitLogin, // 呼叫 API
                        child: Center(child: Text('登入')),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () => context.go('/forgot_password'),
                        child: Center(child: Text('忘記密碼')),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () => context.go('/register'),
                        child: Center(child: Text('尚未擁有帳戶？立即註冊')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
