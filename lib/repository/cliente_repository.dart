import 'package:pedido_facil/data/dummy_clientes.dart';

import 'crud_repository.dart';

class ClienteRepository extends CrudLocalStorage {
  ClienteRepository() : super('cliente', {...Dummy_clientes});
}
