import 'package:flutter/cupertino.dart';

import 'IData.dart';

class Produto extends IData {
  //final String id;
  final String nm;
  final double vlVenda;
  final double vlCompra;
  final int? diasConsumo;
  final String detalhe;
  final Image? foto;

  Produto({
    id,
    required this.nm,
    required this.vlVenda,
    this.vlCompra = 0,
    this.detalhe = '',
    this.foto,
    this.diasConsumo,
  }) : super(id: id);

  Produto clone() {
    return Produto(id: id, nm: nm, vlCompra: vlCompra, vlVenda: vlVenda, detalhe: detalhe);
  }

  getNmIniciais() {
    var nomes = this.nm.split(' ');
    var vIniciais = nomes.length > 1
        ? nomes[0].substring(0, 1).toString() + nomes[1].substring(0, 1).toString()
        : nomes[0].substring(0, 2);
    return vIniciais;
  }
}
