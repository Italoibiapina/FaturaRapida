import 'package:flutter/material.dart';
import 'package:pedido_facil/util/util_model.dart';

import 'IData.dart';

class Cliente extends IData {
  //final String id;
  final String nm;
  double? fone;
  String? email;
  final int nrPed;
  final double vlTotPed;
  Image? foto;

  Cliente(
      {id, required this.nm, this.fone, this.email, this.foto, this.nrPed = 0, this.vlTotPed = 0})
      : super(id: id);

  Cliente clone() {
    return Cliente(
        id: id, nm: nm, fone: fone, email: email, foto: foto, nrPed: nrPed, vlTotPed: vlTotPed);
  }

  getNmIniciais() => UtilModel.getNmIniciais(this.nm);
}
