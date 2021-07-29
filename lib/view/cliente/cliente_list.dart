import 'package:flutter/material.dart';
import 'package:pedido_facil/models/cliente.dart';
import 'package:pedido_facil/provider/cliente_provider.dart';
import 'package:pedido_facil/routes/app_routes.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/util/util_list_tile.dart';
import 'package:provider/provider.dart';

class ClienteList extends StatelessWidget {
  const ClienteList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClienteProvider clis = Provider.of(context);

    return Scaffold(
      backgroundColor: Util.backColorPadrao,
      appBar: AppBar(
        title: Text('Clientes'),
        //elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CLIENTE_FORM);
              }),
        ],
      ),
      body: Container(
        margin: new EdgeInsets.all(Util.marginScreenPadrao),
        child: ListView.builder(
          itemCount: clis.count > 0 ? clis.count + 2 : clis.count,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) return _UtilLstaCliente._acoesLista(context);
            if (index == 1) return _UtilLstaCliente._tituloLista;

            index -= 2;
            return Container(
              child: ClienteTile(cliente: clis.byIndex(index)),
            );
          },
        ),
      ),
    );
  }
}

class ClienteTile extends StatelessWidget {
  final Cliente cliente;
  const ClienteTile({Key? key, required this.cliente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UtilListTile.boxDecorationPadrao,
      child: ListTile(
        contentPadding: UtilListTile.contentPaddingPadrao,
        visualDensity: UtilListTile.visualDensityPadrao,
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.CLIENTE_FORM, arguments: cliente),
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          child: Text(cliente.getNmIniciais(),
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0)),
        ),
        title: Text(cliente.nm, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(cliente.nrPed.toString() + ' Pedidos'),
        trailing: Text(Util.toCurency(cliente.vlTotPed),
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0)),
      ),
    );
  }
}

class _UtilLstaCliente {
  static final _containerHeightButton = 35.0;
  static Container _acoesLista(context) => Container(
        margin: new EdgeInsets.only(bottom: Util.marginScreenPadrao),
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: new BorderRadius.circular(Util.borderRadiousPadrao)),
        //height: 35,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  height: _containerHeightButton,
                  padding: EdgeInsets.only(left: 10.0),
                  child: TextButton(
                      onPressed: () => {Navigator.of(context).pushNamed(AppRoutes.CLIENTE_FORM)},
                      child: Text("Cadastrar Novo", style: TextStyle(color: Colors.green)))),
              Container(
                  height: _containerHeightButton,
                  padding: EdgeInsets.only(right: 5.0),
                  child: TextButton(
                      onPressed: () => {},
                      child: Text("Importar do Telefone", style: TextStyle(color: Colors.green)))),
            ],
          ),
        ),
      );

  static final Container _tituloLista = Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(Util.borderRadiousPadrao),
          topRight: const Radius.circular(Util.borderRadiousPadrao)),
    ),
    height: 28,
    child: Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey.shade300))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.only(left: 60.0),
              child: Text("Nome", style: TextStyle(color: Colors.grey.shade600))),
          Container(
              padding: EdgeInsets.only(right: 10.0),
              child: Text("Valor Vendido", style: TextStyle(color: Colors.grey.shade600))),
        ],
      ),
    ),
  );
}
