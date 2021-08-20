import 'package:flutter/material.dart';
import 'package:pedido_facil/util/util.dart';

class UtilForm {
  static String? valTextFormField(
      {required String valor,
      bool mandatorio = false,
      bool numerico = false,
      bool decimal = true,
      int tamMax = 20,
      int tamMin = 0}) {
    List<String> lstErros = [];

    var vRet;
    if (mandatorio == true) {
      vRet = UtilForm._valMandatorio(valor);
      if (vRet != null) lstErros.add(vRet);
    }

    if (numerico == true) {
      if (decimal == true) {
        vRet = UtilForm._valNumDec(valor.toString());
      } else {
        vRet = UtilForm._valNumInt(valor.toString());
      }
      if (vRet != null) lstErros.add(vRet);
    }

    vRet = UtilForm._valTamMax(valor.toString(), tamMax);
    if (vRet != null) lstErros.add(vRet);

    vRet = UtilForm._valTamMin(valor.toString(), tamMin);
    if (vRet != null) lstErros.add(vRet);

    String vVirg = '';
    String vRetAll = "";
    lstErros.forEach((element) {
      vRetAll += vVirg + element;
      vVirg = ', ';
    });

    return vRetAll == '' ? null : vRetAll;
  }

  static String? _valMandatorio(String? valor) {
    return valor == null || valor.trim().isEmpty || valor.trim().toString() == ""
        ? 'Por favor informa um valor  '
        : null;
  }

  static String? _valNumDec(String valor) {
    final isDigitsOnly = double.tryParse(valor);
    return isDigitsOnly == null ? 'Por favor informar apenas números' : null;
  }

  static String? _valNumInt(String valor) {
    final isDigitsOnly = int.tryParse(valor);
    return isDigitsOnly == null ? 'Por favor informar um numérico sem casa decimais' : null;
  }

  static String? _valTamMax(String valor, int tamMax) {
    return valor.length > tamMax ? 'O tamanho máximo de digitos é ' + tamMax.toString() : null;
  }

  static String? _valTamMin(String valor, int tamMin) {
    return valor.length < tamMin ? 'O tamanho minimo de digitos é ' + tamMin.toString() : null;
  }

  static Scaffold getFormContainerPadrao(String tituloForm, saveFnc, deleteFnc, Form form) {
    var _botoes = <Widget>[IconButton(icon: Icon(Icons.save), onPressed: () => saveFnc())];
    if (deleteFnc != null)
      _botoes.add(IconButton(icon: Icon(Icons.delete), onPressed: () => deleteFnc()));

    final AppBar appBar = AppBar(
      title: Text(tituloForm),
      actions: _botoes,
    );

    return getFormContainerPadraoAppCustom(appBar, form);
  }

  static Scaffold getFormContainerPadraoAppCustom(AppBar appBar, Form form) {
    return Scaffold(
        backgroundColor: Util.backColorPadrao,
        appBar: appBar,
        body: Container(
            margin: new EdgeInsets.all(Util.marginScreenPadrao),
            child: Container(
              padding: EdgeInsets.all(Util.paddingFormPadrao),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.circular(Util.borderRadiousPadrao)),
              child: form,
            )));
  }

  static showDialogSimNao(
      context, String titulo, String msg, Function fncConf, Function fncNaoConf) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titulo),
        content: Text(msg),
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
        //provider.remove(regUpd);
        fncConf();
      } else
        fncNaoConf();
    });
  }

  static showDialogEditarDescartar(context, String titulo, String msg, Function fncDescartar) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(titulo),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            child: Text("Descartar"),
            onPressed: () async {
              Navigator.of(context).pop(true); // fecha pop de pergunta
            },
          ),
          TextButton(
            child: Text("Editar"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    ).then((confirmed) async {
      if (confirmed) {
        await fncDescartar();
      }
    });
  }
}
