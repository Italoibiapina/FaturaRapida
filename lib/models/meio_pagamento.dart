import 'IData.dart';

class MeioPagamento extends IData {
  String nm;

  MeioPagamento({id, required this.nm}) : super(id: id);

  MeioPagamento clone() {
    return MeioPagamento(
      id: id,
      nm: nm,
    );
  }
}
