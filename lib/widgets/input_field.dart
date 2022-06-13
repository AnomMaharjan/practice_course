import 'package:flutter/material.dart';

class InputtField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController textEditingController;
  final double textSize;
  final Color textColor;
  final double fieldWidth, fieldHeight;
  final Color backGroundColor;
  final double borderRadius;
  const InputtField({
    Key key,
    this.borderRadius,
    this.fieldHeight,
    this.fieldWidth,
    this.hintText,
    this.labelText,
    this.textSize,
    this.textEditingController,
    this.backGroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: fieldHeight,
      width: fieldWidth,
      decoration: BoxDecoration(
        color: backGroundColor,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          labelText: labelText,
        ),
        controller: textEditingController,
        style: TextStyle(
          fontSize: textSize,
          color: textColor,
        ),
      ),
    );
  }
}
