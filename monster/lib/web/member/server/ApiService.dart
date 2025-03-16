import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // 基本的 API URL
  static const String _baseUrl = 'https://monsterbackend-production-4a71.up.railway.app/monster/member';

  // 註冊功能
  static Future<http.Response> register({
    required String mpAccount,
    required String mpPassword,
    required String mpEmail,
    required String mpBirthday,
    required String mpNickname,
  }) async {
    final String url = '$_baseUrl/register';
    final Map<String, String> data = {
      "mpAccount": mpAccount,
      "mpPassword": mpPassword,
      "mpEmail": mpEmail,
      "mpBirthday": mpBirthday,
      "mpNickname": mpNickname,
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      print('伺服器回應狀態碼: ${response.statusCode}');
      print('伺服器回應內容: ${response.body}');
      return response;
    } catch (e) {
      print('請求的 URL: $url');
      print('請求的資料: $data');
      print('發生錯誤: $e');
      throw Exception('無法完成註冊請求: $e');
    }
  }

  // 登入功能
  static Future<http.Response> login({
    required String mpAccount,
    required String mpPassword,
  }) async {
    final String url = '$_baseUrl/login';
    final Map<String, String> data = {
      "mpAccount": mpAccount,
      "mpPassword": mpPassword,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      print('伺服器回應狀態碼: ${response.statusCode}');
      print('伺服器回應內容: ${response.body}');
      return response;
    } catch (e) {
      throw Exception('無法完成登入請求: $e');
    }
  }

  // 忘記密碼功能
  static Future<http.Response> forgotPassword({
    required String mpEmail,
  }) async {
    final String url = '$_baseUrl/forget';
    final Map<String, String> data = {"mpEmail": mpEmail};

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      print('伺服器回應狀態碼: ${response.statusCode}');
      print('伺服器回應內容: ${response.body}');
      return response;
    } catch (e) {
      throw Exception('無法完成忘記密碼請求: $e');
    }
  }

  // 驗證碼確認功能
  static Future<http.Response> forgetConfirm({
    required String mpEmail,
    required String confirmCode
  }) async {
    final String url = '$_baseUrl/forget_confirm';
    final Map<String, String> data = {
      "mpEmail": mpEmail,
      "confirmCode": confirmCode
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(data),
      );
      print('伺服器回應狀態碼: ${response.statusCode}');
      print('伺服器回應內容: ${response.body}');
      return response;
    } catch (e) {
      throw Exception('無法完成確認驗證碼請求: $e');
    }
  }

}
