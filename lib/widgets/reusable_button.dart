import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReusableButton extends StatelessWidget {
  final Color bgColor, txtColor;
  final Widget txt;
  final VoidCallback onPressed;
  final bool loading;
  const ReusableButton({
    Key key,
    this.txt,
    this.onPressed,
    this.bgColor,
    this.txtColor,
    this.loading: false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45.0),
      child: AbsorbPointer(
        absorbing: false,
        child: MaterialButton(
          height: 44,
          padding: EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          disabledColor: Colors.black26,
          minWidth: Get.width,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
          color: bgColor,
          onPressed: loading == false ? onPressed : null,
          child: txt,
        ),
      ),
    );
  }
}