import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key key,
    this.autofocus = false,
    @required this.validator,
    this.onTap,
    this.valueChanged,
    this.onEditingCompleted,
    this.readOnly = false,
    this.obsecure = false,
    this.keyboardType,
    this.suffixIcon = null,
    @required this.hintText,
    @required this.controller,
    this.errorStatus = false,
  }) : super(key: key);

  final ValueChanged valueChanged;
  final bool autofocus;
  final FormFieldValidator validator;
  final String hintText;
  final TextEditingController controller;
  final VoidCallback onTap;
  final VoidCallback onEditingCompleted;
  final TextInputType keyboardType;
  final bool obsecure;
  final bool readOnly;
  final Widget suffixIcon;
  final bool errorStatus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      obscureText: obsecure,
      autocorrect: false,
      autofocus: autofocus,
      controller: controller,
      validator: validator,
      onChanged: valueChanged,
      onTap: onTap,
      keyboardType: keyboardType,
      onEditingComplete: onEditingCompleted,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
              width: this.errorStatus ? 1 : 0,
              color: this.errorStatus ? Color(0xffce887b) : Colors.transparent,
              style: BorderStyle.solid),
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(width: 0, style: BorderStyle.none),
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Color(0xff949594)),
        contentPadding: EdgeInsets.only(left: 20, right: 20),
      ),
      style: TextStyle(fontSize: 13, color: Color(0xff222222)),
    );
  }
}
