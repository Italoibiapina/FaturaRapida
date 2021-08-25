import 'package:pedido_facil/data/dummy_meio_pagto.dart';

import 'crud_repository.dart';

class MeioPagamentoRepository extends CrudLocalStorage {
  MeioPagamentoRepository() : super('MeioPagto', {...dummy_meio_pagto});
}
