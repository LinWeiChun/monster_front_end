class Validator {
  static bool isValidAccount(String account) {
    // 帳號只能由英數組合
    return RegExp(r'^[a-zA-Z0-9]+$').hasMatch(account);
  }

  static bool isValidPassword(String password) {
    // 密碼需至少包含8個字符，且包含大小英文字母及特殊符號
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
        .hasMatch(password);
  }

  static bool isValidEmail(String email) {
    // 信箱格式驗證
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
