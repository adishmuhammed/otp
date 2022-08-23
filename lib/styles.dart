import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextStyle normal(fontSize) {
  return TextStyle(
      fontFamily: "Cera-Pro",
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
      color: Colors.black);
}

TextStyle bold(fontSize) {
  return TextStyle(
    fontFamily: "Cera-Pro",
    fontWeight: FontWeight.w700,
    fontSize: fontSize,
  );
}
