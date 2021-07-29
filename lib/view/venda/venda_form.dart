import 'package:flutter/material.dart';
import 'package:pedido_facil/models/cliente.dart';
import 'package:pedido_facil/models/venda.dart';
import 'package:pedido_facil/provider/cliente_provider.dart';
import 'package:pedido_facil/provider/crud_provider.dart';
import 'package:pedido_facil/util/util.dart';

import 'package:provider/provider.dart';

class VendaForm extends StatefulWidget {
  final Venda? venda;
  const VendaForm({Key? key, this.venda}) : super(key: key);

  @override
  _VendaFormState createState() => _VendaFormState(venda: venda);
}

class _VendaFormState extends State<VendaForm> {
  late Venda _newVenda;
  late Venda? venda;
  _VendaFormState({this.venda}) : super();

  //late final Object? regUpd;
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  void _loadFormData() {
    if (venda != null) {
      print("Antes de testar o produto  : " + venda.toString());
      _newVenda = venda!.clone();
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
        body: Column(
          children: [
            Container(
              height: 80,
              margin: EdgeInsets.all(Util.marginScreenPadrao),
              padding: EdgeInsets.only(
                  left: Util.paddingListTopPadrao, right: Util.paddingListTopPadrao),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.all(const Radius.circular(Util.borderRadiousPadrao)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_newVenda.nrPed,
                          style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                      Chip(
                          label: Text(_newVenda.status, style: TextStyle(color: Colors.orange)),
                          backgroundColor: Colors.white,
                          shape: StadiumBorder(
                              side: BorderSide(
                            width: 1,
                            color: Colors.orange,
                          )))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Util.toDateFormat(_newVenda.dtPed),
                          style: TextStyle(color: Colors.grey)),
                      Text(_newVenda.dtVencPed.toString(), style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 40,
              margin: EdgeInsets.all(Util.marginScreenPadrao),
              padding: EdgeInsets.only(
                  left: Util.paddingListTopPadrao, right: Util.paddingListTopPadrao),
              decoration: BoxDecoration(
                color: Colors.white, //blueGrey[50],
                borderRadius: new BorderRadius.all(const Radius.circular(Util.borderRadiousPadrao)),
              ),
              child: Row(
                children: [
                  Text('Cliente'),
                ],
              ),
            ),
          ],
        ));

    /* return UtilForm.getFormContainerPadrao(
        'Venda',
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
                initialValue: _formData['fone'],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Fone'),
                validator: (value) {
                  return UtilForm.valTextFormField(
                      valor: value.toString(), mandatorio: true, numerico: true);
                },
                onSaved: (value) => _formData['fone'] = value!,
              ),
              TextFormField(
                initialValue: _formData['email'],
                decoration: InputDecoration(labelText: 'e-mail'),
                onSaved: (value) => _formData['email'] = value!,
              ),
            ],
          ),
        )); */
  }
}
