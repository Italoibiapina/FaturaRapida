import 'package:pedido_facil/models/cliente.dart';
import 'package:pedido_facil/models/venda.dart';
import 'package:pedido_facil/repository/i_crud_repository.dart';

import 'crud_provider.dart';

class VendaProvider extends CrudProvider {
  VendaProvider(ICrudRepository repository) : super(repository);

  List get all {
    return [...itens.values];
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
    var vendasCli = itens.values.where((element) {
      var vVenda = element as Venda;
      return vendaDesconsiderar.nrPed != vVenda.nrPed && vVenda.cli.id == cliente.id;
    }).toList();
    return vendasCli;
  }
}
