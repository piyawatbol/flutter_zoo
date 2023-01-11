import 'package:flutter/material.dart';
import 'package:zoo_app/widget/color.dart';

inputStyle(context, icon, hintText) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return InputDecoration(
    filled: true,
    fillColor: Color(0xffF1F1EF),
    prefixIcon: Icon(
      icon,
      color: pink,
    ),
    hintText: hintText,
    contentPadding: EdgeInsets.symmetric(
        horizontal: width * 0.05, vertical: height * 0.0131),
    disabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xffD9D9D9)),
      borderRadius: BorderRadius.circular(30),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: pink),
      borderRadius: BorderRadius.circular(30),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(30),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(30),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: pink),
      borderRadius: BorderRadius.circular(30),
    ),
  );
}

inputStyle2(context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(
        horizontal: width * 0.05, vertical: height * 0.0131),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
  );
}
