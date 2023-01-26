import 'package:flutter/foundation.dart';
import 'package:nagamanager/models/cateogry_model.dart';
import 'package:nagamanager/models/location_model.dart';
import 'package:nagamanager/providers/loading_provider.dart';
import 'package:nagamanager/services/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SubCategoryProvider extends ChangeNotifier {
  List<SubCategoryModel> listSubCategory = [];
  LoadingProvider? loadingProvider;
  LocationModel? selectedLocation;

  void update(LoadingProvider loading) {
    loadingProvider = loading;
    notifyListeners();
  }

  Future<bool> getAllSubCategory(String token) async {
    Client _client = Client();
    var _endPoint = EndPointProvider(_client.init(token: token));
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      List<SubCategoryModel> project = await compute(_endPoint.getAllSubCategory, null);
      listSubCategory = project;
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

  Future<bool> addSubCategory(String token, SubCategoryModel data) async {
    Client _client = Client();
    var _endPoint = EndPointProvider(_client.init(token: token));
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      await compute(_endPoint.addSubCategories, data);
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

  Future<bool> editSubCategory(String token, SubCategoryModel categoryModel) async {
    Client _client = Client();
    var _endPoint = EndPointProvider(_client.init(token: token));
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      await compute(_endPoint.editSubCategory, categoryModel);
      await getAllSubCategory(token);
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

  Future<bool> deleteSubCategory(String token, String id) async {
    Client _client = Client();
    var _endPoint = EndPointProvider(_client.init(token: token));
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      await compute(_endPoint.deleteSubCategory, id);
      await getAllSubCategory(token);
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
