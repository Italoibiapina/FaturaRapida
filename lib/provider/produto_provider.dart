import 'package:pedido_facil/models/produto.dart';
import 'package:pedido_facil/repository/i_crud_repository.dart';
import 'package:pedido_facil/repository/produto_repository.dart';
/* import 'package:pedido_facil/repository/produto_repository.dart'; */

import 'crud_provider.dart';

class ProdutoProvider extends CrudProvider {
  /* final rep = CrudLocalStorage('produto');
  final Map<String, Object> _itens = {...Dummy_produtos}; */

  ProdutoProvider(ICrudRepository repository) : super(repository);

  List<Produto> get all {
    return [...itens.values] as List<Produto>;
  }

  Produto byIndex(int i) {
    return itens.values.elementAt(i) as Produto;
  }

  static List<Produto> sugestion(query) {
    final ProdutoRepository repositoryStatic = ProdutoRepository();
    var lst = repositoryStatic.allMap;
    List<Produto> lstProds = lst.values.map((s) => s as Produto).toList();
    lstProds = lstProds.where((produto) {
/*       Produto produto = element as Produto; */
      final nmLowerCase = produto.nm.toLowerCase();
      final queryLowerCase = query.toLowerCase();
      return nmLowerCase.contains(queryLowerCase);
    }).toList();
    //print('Qtd regs .....................: ' + lstProds.length.toString());
    return lstProds;
  }
}
