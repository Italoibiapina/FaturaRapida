import 'package:pedido_facil/models/cliente.dart';
import 'package:pedido_facil/models/venda_item.dart';

import 'IData.dart';

class Venda extends IData {
  late String nrPed;
  late DateTime dtPed;
  final DateTime? dtVencPed;
  late Cliente cli;
  List<VendaItem> itens;
  double vlDesconto;
  double vlFrete;
  String dsEnd;
  final bool isPago;
  final bool isEnt;

  double get vlTotPed {
    return 0.0;
  }

  String get statusPagto {
    if (this.isPago)
      return "Pago";
    else if (!this.isPago) return " Pendente";
    return "";
  }

  String get statusEntrega {
    if (this.isEnt)
      return "Entregue";
    else if (!this.isPago) return "Pendente";
    return "";
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

  Venda(
      {id,
      required this.nrPed,
      required this.dtPed,
      this.dtVencPed,
      required this.cli,
      required this.itens,
      required this.isPago,
      required this.isEnt,
      this.vlDesconto = 0.0,
      this.vlFrete = 0.0,
      this.dsEnd = ''})
      : super(id: id);

  Venda clone() {
    return Venda(
        id: id,
        nrPed: nrPed,
        dtPed: dtPed,
        dtVencPed: dtVencPed,
        cli: cli,
        itens: itens,
        isPago: isPago,
        isEnt: isEnt);
  }

  removeItemVenda(VendaItem vendaItem) {
    itens = itens.where((i) => i.id != vendaItem.id).toList();
  }
}
