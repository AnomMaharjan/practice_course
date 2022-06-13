import 'dart:convert';

List<RetrieveDashboardComponent> retrieveDashboardComponentFromJson(
        String str) =>
    List<RetrieveDashboardComponent>.from(
        json.decode(str).map((x) => RetrieveDashboardComponent.fromJson(x)));

String retrieveDashboardComponentToJson(
        List<RetrieveDashboardComponent> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RetrieveDashboardComponent {
  RetrieveDashboardComponent(
      {this.id,
      this.title,
      this.image,
      this.phoneNumber,
      this.priority,
      this.status,
      this.dialPattern,
      this.dialingNumber,
      this.firstPage,
      this.openTime,
      this.closeTime,
      this.pieColor,
      this.pieImage,
      this.newOpenTime});

  int id;
  String title;
  String image;
  String phoneNumber;
  int priority;
  bool status;
  String dialPattern;
  String dialingNumber;
  String openTime;
  String closeTime;
  Page firstPage;
  String pieColor;
  String pieImage;
  String newOpenTime;

  factory RetrieveDashboardComponent.fromJson(Map<String, dynamic> json) =>
      RetrieveDashboardComponent(
          id: json["id"],
          title: json["title"],
          image: json["image"],
          phoneNumber: json["phone_number"],
          priority: json["priority"],
          status: json["status"],
          dialPattern: json["dial_pattern"],
          dialingNumber: json["dialing_number"],
          openTime: json["open_time"] == null ? null : json["open_time"],
          closeTime: json["close_time"],
          firstPage: json["first_page"] == null
              ? null
              : Page.fromJson(json["first_page"]),
          pieColor: json["pie_color"] == null ? null : json["pie_color"],
          pieImage: json["pie_image"] == null ? null : json["pie_image"],
          newOpenTime:
              json["new_open_time"] == null ? null : json["new_open_time"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "phone_number": phoneNumber,
        "priority": priority,
        "status": status,
        "dial_pattern": dialPattern,
        "dialing_number": dialingNumber,
        "open_time": openTime,
        "close_time": closeTime,
        "first_page": firstPage == null ? null : firstPage.toJson(),
      };

  static List<RetrieveDashboardComponent> mapArray(List<dynamic> data) {
    return data
        .map<RetrieveDashboardComponent>(
            (json) => RetrieveDashboardComponent.fromJson(json))
        .toList();
  }
}

class DisplayButton {
  DisplayButton({
    this.id,
    this.buttonTitle,
    this.buttonType,
    this.displayPage,
    this.nextPage,
  });

  int id;
  String buttonTitle;
  String buttonType;
  Page displayPage;
  NextPage nextPage;

  factory DisplayButton.fromJson(Map<String, dynamic> json) => DisplayButton(
        id: json["id"],
        buttonTitle: json["button_title"],
        buttonType: json["button_type"],
        displayPage: Page.fromJson(json["display_page"]),
        nextPage: json["next_page"] == null
            ? null
            : NextPage.fromJson(json["next_page"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "button_title": buttonTitle,
        "button_type": buttonType,
        "display_page": displayPage.toJson(),
        "next_page": nextPage.toJson(),
      };
}

class Page {
  Page({
    this.id,
    this.title,
    this.openTime,
    this.closeTime,
    this.dialPattern,
    this.displayButton,
    this.previousPage,
  });

  int id;
  String title;
  String openTime;
  String closeTime;
  String dialPattern;
  List<DisplayButton> displayButton;
  int previousPage;

  factory Page.fromJson(Map<String, dynamic> json) => Page(
      id: json["id"],
      title: json["title"],
      openTime: json["open_time"],
      closeTime: json["close_time"],
      dialPattern: json["dial_pattern"],
      displayButton: json["display_button"] == null
          ? null
          : List<DisplayButton>.from(
              json["display_button"].map((x) => DisplayButton.fromJson(x))),
      previousPage: json["previous_page"] == "" ? null : json["previous_page"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "open_time": openTime,
        "close_time": closeTime,
        "dial_pattern": dialPattern,
        "display_button": displayButton == null
            ? null
            : List<dynamic>.from(displayButton.map((x) => x.toJson())),
      };
}

class NextPage {
  NextPage({
    this.id,
    this.title,
  });

  int id;
  String title;

  factory NextPage.fromJson(Map<String, dynamic> json) => NextPage(
        id: json["id"] ?? -1,
        title: json["title"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}
