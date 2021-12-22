import 'package:equatable/equatable.dart';

class ItemModel extends Equatable {
  String barcode;
  String name;
  String type;
  int qty;
  String imagePath;
  int price;
  String lastOpname;
  bool isDifference;

  ItemModel(
      {required this.name,
      required this.barcode,
      required this.imagePath,
      required this.price,
      required this.qty,
      required this.type,
      required this.isDifference,
      required this.lastOpname});



  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
      name: json['name'],
      barcode: json['barcode'],
      imagePath: json['imagePath'],
      price: json['price'],
      qty: json['qty'],
      type: json['type'],
      lastOpname: json['lastOpname'],
      isDifference: json['isDifference']);

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "type": type,
      "qty": qty,
      "imagePath": imagePath,
      "barcode": barcode,
      "price": price,
    };
  }

  @override
  List<Object?> get props => [name, type, qty, imagePath, barcode, price];
}

List<ItemModel> dummyItemModel = [
  ItemModel(
      name: "SAMPOERNA KRETEK 12",
      barcode: "8999909085114",
      imagePath:
          "https://images.tokopedia.net/img/cache/500-square/product-1/2020/8/21/33032584/33032584_5326023d-5278-4e6d-9026-aba1754535e3_517_517",
      price: 12800,
      qty: 100,
      type: "bungkus",
      isDifference: false,
      lastOpname: "2021-01-01"),
  ItemModel(
      name: "TARO POTATO 40G",
      barcode: "8999999000066",
      imagePath:
          "https://images.tokopedia.net/img/cache/500-square/product-1/2019/9/10/71160237/71160237_50b7495a-77e3-4d09-81b3-6ac352752412_1000_1000",
      price: 4400,
      qty: 100,
      type: "bungkus",
      isDifference: false,
      lastOpname: "2021-01-01"),
  ItemModel(
      name: "CHEETOS JAGUNG BAKAR 40G",
      barcode: "89686600247",
      imagePath:
          "https://images.tokopedia.net/img/cache/500-square/attachment/2020/4/26/15878542623331/15878542623331_f9a345b9-f15b-4400-9c2d-0887a63fd612.png",
      price: 4990,
      qty: 100,
      type: "bungkus",
      isDifference: false,
      lastOpname: "2021-01-01"),
  ItemModel(
      name: " AXE DARK TEMPT KLG",
      barcode: "4800888141125",
      imagePath:
          "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2020/10/26/390abe76-2ebb-4f1c-aff7-2624b8de5e5c.jpg",
      price: 37000,
      qty: 100,
      type: "botol",
      isDifference: false,
      lastOpname: "2021-01-01"),
  ItemModel(
      name: "BIMOLI PCH 2000mL",
      barcode: "8992628020152",
      imagePath:
          "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2020/9/17/ba4ae59d-071f-438a-8003-5a9e5286a750.png",
      price: 37600,
      qty: 100,
      type: "pack",
      isDifference: false,
      lastOpname: "2021-01-01"),
  ItemModel(
      name: "KANEBO AUTOSPORT",
      barcode: "4719990020320",
      imagePath:
          "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2020/9/17/ba4ae59d-071f-438a-8003-5a9e5286a750.png",
      price: 37600,
      qty: 100,
      type: "pack",
      isDifference: false,
      lastOpname: "2021-01-01"),
];
