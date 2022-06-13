import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse(
      {this.token,
      this.isLogin,
      this.id,
      this.username,
      this.phoneNumber,
      this.autoRetry,
      this.isSocial});

  String token;
  String isLogin;
  String username, phoneNumber;
  int id;
  bool autoRetry, isSocial;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
      token: json["token"],
      isLogin: json["is_login"],
      id: json["id"],
      username: json["username"] ?? "",
      phoneNumber: json["phone_number"] ?? "",
      autoRetry: json["auto_retry"],
      isSocial: json["is_social"]);

  Map<String, dynamic> toJson() => {
        "token": token,
        "is_login": isLogin,
      };
}
