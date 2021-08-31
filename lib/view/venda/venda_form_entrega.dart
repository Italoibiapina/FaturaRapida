import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pedido_facil/models/IData.dart';
import 'package:pedido_facil/models/meio_pagamento.dart';
import 'package:pedido_facil/models/util/retorno_form.dart';
import 'package:pedido_facil/models/venda.dart';
import 'package:pedido_facil/models/venda_entrega.dart';
import 'package:pedido_facil/models/venda_item.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/util/util_form.dart';
import 'package:pedido_facil/util/util_list_tile.dart';

class VendaFormEntrega extends StatefulWidget {
  const VendaFormEntrega({Key? key}) : super(key: key);

  @override
  _VendaFormEntregaState createState() => _VendaFormEntregaState();
}

class _VendaFormEntregaState extends State<VendaFormEntrega> {
  late Venda venda;
  late VendaEntrega vendaEntrega = VendaEntrega(
    id: DateTime.now().toString(),
    dtEntrega: DateTime.now(),
    entreguePara: '',
    obs: '',
    itenEntregues: List<VendaItem>.empty(),
  );

  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool isNewRec = true;

  final vMeioPagtoTextEditControler = TextEditingController();
  final vlPagtoControler = MoneyMaskedTextController(leftSymbol: 'R\$ ');
  final vDtControler = TextEditingController();

  setDtEntrega(DateTime newDate) {
    setState(() {
      vDtControler.text = Util.toDateFormat(newDate);
      vendaEntrega.dtEntrega = newDate;
    });
  }

