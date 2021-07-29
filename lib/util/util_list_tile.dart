import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UtilListTile {
  static const EdgeInsets contentPaddingPadrao = EdgeInsets.only(left: 10.0, right: 10.0);
  static const VisualDensity visualDensityPadrao = VisualDensity(horizontal: -2, vertical: -3);
  static BoxDecoration boxDecorationPadrao = BoxDecoration(
    color: Colors.white,
    border: new Border(bottom: BorderSide(width: 1.0, color: Colors.grey.shade300)),
  );
}
