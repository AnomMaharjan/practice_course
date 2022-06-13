import 'dart:convert';

UserStats userStatsFromJson(String str) => UserStats.fromJson(json.decode(str));

String userStatsToJson(UserStats data) => json.encode(data.toJson());

class UserStats {
  UserStats(
      {this.user,
      this.remainingCredits,
      this.totalHoursSaved,
      this.subscriptionStatus,
      this.autoRetry,
      this.isSocial});

  int user;
  int remainingCredits;
  double totalHoursSaved;
  bool subscriptionStatus, autoRetry, isSocial;

  factory UserStats.fromJson(Map<String, dynamic> json) => UserStats(
      user: json["user"],
      remainingCredits: json["remaining_credits"],
      totalHoursSaved: json["total_hours_saved"],
      subscriptionStatus: json["subscription_status"],
      autoRetry: json["auto_retry"],
      isSocial: json["is_social"]);

  Map<String, dynamic> toJson() => {
        "user": user,
        "remaining_credits": remainingCredits,
        "total_hours_saved": totalHoursSaved,
      };
}
