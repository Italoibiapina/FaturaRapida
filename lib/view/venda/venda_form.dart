import 'package:flutter/material.dart';
import 'package:pedido_facil/models/cliente.dart';
import 'package:pedido_facil/models/venda.dart';
import 'package:pedido_facil/provider/cliente_provider.dart';
import 'package:pedido_facil/provider/crud_provider.dart';
import 'package:pedido_facil/routes/app_routes.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/util/util_list_tile.dart';
import 'package:pedido_facil/util/widget/date_picker_widget.dart';

import 'package:provider/provider.dart';

class VendaForm extends StatefulWidget {
  final Venda? venda;
  const VendaForm({Key? key, this.venda}) : super(key: key);

  @override
  _VendaFormState createState() => _VendaFormState(venda: venda);
}

class _VendaFormState extends State<VendaForm> {
  late Venda? venda;
  _VendaFormState({this.venda}) : super();

  //late final Object? regUpd;
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  rebuildThisForm() {
    setState(() {
      //print("Dt Pedido: " + Util.toDateFormat(venda!.dtPed));
    });
  }

  void _loadFormData() {
    if (venda != null) {
      print("Antes de testar o produto  : " + venda.toString());
    }
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

      final cli = Cliente(
        id: _formData["id"].toString(),
        nm: _formData["nm"].toString(),
        fone: double.parse(_formData["fone"].toString()),
        email: _formData["email"].toString(),
        //foto: _formData["foto"].toString(),
      );
      var provider = Provider.of<ClienteProvider>(context, listen: false);
      provider.put(cli);
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
              child: UtilFormVenda.getResumoPedido(venda!, context, rebuildThisForm),
            ),
            UtilFormVenda.getBlockData(
              height: 45,
              child: UtilFormVenda.getSecaoCliente(venda),
            ),
            //UtilFormVenda.getBlockDataClean(UtilFormVenda.getListVendaItens(venda)),
            UtilFormVenda.getBlockDataClean(
              Column(
                children: [
                  UtilFormVenda.getBarrasAcoes("Adicionar Item", ""),
                  UtilFormVenda.getListVendaItens(venda),
                  UtilFormVenda.getBarrasSumarizadora(
                      "Subtotal", Util.toCurency(0), Colors.grey.shade400, Colors.white),
                ],
              ),
            ),
            UtilFormVenda.getBlockDataClean(
              UtilFormVenda.getSecaoDescFretePagto(venda!, context, rebuildThisForm),
            ),
            UtilFormVenda.getBlockDataClean(
              UtilFormVenda.getSecaoSigObs(),
            ),
          ],
        ));
  }
}

class UtilFormVenda {
  static Container getResumoPedido(Venda venda, context, Function rebuild) {
    return Container(
      margin: EdgeInsets.only(top: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  child: Text(venda.nrPed,
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                  onTap: () async {
                    await Navigator.of(context)
                        .pushNamed(AppRoutes.VENDA_FORM_CABECALHO, arguments: venda);
                    rebuild();
                  }),
              getStatusResumo("Pagamento: " + venda.statusPagto, Colors.orange, false, venda),
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
              getStatusResumo("Entrega: " + venda.statusEntrega, Colors.orange, true, venda),
            ],
          ),
        ],
      ),
    );
  }

  static Widget getStatusResumo(String texto, Color cor, bool isShrink, Venda venda) {
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 5),
      child: SizedBox(
          height: 30,
          child: OutlinedButton(
              onPressed: () => {print("Dt Entrega : " + Util.toDateFormat(venda.dtPed))},
              child: Row(
                children: [
                  /* InkWell(
                      child: Text(texto, style: TextStyle(color: cor), textAlign: TextAlign.right),
                      onTap: () {
                        print("Data de Venda: " + Util.toDateFormat(venda.dtPed));
                      }), */
                  Text(texto, style: TextStyle(color: cor), textAlign: TextAlign.right),
                  Icon(Icons.navigate_next, color: cor),
                ],
              ),
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: cor, width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  padding: EdgeInsets.only(left: 8, right: 2, top: 0, bottom: 0)))),
    );
  }

  static Row getSecaoCliente(venda) {
    return Row(
      children: [
        Icon(Icons.people, color: Colors.grey), //size: 30.0
        Container(
          child: Text("Cliente:"),
          padding: EdgeInsets.only(left: 10, right: 5),
        ),
        Text(venda!.cli == null ? "Informe o cliente" : venda!.cli.nm),
        new Spacer(), // I just added one line
        Icon(Icons.navigate_next, color: Colors.black) // This Icon
      ],
    );
  }

  static final _containerHeightButton = 30.0;

  static Widget getListVendaItens(Venda? venda) {
    return venda != null
        ? Container(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(), // sem scroll na lista view
              shrinkWrap: true, //para expandir o widget Pai
              itemCount: venda.itens.length,
              itemBuilder: (context, index) {
                final item = venda.itens.elementAt(index);

                return Container(
                  decoration: UtilListTile.boxDecorationPadrao,
                  padding: EdgeInsets.all(Util.contentPaddingPadrao),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(item.prod.nm),
                            Text(Util.toCurency(item.vlTot)),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            item.qtd.toString() + ' x ' + Util.toCurency(item.prod.vlVenda),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        : Container(height: 40, child: const Center(child: Text('Pedido sem itens')));
  }

  static Column getSecaoDescFretePagto(Venda venda, context, Function rebuild) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            await Navigator.of(context)
                .pushNamed(AppRoutes.VENDA_FORM_DESC_FRETE, arguments: venda);
            rebuild();
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
            await Navigator.of(context)
                .pushNamed(AppRoutes.VENDA_FORM_DESC_FRETE, arguments: venda);
            rebuild();
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
              Text(Util.toCurency(0)) // This Icon
            ],
          ),
        ),
        UtilFormVenda.getBarrasSumarizadora(
            "Total Geral", Util.toCurency(0), Colors.grey.shade400, Colors.white),
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
                  left: Util.contentPaddingPadrao,
                  right: Util.contentPaddingPadrao,
                  top: Util.contentPaddingPadrao),
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

  static Container getBarrasAcoes(labelEsq, labelDir /* , bool islbEsqButton */) {
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
                onPressed: () => {},
                child: Text(labelEsq, style: TextStyle(color: Colors.green)),
              )),
          Container(
              height: _containerHeightButton,
              //padding: EdgeInsets.only(right: 5.0),
              child: TextButton(
                  style: _btStyle,
                  onPressed: () => {},
                  child: Text(labelDir, style: TextStyle(color: Colors.green)))),
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
              height: _containerHeightButton,
              child: TextButton(
                  onPressed: () => {}, child: Text(labelEsq, style: TextStyle(color: color)))),
          Container(
              height: _containerHeightButton,
              child: TextButton(
                  onPressed: () => {}, child: Text(labelDir, style: TextStyle(color: color)))),
        ],
      ),
    );
  }
}
