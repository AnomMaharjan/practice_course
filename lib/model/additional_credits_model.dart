// To parse this JSON data, do
//
//     final additionalCredits = additionalCreditsFromJson(jsonString);

import 'dart:convert';

List<AdditionalCredits> additionalCreditsFromJson(String str) =>
    List<AdditionalCredits>.from(
        json.decode(str).map((x) => AdditionalCredits.fromJson(x)));

String additionalCreditsToJson(List<AdditionalCredits> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdditionalCredits {
  AdditionalCredits({
    this.title,
    this.productId,
    this.price,
    this.credit,
    this.platform,
  });

  String title;
  String productId;
  double price;
  int credit;
  String platform;

  factory AdditionalCredits.fromJson(Map<String, dynamic> json) =>
      AdditionalCredits(
        title: json["title"],
        productId: json["product_id"],
        price: json["price"].toDouble(),
        credit: json["credit"],
        platform: json["platform"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "product_id": productId,
        "price": price,
        "credit": credit,
        "platform": platform,
      };

  static List<AdditionalCredits> mapArray(List<dynamic> data) {
    return data
        .map<AdditionalCredits>((json) => AdditionalCredits.fromJson(json))
        .toList();
  }
}
