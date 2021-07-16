import 'package:flutter/material.dart';
import 'package:pedido_facil/models/produto.dart';
import 'package:pedido_facil/provider/produto_provider.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/util/util_form.dart';
import 'package:provider/provider.dart';

class ProdutoForm extends StatefulWidget {
  //const ProdutoForm({Key? key}) : super(key: key);

  @override
  _ProdutoFormState createState() => _ProdutoFormState();
}

class _ProdutoFormState extends State<ProdutoForm> {
  final _form = GlobalKey<FormState>();

  final Map<String, String> _formData = {};

  void _loadFormData(Object? regUpd) {
    //print("Antes de testar o produto  ");
    if (regUpd != null) {
      Produto prod = regUpd as Produto;
      _formData['id'] = prod.id;
      _formData['nm'] = prod.nm;
      _formData['vlVenda'] = prod.vlVenda.toString();
      _formData['vlCompra'] = prod.vlCompra.toString();
      _formData['detalhe'] = prod.detalhe;
    }
  }

  //usar este metodos para quando refazer o parte grafica "Build method" não precisar reexecutar o codigo contido neste metodo.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Object? regUpd = ModalRoute.of(context)!.settings.arguments;
    _loadFormData(regUpd);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Util.backColorPadrao,
        appBar: AppBar(
          title: Text("Formulários de Produto"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                final bool isValid = _form.currentState!.validate();
                if (isValid) {
                  _form.currentState!.save();
                  Provider.of<ProdutoProvider>(context, listen: false).put(
                    Produto(
                      id: _formData["id"].toString(),
                      nm: _formData["nm"].toString(),
                      vlVenda: double.parse(_formData["vlVenda"].toString()),
                      detalhe: _formData["detalhe"].toString(),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        ),
        body: Container(
          margin: new EdgeInsets.all(Util.marginScreenPadrao),
          child: Container(
              padding: EdgeInsets.all(Util.paddingFormPadrao),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(Util.borderRadiousPadrao)),
              child: Form(
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
                      initialValue: _formData['vlVenda'],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Preço venda'),
                      validator: (value) {
                        return UtilForm.valTextFormField(
                            valor: value.toString(), mandatorio: true, numerico: true);
                      },
                      onSaved: (value) => _formData['vlVenda'] = value!,
                    ),
                    TextFormField(
                      initialValue: _formData['detalhe'],
                      decoration: InputDecoration(labelText: 'Detalhes'),
                      onSaved: (value) => _formData['detalhe'] = value!,
                    ),
                  ],
                ),
              )),
        ));
  }
}
