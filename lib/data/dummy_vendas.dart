import 'package:pedido_facil/models/meio_pagamento.dart';
import 'package:pedido_facil/models/venda.dart';
import 'package:pedido_facil/models/venda_item.dart';
import 'package:pedido_facil/models/venda_pagamento.dart';

import 'dummy_clientes.dart';
import 'dummy_produtos.dart';

final clis = {...Dummy_clientes};
final prods = {...Dummy_produtos};
// ignore: non_constant_identifier_names
final Dummy_vendas = {
  '1': Venda(
      id: '1',
      nrPed: 'PED001',
      dtPed: DateTime.now(),
      cli: clis.values.elementAt(0),
      itens: [
        VendaItem(id: '1', prod: prods.values.elementAt(1), qtd: 2),
        VendaItem(id: '2', prod: prods.values.elementAt(2), qtd: 1)
      ],
      pagtos: List<VendaPagamento>.empty(growable: true),
      vlDesconto: 10,
      vlFrete: 15,
      isPago: true,
      isEnt: true),
  '2': Venda(
      id: '2',
      nrPed: 'PED002',
      dtPed: DateTime.now(),
      cli: clis.values.elementAt(1),
      itens: [
        VendaItem(id: '3', prod: prods.values.elementAt(1), qtd: 1),
        VendaItem(id: '4', prod: prods.values.elementAt(2), qtd: 2)
      ],
      pagtos: List<VendaPagamento>.empty(growable: true),
      isPago: false,
      isEnt: true),
  '3': Venda(
      id: '3',
      nrPed: 'PED003',
      dtPed: DateTime.now(),
      cli: clis.values.elementAt(2),
      itens: [
        VendaItem(id: '5', prod: prods.values.elementAt(1), qtd: 1),
        VendaItem(id: '6', prod: prods.values.elementAt(2), qtd: 1)
      ],
      pagtos: List<VendaPagamento>.empty(growable: true),
      vlDesconto: 20,
      vlFrete: 25,
      isPago: true,
      isEnt: false),
  '4': Venda(
      id: '4',
      nrPed: 'PED004',
      dtPed: DateTime.now(),
      cli: clis.values.elementAt(2),
      itens: [
        VendaItem(id: '7', prod: prods.values.elementAt(1), qtd: 2),
        VendaItem(id: '8', prod: prods.values.elementAt(2), qtd: 2)
      ],
      pagtos: List<VendaPagamento>.empty(growable: true),
      vlDesconto: 10,
      vlFrete: 35,
      dsEnd: 'Rua dos Bobos , 0, Sao Bernardo do Campo, SP, Brazil',
      isPago: false,
      isEnt: false),
  '5': Venda(
      id: '5',
      nrPed: 'PED005',
      dtPed: DateTime.now(),
      cli: clis.values.elementAt(2),
      itens: [
        VendaItem(id: '7', prod: prods.values.elementAt(1), qtd: 2),
        VendaItem(id: '8', prod: prods.values.elementAt(2), qtd: 2)
      ],
      pagtos: List<VendaPagamento>.empty(growable: true),
      vlDesconto: 10,
      vlFrete: 15,
      isPago: false,
      isEnt: false),
  '6': Venda(
      id: '6',
      nrPed: 'PED006',
      dtPed: DateTime.now(),
      cli: clis.values.elementAt(2),
      itens: [
        VendaItem(id: '7', prod: prods.values.elementAt(1), qtd: 2),
        VendaItem(id: '8', prod: prods.values.elementAt(2), qtd: 2)
      ],
      pagtos: [
        VendaPagamento(
            id: '1',
            dtPagto: DateTime.now(),
            vlPgto: 10,
            meioPagto: MeioPagamento(id: '1', nm: 'Cartão de Crédito')),
        VendaPagamento(
            id: '2',
            dtPagto: DateTime.now(),
            vlPgto: 50,
            meioPagto: MeioPagamento(id: '1', nm: 'Cartão de Débito')),
      ],
      vlDesconto: 10,
      vlFrete: 15,
      isPago: false,
      isEnt: false),
};
