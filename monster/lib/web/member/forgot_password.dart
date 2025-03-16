import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:monster/web/member/server/ApiService.dart';
import 'dart:convert';

import '../../config/DialogUtils.dart';
import '../../config/Validator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  bool _showOtpField = false;
  bool _isOtpSent = false;
  bool _isLoading = false;

  Future<void> _sendOtp() async {

    if (!Validator.isValidEmail(_emailController.text)) {
      DialogUtils.showErrorDialog(context, '信箱格式不正確');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.forgotPassword(
        mpEmail: _emailController.text,
      );

      final responseData = jsonDecode(response.body);

      if (responseData['errorCode'] == 200) {
        setState(() {
          _showOtpField = true;
          _isOtpSent = true;
        });
        DialogUtils.showSuccessDialog(context, '驗證碼已發送至您的電子郵件！');
      } else {
        DialogUtils.showErrorDialog(context, '發送驗證碼失敗：${responseData['message']}');
      }
    } catch (e) {
      DialogUtils.showErrorDialog(context, '發送驗證碼失敗，請檢查網路連線：$e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.isEmpty) {
      DialogUtils.showErrorDialog(context, '請輸入驗證碼!');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.forgetConfirm(
        mpEmail: _emailController.text,
        confirmCode: _otpController.text
      );

      final responseData = jsonDecode(response.body);

      if (responseData['errorCode'] == 200) {
        DialogUtils.showSuccessDialogWithCallback(
          context: context,
          message: '確認成功！',
          onConfirmed: () {
            context.go('/reset_password');
          },
        );

      } else {
        // 嘗試解析回應中的錯誤訊息
        final errorMessage = responseData['message'] ?? '未知的錯誤';
        DialogUtils.showErrorDialog(context, '確認失敗：$errorMessage');
      }
    } catch (e) {
      // 捕捉網路錯誤或其他例外
      DialogUtils.showErrorDialog(context, '確認失敗，請檢查網路連線：$e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500), // 限制輸入框的最大寬度
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '請輸入您的電子郵件，我們將發送驗證碼以重設密碼。',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.left, // 文字置中
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: '電子郵件',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _sendOtp,
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('發送驗證碼'),
                  ),
                  if (_showOtpField) ...[
                    SizedBox(height: 20),
                    TextField(
                      controller: _otpController,
                      decoration: InputDecoration(
                        labelText: '驗證碼',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _verifyOtp,
                      child: _isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('驗證並重設密碼'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
