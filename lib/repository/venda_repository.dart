import 'package:pedido_facil/data/dummy_vendas.dart';

import 'crud_repository.dart';

class VendaRepository extends CrudLocalStorage {
  VendaRepository() : super('venda', {...Dummy_vendas});
}
