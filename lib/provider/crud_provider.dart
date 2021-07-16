import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pedido_facil/models/IData.dart';
import 'package:pedido_facil/repository/i_crud_repository.dart';

class CrudProvider with ChangeNotifier {
  final ICrudRepository repository;
  late Map<String, Object> itens; // = {...Dummy_produtos};

  CrudProvider(this.repository) {
    itens = this.repository.allMap;
  }

  List get all {
    return [...itens.values];
  }

  int get count {
    return itens.length;
  }

  IData byIndex(int i) {
    return itens.values.elementAt(i) as IData;
  }

  void remove(IData item) {
    if (item.id.trim().isNotEmpty) {
      itens.remove(item.id);
      repository.remove(item);
      notifyListeners();
    }
  }

  void put(IData item) {
    print("Prodiver -> prod.id : " + item.id);

    if (item.id.trim().isNotEmpty && itens.containsKey(item.id)) {
      itens.update(item.id, (value) => item.clone());
      //repository.update(item, item.clone());
    } else {
      final nextId = Random().nextDouble().toString();
      final vClone = item.clone();
      vClone.id = nextId;
      itens.putIfAbsent(nextId, () => vClone);
      //repository.add(vClone); // Par implementar quando estivermos fazendo storage em algum BD ou disco
    }
    notifyListeners();
  }
}
