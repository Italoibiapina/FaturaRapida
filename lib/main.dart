import 'package:flutter/material.dart';
import 'package:pedido_facil/data/dummy_vendas.dart';
import 'package:pedido_facil/models/meio_pagamento.dart';
import 'package:pedido_facil/models/venda.dart';
import 'package:pedido_facil/provider/cliente_provider.dart';
import 'package:pedido_facil/provider/meio_pgto_provider.dart';
import 'package:pedido_facil/provider/produto_provider.dart';
import 'package:pedido_facil/provider/venda_provider.dart';
import 'package:pedido_facil/repository/cliente_repository.dart';
import 'package:pedido_facil/repository/meio_pagto_repository.dart';
import 'package:pedido_facil/repository/produto_repository.dart';
import 'package:pedido_facil/repository/venda_repository.dart';
import 'package:pedido_facil/routes/app_routes.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/view/cliente/cliente_form.dart';
import 'package:pedido_facil/view/cliente/cliente_list.dart';
import 'package:pedido_facil/view/inicio/inicio.dart';
import 'package:pedido_facil/view/produto/produto_form.dart';
import 'package:pedido_facil/view/produto/produto_list.dart';
import 'package:pedido_facil/view/venda/venda_form.dart';
import 'package:pedido_facil/view/venda/venda_form_cabecalho.dart';
import 'package:pedido_facil/view/venda/venda_form_desc_frete.dart';
import 'package:pedido_facil/view/venda/venda_form_item.dart';
import 'package:pedido_facil/view/venda/venda_form_pagamento.dart';
import 'package:pedido_facil/view/venda/venda_list.dart';
import 'package:pedido_facil/view/venda/venda_list_entregas.dart';
import 'package:pedido_facil/view/venda/venda_list_pagamentos.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(PedidoFacil());
}

class PedidoFacil extends StatefulWidget {
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static final Map<String, Object> itens = {...Dummy_vendas};
  static final Venda venda = itens.values.last as Venda;

  static List<Widget> _widgetOptions = <Widget>[
    Inicio(),
    VendaList(),
    VendaForm(venda: venda),
    //ProdutoForm(),
    ClienteList(),
    ProdutoList(),
    Text('Index 2: Compartilhar', style: optionStyle),
  ];

  @override
  _PedidoFacil createState() => _PedidoFacil();
}

class _PedidoFacil extends State<PedidoFacil> {
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
        ChangeNotifierProvider(create: (ctx) => ProdutoProvider(ProdutoRepository())),
        ChangeNotifierProvider(create: (ctx) => ClienteProvider(ClienteRepository())),
        ChangeNotifierProvider(create: (ctx) => VendaProvider(VendaRepository())),
        ChangeNotifierProvider(create: (ctx) => MeioPagamentoProvider(MeioPagamentoRepository()))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          AppRoutes.INICIO: (context) => Inicio(),
          AppRoutes.PRODUTO_LIST: (context) => ProdutoList(),
          AppRoutes.PRODUTO_FORM: (context) => ProdutoForm(),
          AppRoutes.CLIENTE_LIST: (context) => ClienteList(),
          AppRoutes.CLIENTE_FORM: (context) => ClienteForm(),
          AppRoutes.VENDA_LIST: (context) => VendaList(),
          AppRoutes.VENDA_FORM: (context) => VendaForm(venda: Venda()),
          AppRoutes.VENDA_FORM_CABECALHO: (context) => VendaFormCabecalho(venda: Venda()),
          AppRoutes.VENDA_FORM_DESC_FRETE: (context) => VendaFormDescFrete(),
          AppRoutes.VENDA_FORM_ITEM: (context) => VendaFormItem(),
          AppRoutes.VENDA_LIST_PAGTO: (context) => VendaListPagamentos(Venda()),
          AppRoutes.VENDA_FORM_PAGTO: (context) =>
              VendaFormPagamento(VendaPagamento(dtPagto: DateTime.now(), meioPagto: MeioPagamento(nm: 'Outros'))),
          AppRoutes.VENDA_LIST_ENTREGA: (context) => VendaListEntregas(Venda()),
          //AppRoutes.VENDA_FORM_ENTREGA: (context) => VendaFormEntrega(VendaEntrega(dtEntrega: DateTime.)),
        },
        home: Scaffold(
          backgroundColor: Util.backColorPadrao,
          body: Center(
            child: PedidoFacil._widgetOptions.elementAt(_selectedIndex),
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
