// To parse this JSON data, do
//
//     final didYouKnow = didYouKnowFromJson(jsonString);

import 'dart:convert';

List<DidYouKnow> didYouKnowFromJson(String str) => List<DidYouKnow>.from(json.decode(str).map((x) => DidYouKnow.fromJson(x)));

String didYouKnowToJson(List<DidYouKnow> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DidYouKnow {
    DidYouKnow({
        this.content,
    });

    String content;

    factory DidYouKnow.fromJson(Map<String, dynamic> json) => DidYouKnow(
        content: json["content"],
    );

    Map<String, dynamic> toJson() => {
        "content": content,
    };

    static List<DidYouKnow> mapArray(List<dynamic> data) {
    return data.map<DidYouKnow>((json) => DidYouKnow.fromJson(json)).toList();
  }
}
