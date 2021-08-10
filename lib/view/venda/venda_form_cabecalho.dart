import 'package:flutter/material.dart';
import 'package:pedido_facil/models/venda.dart';
import 'package:pedido_facil/util/util_form.dart';

class VendaFormCabelcalho extends StatefulWidget {
  const VendaFormCabelcalho({Key? key}) : super(key: key);

  @override
  _VendaFormCabelcalhoState createState() => _VendaFormCabelcalhoState();
}

class _VendaFormCabelcalhoState extends State<VendaFormCabelcalho> {
  late final Object? regUpd;
  final _form = GlobalKey<FormState>();
  final Map<String, String> _formData = {};

  void _loadFormData(Object? regUpd) {
    //print("Antes de testar o produto  ");
    if (regUpd != null) {
      Venda venda = regUpd as Venda;
      _formData['nrPed'] = venda.nrPed;
      _formData['dtPed'] = venda.dtPed.toString();
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
      _form.currentState!.save(); // Chama o metodos save de cada um do campos (TextFormField)

      Venda venda = regUpd as Venda;
      venda.nrPed = _formData["nrPed"] as String;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppBar appBar = AppBar(
      title: Text('Cabeçalho da Venda'),
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: () {
          save();
        },
      ),
    );
    return UtilForm.getFormContainerPadraoAppCustom(
        appBar,
        Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _formData['nrPed'],
                decoration: InputDecoration(
                    labelText:
                        'Número do Pedido' /* , fillColor: Util.backColorPadrao, filled: true */),
                validator: (value) {
                  return UtilForm.valTextFormField(
                      valor: value.toString(), mandatorio: true, tamMax: 8);
                },
                onSaved: (value) => _formData['nrPed'] = value!,
              )
            ],
          ),
        ));
  }
}
