import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pedido_facil/models/util/retorno_form.dart';
import 'package:pedido_facil/models/venda.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/util/util_list_tile.dart';
import 'package:pedido_facil/view/venda/venda_form_entrega.dart';
import 'package:pedido_facil/widget/projWidget/helper_classes.dart';
import 'package:pedido_facil/widget/projWidget/pj_page_Scaffold.dart';

class VendaListEntregas extends StatefulWidget {
  final Venda venda;
  const VendaListEntregas(this.venda, {Key? key}) : super(key: key);

  @override
  _VendaListEntregasState createState() => _VendaListEntregasState(venda);
}

class _VendaListEntregasState extends State<VendaListEntregas> {
  final Venda venda;
  int qtdItensVenda = 0;
  int qtdItensEntregue = 0;
  _VendaListEntregasState(this.venda);

  /// Usar este metodos para quando refazer o parte grafica "Build method" não precisar
  /// reexecutar o codigo contido neste metodo.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    /* if (ModalRoute.of(context)!.settings.arguments != null) {
      venda = ModalRoute.of(context)!.settings.arguments as Venda;
    } */
  }

  rebuildThisForm() {
    setState(() {
      //print("Dt Pedido: " + Util.toDateFormat(venda!.dtPed));
    });
  }

  @override
  Widget build(BuildContext context) {
    //final ClienteProvider clis = Provider.of(context);

    //var args = ModalRoute.of(context)!.settings.arguments;
    //final isSearch = args != null; // se tiver passado algum

    qtdItensVenda = venda.qtdItens;
    qtdItensEntregue = venda.qtdItensEntregues;

    final PjTopBarListActionHelper topBarActionHelper = getTopListAction(context);
    final PjListaDadosHelper listaDadosHelper = getListaDadosHelper(context);
    final PjBarraSumarizadoraHelper barraSumLstHelper = getBarraSumListaHelper();

    final PjBarraSumarizadoraHelper barraSumTotPedHelper = getBarraSumTotPedHelper();
    final PjBarraSumarizadoraHelper barraSumItemPendHelper = getBarraSumItemPendHelper(venda.qtdItens);

    return PjPageListaScaffoldList(
      titulo: 'Entregas da Venda',
      children: [
        Column(children: [topBarActionHelper.getWidget(), listaDadosHelper.getWidget(), barraSumLstHelper.getWidget()]),
        Column(children: [barraSumTotPedHelper.getWidget(), barraSumItemPendHelper.getWidget()]),
      ],
    );
  }

  PjTopBarListActionHelper getTopListAction(context) {
    return PjTopBarListActionHelper(
        textActEsq: 'Adicionar Entrega',
        actFncEsq: () {
          _callNovoRegistro(context);
        });
  }

  PjListaDadosHelper getListaDadosHelper(context) {
    return PjListaDadosHelper(
        countRecords: venda.entregasCount,
        listViewDados: _getListViewEntrega(venda),
        msgSemDados: 'Vendas sem entregas');
  }

  PjBarraSumarizadoraHelper getBarraSumListaHelper() {
    return PjBarraSumarizadoraHelper(labelEsq: "Itens Entregues", labelDir: qtdItensEntregue.toString());
  }

  PjBarraSumarizadoraHelper getBarraSumTotPedHelper() {
    return PjBarraSumarizadoraHelper(
        labelEsq: "Itens do Pedido",
        labelDir: qtdItensVenda.toString(),
        backColor: Colors.white,
        foreColor: Colors.black,
        fontWeight: FontWeight.normal);
  }

  PjBarraSumarizadoraHelper getBarraSumItemPendHelper(int qtdItensVenda) {
    return PjBarraSumarizadoraHelper(
        labelEsq: "Itens Pendentes de Entrega", labelDir: (qtdItensVenda - qtdItensEntregue).toString());
  }

  _callNovoRegistro(context) async {
    VendaEntrega vendaEntrega = VendaEntrega(
        id: DateTime.now().toString(),
        dtEntrega: DateTime.now(),
        entreguePara: '',
        obs: '',
        itenEntregues: List<VendaItemEntrega>.empty(growable: true));
    vendaEntrega.addVendaPai(venda);

    /// onPressed TEM QUE SER com "context, new MaterialPageRoute(builder: ..."
    /// ASSIM POR CONTA DA FORM_VENDA/LISTA_PAGTO esta sendo chamado de uma lista que esta dentro de uma TAB
    await Navigator.push(context, new MaterialPageRoute(builder: (context) => VendaFormEntrega(vendaEntrega)))
        .then((object) {
      if (object == null) return;
      RetornoForm retornoForm = object as RetornoForm;
      if (!retornoForm.isDelete) venda.addEntrega(retornoForm.objData as VendaEntrega);
    });
    rebuildThisForm();
  }

  _callEditRegistro(context, VendaEntrega entrega /* , Venda venda, VendaEntrega entrega, rebuildForm */) async {
    //await Navigator.of(context).pushNamed(AppRoutes.VENDA_FORM_PAGTO, arguments: pagto)
    /// onPressed TEM QUE SER com "context, new MaterialPageRoute(builder: ..."
    /// ASSIM POR CONTA DA FORM_VENDA/LISTA_PAGTO esta sendo chamado de uma lista que esta dentro de uma TAB
    await Navigator.push(context, new MaterialPageRoute(builder: (context) => VendaFormEntrega(entrega)))
        .then((object) {
      if (object == null) return;
      RetornoForm retorno = object as RetornoForm;
      if (retorno.isDelete) venda.removeEntrega(entrega);
    });
    rebuildThisForm();
  }

  ListView _getListViewEntrega(Venda venda) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: venda.entregasCount,
      itemBuilder: (BuildContext context, int index) {
        VendaEntrega entrega = venda.entregaByIndex(index);
        return Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
            decoration: UtilListTile.boxDecorationPadrao,
            child: ListTile(
              contentPadding: UtilListTile.contentPaddingPadrao,
              visualDensity: UtilListTile.visualDensityPadrao,
              onTap: () => _callEditRegistro(context, entrega),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Para: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(entrega.entreguePara),
                  Spacer(),
                  Text("Iten(s): ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text(entrega.totItensEntregues.toInt().toString()),
                ],
              ),
              subtitle: Row(
                children: [
                  Text("Data: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(Util.toDateFormat(entrega.dtEntrega)),
                ],
              ),
              //trailing: Text('Iten(s): ' + entrega.totItensEntregues.toInt().toString()),
            )
            //child: buildEntregaExpandTile(context, venda, venda.entregaByIndex(index), rebuildForm)
            //),
            );
      },
    );
  }
}
