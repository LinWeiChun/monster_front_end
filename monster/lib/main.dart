import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:go_router/go_router.dart';
import 'package:monster/web/home.dart';
import 'package:monster/web/member/forgot_password.dart';
import 'package:monster/web/member/login.dart';
import 'package:monster/web/member/profile.dart';
import 'package:monster/web/member/register.dart';
import 'package:monster/web/member/reset_password.dart';

void main() {
  // 設置 URL 策略為 Path URL Strategy
  setUrlStrategy(PathUrlStrategy());
  runApp(MyApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(), // 假設這是預設登入頁
    ),
  ],
);

class MyApp extends StatelessWidget {
  // 定義 GoRouter 配置
  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot_password',
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset_password',
        builder: (context, state) => ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => ProfileScreen(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '會員管理系統',
      debugShowCheckedModeBanner: false, // 關閉 DEBUG 標籤
      routerDelegate: _router.routerDelegate, // 使用 GoRouter 的 routerDelegate
      routeInformationParser: _router.routeInformationParser, // 使用 GoRouter 的 routeInformationParser
      routeInformationProvider: _router.routeInformationProvider, // 可選，處理 route information
    );
  }
}
