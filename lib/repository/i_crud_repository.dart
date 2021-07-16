import 'package:pedido_facil/models/IData.dart';

abstract class ICrudRepository {
  List<IData> get all;
  Map<String, Object> get allMap;
  add(IData newReg);
  update(IData oldReg, IData newReg);
  void remove(IData item);
}
