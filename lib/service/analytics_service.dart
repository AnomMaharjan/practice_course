import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future logEvent(String eventName, String clickevent) async {
    await _analytics
        .logEvent(name: eventName, parameters: {"clickevent": clickevent});
  }

  Future logLogin(loginMethod) async {
    await _analytics.logLogin(loginMethod: loginMethod);
  }
}
