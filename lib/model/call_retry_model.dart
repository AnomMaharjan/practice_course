// To parse this JSON data, do
//
//     final callRetry = callRetryFromJson(jsonString);

import 'dart:convert';

CallRetry callRetryFromJson(String str) => CallRetry.fromJson(json.decode(str));

String callRetryToJson(CallRetry data) => json.encode(data.toJson());

class CallRetry {
    CallRetry({
        this.status,
        this.msg,
    });

    bool status;
    String msg;

    factory CallRetry.fromJson(Map<String, dynamic> json) => CallRetry(
        status: json["status"],
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
    };
}