  /// Usar este metodos para quando refazer o parte grafica "Build method" não precisar
  /// reexecutar o codigo contido neste metodo.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      List<IData> arqs = ModalRoute.of(context)!.settings.arguments as List<IData>;
      venda = arqs[0] as Venda;
      vendaEntrega = arqs.length > 1 ? arqs[1] as VendaEntrega : vendaEntrega;
      _formData['entreguePara'] = vendaEntrega.entreguePara;
      _formData['obs'] = vendaEntrega.obs;
      //vlPagtoControler.updateValue(vendaPgto.vlPgto);
      isNewRec = false;
    }
    vDtControler.text = Util.toDateFormat(vendaEntrega.dtEntrega);
  }

  save() {
    final bool isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save();
      vendaEntrega.entreguePara = _formData['entreguePara'].toString();
      vendaEntrega.obs = _formData['obs'].toString();
      Navigator.of(context).pop(RetornoForm(objData: vendaEntrega));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _botoes = <Widget>[];
    if (!isNewRec)
      _botoes.add(IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => Navigator.of(context).pop(RetornoForm(isDelete: true, objData: vendaEntrega))));

    final AppBar appBar = AppBar(
      title: Text('Entrega da Venda'),
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: () => save(),
      ),
      actions: _botoes,
    );

    return Scaffold(
      backgroundColor: Util.backColorPadrao,
      appBar: appBar,
      body: ListView(
        children: [
          containerRounded(formEntrega()),
          containerRoundedList(listaItensEntrega()),
        ],
      ),
    );
  }

  containerRounded(child) => Container(
        margin: new EdgeInsets.all(Util.marginScreenPadrao),
        child: Container(
          padding: EdgeInsets.all(Util.paddingFormPadrao),
          decoration:
              new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.circular(Util.borderRadiousPadrao)),
          child: child,
        ),
      );

  containerRoundedList(child) => Container(
        margin: new EdgeInsets.only(left: Util.marginScreenPadrao, right: Util.marginScreenPadrao),
        child: Container(
          padding: EdgeInsets.all(0),
          decoration:
              new BoxDecoration(color: Colors.white, borderRadius: new BorderRadius.circular(Util.borderRadiousPadrao)),
          child: child,
        ),
      );

  formEntrega() => Form(
        key: _form,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: vDtControler,
              enableInteractiveSelection: false, // Desabilita Ediçao no Pressionar/Segurar
              decoration: InputDecoration(labelText: 'Data da Entrega'),
              onTap: () async {
                // Below line stops keyboard from appearing
                FocusScope.of(context).requestFocus(new FocusNode());

                // Show Date Picker Here
                final newDate = await UtilForm.showPickupDate(context, vendaEntrega.dtEntrega);
                if (newDate != null) setDtEntrega(newDate);
              },
            ),
            TextFormField(
              initialValue: _formData['entreguePara'],
              decoration:
                  InputDecoration(labelText: 'Entrega para:' /* , fillColor: Util.backColorPadrao, filled: true */),
              validator: (value) {
                return UtilForm.valTextFormField(valor: value.toString(), tamMax: 50);
              },
              onSaved: (value) => _formData['entreguePara'] = value!,
            ),
            TextFormField(
              initialValue: _formData['obs'],
              decoration: InputDecoration(labelText: 'Observação'),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              validator: (value) {
                return UtilForm.valTextFormField(valor: value.toString(), tamMax: 150);
              },
              onSaved: (value) => _formData['obs'] = value!,
            )
          ],
        ),
      );

  listaItensEntrega() => ListView.builder(
        physics: NeverScrollableScrollPhysics(), // sem scroll na lista view
        shrinkWrap: true,
        itemCount: venda.itens.length > 0 ? venda.itens.length + 1 : venda.itens.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) return tituloLista();

          index -= 1;
          VendaItem item = venda.itens[index];
          return Container(
              decoration: index == (venda.itens.length - 1) ? null : UtilListTile.boxDecorationPadrao,
              child: Container(
                padding: EdgeInsets.only(left: Util.paddingFormPadrao, right: Util.paddingFormPadrao),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text(item.prod.nm, overflow: TextOverflow.visible)),
                      Container(
                        child: qtdEntregaEditor(item),
                      )
                    ],
                  ),
                  //Text(itemEntrega.prod.nm /* , style: TextStyle(height: 1, fontSize: 14) */),
                  subtitle: Text(
                    'Entregues : ' + item.qtdEntregue.toString() + '/' + item.qtd.toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                  //trailing: qtdEntregaEditor(itemEntrega)
                  //Text(vendaEntrega.itenEntregues[index].qtdEntregue.toString()),
                ),
              )
              //),
              );
        },
      );

  tituloLista() => Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(Util.borderRadiousPadrao),
              topRight: const Radius.circular(Util.borderRadiousPadrao)),
        ),
        height: 28,
        child: Container(
          padding: EdgeInsets.only(left: Util.paddingFormPadrao, right: Util.paddingFormPadrao),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey.shade300))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  //padding: EdgeInsets.only(left: 60.0),
                  child: Text("Item", style: TextStyle(color: Colors.grey.shade600))),
              Container(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Text("Qtd Entregue", style: TextStyle(color: Colors.grey.shade600))),
            ],
          ),
        ),
      );

  qtdEntregaEditor(VendaItem itemVenda) {
    int vQtdEntregues = vendaEntrega.qtdItensEntreguesByProdId(itemVenda.prod.id);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          icon: Icon(Icons.remove),
          color: Colors.orangeAccent,
          onPressed: () => setState(() {
            itemVenda.qtdEntregue -= 1;
          }),
        ),
        Container(
          width: 50,
          child: Center(child: Text(vQtdEntregues.toString())),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          icon: Icon(Icons.add),
          color: Colors.orangeAccent,
          onPressed: () => setState(() {
            itemVenda.qtdEntregue += 1;
          }),
        ),
      ],
    );
  }
}

class UtilFormVendaPagto {
  static showButtonSheetMeioPagto(context, List meiosPagtos, Function selectMeioPagto) {
    List<ListTile> lstTile = meiosPagtos.map((e) {
      MeioPagamento meioPgto = e as MeioPagamento;
      return ListTile(
        title: Text(meioPgto.nm),
        onTap: () {
          selectMeioPagto(meioPgto);
          Navigator.pop(context);
        },
      );
    }).toList();

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
                children:
                    lstTile /* <Widget>[
                ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.white,
                      child: new Icon(Icons.money),
                    ),
                    title: new Text('Músicas'),
                    onTap: () => {selection.entries.first.key}),
                ListTile(
                  leading: new Icon(Icons.videocam),
                  title: new Text('Videos'),
                  onTap: () => {},
                ),
                ListTile(
                  leading: new Icon(Icons.satellite),
                  title: new Text('Tempo'),
                  onTap: () => {},
                ),
              ], */
                ),
          );
        });
  }
}
