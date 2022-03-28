part of 'providers.dart';

class ItemProvider with ChangeNotifier {
  List<ItemModel>? _itemModel = [];
  List<ItemModel>? get item => _itemModel;
  int _totalIn = 0;
  int get totalIn => _totalIn;
  int _totalOut = 0;
  int get totalOut => _totalOut;
  LoadingProvider? loadingProvider;

  void update(LoadingProvider loading) {
    loadingProvider = loading;
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
    firebase_storage.UploadTask task = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("demo")
        .child(itemModel.barcode)
        .putFile(File(itemModel.imagePath));
    try {
      firebase_storage.TaskSnapshot snapshot = await task;
      var downloadURL = await snapshot.ref.getDownloadURL();
      print('Uploaded ${snapshot.bytesTransferred} bytes.');
      print("Donwloaded URL : $downloadURL");
      String project = await _endPoint
          .sendAddBarang(itemModel.copyWith(imagePath: downloadURL));
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      notifyListeners();
      return true;
    } on firebase_storage.FirebaseException catch (e) {
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      print(e.code);
      return false;
    }
  }

  Future<bool> getProject(String token) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      List<ItemModel> project = await _endPoint.getAllItem();
      _itemModel = project;
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      notifyListeners();
      return true;
    } catch (e) {
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      print(e);
      return false;
    }
  }

  Future<void> getTotalIn(String token) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      int project = await _endPoint.getTotal("IN");
      _totalIn = project;
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      notifyListeners();
    } catch (e) {
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      print(e);
    }
  }

  Future<void> getTotalOut(String token) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      int project = await _endPoint.getTotal("OUT");
      _totalOut = project;
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      notifyListeners();
    } catch (e) {
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
      print(e);
    }
  }
}
