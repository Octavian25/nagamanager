part of 'providers.dart';


class StockingProvider with ChangeNotifier {
  String? _stocking;

  String? get stocking  => _stocking;

  set stocking(String? stocking){
    _stocking = stocking;
    notifyListeners();
  }

  Future<bool> sendStocking(String token, StockingModel stockingModel) async{
    try {
      String user = await StockingService().sendStocking(token, stockingModel);
      _stocking = user;
      return true;
    } catch (e) {
      return false;
    }
  }
}