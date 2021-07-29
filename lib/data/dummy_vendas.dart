import 'package:pedido_facil/models/venda.dart';

import 'dummy_clientes.dart';

final clis = {...Dummy_clientes};
// ignore: non_constant_identifier_names
final Dummy_vendas = {
  '1': Venda(
      id: '1',
      nrPed: 'PED001',
      dtPed: DateTime.now(),
      cli: clis.values.elementAt(0),
      isPago: true,
      isEnt: true),
  '2': Venda(
      id: '2',
      nrPed: 'PED002',
      dtPed: DateTime.now(),
      cli: clis.values.elementAt(1),
      isPago: false,
      isEnt: true),
  '3': Venda(
      id: '3',
      nrPed: 'PED003',
      dtPed: DateTime.now(),
      cli: clis.values.elementAt(2),
      isPago: true,
      isEnt: false),
  '4': Venda(
      id: '4',
      nrPed: 'PED004',
      dtPed: DateTime.now(),
      cli: clis.values.elementAt(2),
      isPago: false,
      isEnt: false),
};
