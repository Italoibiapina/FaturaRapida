import 'package:pedido_facil/models/meio_pagamento.dart';
import 'package:pedido_facil/models/venda.dart';
import 'package:pedido_facil/models/venda_item.dart';

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
      entregas: List<VendaEntrega>.empty(growable: true),
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
      entregas: List<VendaEntrega>.empty(growable: true),
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
      entregas: List<VendaEntrega>.empty(growable: true),
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
      entregas: List<VendaEntrega>.empty(growable: true),
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
      entregas: List<VendaEntrega>.empty(growable: true),
      vlDesconto: 10,
      vlFrete: 15,
      isPago: false,
      isEnt: false),
  '6': Venda(
      id: '6',
      nrPed: 'PED006',
      //dtPed: DateTime.now(),
      //cli: clis.values.elementAt(2),
      itens: [
        VendaItem(id: '7', prod: prods.values.elementAt(1), qtd: 2, qtdEntregue: 2),
        VendaItem(id: '9', prod: prods.values.elementAt(3), qtd: 2, qtdEntregue: 1),
        VendaItem(id: '10', prod: prods.values.elementAt(0), qtd: 2, qtdEntregue: 1),
      ],
      pagtos: [
        VendaPagamento(
            id: '1', dtPagto: DateTime.now(), vlPgto: 10.0, meioPagto: MeioPagamento(id: '1', nm: 'Cartão de Crédito')),
        VendaPagamento(
            id: '2', dtPagto: DateTime.now(), vlPgto: 50.0, meioPagto: MeioPagamento(id: '1', nm: 'Cartão de Débito')),
      ],
      entregas: [
        VendaEntrega(
            id: DateTime.now().toString(),
            dtEntrega: DateTime.now(),
            entreguePara: 'Italo Ibiapina',
            itenEntregues: [
              VendaItemEntrega(
                  id: '7',
                  vendaItem: VendaItem(id: '7', prod: prods.values.elementAt(1), qtd: 2, qtdEntregue: 2),
                  qtdEntregueEntrega: 1),
              VendaItemEntrega(
                  id: '9',
                  vendaItem: VendaItem(id: '9', prod: prods.values.elementAt(3), qtd: 2, qtdEntregue: 1),
                  qtdEntregueEntrega: 1),
              VendaItemEntrega(
                  id: '10',
                  vendaItem: VendaItem(id: '9', prod: prods.values.elementAt(0), qtd: 2, qtdEntregue: 1),
                  qtdEntregueEntrega: 1),
            ],
            obs: 'Observação'),
        VendaEntrega(
            id: DateTime.now().toString(),
            dtEntrega: DateTime.now(),
            entreguePara: 'Mara Lucia Falasca Ibiapina',
            itenEntregues: [
              //VendaItem(id: '8', prod: prods.values.elementAt(2), qtd: 2, qtdEntregue: 1),
              VendaItemEntrega(
                  id: '7',
                  vendaItem: VendaItem(id: '7', prod: prods.values.elementAt(1), qtd: 2, qtdEntregue: 2),
                  qtdEntregueEntrega: 1)
            ])
      ],
      vlDesconto: 10,
      vlFrete: 15,
      isPago: false,
      isEnt: false),
};
