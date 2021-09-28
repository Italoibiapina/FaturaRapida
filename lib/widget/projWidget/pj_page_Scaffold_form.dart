import 'package:flutter/material.dart';
import 'package:pedido_facil/util/util.dart';

class PjPageListaScaffoldForm extends StatelessWidget {
  final String titulo;
  final Function backButtonFunc;
  final Form form;
  final Function? deleteFnc;

  //final List<Widget> childrenWithContainer = List<Widget>.empty(growable: true);
  PjPageListaScaffoldForm({
    Key? key,
    required this.titulo,
    required this.backButtonFunc,
    required this.form,
    this.deleteFnc,
  }) : super(key: key);

  /* putChildContainer() {
    double marginTop = 0;
    children.forEach((element) {
      childrenWithContainer.add(PjContainerRouded(child: element, marginTop: marginTop));
      marginTop = 5.0;
    });
  } */

  getAppBar() {
    var _botoes = <Widget>[]; /* <Widget>[IconButton(icon: Icon(Icons.save), onPressed: () => saveFnc())]; */
    if (deleteFnc != null) _botoes.add(IconButton(icon: Icon(Icons.delete), onPressed: () => deleteFnc!()));

    return AppBar(
      title: Text(titulo),
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: _backFunc,
      ),
      actions: _botoes,
    );
  }

  _backFunc() {
    backButtonFunc();
  }

  @override
  Widget build(BuildContext context) {
    //putChildContainer();
    AppBar appBarDfl = getAppBar();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(228, 239, 249, 1),
        appBar: appBarDfl,
        body: Container(
            margin: new EdgeInsets.all(5.0),
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: new BoxDecoration(
                  color: Colors.white, borderRadius: new BorderRadius.circular(Util.borderRadiousPadrao)),
              child: form,
            )));
  }
}
