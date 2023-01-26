part of 'providers.dart';

class StockingProvider with ChangeNotifier {
  String? _stocking;
  LoadingProvider? loadingProvider;
  String? get stocking => _stocking;
  List<DetailStockModel> listDetailStockModel = [];

  StockingProvider(this.loadingProvider);
  set stocking(String? stocking) {
    _stocking = stocking;
    notifyListeners();
  }

  Future<bool> sendStocking(String token, StockingModel stockingModel) async {
    Client _client = Client();
    var _endPoint = EndPointProvider(_client.init(token: token));
    try {
      String user = await compute(_endPoint.sendStocking, stockingModel);
      _stocking = user;
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> getDetailStocking(
      String token, String startDate, String endDate, String type) async {
    Client _client = Client();
    var _endPoint = EndPointProvider(_client.init(token: token));
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String locationCode = sharedPreferences.getString("kode_lokasi") ?? "-";
    try {
      List<DetailStockModel> response = await compute(
          _endPoint.getDetailStocking, GetDetailParam(startDate, endDate, type, locationCode));
      listDetailStockModel = response;
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      return false;
    }
  }
}
