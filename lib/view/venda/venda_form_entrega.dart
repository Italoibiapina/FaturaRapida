import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pedido_facil/models/meio_pagamento.dart';
import 'package:pedido_facil/models/util/retorno_form.dart';
import 'package:pedido_facil/models/venda.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/util/util_form.dart';
import 'package:pedido_facil/util/util_list_tile.dart';

class VendaFormEntrega extends StatefulWidget {
  final VendaEntrega vendaEntrega;
  const VendaFormEntrega(this.vendaEntrega, {Key? key}) : super(key: key);

  @override
  _VendaFormEntregaState createState() => _VendaFormEntregaState(vendaEntrega);
}

class _VendaFormEntregaState extends State<VendaFormEntrega> {
  //late Venda venda;
  final VendaEntrega vendaEntrega;
  _VendaFormEntregaState(this.vendaEntrega);

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
      //vendaEntrega = ModalRoute.of(context)!.settings.arguments as VendaEntrega;
      _formData['entreguePara'] = vendaEntrega.entreguePara;
      _formData['obs'] = vendaEntrega.obs;
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
        itemCount:
            vendaEntrega.itensEntregaCount > 0 ? vendaEntrega.itensEntregaCount + 1 : vendaEntrega.itensEntregaCount,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) return tituloLista();

          index -= 1;
          VendaItemEntrega itemEntrega = vendaEntrega.itemEntregueByIndex(index);
          return Container(
              decoration: index == (vendaEntrega.itensEntregaCount - 1) ? null : UtilListTile.boxDecorationPadrao,
              child: Container(
                padding: EdgeInsets.only(left: Util.paddingFormPadrao, right: Util.paddingFormPadrao),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text(itemEntrega.vendaItem.prod.nm, overflow: TextOverflow.visible)),
                      Container(
                        child: qtdEntregaEditor(itemEntrega),
                      )
                    ],
                  ),
                  //Text(itemEntrega.prod.nm /* , style: TextStyle(height: 1, fontSize: 14) */),
                  subtitle: Text(
                      'Entregues : ' +
                          itemEntrega.vendaItem.qtdEntregue.toString() +
                          '/' +
                          itemEntrega.vendaItem.qtd.toString(),
                      style: TextStyle(
                        color: itemEntrega.vendaItem.qtdEntregue > itemEntrega.vendaItem.qtd
                            ? Colors.redAccent
                            : Colors.grey,
                      )),
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

  qtdEntregaEditor(VendaItemEntrega itemEntrega) {
    //int vQtdEntregues = vendaEntrega.qtdItensEntreguesByProdId(itemVenda.prod.id);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          icon: Icon(Icons.remove),
          color: Colors.orangeAccent,
          onPressed: () => setState(() {
            if (itemEntrega.qtdEntregueEntrega > 0) {
              itemEntrega.vendaItem.qtdEntregue--;
              itemEntrega.qtdEntregueEntrega--;
            }
          }),
        ),
        Container(
          width: 50,
          child: Center(child: Text(itemEntrega.qtdEntregueEntrega.toString())),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          icon: Icon(Icons.add),
          color: Colors.orangeAccent,
          onPressed: () => setState(() {
            itemEntrega.vendaItem.qtdEntregue++;
            itemEntrega.qtdEntregueEntrega++;
            //itenEntrega.qtdEntregue++;
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
