import 'package:flutter/foundation.dart';
import 'package:nagamanager/models/cateogry_model.dart';
import 'package:nagamanager/models/location_model.dart';
import 'package:nagamanager/providers/loading_provider.dart';
import 'package:nagamanager/services/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryModel> listCategory = [];
  LoadingProvider? loadingProvider;
  LocationModel? selectedLocation;

  void update(LoadingProvider loading) {
    loadingProvider = loading;
    notifyListeners();
  }

  Future<bool> getAllCategory(String token) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      List<CategoryModel> project =
          await compute(_endPoint.getAllCategory, null);
      listCategory = project;
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

  Future<bool> addCategory(String token, CategoryModel data) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      await compute(_endPoint.addCategories, data);
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

  Future<bool> editCategory(String token, CategoryModel categoryModel) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    print("EDIT");
    try {
      await compute(_endPoint.editCategory, categoryModel);
      await getAllCategory(token);
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

  Future<bool> deleteCategory(String token, String id) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      await compute(_endPoint.deleteCategory, id);
      await getAllCategory(token);
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
