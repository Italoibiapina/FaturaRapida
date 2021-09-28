import 'package:flutter/material.dart';
import 'package:pedido_facil/models/cliente.dart';
import 'package:pedido_facil/provider/cliente_provider.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/util/util_list_tile.dart';
import 'package:pedido_facil/view/cliente/cliente_form.dart';
import 'package:pedido_facil/widget/projWidget/helper_classes.dart';
import 'package:pedido_facil/widget/projWidget/pj_page_Scaffold.dart';
import 'package:provider/provider.dart';

class ClienteList extends StatelessWidget {
  final bool isSearch;
  const ClienteList({Key? key, this.isSearch = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClienteProvider clis = Provider.of(context);

    /* var args = ModalRoute.of(context)!.settings.arguments;
    final isSearch = args != null; // se tiver passado algum */

    final PjTopBarListActionHelper topBarActionHelper = getTopListAction(context);
    final PjTituloListHelper tituloLista = PjTituloListHelper(textActEsq: 'Nome', textActDir: 'Valor Vendido');
    final PjListaDadosHelper listaDadosHelper = getListaDadosHelper(clis, isSearch);

    return PjPageListaScaffoldList(
      titulo: 'Clientes',
      children: [
        Column(children: [topBarActionHelper.getWidget()]),
        Column(children: [tituloLista.getWidget(), listaDadosHelper.getWidget()]),
      ],
    );

    /* return Scaffold(
      backgroundColor: Util.backColorPadrao,
      appBar: AppBar(
        title: Text('Clientes'),
        //elevation: 0,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                //Navigator.of(context).pushNamed(AppRoutes.CLIENTE_FORM);
                _callNovoRegistro(context);
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
              child: ClienteTile(cliente: clis.byIndex(index), isSearch: isSearch),
            );
          },
        ),
      ),
    ); */
  }

  PjTopBarListActionHelper getTopListAction(context) {
    return PjTopBarListActionHelper(
      textActEsq: 'Novo Cliente',
      actFncEsq: () {
        _callNovoRegistro(context);
      },
      textActDir: 'Importar do Telefone2',
      actFncDir: () {},
      withMargin: true,
    );
  }

  PjListaDadosHelper getListaDadosHelper(ClienteProvider clis, bool isSerach) {
    return PjListaDadosHelper(
      countRecords: clis.count,
      listViewDados: _getListViewCliente(clis, isSerach),
      msgSemDados: 'Não há clientes cadastrados',
    );
  }

  ListView _getListViewCliente(ClienteProvider clis, bool isSearch) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: clis.count,
      itemBuilder: (BuildContext context, int index) {
        Cliente cliente = clis.byIndex(index);
        return Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(0),
          decoration: UtilListTile.boxDecorationPadrao,
          child: ListTile(
            contentPadding: UtilListTile.contentPaddingPadrao,
            visualDensity: UtilListTile.visualDensityPadrao,
            onTap: () {
              if (isSearch) {
                Navigator.of(context).pop(cliente);
              } else {
                _callEditRegistro(context, cliente);
                //Navigator.of(context).pushNamed(AppRoutes.CLIENTE_FORM, arguments: cliente);
              }
            },
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              child: Text(cliente.getNmIniciais(), style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0)),
            ),
            title: Text(cliente.nm, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(cliente.nrPed.toString() + ' Pedidos'),
            trailing:
                Text(Util.toCurency(cliente.vlTotPed), style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16.0)),
          ),
        );
      },
    );
  }

  _callNovoRegistro(context) async {
    Cliente cliente = Cliente('', email: '', id: "-1");

    /// onPressed TEM QUE SER com "context, new MaterialPageRoute(builder: ..."
    /// ASSIM POR CONTA DA FORM_VENDA/LISTA_PAGTO esta sendo chamado de uma lista que esta dentro de uma TAB
    await Navigator.push(context, new MaterialPageRoute(builder: (context) => ClienteForm(cliente)))
        /* .then((object) {
      if (object == null) return;
      RetornoForm retornoForm = object as RetornoForm;
      if (!retornoForm.isDelete) venda.addEntrega(retornoForm.objData as VendaEntrega);
    }) */
        ;
    //rebuildThisForm();
  }

  _callEditRegistro(context, Cliente cliente) async {
    /// onPressed TEM QUE SER com "context, new MaterialPageRoute(builder: ..."
    /// ASSIM POR CONTA DA FORM_VENDA/LISTA_PAGTO esta sendo chamado de uma lista que esta dentro de uma TAB
    await Navigator.push(context, new MaterialPageRoute(builder: (context) => ClienteForm(cliente)));
  }
}
