part of 'providers.dart';

class ItemProvider with ChangeNotifier {
  List<ItemModel>? _itemModel = [];
  List<ItemModel>? get item => _itemModel;
  int _totalIn = 0;
  int get totalIn => _totalIn;
  int _totalOut = 0;
  int get totalOut => _totalOut;

  set project(List<ItemModel>? project) {
    _itemModel = project;
    ChangeNotifier();
  }

  set totalin(int totalin) {
    _totalIn = totalin;
    ChangeNotifier();
  }

  set totalout(int totalout) {
    _totalIn = totalout;
    ChangeNotifier();
  }

  Future<void> getProject(String token) async {
    try {
      List<ItemModel> project = await ProjectService().getAllItem(token);
      _itemModel = project;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getTotalIn(String token) async {
    try {
      int project = await ProjectService().getTotal(token, "IN");
      _totalIn = project;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getTotalOut(String token) async {
    try {
      int project = await ProjectService().getTotal(token, "OUT");
      _totalOut = project;
    } catch (e) {
      print(e);
    }
  }
}
