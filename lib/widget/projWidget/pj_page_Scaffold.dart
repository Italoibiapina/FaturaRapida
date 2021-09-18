import 'package:flutter/material.dart';

class PjPageListaScaffold extends StatelessWidget {
  final String titulo;
  final List<Widget> children;
  final List<Widget> childrenWithContainer = List<Widget>.empty(growable: true);
  PjPageListaScaffold({Key? key, required this.titulo, required this.children}) : super(key: key);

  putChildContainer() {
    double marginTop = 0;
    children.forEach((element) {
      childrenWithContainer.add(PjContainerRouded(child: element, marginTop: marginTop));
      marginTop = 5.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    putChildContainer();
    return Scaffold(
      backgroundColor: Color.fromRGBO(228, 239, 249, 1), //Util.backColorPadrao,
      appBar: AppBar(
        title: Text(titulo),
      ),
      body: ListView(
        padding: const EdgeInsets.all(5.0 /* Util.marginScreenPadrao */),
        children: childrenWithContainer,
      ),
    );
  }
}

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
