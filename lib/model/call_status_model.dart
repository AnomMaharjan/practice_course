// To parse this JSON data, do
//
//     final callStatusModel = callStatusModelFromJson(jsonString);

import 'dart:convert';

CallStatusModel callStatusModelFromJson(String str) =>
    CallStatusModel.fromJson(json.decode(str));

String callStatusModelToJson(CallStatusModel data) =>
    json.encode(data.toJson());

class CallStatusModel {
  CallStatusModel(
      {this.call,
      this.callStatus,
      this.conferenceSId,
      this.imageUrl,
      this.isRetrying});

  Call call;
  String callStatus;
  String conferenceSId;
  String imageUrl;
  bool isRetrying;

  factory CallStatusModel.fromJson(Map<String, dynamic> json) =>
      CallStatusModel(
          call: Call.fromJson(json["call"]),
          callStatus: json["call_status"],
          conferenceSId: json["conference_sid"],
          imageUrl: json["image_url"],
          isRetrying: json["is_retrying"]);

  Map<String, dynamic> toJson() => {
        "call": call.toJson(),
        "call_status": callStatus,
      };
}

class Call {
  Call({
    this.minutesSaved,
    this.user,
  });

  double minutesSaved;
  int user;

  factory Call.fromJson(Map<String, dynamic> json) => Call(
        minutesSaved: json["minutes_saved"] ?? 0,
        user: json["user"],
      );

  Map<String, dynamic> toJson() => {
        "minutes_saved": minutesSaved,
        "user": user,
      };
}
