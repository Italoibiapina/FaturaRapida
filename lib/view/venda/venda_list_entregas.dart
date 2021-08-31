import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pedido_facil/models/IData.dart';
import 'package:pedido_facil/models/util/retorno_form.dart';
import 'package:pedido_facil/models/venda.dart';
import 'package:pedido_facil/models/venda_entrega.dart';
import 'package:pedido_facil/models/venda_item.dart';
import 'package:pedido_facil/routes/app_routes.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/util/util_list_tile.dart';

class VendaListEntregas extends StatefulWidget {
  const VendaListEntregas({Key? key}) : super(key: key);

  @override
  _VendaListEntregasState createState() => _VendaListEntregasState();
}

class _VendaListEntregasState extends State<VendaListEntregas> {
  late Venda venda;

  /// Usar este metodos para quando refazer o parte grafica "Build method" não precisar
  /// reexecutar o codigo contido neste metodo.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      venda = ModalRoute.of(context)!.settings.arguments as Venda;
    }
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

    int qtdItensVenda = venda.qtdItens;
    int qtdItensEntregue = venda.qtdItensEntregues;

    return Scaffold(
      backgroundColor: Util.backColorPadrao,
      appBar: AppBar(
        title: Text('Entregas da Venda'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Util.marginScreenPadrao),
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(const Radius.circular(Util.borderRadiousPadrao)),
            ),
            child: Column(children: [
              _UtilLstaEntregas.getBarraAddItem(context, venda, rebuildThisForm),
              _UtilLstaEntregas.getListaEntregas(/* expItensEntrega */ venda, rebuildThisForm),
              //_UtilLstaEntregas.getListaEntregas_expandivel(expItensEntrega /* venda */, rebuildThisForm),
              _UtilLstaEntregas.getBarrasSumarizadora(
                  "Itens Entregues", qtdItensEntregue.toString(), Colors.grey.shade400, Colors.white),
            ]),
          ),
          Container(
            margin: EdgeInsets.only(top: Util.marginScreenPadrao),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(const Radius.circular(Util.borderRadiousPadrao)),
            ),
            child: Column(children: [
              _UtilLstaEntregas.getBarrasAntesSumarizadora(
                  "Itens do Pedido", qtdItensVenda.toString(), Colors.white, Colors.black),
              _UtilLstaEntregas.getBarrasSumarizadora("Itens Pendentes de Entrega",
                  (qtdItensVenda - qtdItensEntregue).toString(), Colors.grey.shade400, Colors.white),
            ]),
          ),
        ],
      ),
    );
  }
}

class _UtilLstaEntregas {
  static callNovoRegistro(context, Venda venda, rebuildForm) async {
    await Navigator.of(context)
        .pushNamed(AppRoutes.VENDA_FORM_ENTREGA, arguments: List<IData>.from([venda]))
        .then((object) {
      if (object == null) return;
      RetornoForm retornoForm = object as RetornoForm;
      if (!retornoForm.isDelete) venda.entregas.add(retornoForm.objData as VendaEntrega);
    });
    rebuildForm();
  }

  static callEditRegistro(context, Venda venda, VendaEntrega entrega, rebuildForm) async {
    await Navigator.of(context)
        .pushNamed(AppRoutes.VENDA_FORM_ENTREGA, arguments: List<IData>.from([venda, entrega]))
        .then((object) {
      if (object == null) return;
      RetornoForm retorno = object as RetornoForm;
      if (retorno.isDelete) venda.removeEntregaVenda(entrega);
    });
    rebuildForm();
  }

