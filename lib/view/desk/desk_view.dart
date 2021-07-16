/// Flutter code sample for BottomAppBar

// This example shows the [BottomAppBar], which can be configured to have a notch using the
// [BottomAppBar.shape] property. This also includes an optional [FloatingActionButton], which illustrates
// the [FloatingActionButtonLocation]s in relation to the [BottomAppBar].

import 'package:flutter/material.dart';
import 'package:pedido_facil/routes/app_routes.dart';
//import 'package:pedido_facil/routes/app_routes.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/view/inicio/inicio.dart';
import 'package:pedido_facil/view/produto/produto_form.dart';
import 'package:pedido_facil/view/produto/produto_list.dart';

class DeskView extends StatefulWidget {
  const DeskView({Key? key}) : super(key: key);

  @override
  State createState() => _DeskViewState();
}

class _DeskViewState extends State<DeskView> {
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[
    ProdutoList(),
    ProdutoForm(),
    Text('Index 0: Home', style: optionStyle),
    Text('Index 1: Business', style: optionStyle),
    Text('Index 2: School', style: optionStyle),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        AppRoutes.INICIO: (context) => Inicio(),
        AppRoutes.PRODUTO_LIST: (context) => ProdutoList(),
        AppRoutes.PRODUTO_FORM: (context) => ProdutoForm(),
      },
      home: Scaffold(
        backgroundColor: Util.backColorPadrao,
        /* appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('RepresentAe'),
        ), */
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),

        /* floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          tooltip: 'Create',
          backgroundColor: Colors.green[100],
          foregroundColor: Colors.green,
          onPressed: () {},
        ), */
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        //bottomNavigationBar: _BottomAppBar(),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Vendas'),
            BottomNavigationBarItem(icon: Icon(Icons.request_quote_outlined), label: 'Orçam.'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Clientes.'),
            BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'Produtos'),
            BottomNavigationBarItem(icon: Icon(Icons.share), label: 'Compart'),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          //iconSize: 25,
        ),
      ),
    );
  }
}

class _BottomAppBar extends StatefulWidget {
  @override
  __BottomAppBarState createState() => __BottomAppBarState();
}

class __BottomAppBarState extends State<_BottomAppBar> {
  final NotchedShape? shape = CircularNotchedRectangle();

  final selColorButton = Colors.blueAccent;
  final unselColorButton = Colors.grey;
  var _selButton = 'Inicio';

  SizedBox getButonLabelIcon(String label, IconData icon) {
    return SizedBox(
      width: 60,
      child: TextButton(
        onPressed: () {
          _onButtonChange(label);
        },
        style: TextButton.styleFrom(
          primary: _selButton == label ? selColorButton : unselColorButton,
          textStyle: TextStyle(fontSize: 10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[Icon(icon), Text(label)],
        ),
      ),
    );
  }

  void _onButtonChange(String button) {
    setState(() {
      _selButton = button;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: shape,
      color: Colors.white,
      child: IconTheme(
        data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        child: Row(
          children: <Widget>[
            getButonLabelIcon('Inicio', Icons.home),
            getButonLabelIcon('Vendas', Icons.shopping_cart),
            getButonLabelIcon('Orçam.', Icons.request_quote_outlined),
            getButonLabelIcon('Clientes', Icons.people),
            getButonLabelIcon('Produtos', Icons.qr_code),
            //getButonLabelIcon('Produtos', Icons.qr_code),
          ],
        ),
      ),
    );
  }
}
