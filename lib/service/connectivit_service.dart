import 'dart:io';

import 'package:flutter/material.dart';

class ConnectivityService {
  Future<Null> checkConnectivity(context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
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
      }
    } on SocketException catch (_) {
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
        duration: Duration(minutes: 100),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14),
            topRight: Radius.circular(14),
          ),
        ),
      ));
    }
  }
}
