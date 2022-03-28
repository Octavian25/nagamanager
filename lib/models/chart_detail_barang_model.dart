class ChartDetailBarangModel {
  int upperBound;
  List<int> stock;
  List<int> label;
  List<String> list;
  List<HistoryDetail>? historyDetail;

  ChartDetailBarangModel(
      {required this.stock,
      required this.upperBound,
      this.historyDetail,
      required this.label,
      required this.list});

  factory ChartDetailBarangModel.fromJson(Map<String, dynamic> json) {
    return ChartDetailBarangModel(
        stock: json['stock'].isEmpty
            ? []
            : List<int>.from(json['stock'].map((x) => x)),
        upperBound: json['upperBound'],
        label: json['label'].isEmpty
            ? []
            : List<int>.from(json['label'].map((x) => x)),
        list: json['list'].isEmpty
            ? []
            : List<String>.from(json['list'].map((x) => x.toString())),
        historyDetail: json['history_detail'].isEmpty
            ? []
            : List<HistoryDetail>.from(
                json['history_detail'].map((x) => HistoryDetail.fromJson(x))));
  }
}

class HistoryDetail {
  String tanggal;
  int stockIn;
  int stockOut;
  int available;
  String trackNumber;

  HistoryDetail(
      {required this.tanggal,
      required this.available,
      required this.stockOut,
      required this.trackNumber,
      required this.stockIn});

  factory HistoryDetail.fromJson(Map<String, dynamic> json) => HistoryDetail(
      tanggal: json['tanggal'],
      available: json['available'],
      stockOut: json['stock_out'],
      trackNumber: json['trackNumber'],
      stockIn: json['stock_in']);
}
