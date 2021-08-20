import 'package:flutter/material.dart';
import 'package:pedido_facil/models/produto.dart';
import 'package:pedido_facil/provider/produto_provider.dart';
import 'package:pedido_facil/routes/app_routes.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/util/util_form.dart';
import 'package:pedido_facil/util/util_list_tile.dart';
import 'package:provider/provider.dart';

class ProdutoList extends StatelessWidget {
  const ProdutoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProdutoProvider prods = Provider.of(context);

    return Scaffold(
      backgroundColor: Util.backColorPadrao,
      appBar: AppBar(
        title: Text('Lista de Produtos'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.PRODUTO_FORM);
              }),
        ],
      ),
      body: ListView.builder(
        itemCount: prods.count,
        itemBuilder: (ctx, i) =>
            ProdutoTile(produto: prods.byIndex(i)), // Text(prods.values.elementAt(i).nm),
      ),
    );
  }
}

class ProdutoTile extends StatelessWidget {
  final Produto produto;
  const ProdutoTile({Key? key, required this.produto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: UtilListTile.boxDecorationPadrao,
      child: ListTile(
        contentPadding: UtilListTile.contentPaddingPadrao, // reduz o tamanho do left e do right
        visualDensity: UtilListTile.visualDensityPadrao, // padding tanto vertical e horzontal
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          child: Text(produto.getNmIniciais(),
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0)),
        ),
        title: Text(produto.nm, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(Util.toCurency(produto.vlVenda)),
        trailing: Container(
          width: 100,
          child: Row(
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.PRODUTO_FORM, arguments: produto);
                  },
                  color: Colors.orangeAccent),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.redAccent,
                onPressed: () {
                  UtilForm.showDialogSimNao(
                    context,
                    "Excluir Usuário",
                    "Tem certeza que gostaria de excluir?",
                    () {
                      // A remoção b'ao vai gerar notificao (redesenhar a lista, por conta do parametro "listen: false"
                      Provider.of<ProdutoProvider>(context, listen: false).remove(produto);
                    },
                    () => {},
                  );
                  /* showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Excluir Usuário"),
                      content: Text("Tem certeza que gostaria de excluir?"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Não"),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: Text("Sim"),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    ),
                  ).then((confirmed) {
                    if (confirmed) {
                      // A remoção b'ao vai gerar notificao (redesenhar a lista, por conta do parametro "listen: false"
                      Provider.of<ProdutoProvider>(context, listen: false).remove(produto);
                    }
                  });*/
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
