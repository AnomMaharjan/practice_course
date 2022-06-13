import 'dart:convert';

List<TimeBreakdownResponse> timeBreakdownResponseFromJson(String str) =>
    List<TimeBreakdownResponse>.from(
        json.decode(str).map((x) => TimeBreakdownResponse.fromJson(x)));

String timeBreakdownResponseToJson(List<TimeBreakdownResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TimeBreakdownResponse {
  TimeBreakdownResponse(
      {this.dashboardComponentId,
      this.dashboardComponent,
      this.totalMinutesSaved,
      this.dashboardImage,
      this.pieColor,
      this.pieImage});

  int dashboardComponentId;
  String dashboardComponent;
  double totalMinutesSaved;
  String dashboardImage;
  String pieColor;
  String pieImage;

  factory TimeBreakdownResponse.fromJson(Map<String, dynamic> json) =>
      TimeBreakdownResponse(
          dashboardComponentId: json["dashboard_component_id"],
          dashboardComponent: json["dashboard_component"],
          totalMinutesSaved: json["total_minutes_saved"] == null
              ? null
              : json["total_minutes_saved"].toDouble(),
          dashboardImage: json["dashboard_image"],
          pieColor: json["dashboard_pie_char_color"] == null
              ? null
              : json["dashboard_pie_char_color"],
          pieImage: json["pie_background_image"] == null
              ? null
              : json["pie_background_image"]);

  Map<String, dynamic> toJson() => {
        "dashboard_component_id": dashboardComponentId,
        "dashboard_component": dashboardComponent,
        "total_minutes_saved":
            totalMinutesSaved == null ? null : totalMinutesSaved,
      };
  static List<TimeBreakdownResponse> mapArray(List<dynamic> data) {
    return data
        .map<TimeBreakdownResponse>(
            (json) => TimeBreakdownResponse.fromJson(json))
        .toList();
  }
}
