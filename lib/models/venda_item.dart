import 'package:pedido_facil/models/produto.dart';

import 'IData.dart';

class VendaItem extends IData {
  late final Produto prod;
  late int qtd;
  int qtdEntregue;

  double get vlTot {
    return prod.vlVenda * qtd;
  }

  VendaItem({
    id,
    required this.prod,
    this.qtd = 1,
    this.qtdEntregue = 0,
  }) : super(id: id);

  VendaItem clone() {
    return VendaItem(
      id: id,
      prod: prod,
      qtd: qtd,
      qtdEntregue: qtdEntregue,
    );
  }
}
