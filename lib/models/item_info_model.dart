class ItemInfoModel {
  int totalStockIn;
  int totalStockOut;
  int totalBarang;

  ItemInfoModel(
      {required this.totalBarang,
      required this.totalStockIn,
      required this.totalStockOut});

  factory ItemInfoModel.fromJson(Map<String, dynamic> data) => ItemInfoModel(
      totalBarang: data['total_barang'],
      totalStockIn: data['total_stock_in'],
      totalStockOut: data['total_stock_out']);
}
