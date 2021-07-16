import 'package:flutter/material.dart';
import 'package:pedido_facil/provider/produto_provider.dart';
import 'package:pedido_facil/routes/app_routes.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/view/inicio/inicio.dart';
import 'package:pedido_facil/view/produto/produto_form.dart';
import 'package:pedido_facil/view/produto/produto_list.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static List<Widget> _widgetOptions = <Widget>[
    Inicio(),
    ProdutoList(),
    ProdutoForm(),
    Text('Index 0: Home', style: optionStyle),
    Text('Index 1: Business', style: optionStyle),
    Text('Index 2: School', style: optionStyle),
  ];

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProdutoProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          AppRoutes.INICIO: (context) => Inicio(),
          AppRoutes.PRODUTO_LIST: (context) => ProdutoList(),
          AppRoutes.PRODUTO_FORM: (context) => ProdutoForm()
        },
        home: Scaffold(
          backgroundColor: Util.backColorPadrao,
          body: Center(
            child: MyApp._widgetOptions.elementAt(_selectedIndex),
          ),
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
      ),
    );
  }
}
