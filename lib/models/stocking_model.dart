class StockingModel {
  String barcode;
  String date;
  int qty;
  String type;
  String inputBy;
  
  StockingModel({required this.barcode, required this.inputBy, required this.date, required this.qty, required this.type});

  factory StockingModel.fromJson(Map<String, dynamic> json) => StockingModel(barcode: json['barcode'], inputBy: json['inputBy'], date: json['date'], qty: json['qty'], type: json['type']);
  Map<String, dynamic> toJson() {
    return {
      "barcode": barcode,
      "date": date,
      "qty": qty,
      "type": type,
      "inputBy": inputBy
    };
  }
}