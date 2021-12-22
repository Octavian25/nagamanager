part of 'services.dart';

class StockingService{
  Future<String> sendStocking(String token, StockingModel stockingModel) async{
    var url = baseURL + "stockings";
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer' + ' ' + token,
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS"
    };
    print(stockingModel.toJson());
    var response = await Dio(BaseOptions(
        headers: headers
    )).post(url, data: stockingModel);
    print(response);
    if(response.statusCode == 201){
      return "Berhasil";

    } else {
      throw Exception('Gagal Ambil Project');
    }
  }
}