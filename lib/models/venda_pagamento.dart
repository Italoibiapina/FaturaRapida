import 'IData.dart';
import 'meio_pagamento.dart';

class VendaPagamento extends IData {
  double vlPgto;
  DateTime dtPagto;
  MeioPagamento meioPagto;

  VendaPagamento({
    id,
    required this.vlPgto,
    required this.dtPagto,
    required this.meioPagto,
  }) : super(id: id);

  VendaPagamento clone() {
    return VendaPagamento(
      id: id,
      vlPgto: vlPgto,
      dtPagto: dtPagto,
      meioPagto: meioPagto,
    );
  }
}
