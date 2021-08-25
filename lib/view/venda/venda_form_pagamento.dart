import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pedido_facil/models/meio_pagamento.dart';
import 'package:pedido_facil/models/venda_pagamento.dart';
import 'package:pedido_facil/provider/meio_pgto_provider.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/util/util_form.dart';
import 'package:provider/provider.dart';

class VendaFormPagamento extends StatefulWidget {
  const VendaFormPagamento({Key? key}) : super(key: key);

  @override
  _VendaFormPagamentoState createState() => _VendaFormPagamentoState();
}

class _VendaFormPagamentoState extends State<VendaFormPagamento> {
  late VendaPagamento vendaPgto = VendaPagamento(
      id: DateTime.now().toString(),
      dtPagto: DateTime.now(),
      meioPagto: MeioPagamento(id: '-1', nm: ''),
      vlPgto: 0);

  final _form = GlobalKey<FormState>();
  //final Map<String, String> _formData = {};
  bool isNewRec = true;

  final vMeioPagtoTextEditControler = TextEditingController();
  final vlPagtoControler = MoneyMaskedTextController(leftSymbol: 'R\$ ');
  final vDtControler = TextEditingController();

  setDtPgto(DateTime newDate) {
    setState(() {
      vDtControler.text = Util.toDateFormat(newDate);
      vendaPgto.dtPagto = newDate;
    });
  }

  setMeioPgto(MeioPagamento meioPagto) {
    setState(() {
      vMeioPagtoTextEditControler.text = meioPagto.nm;
      vendaPgto.meioPagto = meioPagto;
    });
  }

  /// Usar este metodos para quando refazer o parte grafica "Build method" não precisar
  /// reexecutar o codigo contido neste metodo.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      vendaPgto = ModalRoute.of(context)!.settings.arguments as VendaPagamento;
      vMeioPagtoTextEditControler.text = vendaPgto.meioPagto.nm;
      vlPagtoControler.updateValue(vendaPgto.vlPgto);
      isNewRec = false;
    }
    vDtControler.text = Util.toDateFormat(vendaPgto.dtPagto);
    //_formData['qtd'] = vendaItem.qtd.toString();
  }

  save() {
    vendaPgto.vlPgto = vlPagtoControler.numberValue;
    Navigator.of(context).pop(vendaPgto);

    /* final bool isValid = _form.currentState!.validate();
    _form.currentState!.save(); // Chama o metodos save de cada um do campos (TextFormField)
    if (isValid) {
      //vendaItem.prod.nm = _formData['nmProd'].toString(); //_formData['nmProd'].toString();
      vendaPgto.vlPgto = vlPagtoControler.numberValue;
      //vendaItem.qtd = int.parse(_formData['qtd'].toString());

      Navigator.of(context).pop(vendaPgto);
    } else {
      if (isNewRec) {
        if ((_formData['nmProd'].toString() == "" || _formData['nmProd'] == null) &&
            _formData['qtd'].toString() == "" &&
            vlPagtoControler.numberValue == 0.0) {
          Navigator.of(context).pop();
        } else {
          UtilForm.showDialogEditarDescartar(
            context,
            'Atenção',
            'Alguns campos possuem dados inválidos, Você deseja continuar editando ou descartar as alterações?',
            () => {Navigator.of(context).pop()},
          );
        }
      }
    } */
  }

  @override
  Widget build(BuildContext context) {
    final MeioPagamentoProvider meioPgtoProvider = Provider.of(context);

    final _botoes = <Widget>[];
    if (!isNewRec)
      _botoes
          .add(IconButton(icon: Icon(Icons.delete), onPressed: () => Navigator.of(context).pop()));

    final AppBar appBar = AppBar(
      title: Text('Pagamento da Venda'),
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: () => save(),
      ),
      actions: _botoes,
    );

    return UtilForm.getFormContainerPadraoAppCustom(
        appBar,
        Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: vMeioPagtoTextEditControler,
                decoration: InputDecoration(labelText: 'Meio de Pagamento'),
                enableInteractiveSelection: false, // Desabilita Ediçao no Pressionar/Segurar
                onTap: () async {
                  // Below line stops keyboard from appearing
                  FocusScope.of(context).requestFocus(new FocusNode());

                  UtilFormVendaPagto.showButtonSheetMeioPagto(
                    context,
                    meioPgtoProvider.itens.values.toList(),
                    (meioPagto) {
                      setMeioPgto(meioPagto);
                      //vendaPgto.meioPagto = meioPagto;
                    },
                  );
                },
              ),
              TextFormField(
                controller: vlPagtoControler,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Valor do Pagamento'),
              ),
              TextFormField(
                controller: vDtControler,
                enableInteractiveSelection: false, // Desabilita Ediçao no Pressionar/Segurar
                decoration: InputDecoration(labelText: 'Data do Pagamento'),
                onTap: () async {
                  // Below line stops keyboard from appearing
                  FocusScope.of(context).requestFocus(new FocusNode());

                  // Show Date Picker Here
                  final newDate = await UtilForm.showPickupDate(context, vendaPgto.dtPagto);
                  if (newDate != null) setDtPgto(newDate);
                },
              ),
            ],
          ),
        ));
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
