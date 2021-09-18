import 'package:flutter/material.dart';

final _containerHeightButton = 35.0;

// ignore: slash_for_doc_comments
/******* TopBarList Helper *******/
class PjTopBarListActionHelper {
  final String textActEsq;
  final Function actFncEsq;
  final String? textActDir;
  final Function? actFncDir;

  PjTopBarListActionHelper({required this.textActEsq, required this.actFncEsq, this.textActDir, this.actFncDir});

  //static final _containerHeightButton = 35.0;
  ButtonStyle _btStyle =
      TextButton.styleFrom(padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0, bottom: 0.0));

  List<Widget> _getActionsLinks() {
    final List<Widget> actionsLinks = List<Widget>.empty(growable: true);
    final textLinkEsq = Text(textActEsq, style: TextStyle(color: Colors.green));
    final TextButtonEsq = TextButton(style: _btStyle, onPressed: () => actFncEsq(), child: textLinkEsq);
    final linkEsq = Container(height: _containerHeightButton, child: TextButtonEsq);
    actionsLinks.add(linkEsq);

    if (textActDir != null) {
      final textLinkDir = Text(textActDir!, style: TextStyle(color: Colors.green));
      final TextButtonDir = TextButton(style: _btStyle, onPressed: () => actFncDir!(), child: textLinkDir);
      final linkDir = Container(height: _containerHeightButton, child: TextButtonDir);
      actionsLinks.add(linkDir);
    }
    return actionsLinks;
  }

  Widget getWidget() {
    final List<Widget> actionsLinks = _getActionsLinks();
    return Container(
      height: 30,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: actionsLinks,
      ),
    );
  }
}

// ignore: slash_for_doc_comments
/******* Listar Dados Helper *******/
class PjListaDadosHelper {
  final int countRecords;
  final ListView listViewDados;
  String? msgSemDados;

  PjListaDadosHelper({required this.countRecords, required this.listViewDados, this.msgSemDados});

  Center _getNoDataFoundCenterText() {
    String vMsg = msgSemDados.toString() == '' ? 'Nenhum dados encontrado' : msgSemDados.toString();
    final Text texto = Text(vMsg);
    Center centerText = Center(child: texto);
    return centerText;
  }

  Widget getWidget() {
    return Container(
        color: Colors.white,
        child: countRecords == 0
            ? Container(
                height: 40,
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(width: 1.0, color: Colors.grey.shade200),
                )),
                child: _getNoDataFoundCenterText(),
              )
            : listViewDados);
  }
}

class PjBarraSumarizadoraHelper {
  final String labelEsq;
  final String labelDir;
  Color? backColor;
  Color? foreColor;
  FontWeight? fontWeight;

  PjBarraSumarizadoraHelper(
      {required this.labelEsq, required this.labelDir, this.backColor, this.foreColor, this.fontWeight});

  final double radious = 5.0;

  Container getWidget() {
    backColor ??= Colors.grey.shade400;
    foreColor ??= Colors.white;
    fontWeight ??= FontWeight.w500;

    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(radious), bottomRight: Radius.circular(radious)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              padding: EdgeInsets.all(7),
              height: _containerHeightButton,
              child: Text(labelEsq, style: TextStyle(color: foreColor, fontWeight: fontWeight))),
          Container(
              padding: EdgeInsets.all(7),
              height: _containerHeightButton,
              child: Text(labelDir, style: TextStyle(color: foreColor, fontWeight: fontWeight))),
        ],
      ),
    );
  }
}
