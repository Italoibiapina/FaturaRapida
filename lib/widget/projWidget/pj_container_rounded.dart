import 'package:flutter/material.dart';

class PjContainerRouded extends StatelessWidget {
  final Widget child;
  final double marginTop;
  const PjContainerRouded({Key? key, required this.child, required this.marginTop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: marginTop.toDouble()),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(const Radius.circular(5.0 /*Util.borderRadiousPadrao*/)),
      ),
      child: child,
    );
  }
}
