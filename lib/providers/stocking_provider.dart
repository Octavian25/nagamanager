part of 'providers.dart';

class StockingProvider with ChangeNotifier {
  String? _stocking;
  LoadingProvider? loadingProvider;
  String? get stocking => _stocking;

  StockingProvider(this.loadingProvider);
  set stocking(String? stocking) {
    _stocking = stocking;
    notifyListeners();
  }

  Future<bool> sendStocking(String token, StockingModel stockingModel) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    try {
      String user = await _endPoint.sendStocking(stockingModel);
      _stocking = user;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
