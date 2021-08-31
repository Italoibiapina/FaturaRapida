import 'package:pedido_facil/models/IData.dart';

class RetornoForm {
  bool isDelete;
  final IData objData;
  RetornoForm({this.isDelete = false, required this.objData});
}
