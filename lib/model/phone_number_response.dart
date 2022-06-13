// To parse this JSON data, do
//
//     final phoneNumberResponse = phoneNumberResponseFromJson(jsonString);

import 'dart:convert';

PhoneNumberResponse phoneNumberResponseFromJson(String str) => PhoneNumberResponse.fromJson(json.decode(str));

String phoneNumberResponseToJson(PhoneNumberResponse data) => json.encode(data.toJson());

class PhoneNumberResponse {
  PhoneNumberResponse({
    this.status,
    this.phoneNumber,
  });

  bool status;
  String phoneNumber;

  factory PhoneNumberResponse.fromJson(Map<String, dynamic> json) => PhoneNumberResponse(
    status: json["status"],
    phoneNumber: json["phone_number"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "phone_number": phoneNumber,
  };
}
