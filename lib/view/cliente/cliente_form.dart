import 'package:flutter/material.dart';
import 'package:pedido_facil/models/cliente.dart';
import 'package:pedido_facil/provider/cliente_provider.dart';
import 'package:pedido_facil/provider/crud_provider.dart';
import 'package:pedido_facil/util/util_form.dart';
import 'package:provider/provider.dart';

class ClienteForm extends StatefulWidget {
  const ClienteForm({Key? key}) : super(key: key);

  @override
  _ClienteFormState createState() => _ClienteFormState();
}

class _ClienteFormState extends State<ClienteForm> {
  late final Object? regUpd;
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  void _loadFormData(Object? regUpd) {
    //print("Antes de testar o produto  ");
    if (regUpd != null) {
      Cliente cli = regUpd as Cliente;
      _formData['id'] = cli.id;
      _formData['nm'] = cli.nm;
      _formData['fone'] = cli.fone.toString();
      _formData['email'] = cli.email.toString();
      _formData['foto'] = cli.foto.toString();
    }
  }

  /// Usar este metodos para quando refazer o parte grafica "Build method" não precisar
  /// reexecutar o codigo contido neste metodo.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    regUpd = ModalRoute.of(context)!.settings.arguments;
    _loadFormData(regUpd);
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
    return UtilForm.getFormContainerPadrao(
        'Cliente',
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
        ));
  }
}
