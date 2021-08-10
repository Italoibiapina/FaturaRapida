import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pedido_facil/models/venda.dart';
import 'package:pedido_facil/util/util_form.dart';

class VendaFormDescFrete extends StatefulWidget {
  const VendaFormDescFrete({Key? key}) : super(key: key);

  @override
  _VendaFormDescFreteState createState() => _VendaFormDescFreteState();
}

class _VendaFormDescFreteState extends State<VendaFormDescFrete> {
  late final Object? regUpd;
  final _form = GlobalKey<FormState>();
  //final Map<String, String> _formData = {};

  void _loadFormData(Object? regUpd) {
    if (regUpd != null) {
      Venda venda = regUpd as Venda;
      vlDescInputControler.updateValue(venda.vlDesconto);
      vlFreteInputControler.updateValue(venda.vlFrete);
      //_formData['vlDesc'] = venda.vlDesconto.toString(); //Util.toCurency(venda.vlDesconto);
      //_formData['vlFrete'] = venda.vlFrete.toString(); //Util.toCurency(venda.vlFrete);
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
      venda.vlDesconto =
          vlDescInputControler.numberValue; //double.parse(_formData["vlDesc"].toString());
      venda.vlFrete =
          vlFreteInputControler.numberValue; //double.parse(_formData["vlFrete"].toString());
      Navigator.of(context).pop();
    }
  }

  final vlDescInputControler = MoneyMaskedTextController(leftSymbol: 'R\$ ');
  final vlFreteInputControler = MoneyMaskedTextController(leftSymbol: 'R\$ ');

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
                controller: vlDescInputControler,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                decoration: InputDecoration(labelText: 'Valor de Desconto'),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: vlFreteInputControler,
                textAlign: TextAlign.right,
                decoration: InputDecoration(labelText: 'Valor de Frete'),
              ),
            ],
          ),
        ));
  }
}
