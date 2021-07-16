import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Util {
  static final NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
  static toCurency(double vl) {
    return formatter.format(vl);
  }

  static const Color backColorPadrao = Color.fromRGBO(228, 239, 249, 1);
  static const double marginScreenPadrao = 5.0;
  static const double borderRadiousPadrao = 10.0;
  static const double paddingListTopPadrao = 10.0;
  static const double paddingFormPadrao = 20.0;

  static const Scaffold scaffoldPadrao = Scaffold();
}
