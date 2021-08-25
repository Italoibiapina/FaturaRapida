import 'package:pedido_facil/models/meio_pagamento.dart';
import 'package:pedido_facil/repository/i_crud_repository.dart';

import 'crud_provider.dart';

class MeioPagamentoProvider extends CrudProvider {
  MeioPagamentoProvider(ICrudRepository repository) : super(repository);

  List<MeioPagamento> get all {
    return [...itens.values] as List<MeioPagamento>;
  }
}
