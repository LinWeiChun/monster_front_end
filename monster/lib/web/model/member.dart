class Member {
  final String account;
  final String email;
  final String birthday;
  final String nickname;

  Member({
    required this.account,
    required this.email,
    required this.birthday,
    required this.nickname,
  });

  // 從 JSON 轉換為 User
  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      account: json['account'],
      email: json['email'],
      birthday: json['birthday'],
      nickname: json['nickName'],
    );
  }
}
