import 'package:pedido_facil/models/cliente.dart';

import 'IData.dart';

class Venda extends IData {
  final String nrPed;
  final DateTime dtPed;
  final DateTime? dtVencPed;
  final Cliente cli;
  final bool isPago;
  final bool isEnt;

  double get vlTotPed {
    return 0.0;
  }

  String get status {
    if (this.isPago && this.isEnt)
      return "Pago e Entregue";
    else if (!this.isPago && !this.isEnt)
      return " Pagto e Entrega pendente";
    else if (this.isPago && !this.isEnt)
      return "Entrega pendente";
    else if (!this.isPago && this.isEnt) return "Pagto pendente";
    return "";
  }

  Venda({
    id,
    required this.nrPed,
    required this.dtPed,
    this.dtVencPed,
    required this.cli,
    required this.isPago,
    required this.isEnt,
  }) : super(id: id);

  Venda clone() {
    return Venda(
        id: id,
        nrPed: nrPed,
        dtPed: dtPed,
        dtVencPed: dtVencPed,
        cli: cli,
        isPago: isPago,
        isEnt: isEnt);
  }
}
