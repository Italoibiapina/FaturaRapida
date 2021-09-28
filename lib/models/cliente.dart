import 'package:flutter/material.dart';
import 'package:pedido_facil/util/util_model.dart';

import 'IData.dart';

class Cliente extends IData {
  //final String id;
  String nm;
  double? fone;
  String? email;
  DateTime? dtNasc;
  final int nrPed;
  final double vlTotPed;
  Image? foto;

  Cliente(this.nm, {id, this.fone, this.email, this.dtNasc, this.foto, this.nrPed = 0, this.vlTotPed = 0})
      : super(id: id);

  Cliente clone() {
    return Cliente(nm, id: id, fone: fone, email: email, dtNasc: dtNasc, foto: foto, nrPed: nrPed, vlTotPed: vlTotPed);
  }

  getNmIniciais() => UtilModel.getNmIniciais(this.nm);
}
