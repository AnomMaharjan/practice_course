import 'dart:convert';

AddressFinder addressFinderFromJson(String str) =>
    AddressFinder.fromJson(json.decode(str));

String addressFinderToJson(AddressFinder data) => json.encode(data.toJson());

class AddressFinder {
  AddressFinder({
    this.results,
  });

  List<Result> results;

  factory AddressFinder.fromJson(Map<String, dynamic> json) => AddressFinder(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    this.id,
    this.count,
    this.labels,
  });

  String id;
  int count;
  List<String> labels;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        id: json["id"],
        count: json["count"],
        labels: List<String>.from(json["labels"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "count": count,
        "labels": List<dynamic>.from(labels.map((x) => x)),
      };
  static List<AddressFinder> mapArray(List<dynamic> data) {
    return data
        .map<AddressFinder>((json) => AddressFinder.fromJson(json))
        .toList();
  }

  String get labels0 {
    var labels0 = labels.isEmpty ? "" : labels[0].toString();
    return labels0.toString() + " ";
  }

  String get countNo {
    return count.toString() + " " + "Addresses".toString();
  }

  String get labels1 {
    var labels1 = labels.length == 1 ? "" : labels[1].toString();
    return labels1.toString() + ", ";
  }
}
