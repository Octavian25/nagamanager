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
      inputBy: json['inputBy'],
      date: json['date'],
      qty: json['qty'],
      locationCode: json['location_code'],
      type: json['type']);
  Map<String, dynamic> toJson() {
    return {
      "barcode": barcode,
      "date": date,
      "qty": qty,
      "type": type,
      "inputBy": inputBy,
      "location_code": locationCode ?? "-"
    };
  }
}
