// To parse this JSON data, do
//
//     final otpResponse = otpResponseFromJson(jsonString);

import 'dart:convert';

OtpResponse otpResponseFromJson(String str) => OtpResponse.fromJson(json.decode(str));

String otpResponseToJson(OtpResponse data) => json.encode(data.toJson());

class OtpResponse {
    OtpResponse({
        this.msg,
        this.status,
        this.serviceSid,
    });

    String msg;
    bool status;
    String serviceSid;

    factory OtpResponse.fromJson(Map<String, dynamic> json) => OtpResponse(
        msg: json["msg"],
        status: json["status"],
        serviceSid: json["service_sid"],
    );

    Map<String, dynamic> toJson() => {
        "msg": msg,
        "status": status,
        "service_sid": serviceSid,
    };
}
