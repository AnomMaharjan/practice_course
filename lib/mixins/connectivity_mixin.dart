import 'dart:async';
import 'dart:developer';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

mixin Connection {
  bool isConnected;
  Connectivity _connectivity = Connectivity();
  ConnectivityResult result;
  ConnectivityResult currentResult;
  StreamSubscription<ConnectivityResult> _streamSubscription;
  bool wifiChanged = false;
  String wifiStatus = 'afa';

  Future<void> initConnectivity(contexts) async {
    BuildContext context = contexts;
    try {
      result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar
        (
          content: Container(
              height: 20,
              child: Center(
                  child: Text(
                "No internet connection found.",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff222222),
                    fontWeight: FontWeight.bold),
              ))),
          backgroundColor: Color(0xfff8d0c9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
          ),
        ));
      }
      // _updateConnectionStatus(result, context);
    } on Exception catch (e) {
      log(e.toString());
    }
    return _onChanged(result, context);
  }

  _onChanged(ConnectivityResult result, context) async {
    _streamSubscription = await _connectivity.onConnectivityChanged.listen(
      (result) {
        _updateConnectionStatus(result, context);
      },
    );
    return _streamSubscription;
  }

  _updateConnectionStatus(ConnectivityResult result, context) async {
    print('*****************************************');
    if (currentResult == result) return;
    print(result);
    if (result == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(
            height: 20,
            child: Center(
                child: Text(
              "No internet connection found.",
              style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff222222),
                  fontWeight: FontWeight.bold),
            ))),
        backgroundColor: Color(0xfff8d0c9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
        ),
      ));
      wifiStatus = 'No internet enabled';
      isConnected = false;
    } else if (result == ConnectivityResult.mobile && wifiChanged) {
      wifiStatus = 'data Internet';
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Container(
              height: 20,
              child: Center(
                  child: Text("Back Online",
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff222222),
                          fontWeight: FontWeight.bold)))),
          backgroundColor: Color(0xffdfecd5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
          ),
        ));
      isConnected = true;
    } else if (result == ConnectivityResult.wifi && wifiChanged) {
      wifiStatus = 'data Internet';
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(
            height: 20,
            child: Center(
                child: Text("Back Online",
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff222222),
                        fontWeight: FontWeight.bold)))),
        backgroundColor: Color(0xffdfecd5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
        ),
      ));
      isConnected = true;
    }
    currentResult = result;
    wifiChanged = true;
  }
}
