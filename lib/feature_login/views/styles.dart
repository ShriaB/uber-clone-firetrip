import 'package:firetrip/common/constants/colors.dart';
import 'package:flutter/material.dart';

/// Style for buttons
var textButtonStyle = ButtonStyle(
  textStyle: MaterialStateProperty.all(
      const TextStyle(color: Colors.white, fontSize: 20.0)),
  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
      const EdgeInsets.symmetric(vertical: 10.0)),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0))),
  backgroundColor: MaterialStateProperty.all(primaryColor),
);

/// Style for input text fields
var textInputDecorationBorder = const OutlineInputBorder(
    borderSide: BorderSide(
  width: 1.0,
));
