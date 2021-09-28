import 'package:flutter/material.dart';
import 'package:pedido_facil/models/cliente.dart';
import 'package:pedido_facil/models/util/retorno_form.dart';
import 'package:pedido_facil/provider/cliente_provider.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/util/util_form.dart';
import 'package:pedido_facil/widget/projWidget/pj_page_Scaffold_form.dart';
import 'package:provider/provider.dart';

class ClienteForm extends StatefulWidget {
  final Cliente cli;
  const ClienteForm(this.cli, {Key? key}) : super(key: key);

  @override
  _ClienteFormState createState() => _ClienteFormState(cli);
}

class _ClienteFormState extends State<ClienteForm> {
  final Cliente cli;
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  bool isNovoReg = false;
  _ClienteFormState(this.cli);

  final vDtNascControler = TextEditingController();
  setDtNasc(DateTime newDate) {
    setState(() {
      vDtNascControler.text = Util.toDateFormat(newDate);
      cli.dtNasc = newDate;
    });
  }

  /// Usar este metodos para quando refazer o parte grafica "Build method" não precisar
  /// reexecutar o codigo contido neste metodo.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isNovoReg = this.cli.nm == "" && cli.fone == null && cli.email == "";
    _formData['id'] = cli.id;
    _formData['nm'] = cli.nm;
    _formData['fone'] = cli.fone == null ? '' : cli.fone.toString();
    _formData['email'] = cli.email.toString();
    _formData['foto'] = cli.foto.toString();

    if (cli.dtNasc != null) {
      DateTime vData = cli.dtNasc as DateTime;
      vDtNascControler.text = Util.toDateFormat(vData);

      //cli.dtNasc = vData;
    }
  }

  save() {
    _form.currentState!.save(); // Chama o metodos save de cada um do campos (TextFormField)

    /// Se for novo registro e os campos estão em branco sai sem salvar
    if (isNovoReg && _formData['nm'] == "" && _formData['fone'] == "" && _formData['email'] == "") {
      Navigator.of(context).pop();
    }

    /// é Edição de registro ou é novo registro e o usuários informou valor
    final bool isValid = _form.currentState!.validate();
    if (isValid) {
      final editedCli = Cliente(
        _formData["nm"].toString(),
        id: _formData["id"].toString(),
        fone: _formData["fone"].toString() != '' ? double.parse(_formData["fone"].toString()) : null,
        email: _formData["email"].toString(),
        dtNasc: cli.dtNasc,
        //foto: _formData["foto"].toString(),
      );
      var provider = Provider.of<ClienteProvider>(context, listen: false);
      provider.put(editedCli);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PjPageListaScaffoldForm(
      titulo: 'Cliente',
      form: _getForm(),
      backButtonFunc: _backFunction,
      deleteFnc: _deleteFunction,
    );
  }

  Form _getForm() {
    return Form(
      key: _form,
      child: Column(
        children: <Widget>[
          TextFormField(
            initialValue: _formData['nm'],
            decoration: InputDecoration(labelText: 'Nome' /* , fillColor: Util.backColorPadrao, filled: true */),
            validator: (value) {
              return UtilForm.valTextFormField(valor: value.toString(), mandatorio: true);
            },
            onSaved: (value) => _formData['nm'] = value!,
          ),
          Container(
            //margin: new EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: TextFormField(
              initialValue: _formData['fone'],
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                //contentPadding: EdgeInsets.only(left: 12, top: 10, bottom: 5),
                labelText: 'Fone',
                //fillColor: Util.backColorPadrao,
                //filled: true,
                //labelStyle: TextStyle(color: Colors.lightBlue[600]),
              ),
              validator: (value) {
                return UtilForm.valTextFormField(valor: value.toString(), numerico: true);
              },
              onSaved: (value) => _formData['fone'] = value!,
            ),
          ),
          TextFormField(
            initialValue: _formData['email'],
            decoration: InputDecoration(labelText: 'e-mail' /* , fillColor: Util.backColorPadrao, filled: true */),
            onSaved: (value) => _formData['email'] = value!,
          ),
          TextFormField(
            controller: vDtNascControler,
            enableInteractiveSelection: false, // Desabilita Ediçao no Pressionar/Segurar
            decoration: InputDecoration(labelText: 'Data do Pagamento'),
            onTap: () async {
              // Below line stops keyboard from appearing
              FocusScope.of(context).requestFocus(new FocusNode());
              DateTime vData = cli.dtNasc == null ? DateTime.now() : cli.dtNasc as DateTime;
              // Show Date Picker Here
              final newDate = await UtilForm.showPickupDate(context, vData);

              if (newDate != null) {
                /* vDtNascControler.text = Util.toDateFormat(newDate);
                vDtNascCli = newDate; */
                setDtNasc(newDate);
              }
            },
          ),
        ],
      ),
    );
  }

  _backFunction() {
    save();
  }

  _deleteFunction() {
    var provider = Provider.of<ClienteProvider>(context, listen: false);
    provider.remove(cli);
    Navigator.of(context).pop(RetornoForm(isDelete: true, objData: cli));
  }
}
