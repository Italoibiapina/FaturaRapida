import 'package:flutter/material.dart';
import 'package:pedido_facil/models/meio_pagamento.dart';
import 'package:pedido_facil/models/util/retorno_form.dart';
import 'package:pedido_facil/models/venda.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/util/util_list_tile.dart';
import 'package:pedido_facil/view/venda/venda_form_pagamento.dart';
import 'package:pedido_facil/widget/projWidget/helper_classes.dart';
import 'package:pedido_facil/widget/projWidget/pj_page_Scaffold.dart';

class VendaListPagamentos extends StatefulWidget {
  final Venda venda;
  const VendaListPagamentos(this.venda, {Key? key}) : super(key: key);

  @override
  _VendaListPagamentosState createState() => _VendaListPagamentosState(venda);
}

class _VendaListPagamentosState extends State<VendaListPagamentos> {
  final Venda venda;
  _VendaListPagamentosState(this.venda);

  /// Usar este metodos para quando refazer o parte grafica "Build method" não precisar
  /// reexecutar o codigo contido neste metodo.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  rebuildThisForm() {
    setState(() {
      //print("Dt Pedido: " + Util.toDateFormat(venda!.dtPed));
    });
  }

  @override
  Widget build(BuildContext context) {
    final PjTopBarListActionHelper topBarActionHelper = getTopListAction(context);
    final PjListaDadosHelper listaDadosHelper = getListaDadosHelper(context);
    final PjBarraSumarizadoraHelper barraSumLstHelper = getBarraSumListaHelper();

    final PjBarraSumarizadoraHelper barraSumTotPedHelper = getBarraSumTotPedHelper();
    final PjBarraSumarizadoraHelper barraSumSldDevHelper = getBarraSumSldDevHelper();

    return PjPageListaScaffold(
      titulo: 'Pagamentos da Venda',
      children: [
        Column(children: [topBarActionHelper.getWidget(), listaDadosHelper.getWidget(), barraSumLstHelper.getWidget()]),
        Column(children: [barraSumTotPedHelper.getWidget(), barraSumSldDevHelper.getWidget()]),
      ],
    );
  }

  PjTopBarListActionHelper getTopListAction(context) {
    return PjTopBarListActionHelper(
        textActEsq: 'Adicionar Pagamento',
        actFncEsq: () {
          _callNovoVendaPagtoForm(context);
        });
  }

  PjListaDadosHelper getListaDadosHelper(context) {
    return PjListaDadosHelper(
        countRecords: venda.pagtoCount,
        listViewDados: getListViewPagtos(venda, (pagto) {
          _callEditRegistro(context, pagto);
        }),
        msgSemDados: 'Pedidos sem Pagamentos');
  }

  PjBarraSumarizadoraHelper getBarraSumListaHelper() {
    return PjBarraSumarizadoraHelper(labelEsq: "Total de Pagamentos", labelDir: Util.toCurency(venda.vlTotPg));
  }

  PjBarraSumarizadoraHelper getBarraSumTotPedHelper() {
    return PjBarraSumarizadoraHelper(
        labelEsq: "Total Pedido",
        labelDir: Util.toCurency(venda.vlTotItens),
        backColor: Colors.white,
        foreColor: Colors.black,
        fontWeight: FontWeight.normal);
  }

  PjBarraSumarizadoraHelper getBarraSumSldDevHelper() {
    return PjBarraSumarizadoraHelper(
        labelEsq: "Saldo Devedor", labelDir: Util.toCurency(venda.vlTotItens - venda.vlTotPg));
  }

  _callNovoVendaPagtoForm(context) async {
    final VendaPagamento pagto = VendaPagamento(
        id: DateTime.now().toString(),
        dtPagto: DateTime.now(),
        meioPagto: MeioPagamento(id: '-1', nm: ''),
        vlPgto: 0.0);

    /// onPressed TEM QUE SER com "context, new MaterialPageRoute(builder: ..."
    /// ASSIM POR CONTA DA FORM_VENDA/LISTA_PAGTO esta sendo chamado de uma lista que esta dentro de uma TAB
    await Navigator.push(context, new MaterialPageRoute(builder: (context) => VendaFormPagamento(pagto)))
        .then((object) {
      if (object == null) return;
      RetornoForm retornoForm = object as RetornoForm;
      if (!retornoForm.isDelete) venda.addPagto(retornoForm.objData as VendaPagamento);
    });
    rebuildThisForm();
  }

  _callEditRegistro(context, pagto) async {
    //await Navigator.of(context).pushNamed(AppRoutes.VENDA_FORM_PAGTO, arguments: pagto)
    /// onPressed TEM QUE SER com "context, new MaterialPageRoute(builder: ..."
    /// ASSIM POR CONTA DA FORM_VENDA/LISTA_PAGTO esta sendo chamado de uma lista que esta dentro de uma TAB
    await Navigator.push(context, new MaterialPageRoute(builder: (context) => VendaFormPagamento(pagto)))
        .then((object) {
      if (object == null) return;
      RetornoForm retorno = object as RetornoForm;
      if (retorno.isDelete) venda.removePagto(pagto);
    });
    rebuildThisForm();
  }
}

ListView getListViewPagtos(Venda venda, Function callEditRegistro) {
  return ListView.builder(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    itemCount: venda.pagtoCount,
    itemBuilder: (BuildContext context, int index) {
      final pagto = venda.pagtoByIndex(index);
      return Container(
          //PagamentoTile(pagto: venda.pagtos.elementAt(index), rebuildThisForm),
          child: Container(
        decoration: UtilListTile.boxDecorationPadrao,
        child: ListTile(
          contentPadding: UtilListTile.contentPaddingPadrao,
          visualDensity: UtilListTile.visualDensityPadrao,
          onTap: () => callEditRegistro(pagto),
          //callEditRegistro(context, venda, pagto, rebuildForm),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(pagto.meioPagto.nm),
              Text(Util.toCurency(pagto.vlPgto)),
            ],
          ),
          subtitle: Text(Util.toDateFormat(pagto.dtPagto)),
          //trailing: Text(Util.toCurency(pagto.vlPgto)),
        ),
      ));
    },
  );
}
