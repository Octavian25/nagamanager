import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:encryptor_flutter_nagatech/main.dart';
import 'package:flutter/foundation.dart';
import 'package:nagamanager/models/batch-item.repose.dart';
import 'package:nagamanager/models/chart_annual_model.dart';
import 'package:nagamanager/models/chart_barang_model.dart';
import 'package:nagamanager/models/chart_detail_barang_model.dart';
import 'package:nagamanager/models/detail_stock_model.dart';
import 'package:nagamanager/models/item_info_model.dart';
import 'package:nagamanager/models/item_model.dart';
import 'package:nagamanager/models/location_model.dart';
import 'package:nagamanager/models/params/get_annual_chart.dart';
import 'package:nagamanager/models/params/get_detail.dart';
import 'package:nagamanager/models/params/login.dart';
import 'package:nagamanager/models/params/send_tracking.dart';
import 'package:nagamanager/models/stocking_model.dart';
import 'package:nagamanager/models/tracking_feedback_model.dart';
import 'package:nagamanager/models/user_model.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../models/cateogry_model.dart';

part 'client.dart';

class EndPointProvider {
  final Dio _client;

  EndPointProvider(this._client);

  Future<LoginFeedback> login(loginParam data) async {
    var url = "auth/login";
    var body = json.encode({
      "username": Encryptor.doEncrypt(data.username),
      "password": Encryptor.doEncrypt(data.password)
    });
    try {
      var response = await _client.post(url, data: body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        LoginFeedback loginFeedback = LoginFeedback.fromJson(response.data);
        return loginFeedback;
      } else {
        throw Exception('Gagal Login');
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<List<ItemModel>> getAllItem(String locationCode) async {
    var url = "items";
    try {
      var response = await _client.get(url, queryParameters: {
        "location_code":
            Encryptor.doEncrypt(locationCode).toString().toUpperCase()
      });
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
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> getTotal(Map<String, String> data) async {
    var url = "stockings/global";
    try {
      var response = await _client.get(url, queryParameters: {
        "type": data['type'],
        "location_code": data['location_code']
      });
      if (response.statusCode == 200) {
        return int.parse(response.data);
      } else {
        throw Exception('Gagal Ambil Project');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ChartBarangModel> getChartDashboard(String locationCode) async {
    var url = "chart/chart-barang";
    try {
      var response = await _client
          .get(url, queryParameters: {"location_code": locationCode});
      if (response.statusCode == 200) {
        ChartBarangModel chartBarangModel =
            ChartBarangModel.fromJson(response.data);
        return chartBarangModel;
      } else {
        throw Exception('Gagal Ambil Project');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ChartDetailBarangModel> getDetailChart(GetDetailParam data) async {
    var url = "chart/chart-barang-detail";
    try {
      var response = await _client.get(url, queryParameters: {
        "startDate": data.startDate,
        "endDate": data.endDate,
        "barcode": data.barcode,
        "location_code": data.locationCode
      });
      if (response.statusCode == 200) {
        ChartDetailBarangModel chartDetailBarangModel =
            ChartDetailBarangModel.fromJson(response.data);
        return chartDetailBarangModel;
      } else {
        throw Exception('Gagal Ambil Project');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<ChartAnnual>> getAnnualChart(GetAnnualChartParam data) async {
    var url = "chart/chart-annual";
    try {
      var response = await _client.get(url, queryParameters: data.toJson());
      if (response.statusCode == 200) {
        List<ChartAnnual> list = listChartAnnualFromJson(response.data);
        return list;
      } else {
        throw Exception('Gagal Ambil Project');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> sendStocking(StockingModel stockingModel) async {
    var url = "stockings";
    try {
      var response = await _client.post(url, data: stockingModel);
      if (response.statusCode == 201) {
        return "Berhasil";
      } else {
        throw Exception('Gagal Ambil Project');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<TrackingFeedback>> sendTracking(SendTracking param) async {
    var url = "trackings";
    try {
      var data = param.stockingModel.map((e) => e.toJson()).toList();
      var response = await _client
          .post(url, data: data, queryParameters: {"type": param.type});
      if (response.statusCode == 201) {
        return List<TrackingFeedback>.from(
            response.data.map((x) => TrackingFeedback.fromJson(x)));
      } else {
        throw Exception('Gagal Ambil Project');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> sendAddBarang(ItemModel item) async {
    var url = "items";
    try {
      var response = await _client.post(url, data: item.toJson());
      if (response.statusCode == 201) {
        return "Berhasil";
      } else {
        throw Exception('Gagal Ambil Barang');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> updateBarang(ItemModel item) async {
    var url = "items";
    try {
      var response =
          await _client.put("$url/${item.id}", data: item.updateJson());
      if (response.statusCode == 200) {
        return "Berhasil";
      } else {
        throw Exception('Gagal Ambil Barang');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> deleteBarang(ItemModel item) async {
    var url = "items";
    try {
      var response = await _client.delete("$url/${item.id}");
      if (response.statusCode == 200) {
        return "Berhasil";
      } else {
        throw Exception('Gagal Hapus Barang');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<BatchItemResponse> batchSendAddBarang(List<ItemModel> items) async {
    var url = "items/batch";
    var data = items.map((e) => e.toJson()).toList();
    try {
      var response = await _client.post(url, data: {"items": data});
      if (response.statusCode == 201) {
        BatchItemResponse batchItemResponse =
            BatchItemResponse.fromJson(response.data);
        return batchItemResponse;
      } else {
        throw Exception('Gagal Ambil Project');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<ItemInfoModel> getItemInfo(String locationCode) async {
    try {
      var url = "chart/item-info";
      var response = await _client
          .get(url, queryParameters: {"location_code": locationCode});
      if (response.statusCode == 200) {
        ItemInfoModel infoModel = ItemInfoModel.fromJson(response.data);
        return infoModel;
      } else {
        throw Exception('Gagal Ambil Item Info');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<DetailStockModel>> getDetailStocking(GetDetailParam data) async {
    try {
      var url = "chart/detail-stock";
      var response = await _client.get(url, queryParameters: {
        "startDate": data.startDate,
        "endDate": data.endDate,
        "type": data.barcode,
        "location_code": data.locationCode
      });
      if (response.statusCode == 200) {
        List<DetailStockModel> detailStock =
            listDetailStockFromJson(response.data);
        return detailStock;
      } else {
        throw Exception('Gagal Detail Stock In');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<LocationModel>> getAllLocation(void _) async {
    try {
      var url = "locations";
      var response = await _client.get(url);
      if (response.statusCode == 200) {
        List<LocationModel> listLocation = listLocationFromJson(response.data);
        return listLocation;
      } else {
        throw Exception('Gagal Ambil Data Lokasi');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> deleteLocation(String id) async {
    try {
      var url = "locations";
      var response = await _client.delete("$url/$id");
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw Exception('Gagal Hapus Lokasi');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> editLocation(EditLocationModel data) async {
    try {
      var url = "locations";
      var response = await _client.put(url, data: data.toJson());
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw Exception('Gagal Edit Lokasi');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> addLocation(LocationModel data) async {
    try {
      var url = "locations";
      var response = await _client.post(url, data: data.toJson());
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw Exception('Gagal Tambah Lokasi');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> addCategories(CategoryModel categoryModel) async {
    try {
      var url = "Categories";
      var response = await _client.post(url, data: categoryModel.toJson());
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw Exception('Gagal Tambah Category');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<CategoryModel>> getAllCategory(void _) async {
    try {
      var url = "Categories";
      var response = await _client.get(url);
      if (response.statusCode == 200) {
        List<CategoryModel> listLocation = listCategoryFromJson(response.data);
        return listLocation;
      } else {
        throw Exception('Gagal Ambil Data Category');
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<String> deleteCategory(String id) async {
    try {
      var url = "Categories";
      var response = await _client.delete("$url/$id");
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw Exception('Gagal Hapus Category');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> editCategory(CategoryModel data) async {
    try {
      var url = "Categories";
      var response =
          await _client.put("$url/${data.id}", data: data.toJsonEdit());
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw Exception('Gagal Edit Category');
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<String> addSubCategories(SubCategoryModel subCategoryModel) async {
    try {
      var url = "sub-categories";
      var response = await _client.post(url, data: subCategoryModel.toJson());
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw Exception('Gagal Tambah Category');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<SubCategoryModel>> getAllSubCategory(void _) async {
    try {
      var url = "sub-categories";
      var response = await _client.get(url);
      if (response.statusCode == 200) {
        List<SubCategoryModel> listLocation =
            listSubCategoryFromJson(response.data);
        return listLocation;
      } else {
        throw Exception('Gagal Ambil Data Category');
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<String> deleteSubCategory(String id) async {
    try {
      var url = "sub-categories";
      var response = await _client.delete("$url/$id");
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw Exception('Gagal Hapus Sub Category');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> editSubCategory(SubCategoryModel data) async {
    try {
      var url = "sub-categories";
      var response =
          await _client.put("$url/${data.id}", data: data.toJsonEdit());
      if (response.statusCode == 200) {
        return response.data['message'];
      } else {
        throw Exception('Gagal Edit Category');
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
