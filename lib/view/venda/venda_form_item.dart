import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:pedido_facil/models/produto.dart';
import 'package:pedido_facil/models/venda_item.dart';
import 'package:pedido_facil/provider/produto_provider.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/util/util_form.dart';
import 'package:pedido_facil/util/util_list_tile.dart';

class VendaFormItem extends StatefulWidget {
  const VendaFormItem({Key? key}) : super(key: key);

  @override
  _VendaFormItemState createState() => _VendaFormItemState();
}

class _VendaFormItemState extends State<VendaFormItem> {
  late VendaItem vendaItem =
      VendaItem(id: DateTime.now().toString(), prod: Produto(id: 'novoItem', nm: '', vlVenda: 0));
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};
  bool isNewRec = true;

  final TextEditingController _typeAheadController = TextEditingController();
  final vlVendaControler = MoneyMaskedTextController(leftSymbol: 'R\$ ');
  //final qtdControler = MoneyMaskedTextController();

  /// Usar este metodos para quando refazer o parte grafica "Build method" não precisar
  /// reexecutar o codigo contido neste metodo.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)!.settings.arguments != null) {
      vendaItem = ModalRoute.of(context)!.settings.arguments as VendaItem;
      //_formData['nmProd'] = vendaItem.prod.nm;
      this._typeAheadController.text = vendaItem.prod.nm;
      vlVendaControler.updateValue(vendaItem.prod.vlVenda);
      isNewRec = false;
    }
    _formData['qtd'] = vendaItem.qtd.toString();
  }

  save() {
    final bool isValid = _form.currentState!.validate();
    _form.currentState!.save(); // Chama o metodos save de cada um do campos (TextFormField)
    if (isValid) {
      vendaItem.prod.nm = _typeAheadController.text; //_formData['nmProd'].toString();
      vendaItem.prod.vlVenda = vlVendaControler.numberValue;
      vendaItem.qtd = int.parse(_formData['qtd'].toString());

      Navigator.of(context).pop(vendaItem);
    } else {
      if (isNewRec) {
        if ((_formData['nmProd'].toString() == "" || _formData['nmProd'] == null) &&
            _formData['qtd'].toString() == "" &&
            vlVendaControler.numberValue == 0.0) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final _botoes = <Widget>[];
    if (!isNewRec)
      _botoes
          .add(IconButton(icon: Icon(Icons.delete), onPressed: () => Navigator.of(context).pop()));
    final AppBar appBar = AppBar(
      title: Text('Item da Venda'),
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: () {
          save();
        },
      ),
      actions: _botoes,
    );

    return UtilForm.getFormContainerPadraoAppCustom(
        appBar,
        Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TypeAheadFormField<Produto?>(
                initialValue: _formData['nmProd'],
                textFieldConfiguration: TextFieldConfiguration(
                  controller: this._typeAheadController,
                  decoration: InputDecoration(labelText: 'Produto/Serviço'),
                ),
                transitionBuilder: (context, suggestionsBox, controller) => suggestionsBox,
                debounceDuration: Duration(milliseconds: 500),
                hideSuggestionsOnKeyboardHide: true,
                suggestionsCallback: (pattern) {
                  return ProdutoProvider.sugestion(pattern.toString());
                },
                noItemsFoundBuilder: (context) => Container(
                  height: 40,
                  child: Center(
                    child: Text('Nenhum produto encontrado.',
                        style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ),
                ),
                itemBuilder: (context, Produto? suggestion) {
                  final Produto prod = suggestion!;
                  return Container(
                    decoration: UtilListTile.boxDecorationPadrao,
                    child: ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -3),
                      title: Text(prod.nm, style: TextStyle(fontSize: 14)),
                      trailing: Text(Util.toCurency(prod.vlVenda),
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ),
                  );
                },
                onSuggestionSelected: (suggestion) {
                  Produto prod = suggestion as Produto;
                  this._typeAheadController.text = prod.nm;
                  vlVendaControler.updateValue(prod.vlVenda);
                },
                validator: (value) {
                  return UtilForm.valTextFormField(
                      valor: value.toString(), mandatorio: true, tamMax: 50);
                },
              ),
              /* TextFormField(
                initialValue: _formData['nmProd'],
                decoration: InputDecoration(labelText: 'Nome do Produto/Serviço'),
                validator: (value) {
                  return UtilForm.valTextFormField(
                      valor: value.toString(), mandatorio: true, tamMax: 50);
                },
                onSaved: (value) => _formData['nmProd'] = value == null ? '' : value,
              ), */
              TextFormField(
                controller: vlVendaControler,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Valor de Venda'),
              ),
              TextFormField(
                initialValue: isNewRec ? '1' : _formData['qtd'],
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Quantidade', hintText: '1'),
                validator: (value) {
                  return UtilForm.valTextFormField(
                      valor: value.toString(), tamMax: 4, numerico: true);
                },
                onSaved: (value) => _formData['qtd'] = value!,
              ),
            ],
          ),
        ));
  }
}
