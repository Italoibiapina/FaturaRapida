import 'package:flutter/material.dart';
import 'package:pedido_facil/models/produto.dart';
import 'package:pedido_facil/provider/produto_provider.dart';
import 'package:pedido_facil/util/util.dart';
import 'package:pedido_facil/util/util_list_tile.dart';
import 'package:pedido_facil/view/produto/produto_form.dart';
import 'package:pedido_facil/widget/projWidget/helper_classes.dart';
import 'package:pedido_facil/widget/projWidget/pj_page_Scaffold.dart';
import 'package:provider/provider.dart';

class ProdutoList extends StatelessWidget {
  const ProdutoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final ProdutoProvider prods = Provider.of(context);
    final ProdutoProvider prodProvider = Provider.of(context);

    final PjTopBarListActionCenterHelper topBarActionHelper = getTopListAction(context);
    final PjTituloListHelper tituloLista = PjTituloListHelper(textActEsq: 'Nome do Produto', textActDir: 'Preço Venda');
    final PjListaDadosHelper listaDadosHelper = getListaDadosHelper(prodProvider);

    return PjPageListaScaffoldList(
      titulo: 'Produtos',
      children: [
        Column(children: [topBarActionHelper.getWidget()]),
        Column(children: [tituloLista.getWidget(), listaDadosHelper.getWidget()]),
      ],
    );

    /* return Scaffold(
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
        itemBuilder: (ctx, i) => ProdutoTile(produto: prods.byIndex(i)), // Text(prods.values.elementAt(i).nm),
      ),
    ); */
  }

  PjTopBarListActionCenterHelper getTopListAction(context) {
    return PjTopBarListActionCenterHelper('Adicionar Produto', () {
      _callNovoRegistro(context);
    });
  }

  PjListaDadosHelper getListaDadosHelper(ProdutoProvider prodProvider) {
    return PjListaDadosHelper(
      countRecords: prodProvider.count,
      listViewDados: _getListViewProduto(prodProvider),
      msgSemDados: 'Não há produtos cadastrados',
    );
  }

  ListView _getListViewProduto(ProdutoProvider prodProvider) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: prodProvider.count,
        itemBuilder: (BuildContext context, int index) {
          Produto produto = prodProvider.byIndex(index);
          return Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
            decoration: UtilListTile.boxDecorationPadrao,
            child: ListTile(
              contentPadding: UtilListTile.contentPaddingPadrao,
              visualDensity: UtilListTile.visualDensityPadrao,
              onTap: () {
                _callEditRegistro(context, produto);
              },
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                child: Text(produto.getNmIniciais(), style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0)),
              ),
              title: Text(produto.nm, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(produto.detalhe, overflow: TextOverflow.ellipsis),
              trailing: Text(Util.toCurency(produto.vlVenda)),
            ),
          );
        });
  }

  _callNovoRegistro(context) async {
    Produto produto = Produto(nm: '', id: '-1', vlVenda: 0);

    /// onPressed TEM QUE SER com "context, new MaterialPageRoute(builder: ..."
    /// ASSIM POR CONTA DA FORM_VENDA/LISTA_PAGTO esta sendo chamado de uma lista que esta dentro de uma TAB
    await Navigator.push(context, new MaterialPageRoute(builder: (context) => ProdutoForm(produto)));
    //rebuildThisForm();
  }

  _callEditRegistro(context, Produto produto) async {
    /// onPressed TEM QUE SER com "context, new MaterialPageRoute(builder: ..."
    /// ASSIM POR CONTA DA FORM_VENDA/LISTA_PAGTO esta sendo chamado de uma lista que esta dentro de uma TAB
    await Navigator.push(context, new MaterialPageRoute(builder: (context) => ProdutoForm(produto)));
  }
}

/* class ProdutoTile extends StatelessWidget {
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
          child: Text(produto.getNmIniciais(), style: TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0)),
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
                  
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 */