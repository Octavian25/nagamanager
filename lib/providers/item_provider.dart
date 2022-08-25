part of 'providers.dart';

class ItemProvider with ChangeNotifier {
  List<ItemModel>? _itemModel = [];
  List<ItemModel>? get item => _itemModel;
  int _totalIn = 0;
  int get totalIn => _totalIn;
  int _totalOut = 0;
  int get totalOut => _totalOut;
  LoadingProvider? loadingProvider;
  AuthProvider? authProvider;
  List<String> duplicatedBatchResult = [];
  List<String> listGeneratedBarcode = [];
  int successfullyAdded = 0;
  List<DetailStockModel> _listDetailStock = [];
  List<DetailStockModel> _listDetailStockFilter = [];

  List<DetailStockModel> get listDetailStockFilter => _listDetailStockFilter;

  set listDetailStockFilter(List<DetailStockModel> value) {
    _listDetailStockFilter = value;
  }

  List<DetailStockModel> get listDetailStock => _listDetailStock;

  set listDetailStock(List<DetailStockModel> value) {
    _listDetailStock = value;
  }

  void update(LoadingProvider loading) {
    loadingProvider = loading;
    notifyListeners();
  }

  void setAuthProvider(AuthProvider authProvider) {
    this.authProvider = authProvider;
    notifyListeners();
  }

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

  Future<bool> addItems(String token, ItemModel itemModel) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      String project =
          await _endPoint.sendAddBarang(itemModel.copyWith(imagePath: "-"));
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      getProject(token);
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> updateItems(String token, ItemModel itemModel) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      await _endPoint.updateBarang(itemModel);
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      getProject(token);
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> deleteItems(String token, ItemModel itemModel) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      await _endPoint.deleteBarang(itemModel);
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      getProject(token);
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> batchAddItems(String token, List<ItemModel> data) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      BatchItemResponse response =
          await compute(_endPoint.batchSendAddBarang, data);
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      duplicatedBatchResult =
          response.duplicated.map((e) => e.toString()).toList();
      listGeneratedBarcode =
          response.listGeneratedBarcode.map((e) => e.toString()).toList();
      final text = listGeneratedBarcode.join(",");
      print(text);
      final bytes = utf8.encode(text);
      final blob = html.Blob([bytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement("a") as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = "autoprint_barcode.txt";
      html.document.body?.children.add(anchor);

      anchor.click();

      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
      successfullyAdded = response.successfullyAdded;
      getProject(token);
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      print(e);
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  Future<bool> getProject(String token) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String locationCode =
        sharedPreferences.getString(LocationProvider.KODE_LOKASI) ?? "-";
    try {
      List<ItemModel> project =
          await compute(_endPoint.getAllItem, locationCode);
      _itemModel = project;
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

  Future<void> getTotalIn(String token) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String locationCode =
        sharedPreferences.getString(LocationProvider.KODE_LOKASI) ?? "-";
    print(locationCode);
    try {
      int project = await compute(
          _endPoint.getTotal, {"type": "IN", "location_code": locationCode});
      _totalIn = project;
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      notifyListeners();
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
    }
  }

  Future<void> getTotalOut(String token) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String locationCode =
        sharedPreferences.getString(LocationProvider.KODE_LOKASI) ?? "-";
    try {
      int project = await compute(
          _endPoint.getTotal, {"type": "OUT", "location_code": locationCode});
      _totalOut = project;
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      notifyListeners();
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
    }
  }

  Future<bool> getDetailStock(String token, String startDate, String endDate,
      String type, String locationCode) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      List<DetailStockModel> project = await compute(
          _endPoint.getDetailStocking,
          GetDetailParam(startDate, endDate, type, locationCode));
      _listDetailStock = project;
      _listDetailStockFilter = project;
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

  Future<void> changeShow(int index) async {
    var selected = _listDetailStock[index]
        .copyWith(isShow: !_listDetailStock[index].isShow);
    _listDetailStock[index] = selected;
    notifyListeners();
  }
}
