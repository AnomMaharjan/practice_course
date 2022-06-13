import 'dart:convert';

GoogleLoginResponse googleLoginResponseFromJson(String str) =>
    GoogleLoginResponse.fromJson(json.decode(str));

String googleLoginResponseToJson(GoogleLoginResponse data) =>
    json.encode(data.toJson());

class GoogleLoginResponse {
  GoogleLoginResponse(
      {this.token,
      this.id,
      this.username,
      this.phoneNumber,
      this.numberStatus,
      this.isSocial,
      this.autoRetry});

  String token;
  int id;
  String username;
  String phoneNumber;
  bool numberStatus, autoRetry, isSocial;

  factory GoogleLoginResponse.fromJson(Map<String, dynamic> json) =>
      GoogleLoginResponse(
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
