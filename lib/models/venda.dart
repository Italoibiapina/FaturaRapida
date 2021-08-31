import 'package:pedido_facil/models/cliente.dart';
import 'package:pedido_facil/models/venda_item.dart';
import 'package:pedido_facil/models/venda_pagamento.dart';

import 'IData.dart';
import 'venda_entrega.dart';

class Venda extends IData {
  late String nrPed;
  late DateTime dtPed;
  final DateTime? dtVencPed;
  late Cliente cli;
  List<VendaItem> itens;
  List<VendaPagamento> pagtos;
  List<VendaEntrega> entregas;
  double vlDesconto;
  double vlFrete;
  String dsEnd;
  final bool isPago;
  final bool isEnt;

  Venda(
      {id,
      required this.nrPed,
      required this.dtPed,
      this.dtVencPed,
      required this.cli,
      required this.itens,
      required this.isPago,
      required this.isEnt,
      required this.pagtos,
      required this.entregas,
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
        pagtos: pagtos,
        entregas: entregas,
        isPago: isPago,
        isEnt: isEnt);
  }

  double get vlTotItens {
    return this.itens.fold(0, (sum, VendaItem item) => sum + item.vlTot); // sum é o acumulador
  }

  double get vlTotPg {
    return this.pagtos.fold(0, (sum, VendaPagamento pgto) => sum + pgto.vlPgto);
  }

  int get qtdItens {
    return this.itens.fold(0, (sum, VendaItem item) => sum + item.qtd);
  }

  int get qtdItensEntregues {
    return this.entregas.fold(0, (sum, VendaEntrega entrega) => sum + entrega.totItensEntregues);
  }

  double get vlTotGeral {
    return (vlTotItens + vlFrete) - (vlDesconto + vlTotPg);
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

  removeItemVenda(VendaItem vendaItem) {
    itens = itens.where((i) => i.id != vendaItem.id).toList();
  }

  removePagtoVenda(VendaPagamento vendaPgto) {
    pagtos = pagtos.where((i) => i.id != vendaPgto.id).toList();
  }

  removeEntregaVenda(VendaEntrega vendaEntrega) {
    entregas = entregas.where((i) => i.id != vendaEntrega.id).toList();
  }
}
