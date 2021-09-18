import 'package:pedido_facil/models/cliente.dart';
import 'package:pedido_facil/models/venda.dart';
import 'package:pedido_facil/repository/i_crud_repository.dart';

import 'crud_provider.dart';

class VendaProvider extends CrudProvider {
  VendaProvider(ICrudRepository repository) : super(repository);

  List get all {
    return [...itens.values];
  }

  String get nextNrPed {
    String nrNextPed = '001';
    if (itens.values.length > 0) {
      Venda ultVenda = itens.values.last as Venda;
      int nrNextPedInt = int.parse(ultVenda.nrPed.substring(3));
      nrNextPedInt++;
      nrNextPed = nrNextPedInt.toString().padLeft(3, '0');
    }
    return 'PED' + nrNextPed;
  }

  List get pend {
    var vendaPend = itens.values.where((element) {
      var vVenda = element as Venda;
      bool vRet = (!vVenda.isPago || !vVenda.isEnt);
      return vRet;
    }).toList();
    return vendaPend;
  }

  List get pagas {
    var vendaPend = itens.values.where((element) {
      var vVenda = element as Venda;
      bool vRet = vVenda.isPago;
      return vRet;
    }).toList();
    return vendaPend;
  }

  List get entregues {
    var vendaPend = itens.values.where((element) {
      var vVenda = element as Venda;
      bool vRet = vVenda.isEnt;
      return vRet;
    }).toList();
    return vendaPend;
  }

  Venda byIndex(int i) {
    return itens.values.elementAt(i) as Venda;
  }

  List byCliente(Cliente cliente, Venda vendaDesconsiderar) {
    //if (cliente == null) return List<Venda>.empty();
    var vendasCli = itens.values.where((element) {
      var vVenda = element as Venda;
      //if (vVenda.cli == null) return false;
      return vendaDesconsiderar.nrPed != vVenda.nrPed && vVenda.cli.id == cliente.id;
    }).toList();
    return vendasCli;
  }
}
