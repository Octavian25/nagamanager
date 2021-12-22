import 'dart:convert';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:dio/dio.dart';
import 'package:nagamanager/models/api_return_value.dart';
import 'package:nagamanager/models/item_model.dart';
import 'package:nagamanager/models/stocking_model.dart';
import 'package:nagamanager/models/tracking_feedback_model.dart';
import 'package:nagamanager/models/user_model.dart';

part 'auth_service.dart';
part 'barang_service.dart';
part 'stocking_service.dart';
part 'tracking_service.dart';

Future<String> checkExistCache({response , key}) async {
  print("INI DI CHECK EXIST");
  var isCacheExist = await APICacheManager().isAPICacheKeyExist(key);
  print("ISCACHEEXIST = " + isCacheExist.toString());
  if(isCacheExist){
    print("ADA CACHE");
    try{
      var prevCache = await APICacheManager().getCacheData(key);
      List<ItemModel> prevItems = [];
      print(prevCache);
      // for (var item in json.decode(prevCache.syncData)) {
      //   if (item != null) {
      //     prevItems.add(ItemModel.fromJson(item));
      //   }
      // }
      // print(prevItems[0].toString());
      return "BERHASIL";
    } catch (e){
      print(e);
      return "ERROR";
    }
    // var prevCache = await APICacheManager().getCacheData(key);
    // print(prevCache.syncData);

    // for (var item in response) {
    //   if (item != null) {
    //     newItems.add(ItemModel.fromJson(item));
    //   }
    // }
    // print(prevItems == newItems);
    // if(prevItems != null){
    //   print("PREV CACHE IS SIMILLAR TO API");
    //   return "PREV CACHE IS SIMILLAR TO API";
    // } else {
    //   APICacheDBModel cacheDBModel = new APICacheDBModel(
    //       key: key, syncData: response.toString());
    //   APICacheManager().addCacheData(cacheDBModel);
    //   print("PREV CACHE IS DIFFERENCE TO API, ADDED API TO CACHE");
    //   return "PREV CACHE IS DIFFERENCE TO API, ADDED API TO CACHE";
    // }
  } else {
    APICacheDBModel cacheDBModel = new APICacheDBModel(
        key: key, syncData: jsonEncode(response));
    APICacheManager().addCacheData(cacheDBModel);
    return "ADDING NEW CACHE";
  }

}

String baseURL = "http://147.139.193.169:3133/api/v1/";
