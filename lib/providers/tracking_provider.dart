import 'package:flutter/foundation.dart';
import 'package:nagamanager/models/params/send_tracking.dart';
import 'package:nagamanager/models/tracking_feedback_model.dart';
import 'package:nagamanager/providers/loading_provider.dart';
import 'package:nagamanager/services/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

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
      {required String token, required dynamic listBarang, required String type}) async {
    Client _client = Client();
    var _endPoint = EndPointProvider(_client.init(token: token));
    try {
      List<TrackingFeedback> feedback =
          await compute(_endPoint.sendTracking, SendTracking(listBarang, type));
      _feedback = feedback;
      return feedback;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return [TrackingFeedback(barcode: "-", name: "EMPTY", qty: 0)];
    }
  }
}
