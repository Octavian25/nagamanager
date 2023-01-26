import 'package:flutter/foundation.dart';
import 'package:nagamanager/models/location_model.dart';
import 'package:nagamanager/providers/loading_provider.dart';
import 'package:nagamanager/services/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider extends ChangeNotifier {
  static const KODE_LOKASI = "KODE_LOKASI";
  static const NAMA_LOKASI = "NAMA_LOKASI";
  static const ID_LOKASI = "ID_LOKASI";
  List<LocationModel> listLocation = [];
  LoadingProvider? loadingProvider;
  LocationModel? selectedLocation;

  void update(LoadingProvider loading) {
    loadingProvider = loading;
    notifyListeners();
  }

  void checkLastLocation() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String locationCode = sharedPreferences.getString(KODE_LOKASI) ?? "-";
    String locationName = sharedPreferences.getString(NAMA_LOKASI) ?? "-";
    String locationID = sharedPreferences.getString(ID_LOKASI) ?? "-";
    if (locationCode != "-" && locationName != "-" && locationID != "-") {
      LocationModel locationModel =
          LocationModel(locationCode: locationCode, locationName: locationName, id: locationID);
      selectedLocation = locationModel;
      notifyListeners();
    }
  }

  void setLocation(LocationModel locationModel) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(KODE_LOKASI, locationModel.locationCode);
    sharedPreferences.setString(NAMA_LOKASI, locationModel.locationName);
    sharedPreferences.setString(ID_LOKASI, locationModel.id);
    selectedLocation = locationModel;
    notifyListeners();
  }

  Future<bool> getAllLocation(String token) async {
    Client _client = Client();
    var _endPoint = EndPointProvider(_client.init(token: token));
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      List<LocationModel> project = await compute(_endPoint.getAllLocation, null);
      listLocation = project;
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

  Future<bool> addLocation(String token, LocationModel locationModel) async {
    Client _client = Client();
    var _endPoint = EndPointProvider(_client.init(token: token));
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      await compute(_endPoint.addLocation, locationModel);
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

  Future<bool> editLocation(String token, EditLocationModel locationModel) async {
    Client _client = Client();
    var _endPoint = EndPointProvider(_client.init(token: token));
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      await compute(_endPoint.editLocation, locationModel);
      await getAllLocation(token);
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

  Future<bool> deleteLocation(String token, String id) async {
    Client _client = Client();
    var _endPoint = EndPointProvider(_client.init(token: token));
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      await compute(_endPoint.deleteLocation, id);
      await getAllLocation(token);
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
