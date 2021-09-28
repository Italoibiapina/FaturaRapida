import 'package:pedido_facil/models/cliente.dart';
import 'package:pedido_facil/models/venda_item.dart';

import 'IData.dart';
import 'meio_pagamento.dart';

class Venda extends IData {
  late String nrPed;
  late DateTime dtPed;
  final DateTime? dtVencPed;
  late Cliente cli;
  late List<VendaItem> _itens;
  late List<VendaPagamento> _pagtos;
  late List<VendaEntrega> _entregas;
  double vlDesconto;
  double vlFrete;
  String dsEnd;
  late bool isPago;
  late bool isEnt;

  late Stream streamItens;

  final vHoje = DateTime.now();

  Venda(
      {id,
      this.nrPed = '',
      dtPed,
      this.dtVencPed,
      cli,
      itens,
      pagtos,
      entregas,
      this.isPago = false,
      this.isEnt = false,
      this.vlDesconto = 0.0,
      this.vlFrete = 0.0,
      this.dsEnd = ''})
      : super(id: id) {
    this.dtPed = dtPed == null ? DateTime.now() : dtPed;
    this.cli = cli != null ? cli : Cliente('Informe o cliente', id: '-1');
    _itens = itens != null ? itens : List<VendaItem>.empty(growable: true);
    _pagtos = pagtos != null ? pagtos : List<VendaPagamento>.empty(growable: true);
    _entregas = entregas != null ? entregas : List<VendaEntrega>.empty(growable: true);
    _calcTotItens();
    _calcQtdItens();
    _calcTotPagtos();
    _calcQtdItensEntregues();

    _pagtos.forEach((VendaPagamento element) {
      element._venda = this;
    });

    _entregas.forEach((VendaEntrega entrega) {
      entrega.addVendaPai(this);
    });

    //_mergeItensVendaItemEntregue();
  }

  Venda clone() {
    return Venda(
        id: id,
        nrPed: nrPed,
        dtPed: dtPed,
        dtVencPed: dtVencPed,
        cli: cli,
        itens: _itens,
        pagtos: _pagtos,
        entregas: _entregas,
        isPago: isPago,
        isEnt: isEnt);
  }

  int get itensCount => _itens.length;
  VendaItem itensByIndex(int i) => _itens[i];

  int get pagtoCount => _pagtos.length;
  VendaPagamento pagtoByIndex(int i) => _pagtos[i];

  int get entregasCount => _entregas.length;
  VendaEntrega entregaByIndex(int i) => _entregas[i];

  double _vlTotItens = 0;
  double get vlTotItens => _vlTotItens;
  _calcTotItens() => _vlTotItens = this._itens.fold(0, (sum, VendaItem item) => sum + item.vlTot);

  int _qtdItens = 0;
  int get qtdItens => _qtdItens;
  _calcQtdItens() => _qtdItens = this._itens.fold(0, (sum, VendaItem item) => sum + item.qtd);

  double _vlTotPg = 0;
  double get vlTotPg => _vlTotPg;
  _calcTotPagtos() => _vlTotPg = this._pagtos.fold(0, (sum, VendaPagamento pgto) => sum + pgto.vlPgto);

  int _qtdItensEntregues = 0;
  int get qtdItensEntregues => _qtdItensEntregues;
  _calcQtdItensEntregues() =>
      _qtdItensEntregues = this._entregas.fold(0, (sum, VendaEntrega entrega) => sum + entrega.totItensEntregues);

  addItem(VendaItem vendaItem) {
    _itens.add(vendaItem);
    _calcTotItens();
  }

  removeItem(VendaItem vendaItem) {
    _itens = _itens.where((i) => i.id != vendaItem.id).toList();
    _calcTotItens();
    _calcQtdItens();

    _entregas.forEach((element) {
      VendaEntrega entrega = element;
      List<VendaItemEntrega> itensEntrega = entrega.itenEntregues.where((i) => i.vendaItem.id != vendaItem.id).toList();
      entrega.itenEntregues = itensEntrega;
      entrega._calcTotItensEntregues();
    });
    _calcQtdItensEntregues();
  }

  addPagto(VendaPagamento vendaPgto) {
    vendaPgto._venda = this;
    _pagtos.add(vendaPgto);
    _calcTotPagtos();
  }

  removePagto(VendaPagamento vendaPgto) {
    _pagtos = _pagtos.where((i) => i.id != vendaPgto.id).toList();
    _calcTotPagtos();
  }

  addEntrega(VendaEntrega vendaEntrega) {
    _entregas.add(vendaEntrega);
    _calcQtdItensEntregues();
  }

  removeEntrega(VendaEntrega vendaEntrega) {
    _entregas = _entregas.where((i) => i.id != vendaEntrega.id).toList();
    _calcQtdItensEntregues();
  }

