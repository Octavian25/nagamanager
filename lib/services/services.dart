import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nagamanager/models/chart_annual_model.dart';
import 'package:nagamanager/models/chart_barang_model.dart';
import 'package:nagamanager/models/chart_detail_barang_model.dart';
import 'package:nagamanager/models/item_info_model.dart';
import 'package:nagamanager/models/item_model.dart';
import 'package:nagamanager/models/stocking_model.dart';
import 'package:nagamanager/models/tracking_feedback_model.dart';
import 'package:nagamanager/models/user_model.dart';

part 'client.dart';

String baseURL = "http://147.139.193.169:3133/api/v1/";

class EndPointProvider {
  final Dio _client;

  EndPointProvider(this._client);

  Future<LoginFeedback> login(
      {required String username, required String password}) async {
    var url = "auth/login";
    var body = json.encode({"username": username, "password": password});
    try {
      var response = await _client.post(url, data: body);
      if (response.statusCode == 200) {
        LoginFeedback loginFeedback = LoginFeedback.fromJson(response.data);
        return loginFeedback;
      } else {
        throw Exception('Gagal Login');
      }
    } catch (e) {
      throw Exception('Gagal Login, Periksa Username dan password anda');
    }
  }

  Future<List<ItemModel>> getAllItem() async {
    var url = "items";
    var response = await _client.get(url);
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

  Future<int> getTotal(String type) async {
    var url = "stockings/global";
    var response = await _client.get(url, queryParameters: {"type": type});
    if (response.statusCode == 200) {
      return int.parse(response.data);
    } else {
      throw Exception('Gagal Ambil Project');
    }
  }

  Future<ChartBarangModel> getChartDashboard() async {
    var url = "chart/chart-barang";
    var response = await _client.get(url);
    if (response.statusCode == 200) {
      ChartBarangModel chartBarangModel =
          ChartBarangModel.fromJson(response.data);
      return chartBarangModel;
    } else {
      throw Exception('Gagal Ambil Project');
    }
  }

  Future<ChartDetailBarangModel> getDetailChart(
      String startDate, String endDate, String barcode) async {
    var url = "chart/chart-barang-detail";
    var response = await _client.get(url, queryParameters: {
      "startDate": startDate,
      "endDate": endDate,
      "barcode": barcode,
    });
    if (response.statusCode == 200) {
      ChartDetailBarangModel chartDetailBarangModel =
          ChartDetailBarangModel.fromJson(response.data);
      return chartDetailBarangModel;
    } else {
      throw Exception('Gagal Ambil Project');
    }
  }

  Future<List<ChartAnnual>> getAnnualChart(String barcode, String type) async {
    var url = "chart/chart-annual";
    var response = await _client
        .get(url, queryParameters: {"barcode": barcode, "type": type});
    if (response.statusCode == 200) {
      List<ChartAnnual> list = listChartAnnualFromJson(response.data);
      return list;
    } else {
      throw Exception('Gagal Ambil Project');
    }
  }

  Future<String> sendStocking(StockingModel stockingModel) async {
    var url = "stockings";
    var response = await _client.post(url, data: stockingModel);
    if (response.statusCode == 201) {
      return "Berhasil";
    } else {
      throw Exception('Gagal Ambil Project');
    }
  }

  Future<List<TrackingFeedback>> sendTracking(
      List<ItemModel> stockingModel, String type) async {
    var url = "trackings";
    var response = await _client
        .post(url, data: stockingModel, queryParameters: {"type": type});
    if (response.statusCode == 201) {
      return List<TrackingFeedback>.from(
          response.data.map((x) => TrackingFeedback.fromJson(x)));
    } else {
      throw Exception('Gagal Ambil Project');
    }
  }

  Future<String> sendAddBarang(ItemModel item) async {
    var url = "items";
    var response = await _client.post(url, data: item.toJson());
    if (response.statusCode == 201) {
      return "Berhasil";
    } else {
      throw Exception('Gagal Ambil Project');
    }
  }

  Future<ItemInfoModel> getItemInfo() async {
    try {
      var url = "chart/item-info";
      var response = await _client.get(url);
      if (response.statusCode == 200) {
        ItemInfoModel infoModel = ItemInfoModel.fromJson(response.data);
        print(infoModel.totalBarang);
        return infoModel;
      } else {
        throw Exception('Gagal Ambil Item Info');
      }
    } catch (e) {
      throw Exception('Gagal Ambil Item Info');
    }
  }
}
