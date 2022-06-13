import 'dart:convert';

List<PrivacyPolicy> privacyPolicyFromJson(String str) =>
    List<PrivacyPolicy>.from(
        json.decode(str).map((x) => PrivacyPolicy.fromJson(x)));

String privacyPolicyToJson(List<PrivacyPolicy> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PrivacyPolicy {
  PrivacyPolicy({
    this.title,
    this.image,
    this.content,
    this.updatedAt,
    this.priority,
  });

  String title;
  dynamic image;
  String content;
  DateTime updatedAt;
  int priority;

  factory PrivacyPolicy.fromJson(Map<String, dynamic> json) => PrivacyPolicy(
        title: json["title"],
        image: json["image"],
        content: json["content"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        priority: json["priority"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "image": image,
        "content": content,
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "priority": priority,
      };

      static List<PrivacyPolicy> mapArray(List<dynamic> data) {
    return data
        .map<PrivacyPolicy>(
            (json) => PrivacyPolicy.fromJson(json))
        .toList();
  }
}
