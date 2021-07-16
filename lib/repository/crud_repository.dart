import 'dart:math';

import 'package:pedido_facil/models/IData.dart';
import 'package:pedido_facil/models/produto.dart';

import 'i_crud_repository.dart';

class CrudLocalStorage extends ICrudRepository {
  final String dataSrc;
  final Map<String, Object> itens;

  CrudLocalStorage(this.dataSrc, this.itens);

  Map<String, Object> get allMap => itens;

  List<IData> get all {
    return [...itens.values] as List<IData>;
  }

/*   int get count {
    return _itens.length;
  } */

  add(IData newReg) {
    final nextId = Random().nextDouble().toString();
    itens.putIfAbsent(nextId, () => newReg);
  }

  update(IData oldReg, IData newReg) {
    newReg as Produto;
    print("Prod Update: " + oldReg.id + " - " + newReg.nm);
    //_itens.update(oldReg.id, (value) => newReg);
    itens.update(
        oldReg.id,
        (value) => Produto(
            id: newReg.id,
            nm: newReg.nm,
            vlCompra: newReg.vlCompra,
            vlVenda: newReg.vlVenda,
            detalhe: newReg.detalhe));
  }

  void remove(IData item) {
    if (item.id.trim().isNotEmpty) {
      itens.remove(item.id);
    }
  }
}
