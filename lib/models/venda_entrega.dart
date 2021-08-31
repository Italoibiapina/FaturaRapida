import 'IData.dart';
import 'venda_item.dart';

class VendaEntrega extends IData {
  DateTime dtEntrega;
  List<VendaItem> itenEntregues;
  String entreguePara;
  String obs;

  int get totItensEntregues {
    return this.itenEntregues.fold(0, (sum, VendaItem item) => sum + item.qtdEntregue); // sum é o acumulador
  }

  int qtdItensEntreguesByProdId(String prodId) {
    return this.itenEntregues.fold(0, (sum, VendaItem item) {
      return prodId == item.prod.id ? sum + item.qtdEntregue : sum;
    });
  }

  VendaEntrega({
    id,
    required this.dtEntrega,
    required this.itenEntregues,
    required this.entreguePara,
    this.obs = '',
  }) : super(id: id);

  VendaEntrega clone() {
    return VendaEntrega(
      id: id,
      dtEntrega: dtEntrega,
      itenEntregues: itenEntregues,
      entreguePara: entreguePara,
      obs: obs,
    );
  }
}
