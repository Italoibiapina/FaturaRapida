import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:pedido_facil/models/venda.dart';
import 'package:pedido_facil/provider/venda_provider.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/util/util_list_tile.dart';
import 'package:provider/provider.dart';

class VendaFormDescFrete extends StatefulWidget {
  const VendaFormDescFrete({Key? key}) : super(key: key);

  @override
  _VendaFormDescFreteState createState() => _VendaFormDescFreteState();
}

class _VendaFormDescFreteState extends State<VendaFormDescFrete> {
  late final Venda? vendaEdit;
  final _form = GlobalKey<FormState>();
  //final Map<String, String> _formData = {};

  selectFrete(Venda vendaSelected) {
    //Atualiza o dados do form
    vlFreteInputControler.updateValue(vendaSelected.vlFrete);
    dsEndEditControler.text = vendaSelected.dsEnd;
  }

  /// Usar este metodos para quando refazer o parte grafica "Build method" não precisar
  /// reexecutar o codigo contido neste metodo.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vendaEdit = ModalRoute.of(context)!.settings.arguments as Venda;
    vlDescInputControler.updateValue(vendaEdit!.vlDesconto);
    vlFreteInputControler.updateValue(vendaEdit!.vlFrete);
    dsEndEditControler.text = vendaEdit!.dsEnd;
  }

  save() {
    final bool isValid = _form.currentState!.validate();
    if (isValid) {
      _form.currentState!.save(); // Chama o metodos save de cada um do campos (TextFormField)

      vendaEdit!.vlDesconto = vlDescInputControler.numberValue;
      vendaEdit!.vlFrete = vlFreteInputControler.numberValue;
      vendaEdit!.dsEnd = dsEndEditControler.text;
      Navigator.of(context).pop();
    }
  }

  final vlDescInputControler = MoneyMaskedTextController(leftSymbol: 'R\$ ');
  final vlFreteInputControler = MoneyMaskedTextController(leftSymbol: 'R\$ ');
  final dsEndEditControler = TextEditingController();

  final labelStyle = TextStyle(fontSize: 16, color: Colors.grey);
  final labelStyleFloat = TextStyle(fontSize: 20, color: Colors.grey);
  final paddingField = EdgeInsets.only(left: Util.paddingFormPadrao, right: Util.paddingFormPadrao);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VendaProvider>(context, listen: false);
    late List vendasCli = <Venda>[];
    if (vendaEdit != null) vendasCli = provider.byCliente(vendaEdit!.cli, vendaEdit!);

    final AppBar appBar = AppBar(
      title: Text('Desconto e Valor Entrega'),
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back),
        onPressed: () => save(),
      ),
    );
    return Scaffold(
      backgroundColor: Util.backColorPadrao,
      appBar: appBar,
      body: ListView(
        padding: const EdgeInsets.all(Util.marginScreenPadrao),
        children: [
          UtilFomrDescFrete.getBlockData(
              marginTop: false,
              //height: 180,
              child: Form(
                key: _form,
                child: Column(
                  children: [
                    Container(
                      padding: paddingField,
                      child: TextFormField(
                        autofocus: true,
                        controller: vlDescInputControler,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          //labelText: 'Valor de Desconto',
                          //labelStyle: lebelStyle,
                          border: InputBorder.none,
                          prefixText: 'Desconto:',
                          prefixStyle: labelStyle,
                        ),
                      ),
                    ),
                    Container(
                      //width: 150,
                      padding: paddingField,
                      //decoration: UtilListTile.boxDecorationPadrao,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: vlFreteInputControler,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixText: 'Valor da entrega:',
                          prefixStyle: labelStyle,
                        ),
                      ),
                    ),
                    Container(
                      padding: paddingField,
                      child: TextFormField(
                        /* initialValue: _formData['dsEnd'],
                        onSaved: (value) => _formData['dsEnd'] = value!, */
                        controller: dsEndEditControler,
                        keyboardType: TextInputType.multiline,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Endereço da Entrega:',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: labelStyleFloat,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          UtilFomrDescFrete.getBlockData(
            child: vendasCli.length > 0
                ? ListView.builder(
                    shrinkWrap: true, //para expandir o widget Pai
                    itemCount: vendasCli.length > 0 ? vendasCli.length + 1 : vendasCli.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) return UtilFomrDescFrete.getTituloListHist();
                      index -= 1;
                      return UtilFomrDescFrete.getListHistTile(vendasCli[index], selectFrete);
                    },
                  )
                : const Center(child: Text('No items')),
            //),
          ),
        ],
      ),
    );
  }
}

class UtilFomrDescFrete {
  static Container getTituloListHist() {
    return Container(
      height: 28,
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey.shade300))),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Histórico Pagamento de Entrega', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))
      ]),
    );
  }

  static Container getListHistTile(Venda venda, Function selectFrete) {
    return Container(
      decoration: UtilListTile.boxDecorationPadrao,
      child: InkWell(
          child: ListTile(
            contentPadding: UtilListTile.contentPaddingPadrao,
            visualDensity: UtilListTile.visualDensityPadrao,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(venda.nrPed + ' - ' + Util.toDateFormat(venda.dtPed)),
                Text(Util.toCurency(venda.vlFrete))
              ],
            ),
            subtitle: Text(venda.dsEnd, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          onTap: () async {
            selectFrete(venda);
          }),
    );
  }

  static Container getBlockData({double? height, bool? marginTop, child, double? padding}) {
    height = height == null ? 50 : height;
    marginTop = marginTop == null ? true : marginTop;
    double _marginTopVl = marginTop ? Util.marginScreenPadrao : 0.0;
    padding = padding == null ? 0.0 : padding;
    return Container(
      //height: height,
      margin: EdgeInsets.only(top: _marginTopVl),
      padding: EdgeInsets.only(left: padding, right: padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(const Radius.circular(Util.borderRadiousPadrao)),
      ),
      child: child,
    );
  }
}
