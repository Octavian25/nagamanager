import 'package:flutter/cupertino.dart';
import 'package:nagamanager/models/tracking_feedback_model.dart';
import 'package:nagamanager/providers/loading_provider.dart';
import 'package:nagamanager/services/services.dart';

class TrackingProvider extends ChangeNotifier {
  List<TrackingFeedback>? _feedback;
  List<TrackingFeedback>? get feedback => _feedback;
  LoadingProvider? loadingProvider;

  TrackingProvider(this.loadingProvider);

  set feedback(List<TrackingFeedback>? feedback) {
    _feedback = feedback;
    notifyListeners();
  }

  Future<List<TrackingFeedback>> sendTracking(
      {required String token,
      required dynamic listBarang,
      required String type}) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    try {
      List<TrackingFeedback> feedback =
          await _endPoint.sendTracking(listBarang, type);
      _feedback = feedback;
      return feedback;
    } catch (e) {
      return [TrackingFeedback(barcode: "-", name: "EMPTY", qty: 0)];
    }
  }
}
