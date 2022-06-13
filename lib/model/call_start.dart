import 'dart:convert';

CallStart callStartFromJson(String str) => CallStart.fromJson(json.decode(str));

String callStartToJson(CallStart data) => json.encode(data.toJson());

class CallStart {
    CallStart({
        this.status,
        this.id,
        this.startTime,
        this.endTime,
        this.minutesSaved,
        this.callStatus,
    });

    String status;
    int id;
    DateTime startTime;
    dynamic endTime;
    dynamic minutesSaved;
    String callStatus;

    factory CallStart.fromJson(Map<String, dynamic> json) => CallStart(
        status: json["status"],
        id: json["id"],
        startTime: DateTime.parse(json["start_time"]),
        endTime: json["end_time"],
        minutesSaved: json["minutes_saved"],
        callStatus: json["call_status"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "id": id,
        "start_time": startTime.toIso8601String(),
        "end_time": endTime,
        "minutes_saved": minutesSaved,
        "call_status": callStatus,
    };
}
