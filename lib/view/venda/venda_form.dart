import 'package:flutter/material.dart';
import 'package:pedido_facil/models/cliente.dart';
import 'package:pedido_facil/models/produto.dart';
import 'package:pedido_facil/models/util/retorno_form.dart';
import 'package:pedido_facil/models/venda.dart';
import 'package:pedido_facil/models/venda_item.dart';
import 'package:pedido_facil/provider/crud_provider.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/util/util_list_tile.dart';
import 'package:pedido_facil/util/widget/date_picker_widget.dart';
import 'package:pedido_facil/view/cliente/cliente_list.dart';
import 'package:pedido_facil/view/venda/venda_form_cabecalho.dart';
import 'package:pedido_facil/view/venda/venda_form_desc_frete.dart';
import 'package:pedido_facil/view/venda/venda_form_item.dart';
import 'package:pedido_facil/view/venda/venda_list_entregas.dart';
import 'package:pedido_facil/view/venda/venda_list_pagamentos.dart';
import 'package:pedido_facil/widget/projWidget/helper_classes.dart';

class VendaForm extends StatefulWidget {
  final Venda venda;
  const VendaForm({Key? key, required this.venda}) : super(key: key);

  @override
  _VendaFormState createState() => _VendaFormState(venda: venda);
}

class _VendaFormState extends State<VendaForm> {
  final Venda venda;
  _VendaFormState({required this.venda}) : super();

  //late final Object? regUpd;
  final _form = GlobalKey<FormState>();
  //final Map<String, String> _formData = {};

  _rebuildThisForm() {
    setState(() {
      //print("Dt Pedido: " + Util.toDateFormat(venda!.dtPed));
    });
  }

  void _loadFormData() {
    //if (venda != null) {
    print("Antes de testar o produto  : " + venda.toString());
    //}
  }

