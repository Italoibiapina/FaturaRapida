import 'package:flutter/material.dart';

import 'pj_container_rounded.dart';

class PjPageListaScaffoldList extends StatelessWidget {
  final String titulo;
  final List<Widget> children;
  final List<Widget> childrenWithContainer = List<Widget>.empty(growable: true);
  PjPageListaScaffoldList({Key? key, required this.titulo, required this.children}) : super(key: key);

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
