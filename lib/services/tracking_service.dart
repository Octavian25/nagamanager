part of 'services.dart';

class TrackingService{
  Future<List<TrackingFeedback>> sendTracking(String token, List<ItemModel> stockingModel, String type) async{
    var url = baseURL + "trackings";
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer' + ' ' + token,
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    };
    print(stockingModel.toString());
    var response = await Dio(BaseOptions(
        headers: headers,
      queryParameters: {
          "type" : type
      }
    )).post(url, data: stockingModel);

    if(response.statusCode == 201){
      return List<TrackingFeedback>.from(response.data.map((x) => TrackingFeedback.fromJson(x)));
    } else {
      throw Exception('Gagal Ambil Project');
    }
  }
}