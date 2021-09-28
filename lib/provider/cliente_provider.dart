import 'package:pedido_facil/models/cliente.dart';
import 'package:pedido_facil/repository/i_crud_repository.dart';

import 'crud_provider.dart';

class ClienteProvider extends CrudProvider {
  ClienteProvider(ICrudRepository repository) : super(repository);

  List<Cliente> get all {
    List<Cliente> lista = List<Cliente>.empty(growable: true);
    [...itens.values].forEach((element) {
      lista.add(element as Cliente);
    });
    //[...itens.values].map((e) => lista.add(e as Cliente));

    return lista;
  }

  Cliente byIndex(int i) {
    return itens.values.elementAt(i) as Cliente;
  }
}
