class ChartBarangModel {
  int UpperBound;
  List<int> stock;
  List<int> namaBarang;
  List<String> listBarang;
  List<String> barcode;

  ChartBarangModel(
      {required this.UpperBound,
      required this.listBarang,
      required this.stock,
      required this.namaBarang,
      required this.barcode});

  factory ChartBarangModel.fromJson(Map<String, dynamic> json) =>
      ChartBarangModel(
          barcode: List<String>.from(json['barcode'].map((x) => x.toString())),
          UpperBound: json['upperBound'],
          listBarang:
              List<String>.from(json['list_barang'].map((x) => x.toString())),
          stock: List<int>.from(json['stock'].map((x) => x)),
          namaBarang: List<int>.from(json['nama_barang'].map((x) => x)));
}
