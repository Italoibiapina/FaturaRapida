import 'package:flutter/material.dart';
import 'package:pedido_facil/models/venda.dart';
import 'package:pedido_facil/provider/venda_provider.dart';
import 'package:pedido_facil/routes/app_routes.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/util/util_list_tile.dart';
import 'package:pedido_facil/view/venda/venda_form.dart';
import 'package:provider/provider.dart';

class VendaList extends StatefulWidget {
  const VendaList({Key? key}) : super(key: key);

  @override
  _VendaListState createState() => _VendaListState();
}

class _VendaListState extends State<VendaList> {
  int indexSelected = 0;
  void _onItemTapped(int index) {
    setState(() {
      indexSelected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final VendaProvider vendasProvider = Provider.of(context);
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Util.backColorPadrao,
          appBar: AppBar(
              title: Text("Vendas"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => Navigator.of(context).pushNamed(AppRoutes.VENDA_FORM /* , arguments:  */),
                  //Navigator.push(context, new MaterialPageRoute(builder: (context) => VendaForm(venda: venda))),
                )
              ],
              bottom: TabBar(
                onTap: (value) {
                  _onItemTapped(value);
                },
                labelPadding: EdgeInsets.zero,
                labelStyle: TextStyle(),
                tabs: [
                  Tab(text: "Todas"),
                  Tab(text: "Pendencia"),
                  Tab(text: "Pago"),
                  Tab(text: "Entregue"),
                ],
              )),
          body: TabBarView(
            children: [
              _UtilLstaCliente.buildList(vendasProvider.all, vendasProvider),
              _UtilLstaCliente.buildList(vendasProvider.pend, vendasProvider),
              _UtilLstaCliente.buildList(vendasProvider.pagas, vendasProvider),
              _UtilLstaCliente.buildList(vendasProvider.entregues, vendasProvider), //ConteudoDaLista(lstVendas),
            ],
          ),
        ),
      ),
    );
  }
}

class VendaTile extends StatelessWidget {
  final Venda venda;
  const VendaTile({Key? key, required this.venda}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UtilListTile.boxDecorationPadrao,
      child: ListTile(
        contentPadding: UtilListTile.contentPaddingPadrao,
        visualDensity: UtilListTile.visualDensityPadrao,
        // onPressed TEM QUE SER com "context, new MaterialPageRoute(builder: ..." ASSIM POR CONTA DE ESTARMOS DENTRO DE UMA TAB
        onTap: () => Navigator.push(context, new MaterialPageRoute(builder: (context) => VendaForm(venda: venda))),
        onLongPress: () {
          print("Longo Press!!!");
        },
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(venda.cli.nm, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(Util.toCurency(venda.vlTotItens)),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(venda.nrPed.toString()),
            Text(venda.status, style: TextStyle(color: _UtilLstaCliente.getColorStatus(venda)))
          ],
        ),
        /* trailing: Text(Util.toCurency(venda.vlTotPed),
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0)), */
      ),
    );
  }
}

class _UtilLstaCliente {
  static final _containerHeightButton = 35.0;
  static Container _acoesLista(context, VendaProvider vendasProvider) {
    String nextNrPed = vendasProvider.nextNrPed;
    Venda venda = Venda(id: DateTime.now().toString(), nrPed: nextNrPed);
    return Container(
      margin: new EdgeInsets.only(bottom: Util.marginScreenPadrao),
      padding: EdgeInsets.all(0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.circular(Util.borderRadiousPadrao)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: _containerHeightButton,
              padding: EdgeInsets.only(left: 10.0),
              child: TextButton(
                  // onPressed TEM QUE SER com "context, new MaterialPageRoute(builder: ..." ASSIM POR CONTA DE ESTARMOS DENTRO DE UMA TAB
                  onPressed: () {
                    /* final Map<String, Object> itens = {...Dummy_vendas};
                    final Venda vendaTeste = itens.values.last as Venda; */
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => new VendaForm(venda: venda)));
                  },
                  child: Text("Cadastrar Novo Venda", style: TextStyle(color: Colors.green)))),
        ],
      ),
    );
  }

  static final Container _tituloLista = Container(
    decoration: BoxDecoration(
      color: Colors.white, //blueGrey[50],
      borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(Util.borderRadiousPadrao),
          topRight: const Radius.circular(Util.borderRadiousPadrao)),
    ),
    height: 28,
    child: Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              //decoration: BoxDecoration(border: Border.all()),
              padding: EdgeInsets.only(left: 10.0),
              child: Text("Pedido Cliente", style: TextStyle(color: Colors.grey.shade600))),
          Container(
              padding: EdgeInsets.only(right: 10.0),
              child: Text("Total Pedido", style: TextStyle(color: Colors.grey.shade600))),
        ],
      ),
    ),
  );

  static Container buildList(vendas, VendaProvider vendasProvider) {
    //print('buildList: ' + vendas.leght.toString());
    return Container(
      margin: new EdgeInsets.all(Util.marginScreenPadrao),
      child: ListView.builder(
        itemCount: vendas.length > 0 ? vendas.length + 2 : vendas.length,
        itemBuilder: (BuildContext context, int index) {
          print('Indice Lista Methodo:' + index.toString());
          if (index == 0) return _UtilLstaCliente._acoesLista(context, vendasProvider);
          if (index == 1) return _UtilLstaCliente._tituloLista;

          index -= 2;
          return Container(
            child: VendaTile(venda: vendas[index]),
          );
        },
      ),
    );
  }

  static Color getColorStatus(Venda venda) {
    if (venda.isPago && !venda.isEnt) return Colors.orangeAccent;
    if (!venda.isPago || !venda.isEnt) return Colors.redAccent;

    return Colors.green;
  }
}
