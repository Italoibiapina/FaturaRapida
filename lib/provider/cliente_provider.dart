import 'package:pedido_facil/models/cliente.dart';
import 'package:pedido_facil/repository/i_crud_repository.dart';

import 'crud_provider.dart';

class ClienteProvider extends CrudProvider {
  ClienteProvider(ICrudRepository repository) : super(repository);

  List<Cliente> get all {
    return [...itens.values] as List<Cliente>;
  }

  Cliente byIndex(int i) {
    return itens.values.elementAt(i) as Cliente;
  }
}
