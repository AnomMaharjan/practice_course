import 'dart:convert';

AppleLoginResponse appleLoginResponseFromJson(String str) =>
    AppleLoginResponse.fromJson(json.decode(str));

String appleLoginResponseToJson(AppleLoginResponse data) =>
    json.encode(data.toJson());

class AppleLoginResponse {
  AppleLoginResponse(
      {this.token,
      this.id,
      this.username,
      this.phoneNumber,
      this.numberStatus,
      this.autoRetry,
      this.isSocial});

  String token;
  int id;
  String username;
  String phoneNumber;
  bool numberStatus, autoRetry, isSocial;

  factory AppleLoginResponse.fromJson(Map<String, dynamic> json) =>
      AppleLoginResponse(
          token: json["key"],
          id: json["id"],
          username: json["username"],
          phoneNumber: json["phone_number"],
          numberStatus: json["status"],
          autoRetry: json["auto_retry"],
          isSocial: json["is_social"]);

  Map<String, dynamic> toJson() => {
        "key": token,
      };
}
