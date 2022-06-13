import 'dart:convert';

import 'package:flutter_html/flutter_html.dart';

List<Faq> faqFromJson(String str) =>
    List<Faq>.from(json.decode(str).map((x) => Faq.fromJson(x)));

String faqToJson(List<Faq> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Faq {
  Faq({
    this.question,
    this.image,
    this.answer,
    this.updatedAt,
    this.priority,
  });

  String question;
  String image;
  String answer;
  DateTime updatedAt;
  int priority;

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
        question: json["question"],
        image: json["image"] == null ? null : json["image"],
        answer: json["answer"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        priority: json["priority"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "image": image == null ? null : image,
        "answer": answer,
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "priority": priority,
      };

  static List<Faq> mapArray(List<dynamic> data) {
    return data.map<Faq>((json) => Faq.fromJson(json)).toList();
  }

  // String get contents {
  //   var content = HtmlParser.parseHTML(answer);
  //   return content.toString();
  // }
}
