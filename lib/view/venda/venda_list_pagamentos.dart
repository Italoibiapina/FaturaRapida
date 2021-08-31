import 'package:flutter/material.dart';
import 'package:pedido_facil/models/util/retorno_form.dart';
import 'package:pedido_facil/models/venda.dart';
import 'package:pedido_facil/models/venda_pagamento.dart';
import 'package:pedido_facil/routes/app_routes.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/util/util_list_tile.dart';

class VendaListPagamentos extends StatefulWidget {
  const VendaListPagamentos({Key? key}) : super(key: key);

  @override
  _VendaListPagamentosState createState() => _VendaListPagamentosState();
}

class _VendaListPagamentosState extends State<VendaListPagamentos> {
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

    return Scaffold(
      backgroundColor: Util.backColorPadrao,
      appBar: AppBar(
        title: Text('Pagamentos da Venda'),
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
              _UtilLstaPagtos.getBarraAddItem(context, venda, rebuildThisForm),
              _UtilLstaPagtos.getListaPagtos(venda, rebuildThisForm),
              _UtilLstaPagtos.getBarrasSumarizadora(
                  "Total de Pagamentos", Util.toCurency(venda.vlTotPg), Colors.grey.shade400, Colors.white),
            ]),
          ),
          Container(
            margin: EdgeInsets.only(top: Util.marginScreenPadrao),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(const Radius.circular(Util.borderRadiousPadrao)),
            ),
            child: Column(children: [
              _UtilLstaPagtos.getBarrasAntesSumarizadora(
                  "Total do Pedido", Util.toCurency(venda.vlTotItens), Colors.white, Colors.black),
              _UtilLstaPagtos.getBarrasSumarizadora("Saldo Devedor", Util.toCurency(venda.vlTotItens - venda.vlTotPg),
                  Colors.grey.shade400, Colors.white),
            ]),
          ),
        ],
      ),
    );
  }
}

/* class PagamentoTile extends StatelessWidget {
  final Venda venda;
  final VendaPagamento pagto;
  final Function rebuildThisForm;
  const PagamentoTile({
    Key? key,
    required this.pagto,
    required this.venda,
    required this.rebuildThisForm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UtilListTile.boxDecorationPadrao,
      child: ListTile(
        contentPadding: UtilListTile.contentPaddingPadrao,
        visualDensity: UtilListTile.visualDensityPadrao,
        onTap: () {
          Navigator.of(context)
              .pushNamed(AppRoutes.VENDA_FORM_PAGTO, arguments: pagto)
              .then((object) {
            if (object == null) venda.removePagtoVenda(pagto);
          });
          rebuildThisForm();
        },
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
    );
  }
} */

class _UtilLstaPagtos {
  static callNovoRegistro(context, Venda venda, rebuildForm) async {
    await Navigator.of(context).pushNamed(AppRoutes.VENDA_FORM_PAGTO).then((object) {
      if (object == null) return;
      RetornoForm retornoForm = object as RetornoForm;
      if (!retornoForm.isDelete) venda.pagtos.add(retornoForm.objData as VendaPagamento);
    });
    rebuildForm();
  }

  static callEditRegistro(context, Venda venda, pagto, rebuildForm) async {
    await Navigator.of(context).pushNamed(AppRoutes.VENDA_FORM_PAGTO, arguments: pagto).then((object) {
      if (object == null) return;
      RetornoForm retorno = object as RetornoForm;
      if (retorno.isDelete) venda.removePagtoVenda(pagto);
    });
    rebuildForm();
  }

  static Container getBarraAddItem(context, venda, rebuildForm) {
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
                /* () async {
                  await Navigator.of(context).pushNamed(AppRoutes.VENDA_FORM_PAGTO).then((object) {
                    if (object == null) return;
                    RetornoForm retornoForm = object as RetornoForm;
                    if (!retornoForm.isDelete) venda.pagtos.add(retornoForm.objData as VendaPagamento);
                  });
                  rebuildForm();
                }, */
                child: Text('Adicionar Pagamento', style: TextStyle(color: Colors.green)),
              )),
        ],
      ),
    );
  }

  static Container getListaPagtos(venda, rebuildForm) {
    return Container(
      color: Colors.white,
      child: venda.pagtos.length == 0
          ? Container(
              height: 40,
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(width: 1.0, color: Colors.grey.shade200),
              )),
              child: const Center(child: Text('Pedidos sem Pagamentos')),
            )
          : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: venda.pagtos.length,
              itemBuilder: (BuildContext context, int index) {
                final pagto = venda.pagtos.elementAt(index);
                return Container(
                    //PagamentoTile(pagto: venda.pagtos.elementAt(index), rebuildThisForm),
                    child: Container(
                  decoration: UtilListTile.boxDecorationPadrao,
                  child: ListTile(
                    contentPadding: UtilListTile.contentPaddingPadrao,
                    visualDensity: UtilListTile.visualDensityPadrao,
                    onTap: () => callEditRegistro(context, venda, pagto, rebuildForm),
                    /* () async {
                      await Navigator.of(context)
                          .pushNamed(AppRoutes.VENDA_FORM_PAGTO, arguments: pagto)
                          .then((object) {
                        if (object == null) return;
                        RetornoForm retorno = object as RetornoForm;
                        if (retorno.isDelete) venda.removePagtoVenda(pagto);
                      });
                      rebuildForm();
                    }, */
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
  /* 
  static Container acoesLista(context) => Container(
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

  static final Container tituloLista = Container(
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
  ); */
}
