import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pedido_facil/models/produto.dart';
import 'package:pedido_facil/models/util/retorno_form.dart';
import 'package:pedido_facil/provider/produto_provider.dart';
import 'package:pedido_facil/util/util_form.dart';
import 'package:pedido_facil/widget/projWidget/pj_page_Scaffold_form.dart';
import 'package:provider/provider.dart';

class ProdutoForm extends StatefulWidget {
  final Produto produto;
  const ProdutoForm(this.produto, {Key? key}) : super(key: key);

  @override
  _ProdutoFormState createState() => _ProdutoFormState();
}

class _ProdutoFormState extends State<ProdutoForm> {
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  bool isNovoReg = false;
  final vlVendaControler = MoneyMaskedTextController(leftSymbol: 'R\$ ');

  void _loadFormData() {
    isNovoReg = widget.produto.nm == "" && widget.produto.detalhe == "" && widget.produto.vlVenda == 0;
    _formData['id'] = widget.produto.id;
    _formData['nm'] = widget.produto.nm;
    vlVendaControler.updateValue(widget.produto.vlVenda);
    //_formData['vlVenda'] = widget.produto.vlVenda.toString();
    _formData['vlCompra'] = widget.produto.vlCusto.toString();
    _formData['detalhe'] = widget.produto.detalhe;
  }

  /// Usar este metodos para quando refazer o parte grafica "Build method" não precisar
  /// reexecutar o codigo contido neste metodo.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadFormData();
  }

  save() {
    _form.currentState!.save();

    /// Se for novo registro e os campos estão em branco sai sem salvar
    if (isNovoReg && _formData['nm'] == "" && _formData["detalhe"] == "" && vlVendaControler.numberValue == 0.0) {
      Navigator.of(context).pop();
    }

    final bool isValid = _form.currentState!.validate();
    if (isValid) {
      Provider.of<ProdutoProvider>(context, listen: false).put(
        Produto(
          id: _formData["id"].toString(),
          nm: _formData["nm"].toString(),
          vlVenda: vlVendaControler.numberValue, //double.parse(_formData["vlVenda"].toString()),
          detalhe: _formData["detalhe"].toString(),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PjPageListaScaffoldForm(
      titulo: 'Produto',
      form: _getForm(),
      backButtonFunc: _backFunction,
      deleteFnc: _deleteFunction,
    );

    /*  return UtilForm.getFormContainerPadrao(
        'Produto',
        () => save(),
        null,
        Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _formData['nm'],
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  return UtilForm.valTextFormField(valor: value.toString(), mandatorio: true);
                },
                onSaved: (value) => _formData['nm'] = value!,
              ),
              TextFormField(
                controller: vlVendaControler,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Preço de Venda'),
              ),
              TextFormField(
                initialValue: _formData['detalhe'],
                decoration: InputDecoration(labelText: 'Detalhes'),
                onSaved: (value) => _formData['detalhe'] = value!,
              ),
            ],
          ),
        )); */
  }

  Form _getForm() {
    return Form(
      key: _form,
      child: Column(
        children: <Widget>[
          TextFormField(
            initialValue: _formData['nm'],
            decoration: InputDecoration(labelText: 'Nome'),
            validator: (value) {
              return UtilForm.valTextFormField(valor: value.toString(), mandatorio: true);
            },
            onSaved: (value) => _formData['nm'] = value!,
          ),
          TextFormField(
            controller: vlVendaControler,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Preço de Venda'),
          ),
          TextFormField(
            initialValue: _formData['detalhe'],
            decoration: InputDecoration(labelText: 'Detalhes'),
            onSaved: (value) => _formData['detalhe'] = value!,
          ),
        ],
      ),
    );
  }

  _backFunction() {
    save();
  }

  _deleteFunction() {
    final ProdutoProvider prodProvider = Provider.of(context, listen: false);
    prodProvider.remove(widget.produto);
    Navigator.of(context).pop(RetornoForm(isDelete: true, objData: widget.produto));
  }
}
