import 'package:pedido_facil/data/dummy_produtos.dart';

import 'crud_repository.dart';

class ProdutoRepository extends CrudLocalStorage {
  ProdutoRepository() : super('produto', {...Dummy_produtos});
}
