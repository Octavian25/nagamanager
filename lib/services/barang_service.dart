part of 'services.dart';

class ProjectService {
  Future<List<ItemModel>> getAllItem(String token) async {
    var url = baseURL + "items";
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer' + ' ' + token,
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS, GET"
    };
    var response = await Dio(BaseOptions(headers: headers)).get(url);
    if (response.statusCode == 200) {
      List<ItemModel> items = [];
      for (var item in response.data) {
        if (item != null) {
          items.add(ItemModel.fromJson(item));
        }
      }
      // print(items[0].toJson());
      return items;
    } else {
      throw Exception('Gagal Ambil Project');
    }
  }

  Future<int> getTotal(String token, String type) async {
    var url = baseURL + "stockings/global";
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer' + ' ' + token,
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Credentials": "true",
      "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
      "Access-Control-Allow-Methods": "POST, OPTIONS, GET"
    };
    var response = await Dio(
            BaseOptions(headers: headers, queryParameters: {"type": type}))
        .get(url);
    if (response.statusCode == 200) {
      return int.parse(response.data);
    } else {
      throw Exception('Gagal Ambil Project');
    }
  }
}