  double get vlTotGeral => (vlTotItens + vlFrete) - (vlDesconto + vlTotPg);

  String get statusPagto {
    if (this.isPago)
      return "Pago";
    else if (!this.isPago) return " Pendente";
    return "";
  }

  String get statusEntrega {
    if (this.isEnt)
      return "Entregue";
    else if (!this.isPago) return "Pendente";
    return "";
  }

  String get status {
    if (this.isPago && this.isEnt)
      return "Pago e Entregue";
    else if (!this.isPago && !this.isEnt)
      return " Pagto e Entrega pendente";
    else if (this.isPago && !this.isEnt)
      return "Entrega pendente";
    else if (!this.isPago && this.isEnt) return "Pagto pendente";
    return "";
  }
}

///******************** VendaPagamento **********************
class VendaPagamento extends IData {
  late double _vlPgto;
  DateTime dtPagto;
  MeioPagamento meioPagto;
  Venda? _venda;

  VendaPagamento({id, vlPgto = 0.0, required this.dtPagto, required this.meioPagto}) : super(id: id) {
    _vlPgto = vlPgto;
  }

  double get vlPgto => _vlPgto;
  set vlPgto(double vl) {
    _vlPgto = vl;

    if (_venda != null) _venda!._calcTotPagtos();
  }

  VendaPagamento clone() {
    return VendaPagamento(
      id: id,
      vlPgto: vlPgto,
      dtPagto: dtPagto,
      meioPagto: meioPagto,
    );
  }
}

///******************** VendaEntrega **********************
class VendaEntrega extends IData {
  DateTime dtEntrega;
  late List<VendaItemEntrega> itenEntregues;
  String entreguePara;
  String obs;
  int _totItensEntregues = 0;
  Venda? _venda;

  VendaEntrega({
    id,
    required this.dtEntrega,
    required this.itenEntregues,
    required this.entreguePara,
    this.obs = '',
  }) : super(id: id) {
    itenEntregues.forEach((VendaItemEntrega itemEntrega) {
      itemEntrega._entrega = this;
    });
    _calcTotItensEntregues();
  }

  VendaEntrega clone() {
    return VendaEntrega(
            id: id, dtEntrega: dtEntrega, itenEntregues: itenEntregues, entreguePara: entreguePara, obs: obs)
        .addVendaPai(_venda);
  }

  addVendaPai(Venda? venda) {
    if (venda != null) {
      _venda = venda;
      _mergeItensVendaItemEntregue();
    }
  }

// ignore: slash_for_doc_comments
  /** Alimentar os itens da Entrega com as mesma instance do item de venda, para 
   * quando o item entregue editar aqtd, refletir em todas as telas que usam o item de 
   * venda */
  _mergeItensVendaItemEntregue() {
    /** Adicionar itens de Venda que n"ao estavm nos itens da entrega, porém o itens de entrega ficam com qtd entregue na entrega com ZERO  */
    _venda!._itens.forEach((VendaItem itemVenda) {
      bool achou = false;
      itenEntregues.forEach((itemEntrega) {
        if (itemEntrega.id == itemVenda.id) {
          itemEntrega.vendaItem = itemVenda;
          achou = true;
        }
      });
      if (!achou) {
        VendaItemEntrega itemEntrega = VendaItemEntrega(id: itemVenda.id, vendaItem: itemVenda, qtdEntregueEntrega: 0);
        itemEntrega._entrega = this;
        itenEntregues.add(itemEntrega);
      }
    });
  }

  int get itensEntregaCount => itenEntregues.length;
  VendaItemEntrega itemEntregueByIndex(int i) => itenEntregues[i];

  int get totItensEntregues => _totItensEntregues;
  _calcTotItensEntregues() {
    _totItensEntregues = this
        .itenEntregues
        .fold(0, (sum, VendaItemEntrega itemEntrega) => sum + itemEntrega.qtdEntregueEntrega); // sum é o acumulador
  }
}

class VendaItemEntrega extends IData {
  VendaItem vendaItem;
  late int _qtdEntregueEntrega = 0;
  late VendaEntrega? _entrega;

  VendaItemEntrega({
    id,
    required this.vendaItem,
    required qtdEntregueEntrega,
  }) : super(id: id) {
    _qtdEntregueEntrega = qtdEntregueEntrega;
  }

  VendaItemEntrega clone() {
    return VendaItemEntrega(id: id, vendaItem: vendaItem, qtdEntregueEntrega: qtdEntregueEntrega);
  }

  int get qtdEntregueEntrega => _qtdEntregueEntrega;
  set qtdEntregueEntrega(int vl) {
    _qtdEntregueEntrega = vl;

    if (_entrega != null) {
      _entrega!._calcTotItensEntregues();
      _entrega!._venda!._calcQtdItensEntregues();
    }
  }
}