  static Container getBarraAddItem(context, Venda venda, rebuildForm) {
    ButtonStyle _btStyle = TextButton.styleFrom(
      padding: const EdgeInsets.only(
          left: Util.contentPaddingPadrao, right: Util.contentPaddingPadrao, top: 0.0, bottom: 0.0),
    );
    return Container(
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              height: _containerHeightButton,
              child: TextButton(
                style: _btStyle,
                onPressed: () => callNovoRegistro(context, venda, rebuildForm),
                child: Text('Adicionar Entrega', style: TextStyle(color: Colors.green)),
              )),
        ],
      ),
    );
  }

  static Container getListaEntregas(/* expItensEntrega */ Venda venda, rebuildForm) {
    return Container(
      color: Colors.white,
      child: venda.entregas.length == 0
          ? Container(
              height: 40,
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey.shade200),
              )),
              child: const Center(child: Text('Vendas sem entregas')),
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: venda.entregas.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(0),
                    decoration: UtilListTile.boxDecorationPadrao,
                    child: buildEntregaExpandTile(context, venda, venda.entregas[index], rebuildForm)
                    //),
                    );
              },
            ),
    );
  }

  static Widget buildEntregaExpandTile(BuildContext context, Venda venda, VendaEntrega entrega, rebuildForm) {
    //VendaEntrega entrega = item.dataObj as VendaEntrega;
    return ExpansionTile(
      //tilePadding: EdgeInsets.zero,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.check, color: Colors.green),
          Container(padding: EdgeInsets.only(left: 10), child: Text(Util.toDateFormat(entrega.dtEntrega))),
          TextButton(
              onPressed: () => callEditRegistro(context, venda, entrega, rebuildForm),
              /* () async {
                await Navigator.of(context).pushNamed(AppRoutes.VENDA_FORM_ENTREGA, arguments: entrega).then((object) {
                  if (object == null) venda.removeEntregaVenda(entrega);
                });
                rebuildForm();
              }, */
              child: Text('Editar')),
          Spacer(),
          Text(entrega.totItensEntregues.toInt().toString()),
        ],
      ),
      children: [buildItensEntregaList(context, entrega.itenEntregues)],
    );
  }

  static Widget buildItensEntregaList(BuildContext context, List<VendaItem> itenEntregues) {
    final borderInset = BorderSide(width: 5.0, color: Colors.green.shade300);
    return Container(
      decoration: BoxDecoration(border: Border(left: borderInset)),
      child: ListView.builder(
        /* scrollDirection: Axis.vertical, */
        physics: NeverScrollableScrollPhysics(), // sem scroll na lista view
        shrinkWrap: true,
        itemCount: itenEntregues.length > 0 ? itenEntregues.length + 1 : itenEntregues.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) return _tituloListaItensEntrega();

          index -= 1;

          return Container(
              decoration: index == (itenEntregues.length - 1) ? null : UtilListTile.boxDecorationPadrao,
              child: ListTile(
                visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                title: Text(itenEntregues[index].prod.nm, style: TextStyle(height: 1, fontSize: 14)),
                trailing: Text(itenEntregues[index].qtdEntregue.toString()),
              )
              //),
              );
        },
      ),
    );
  }

  static Container _tituloListaItensEntrega() {
    final textStyle = TextStyle(height: 1, fontSize: 12, color: Colors.grey.shade600);
    final borderStyle = BorderSide(width: 1.0, color: Colors.grey.shade300);
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(Util.borderRadiousPadrao),
            topRight: const Radius.circular(Util.borderRadiousPadrao)),
      ),
      height: 28,
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: borderStyle, top: borderStyle, right: borderStyle)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(padding: EdgeInsets.only(left: 15.0), child: Text("Nome do Item", style: textStyle)),
            Container(padding: EdgeInsets.only(right: 10.0), child: Text("Qtd Entregue", style: textStyle)),
          ],
        ),
      ),
    );
  }

  static Container getBarrasAntesSumarizadora(
    String labelEsq,
    String labelDir,
    Color backColor,
    Color color,
  ) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: new BorderRadius.only(
            topLeft: Radius.circular(Util.borderRadiousPadrao), topRight: Radius.circular(Util.borderRadiousPadrao)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.all(7),
              height: _containerHeightButton,
              child: Text(labelEsq, style: TextStyle(color: color /* , fontWeight: FontWeight.w500 */))),
          Container(
              padding: EdgeInsets.all(7),
              height: _containerHeightButton,
              child: Text(labelDir, style: TextStyle(color: color /* , fontWeight: FontWeight.w500 */))),
        ],
      ),
    );
  }

  static Container getBarrasSumarizadora(
    String labelEsq,
    String labelDir,
    Color backColor,
    Color color,
  ) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: new BorderRadius.only(
            bottomLeft: Radius.circular(Util.borderRadiousPadrao),
            bottomRight: Radius.circular(Util.borderRadiousPadrao)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.all(7),
              height: _containerHeightButton,
              child: Text(labelEsq, style: TextStyle(color: color, fontWeight: FontWeight.w500))),
          Container(
              padding: EdgeInsets.all(7),
              height: _containerHeightButton,
              child: Text(labelDir, style: TextStyle(color: color, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  static final _containerHeightButton = 35.0;
}
