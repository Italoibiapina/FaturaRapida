import 'package:flutter/material.dart';
import 'package:pedido_facil/util/util_model.dart';

import 'IData.dart';

class Produto extends IData {
  //final String id;
  final String nm;
  final double vlVenda;
  final double vlCusto;
  final int? diasConsumo;
  final String detalhe;
  final Image? foto;

  Produto({
    id,
    required this.nm,
    required this.vlVenda,
    this.vlCusto = 0,
    this.detalhe = '',
    this.foto,
    this.diasConsumo,
  }) : super(id: id);

  Produto clone() {
    return Produto(id: id, nm: nm, vlCusto: vlCusto, vlVenda: vlVenda, detalhe: detalhe);
  }

  getNmIniciais() => UtilModel.getNmIniciais(this.nm);
}
