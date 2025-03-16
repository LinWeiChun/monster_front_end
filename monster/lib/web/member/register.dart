import 'dart:convert'; // 為了解析 JSON

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // 用於格式化日期
import 'package:monster/web/member/server/ApiService.dart';

import '../../config/DialogUtils.dart';
import '../../config/Validator.dart';


class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  DateTime? _selectedDate;

  // 輸入框的控制器
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  Future<void> _submitRegistration() async {
    if (!Validator.isValidAccount(_accountController.text)) {
      DialogUtils.showErrorDialog(context, '帳號只能由英數組合');
      return;
    }

    if (!Validator.isValidPassword(_passwordController.text)) {
      DialogUtils.showErrorDialog(context, '密碼需至少包含8個字符，且包含大小英文字母及特殊符號');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      DialogUtils.showErrorDialog(context, '密碼與確認密碼不一致');
      return;
    }

    if (!Validator.isValidEmail(_emailController.text)) {
      DialogUtils.showErrorDialog(context, '信箱格式不正確');
      return;
    }

    try {
      final response = await ApiService.register(
        mpAccount: _accountController.text,
        mpPassword: _passwordController.text,
        mpEmail: _emailController.text,
        mpBirthday: _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!) // 確保格式正確
            : '',
        mpNickname: _nicknameController.text,
      );

      final responseData = jsonDecode(response.body);
      // 確認回應狀態
      if (responseData['errorCode'] == 200) {
        DialogUtils.showSuccessDialogWithCallback(
          context: context,
          message: '註冊成功！',
          onConfirmed: () {
            // 跳轉到登入頁面
            context.go('/login');
          },
        );

      } else {
        // 嘗試解析回應中的錯誤訊息
        final errorMessage = responseData['message'] ?? '未知的錯誤';
        DialogUtils.showErrorDialog(context, '註冊失敗：$errorMessage');
      }
    } catch (e) {
      // 捕捉網路錯誤或其他例外
      DialogUtils.showErrorDialog(context, '註冊失敗，請檢查網路連線：$e');
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
                  '建立帳戶',
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
                      SizedBox(height: 10),
                      TextField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: '確認密碼',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: '電子郵件',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 10),
                      Text(
                        '生日',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _selectedDate == null
                                ? '請選擇生日'
                                : DateFormat('yyyy-MM-dd').format(_selectedDate!), // 顯示格式化後的日期
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _nicknameController,
                        decoration: InputDecoration(
                          labelText: '暱稱',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _submitRegistration, // 呼叫 API
                        child: Center(child: Text('註冊')),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: Center(child: Text('已有帳戶？立即登入')),
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
