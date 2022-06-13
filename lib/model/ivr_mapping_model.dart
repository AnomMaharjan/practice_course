import 'dart:convert';

PageModel pageModelFromJson(String str) => PageModel.fromJson(json.decode(str));

String pageModelToJson(PageModel data) => json.encode(data.toJson());

class PageModel {
  PageModel(
      {this.id,
      this.title,
      this.dynamicInputStatus,
      this.dynamicInput,
      this.displayButton,
      this.previousPage,
      this.inputText});

  int id;
  String title;
  DynamicInput dynamicInput;
  bool dynamicInputStatus;
  List<DisplayButton> displayButton;
  int previousPage;
  String inputText;

  factory PageModel.fromJson(Map<String, dynamic> json) => PageModel(
      id: json["id"] == null ? null : json["id"],
      title: json["title"],
      dynamicInput: json["dynamic_input"] == null
          ? null
          : DynamicInput.fromJson(json["dynamic_input"]),
      dynamicInputStatus: json["dynamic_input_status"] == null
          ? null
          : json["dynamic_input_status"],
      displayButton: json["display_button"] == null
          ? null
          : List<DisplayButton>.from(
              json["display_button"].map((x) => DisplayButton.fromJson(x))),
      previousPage:
          json["previous_page"] == null ? null : json["pre vious_page"],
      inputText: json["input_text"] == null ? null : json["input_text"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "display_button":
            List<dynamic>.from(displayButton.map((x) => x.toJson())),
        "previous_page": previousPage,
      };
}

class DisplayButton {
  DisplayButton({
    this.id,
    this.buttonTitle,
    this.buttonType,
    this.displayPage,
    this.nextPage,
    this.supportComponent,
  });

  int id;
  String buttonTitle;
  String buttonType;
  DisplayPage displayPage;
  dynamic nextPage;
  SupportComponent supportComponent;

  factory DisplayButton.fromJson(Map<String, dynamic> json) => DisplayButton(
        id: json["id"],
        buttonTitle: json["button_title"],
        buttonType: json["button_type"],
        displayPage: DisplayPage.fromJson(json["display_page"]),
        nextPage: json["next_page"],
        supportComponent: json["support_component"] == null
            ? null
            : SupportComponent.fromJson(json["support_component"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "button_title": buttonTitle,
        "button_type": buttonType,
        "display_page": displayPage.toJson(),
        "next_page": nextPage,
        "support_component": supportComponent.toJson(),
        // "dynamic_input": dynamicInput == null ? null : dynamicInput.toJson(),
      };
}

class DisplayPage {
  DisplayPage({
    this.id,
    this.title,
  });

  int id;
  String title;

  factory DisplayPage.fromJson(Map<String, dynamic> json) => DisplayPage(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}

class DynamicInput {
  DynamicInput({
    this.id,
    this.title,
    this.fieldType,
    this.fieldSlug,
  });

  int id;
  String title;
  String fieldType;
  String fieldSlug;

  factory DynamicInput.fromJson(Map<String, dynamic> json) => DynamicInput(
        id: json["id"] ?? -1,
        title: json["title"] ?? "",
        fieldType: json["field_type"] ?? "",
        fieldSlug: json["field_slug"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "field_type": fieldType,
        "field_slug": fieldSlug,
      };
}

class SupportComponent {
  SupportComponent({
    this.id,
    this.title,
    this.openTime,
    this.closeTime,
    this.dialPattern,
    this.dialingNumber,
  });

  int id;
  String title;
  dynamic openTime;
  dynamic closeTime;
  String dialPattern;
  String dialingNumber;

  factory SupportComponent.fromJson(Map<String, dynamic> json) =>
      SupportComponent(
        id: json["id"],
        title: json["title"],
        openTime: json["open_time"] == null ? null : json["open_time"],
        closeTime: json["close_time"] == null ? null : json["close_time"],
        dialPattern: json["dial_pattern"],
        dialingNumber: json["dialing_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "open_time": openTime,
        "close_time": closeTime,
        "dial_pattern": dialPattern,
        "dialing_number": dialingNumber,
      };
}
