import 'package:encryptor_flutter_nagatech/main.dart';

class StockingModel {
  String barcode;
  String date;
  int qty;
  String? locationCode;
  String type;
  String inputBy;

  StockingModel(
      {required this.barcode,
      this.locationCode,
      required this.inputBy,
      required this.date,
      required this.qty,
      required this.type});

  factory StockingModel.fromJson(Map<String, dynamic> json) => StockingModel(
      barcode: json['barcode'],
      inputBy: Encryptor.doDecrypt(json['inputBy']),
      date: json['date'],
      qty: json['qty'],
      locationCode: Encryptor.doDecrypt(json['location_code']),
      type: json['type']);

  Map<String, dynamic> toJson() {
    return {
      "barcode": barcode,
      "date": date,
      "qty": qty,
      "type": type,
      "inputBy": Encryptor.doEncrypt(inputBy),
      "location_code": Encryptor.doEncrypt(locationCode ?? "-")
    };
  }
}
