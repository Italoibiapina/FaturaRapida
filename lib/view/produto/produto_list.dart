import 'package:flutter/material.dart';
import 'package:pedido_facil/models/produto.dart';
import 'package:pedido_facil/provider/produto_provider.dart';
import 'package:pedido_facil/routes/app_routes.dart';
import 'package:pedido_facil/util/util.dart';
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
        body: Container(
          margin: new EdgeInsets.all(Util.marginScreenPadrao),
          child: Container(
            padding: EdgeInsets.only(top: Util.paddingListTopPadrao),
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius:
                    new BorderRadius.circular(Util.borderRadiousPadrao)),
            child: ListView.builder(
              itemCount: prods.count,
              itemBuilder: (ctx, i) => PordutoTile(
                  produto:
                      prods.byIndex(i)), // Text(prods.values.elementAt(i).nm),
            ),
          ),
        ));
  }
}

class PordutoTile extends StatelessWidget {
  final Produto produto;
  const PordutoTile({Key? key, required this.produto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: Text(produto.getNmIniciais(),
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0)),
      ),
      title: Text(produto.nm),
      subtitle: Text(Util.toCurency(produto.vlVenda)),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(AppRoutes.PRODUTO_FORM, arguments: produto);
                },
                color: Colors.orangeAccent),
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
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
                      // o provider abaixo não vai ser notificado, mas o provider da lista vai.
                      Provider.of<ProdutoProvider>(context, listen: false)
                          .remove(produto);
                    }
                  });
                },
                color: Colors.redAccent),
          ],
        ),
      ),
    );
  }
}
