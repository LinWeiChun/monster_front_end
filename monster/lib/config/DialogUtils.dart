import 'package:flutter/material.dart';

class DialogUtils {
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('錯誤', style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('確定'),
          ),
        ],
      ),
    );
  }

  static void showSuccessDialogWithCallback({
    required BuildContext context,
    required String message,
    required VoidCallback onConfirmed,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('成功'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 關閉彈跳視窗
                onConfirmed(); // 執行回調函數
              },
              child: Text('確定'),
            ),
          ],
        );
      },
    );
  }
  static void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('成功', style: TextStyle(color: Colors.green)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // 關閉對話框
            },
            child: Text('確定'),
          ),
        ],
      ),
    );
  }
}
