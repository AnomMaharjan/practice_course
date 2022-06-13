import 'dart:convert';

SubscriptionStatus subrscriptionStatusFromJson(String str) => SubscriptionStatus.fromJson(json.decode(str));

String subrscriptionStatusToJson(SubscriptionStatus data) => json.encode(data.toJson());

class SubscriptionStatus {
    SubscriptionStatus({
        this.subscriptionStatus,
    });

    bool subscriptionStatus;

    factory SubscriptionStatus.fromJson(Map<String, dynamic> json) => SubscriptionStatus(
        subscriptionStatus: json["subscription_status"],
    );

    Map<String, dynamic> toJson() => {
        "subscription_status": subscriptionStatus,
    };
}