  /// Usar este metodos para quando refazer o parte grafica "Build method" não precisar
  /// reexecutar o codigo contido neste metodo.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFormData();
  }

  save() {
    final bool isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save();

      /* final cli = Cliente(
        _formData["nm"].toString(),
        id: _formData["id"].toString(),
        fone: double.parse(_formData["fone"].toString()),
        email: _formData["email"].toString(),
        //foto: _formData["foto"].toString(),
      ); */
      //var provider = Provider.of<ClienteProvider>(context, listen: false);
      //provider.put(cli);
      Navigator.of(context).pop();
    }
  }

  delete(CrudProvider provider, regUpd) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Excluir Registro"),
        content: Text("Tem certeza que gostaria de excluir?"),
        actions: <Widget>[
          TextButton(
            child: Text("Não"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text("Sim"),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed) {
        // o provider abaixo não vai ser notificado, mas o provider da lista vai.
        //Provider.of<ClienteProvider>(context, listen: false).remove(regUpd);
        provider.remove(regUpd);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final PjTopBarListActionHelper topBarActionItemVendaHelper = getTopListActionItemVenda(context);
    final PjListaDadosHelper listaItenVendaHelper = getListaDadosHelper();
    final PjBarraSumarizadoraHelper barraSumItensVendaHelper = getBarraSumListaHelper();

    return Scaffold(
        backgroundColor: Util.backColorPadrao,
        appBar: AppBar(
          title: Text('Venda'),
          //elevation: 0,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.save), onPressed: () => {} /* saveFnc() */),
            IconButton(icon: Icon(Icons.delete), onPressed: () => {} /* deleteFnc() */)
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(Util.marginScreenPadrao),
          children: <Widget>[
            UtilFormVenda.getBlockData(
              height: 90,
              marginTop: false,
              child: UtilFormVenda.getResumoPedido(
                  venda, context, _callVendaCabecalho, _callVendaPagtoLista, _callVendaEntregaLista),
            ),
            UtilFormVenda.getBlockData(
                height: 45, child: UtilFormVenda.getSecaoCliente(venda, context, _callSelecionarCliente)),
            //UtilFormVenda.getBlockDataClean(UtilFormVenda.getListVendaItens(venda)),
            UtilFormVenda.getBlockDataClean(
              Column(
                children: [
                  topBarActionItemVendaHelper.getWidget(),
                  listaItenVendaHelper.getWidget(),
                  barraSumItensVendaHelper.getWidget(),
                ],
              ),
            ),
            UtilFormVenda.getBlockDataClean(
              UtilFormVenda.getSecaoDescFretePagto(venda, context, _callEditDescontoFrete /* _rebuildThisForm */),
            ),
            UtilFormVenda.getBlockDataClean(
              UtilFormVenda.getSecaoSigObs(),
            ),
          ],
        ));
  }

  _callSelecionarCliente(context) async {
    /// onPressed TEM QUE SER com "context, new MaterialPageRoute(builder: ..."
    /// ASSIM POR CONTA DO FORM_VENDA esta sebdo chamdo de uma lista que esta dentrp de uma TAB
    await Navigator.push(context, new MaterialPageRoute(builder: (context) => ClienteList(isSearch: true)))
        .then((object) {
      if (object != null) {
        Cliente cliente = object as Cliente;
        venda.cli = cliente;
      }
    });
    _rebuildThisForm();
  }

  _callVendaCabecalho(context) async {
    /// onPressed TEM QUE SER com "context, new MaterialPageRoute(builder: ..."
    /// ASSIM POR CONTA DO FORM_VENDA esta sebdo chamdo de uma lista que esta dentrp de uma TAB
    await Navigator.push(context, new MaterialPageRoute(builder: (context) => VendaFormCabecalho(venda: venda)));
    _rebuildThisForm();
  }

  _callVendaPagtoLista(context) async {
    /// onPressed TEM QUE SER com "context, new MaterialPageRoute(builder: ..."
    /// ASSIM POR CONTA DO FORM_VENDA esta sebdo chamdo de uma lista que esta dentrp de uma TAB
    await Navigator.push(context, new MaterialPageRoute(builder: (context) => VendaListPagamentos(venda)));
    _rebuildThisForm();
  }

  _callVendaEntregaLista(context) async {
    /// onPressed TEM QUE SER com "context, new MaterialPageRoute(builder: ..."
    /// ASSIM POR CONTA DO FORM_VENDA esta sebdo chamdo de uma lista que esta dentrp de uma TAB
    await Navigator.push(context, new MaterialPageRoute(builder: (context) => VendaListEntregas(venda)));
    _rebuildThisForm();
  }

  _callNovoItemVenda(context) async {
    final VendaItem vendaItem =
        VendaItem(id: DateTime.now().toString(), prod: Produto(id: 'novoItem', nm: '', vlVenda: 0));

    /// onPressed TEM QUE SER com "context, new MaterialPageRoute(builder: ..."
    /// ASSIM POR CONTA DA FORM_VENDA/LISTA_PAGTO esta sendo chamado de uma lista que esta dentro de uma TAB
    await Navigator.push(context, new MaterialPageRoute(builder: (context) => VendaFormItem(vendaItem))).then((object) {
      if (object == null) return;
      RetornoForm retornoForm = object as RetornoForm;
      if (!retornoForm.isDelete) {
        VendaItem vendaItemRetorno = retornoForm.objData as VendaItem;
        venda.addItem(vendaItemRetorno);
      }
    });

    _rebuildThisForm();
  }

  _callEditItemVenda(context, VendaItem item) async {
    /// onPressed TEM QUE SER com "context, new MaterialPageRoute(builder: ..."
    /// ASSIM POR CONTA DA FORM_VENDA/LISTA_PAGTO esta sendo chamado de uma lista que esta dentro de uma TAB
    await Navigator.push(context, new MaterialPageRoute(builder: (context) => VendaFormItem(item))).then((object) {
      if (object == null) return;
      RetornoForm retorno = object as RetornoForm;
      if (retorno.isDelete) venda.removeItem(item);
    });
    _rebuildThisForm();
  }

  _callEditDescontoFrete(context) async {
    /// onPressed TEM QUE SER com "context, new MaterialPageRoute(builder: ..."
    /// ASSIM POR CONTA DA FORM_VENDA/LISTA_PAGTO esta sendo chamado de uma lista que esta dentro de uma TAB
    await Navigator.push(context, new MaterialPageRoute(builder: (context) => VendaFormDescFrete(venda)));
    _rebuildThisForm();

    //await Navigator.of(context).pushNamed(AppRoutes.VENDA_FORM_DESC_FRETE, arguments: venda);
  }

  PjTopBarListActionHelper getTopListActionItemVenda(context) {
    return PjTopBarListActionHelper(
        textActEsq: 'Adicionar Item',
        actFncEsq: () {
          _callNovoItemVenda(context);
        });
  }

  PjListaDadosHelper getListaDadosHelper() {
    return PjListaDadosHelper(
      countRecords: venda.itensCount,
      listViewDados: _getListViewItens(),
      msgSemDados: 'Pedido sem itens',
    );
  }

  PjBarraSumarizadoraHelper getBarraSumListaHelper() {
    return PjBarraSumarizadoraHelper(labelEsq: "Subtotal 2", labelDir: Util.toCurency(venda.vlTotItens));
  }

  ListView _getListViewItens() {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(), // sem scroll na lista view
      shrinkWrap: true, //para expandir o widget Pai
      itemCount: venda.itensCount,
      itemBuilder: (context, index) {
        final item = venda.itensByIndex(index);

        return InkWell(
          onTap: () async {
            _callEditItemVenda(context, item);
            /* await Navigator.of(context).pushNamed(AppRoutes.VENDA_FORM_ITEM, arguments: item).then((object) {
              if (object == null) venda.removeItem(item);
            });
            _rebuildThisForm(); */
          },
          child: Container(
            decoration: UtilListTile.boxDecorationPadrao,
            padding: EdgeInsets.all(Util.contentPaddingPadrao),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Text(
                        item.prod.nm,
                        overflow: TextOverflow.ellipsis,
                      )),
                      Text(Util.toCurency(item.vlTot)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Entregues : ' + item.qtdEntregue.toString() + '/' + item.qtd.toString(),
                      style: TextStyle(color: item.qtdEntregue > item.qtd ? Colors.redAccent : Colors.grey),
                    ),
                    Text(
                      item.qtd.toString() + ' x ' + Util.toCurency(item.prod.vlVenda),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class UtilFormVenda {
  static Container getResumoPedido(
      Venda venda, context, Function callCabecalhoForm, Function callPagtoList, Function callEntregaList) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: Text(venda.nrPed, style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                onTap: () => callCabecalhoForm(context),
                /* onTap: () async {
                  await Navigator.of(context).pushNamed(AppRoutes.VENDA_FORM_CABECALHO, arguments: venda);
                  rebuild();
                }, */
              ),
              getStatusResumo(context, "Pagamento: " + venda.statusPagto,
                  callPagtoList /* AppRoutes.VENDA_LIST_PAGTO, venda, rebuild */),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DatePickerWidget(
                iniDate: venda.dtPed,
                setDateFnc: (pickedDate) => {venda.dtPed = pickedDate},
              ),
              //Text(Util.toDateFormat(venda.dtPed), style: TextStyle(color: Colors.grey)),
              //getStatusResumo("Entrega: " + venda.statusEntrega, Colors.orange, true, venda),
              getStatusResumo(context, "Entrega: " + venda.statusEntrega,
                  callEntregaList /* AppRoutes.VENDA_LIST_ENTREGA, venda, rebuild */),
            ],
          ),
        ],
      ),
    );
  }

  static Widget getStatusResumo(
      context, String texto, Function callLista /* String route, Venda venda, Function rebuild */) {
    Color corTexto = Colors.orange;
    Color corIcon = Colors.orange;
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      child: SizedBox(
          height: 30,
          child: OutlinedButton(
              onPressed: () => callLista(context),
              /* onPressed: () => {
                    Navigator.of(context).pushNamed(route, arguments: venda).then(
                      (value) {
                        rebuild();
                      },
                    )
                  }, */
              child: Row(
                children: [
                  Text(texto, style: TextStyle(color: corTexto), textAlign: TextAlign.right),
                  Icon(Icons.navigate_next, color: corIcon),
                ],
              ),
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: corTexto, width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  padding: EdgeInsets.only(left: 8, right: 2, top: 0, bottom: 0)))),
    );
  }

  static InkWell getSecaoCliente(Venda venda, context, Function callSelecionarCliente) {
    return InkWell(
      child: Row(
        children: [
          Icon(Icons.people, color: Colors.grey), //size: 30.0
          Container(
            child: Text("Cliente:"),
            padding: EdgeInsets.only(left: 10, right: 5),
          ),
          // ignore: unnecessary_null_comparison
          Text(venda.cli == null ? "Informe o cliente" : venda.cli.nm),
          new Spacer(), // I just added one line
          Icon(Icons.navigate_next, color: Colors.black), // This Icon
        ],
      ),
      onTap: () => callSelecionarCliente(context),
    );
  }

  static final _containerHeightButton = 30.0;

  /* static Container getBarraAddItem(context, Venda venda, rebuildForm) {
    ButtonStyle _btStyle = TextButton.styleFrom(
      padding: const EdgeInsets.only(
          left: Util.contentPaddingPadrao, right: Util.contentPaddingPadrao, top: 0.0, bottom: 0.0),
    );
    return Container(
      height: 30,
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 1.0, color: Colors.grey.shade200),
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              height: _containerHeightButton,
              child: TextButton(
                style: _btStyle,
                onPressed: () async {
                  await Navigator.of(context).pushNamed(AppRoutes.VENDA_FORM_ITEM).then((object) {
                    if (object != null) venda.addItem(object as VendaItem);
                  });
                  rebuildForm();
                },
                child: Text('Adicionar Item', style: TextStyle(color: Colors.green)),
              )),
        ],
      ),
    );
  } */

  /* static Widget getListVendaItens(Venda venda, rebuildForm) {
    return venda.itensCount > 0
        ? Container(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(), // sem scroll na lista view
              shrinkWrap: true, //para expandir o widget Pai
              itemCount: venda.itensCount,
              itemBuilder: (context, index) {
                final item = venda.itensByIndex(index);

                return InkWell(
                  onTap: () async {
                    await Navigator.of(context).pushNamed(AppRoutes.VENDA_FORM_ITEM, arguments: item).then((object) {
                      if (object == null) venda.removeItem(item);
                    });
                    rebuildForm();
                  },
                  child: Container(
                    decoration: UtilListTile.boxDecorationPadrao,
                    padding: EdgeInsets.all(Util.contentPaddingPadrao),
                    child:
                        
                        Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                  child: Text(
                                item.prod.nm,
                                overflow: TextOverflow.ellipsis,
                              )),
                              Text(Util.toCurency(item.vlTot)),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Entregues : ' + item.qtdEntregue.toString() + '/' + item.qtd.toString(),
                              style: TextStyle(color: item.qtdEntregue > item.qtd ? Colors.redAccent : Colors.grey),
                            ),
                            Text(
                              item.qtd.toString() + ' x ' + Util.toCurency(item.prod.vlVenda),
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : Container(height: 40, child: const Center(child: Text('Pedido sem itens')));
  } */

  static Column getSecaoDescFretePagto(Venda venda, context, /* Function rebuild, */ Function callFormEdit) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            callFormEdit(context);
            /* await Navigator.of(context).pushNamed(AppRoutes.VENDA_FORM_DESC_FRETE, arguments: venda);
            rebuild(); */
          },
          child: Container(
            padding: EdgeInsets.all(Util.contentPaddingPadrao),
            child: Row(
              children: [
                Icon(Icons.money_off, color: Colors.grey), //size: 30.0
                Container(child: Text("Desconto"), padding: EdgeInsets.only(left: 10)),
                new Spacer(), // I just added one line
                Text(Util.toCurency(venda.vlDesconto)) // This Icon
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            callFormEdit(context);
            /* await Navigator.of(context).pushNamed(AppRoutes.VENDA_FORM_DESC_FRETE, arguments: venda);
            rebuild(); */
          },
          child: Container(
            padding: EdgeInsets.all(Util.contentPaddingPadrao),
            child: Row(
              children: [
                Icon(Icons.local_shipping, color: Colors.grey), //size: 30.0
                Container(child: Text("Frete"), padding: EdgeInsets.only(left: 10)),
                new Spacer(), // I just added one line
                Text(Util.toCurency(venda.vlFrete)) // This Icon
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(Util.contentPaddingPadrao),
          child: Row(
            children: [
              Icon(Icons.payments, color: Colors.grey), //size: 30.0
              Container(child: Text("Pagamentos"), padding: EdgeInsets.only(left: 10)),
              new Spacer(), // I just added one line
              Text(Util.toCurency(venda.vlTotPg)) // This Icon
            ],
          ),
        ),
        UtilFormVenda.getBarrasSumarizadora(
            "Total Geral", Util.toCurency(venda.vlTotGeral), Colors.grey.shade400, Colors.white),
      ],
    );
  }

  static Column getSecaoSigObs() {
    return Column(
      children: [
        Container(
          decoration: UtilListTile.boxDecorationPadrao,
          margin: EdgeInsets.only(top: Util.contentPaddingPadrao),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: Util.contentPaddingPadrao,
                    right: Util.contentPaddingPadrao,
                    bottom: Util.contentPaddingPadrao),
                child: Text("Assinatura", style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
        Container(
          height: 50,
          margin: EdgeInsets.only(bottom: Util.contentPaddingPadrao),
          child: Row(children: [
            Container(
              margin: EdgeInsets.only(
                  left: Util.contentPaddingPadrao, right: Util.contentPaddingPadrao, top: Util.contentPaddingPadrao),
              child: Text("Observações", style: TextStyle(color: Colors.grey)),
            ),
          ]),
        ),
      ],
    );
  }

  static Container getBlockData({double? height, bool? marginTop, child}) {
    height = height == null ? 80 : height;
    marginTop = marginTop == null ? true : marginTop;
    double _marginTopVl = marginTop ? Util.marginScreenPadrao : 0.0;
    //padding = padding == null ? Util.paddingListTopPadrao : padding;
    return Container(
      height: height,
      margin: EdgeInsets.only(top: _marginTopVl),
      padding: EdgeInsets.only(left: Util.paddingListTopPadrao, right: Util.paddingListTopPadrao),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(const Radius.circular(Util.borderRadiousPadrao)),
      ),
      child: child,
    );
  }

  static Container getBlockDataClean(child) {
    return Container(
      margin: EdgeInsets.only(top: Util.marginScreenPadrao),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(const Radius.circular(Util.borderRadiousPadrao)),
      ),
      child: child,
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
              height: _containerHeightButton,
              child: TextButton(onPressed: () => {}, child: Text(labelEsq, style: TextStyle(color: color)))),
          Container(
              height: _containerHeightButton,
              child: TextButton(onPressed: () => {}, child: Text(labelDir, style: TextStyle(color: color)))),
        ],
      ),
    );
  }
}
