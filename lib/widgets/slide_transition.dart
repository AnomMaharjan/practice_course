import 'package:flutter/material.dart';

Widget slideIt(animation, height, dividerColor) {
  return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0),
        end: Offset(0, 0),
      ).animate(animation),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: height,
              child: VerticalDivider(
                color: dividerColor,
                width: 5,
                thickness: 4,
              ),
            ),
          ),
        ),
      ));
}
