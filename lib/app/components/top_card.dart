import 'package:flutter/material.dart';

class TopCard extends StatelessWidget {
  final Color topColor, bottomColor;

  final double height;
  const TopCard({Key key, this.topColor, this.bottomColor,this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height:height,
      width: size.width,
      decoration: BoxDecoration(
        color: Color(0xff13253A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
    );
  }
}
