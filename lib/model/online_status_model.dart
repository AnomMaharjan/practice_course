import 'dart:convert';

List<OnlineStatus> onlineStatusFromJson(String str) => List<OnlineStatus>.from(
    json.decode(str).map((x) => OnlineStatus.fromJson(x)));

String onlineStatusToJson(List<OnlineStatus> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OnlineStatus {
  OnlineStatus({
    this.id,
    this.status,
  });

  int id;
  bool status;

  factory OnlineStatus.fromJson(Map<String, dynamic> json) => OnlineStatus(
        id: json["id"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
      };

  static List<OnlineStatus> mapArray(List<dynamic> data) {
    return data
        .map<OnlineStatus>((json) => OnlineStatus.fromJson(json))
        .toList();
  }
}
