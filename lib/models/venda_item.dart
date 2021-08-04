import 'package:pedido_facil/models/produto.dart';

import 'IData.dart';

class VendaItem extends IData {
  final Produto prod;
  final int qtd;

  double get vlTot {
    return prod.vlVenda * qtd;
  }

  VendaItem({
    id,
    required this.prod,
    required this.qtd,
  }) : super(id: id);

  VendaItem clone() {
    return VendaItem(
      id: id,
      prod: prod,
      qtd: qtd,
    );
  }
}
