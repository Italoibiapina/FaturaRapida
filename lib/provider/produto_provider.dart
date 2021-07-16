import 'package:pedido_facil/models/produto.dart';
import 'package:pedido_facil/repository/produto_repository.dart';

import 'crud_provider.dart';

class ProdutoProvider extends CrudProvider {
  /* final rep = CrudLocalStorage('produto');
  final Map<String, Object> _itens = {...Dummy_produtos}; */

  ProdutoProvider() : super(ProdutoRepository());

  List<Produto> get all {
    return [...itens.values] as List<Produto>;
  }

  Produto byIndex(int i) {
    return itens.values.elementAt(i) as Produto;
  }
}
