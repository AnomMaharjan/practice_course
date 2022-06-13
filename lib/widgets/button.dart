import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Color buttonColor;
  final VoidCallback onClick;
  final Widget child;
  final double height, minWidth, borderRadius;
  final ShapeBorder buttonShape;
  final EdgeInsets padding;
  const Button(
      {Key key, 
      this.padding,
      this.borderRadius,
      this.height,
      this.minWidth,
      this.buttonColor,
      this.buttonShape,
      @required this.onClick,
      @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialButton(
        padding: padding,
        shape: buttonShape,
        height: height,
        minWidth: minWidth,
        onPressed: onClick,
        child: Center(child: child),
        color: buttonColor,
      ),
    );
  }
}
