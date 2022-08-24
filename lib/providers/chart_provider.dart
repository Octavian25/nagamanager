import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nagamanager/models/chart_barang_model.dart';
import 'package:nagamanager/models/chart_detail_barang_model.dart';
import 'package:nagamanager/models/item_info_model.dart';
import 'package:nagamanager/models/params/get_annual_chart.dart';
import 'package:nagamanager/models/params/get_detail.dart';
import 'package:nagamanager/providers/loading_provider.dart';
import 'package:nagamanager/providers/location_provider.dart';
import 'package:nagamanager/services/services.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/chart_annual_model.dart';

class ChartProvider extends ChangeNotifier {
  ChartBarangModel? chartBarangModel;
  ChartDetailBarangModel? chartDetailBarangModel;
  List<ChartAnnual> chartAnnualIn = [];
  List<ChartAnnual> chartAnnualOut = [];
  List<BarChartGroupData> listBarChartGroupData = [];
  int? longestName = 0;
  ItemInfoModel? itemInfoModel;
  String barangSelected = "";
  String startDate = "";
  String endDate = "";
  String barcodeSelected = "";
  int totalBarang = 0;
  DateTime? RequestEnd;
  List<FlSpot> chartDetail = [];
  LoadingProvider? loadingProvider;

  void update(LoadingProvider? loadingProvider) {
    this.loadingProvider = loadingProvider;
  }

  void updateDate({required String startDate, required String endDate}) {
    this.startDate = startDate;
    this.endDate = endDate;
    notifyListeners();
  }

  void setInformation(
      {required String barangSelectedd,
      required String startDatee,
      required String endDatee,
      required String barcodeSelectedd}) {
    barangSelected = barangSelectedd;
    startDate = startDatee;
    endDate = endDatee;
    barcodeSelected = barcodeSelectedd;
    notifyListeners();
  }

  Future<bool> getItemInfo(String token) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String locationCode =
          sharedPreferences.getString(LocationProvider.KODE_LOKASI) ?? "-";
      ItemInfoModel response =
          await compute(_endPoint.getItemInfo, locationCode);
      itemInfoModel = response;
      notifyListeners();
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
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

  Future<bool> getDashboardChart(String token) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String locationCode =
        sharedPreferences.getString(LocationProvider.KODE_LOKASI) ?? "-";
    try {
      ChartBarangModel response =
          await compute(_endPoint.getChartDashboard, locationCode);
      chartBarangModel = response;
      List<BarChartGroupData> items = [];
      List<int>? lengthName = [];
      for (var i = 0; i < chartBarangModel!.stock.length; i++) {
        items.add(makeGroupData(chartBarangModel!.namaBarang[i],
            chartBarangModel!.stock[i].toDouble()));
      }
      listBarChartGroupData = items;
      lengthName =
          List<int>.from(chartBarangModel!.listBarang.map((e) => e.length));
      lengthName.sort();
      longestName = lengthName.isEmpty ? 10 : lengthName.last;
      notifyListeners();
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
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

  Future<bool> getDetailChart(
      String token, String barcode, String startDate, String endDate) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String locationCode =
        sharedPreferences.getString(LocationProvider.KODE_LOKASI) ?? "-";
    try {
      RequestEnd ??= DateTime.now().add(const Duration(seconds: 3));
      if (DateTime.now().isAfter(RequestEnd!)) {
        RequestEnd = DateTime.now().add(const Duration(milliseconds: 50));
      } else {
        if (DateTime.now().isBefore(RequestEnd!)) {
          ChartDetailBarangModel response = await compute(
              _endPoint.getDetailChart,
              GetDetailParam(startDate, endDate, barcode, locationCode));
          List<FlSpot> hasil = [];
          for (var i = 0; i < response.stock.length; i++) {
            hasil.add(FlSpot(
                response.label[i].toDouble(), response.stock[i].toDouble()));
          }
          chartDetailBarangModel = response;
          chartDetail = hasil;
          notifyListeners();
          loadingProvider!.stopLoading();
          loadingProvider!.notifyListeners();
          return true;
        } else {
          loadingProvider!.stopLoading();
          loadingProvider!.notifyListeners();
          return true;
        }
      }
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
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

  Future<bool> getChartAnnual(String token, String barcode) async {
    Client _client = Client(token);
    var _endPoint = EndPointProvider(_client.init());
    loadingProvider!.setLoading();
    loadingProvider!.notifyListeners();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String locationCode =
        sharedPreferences.getString(LocationProvider.KODE_LOKASI) ?? "-";
    try {
      RequestEnd ??= DateTime.now().add(const Duration(seconds: 3));
      if (DateTime.now().isAfter(RequestEnd!)) {
        print("UPDATE TIME BARU");
        RequestEnd = DateTime.now().add(const Duration(milliseconds: 50));
      } else {
        if (DateTime.now().isBefore(RequestEnd!)) {
          print("MASUK AFTER ANNUAL");
          List<ChartAnnual> responseIn = await compute(_endPoint.getAnnualChart,
              GetAnnualChartParam(barcode, "IN", locationCode));
          List<ChartAnnual> responseOut = await compute(
              _endPoint.getAnnualChart,
              GetAnnualChartParam(barcode, "OUT", locationCode));
          chartAnnualIn = responseIn;
          chartAnnualOut = responseOut;
          notifyListeners();
          loadingProvider!.stopLoading();
          loadingProvider!.notifyListeners();
          RequestEnd = null;
          return true;
        } else {
          loadingProvider!.stopLoading();
          loadingProvider!.notifyListeners();
          return true;
        }
      }
      loadingProvider!.stopLoading();
      loadingProvider!.notifyListeners();
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

BarChartGroupData makeGroupData(int x, double y1) {
  return BarChartGroupData(barsSpace: 10, x: x, barRods: [
    BarChartRodData(
      toY: y1,
      colors: [const Color(0xff53fdd7)],
      width: 10.w,
    ),
  ]);
}
