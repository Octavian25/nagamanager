import 'package:encryptor_flutter_nagatech/main.dart';
import 'package:equatable/equatable.dart';

class ItemModel extends Equatable {
  String id;
  String barcode;
  String name;
  String type;
  int qty;
  String imagePath;
  int price;
  String? locationCode;
  String lastOpname;
  bool isDifference;
  String categoryCode;
  String subCategoryCode;

  ItemModel(
      {required this.name,
      required this.id,
      required this.barcode,
      required this.imagePath,
      required this.price,
      required this.qty,
      this.locationCode,
      required this.type,
      required this.subCategoryCode,
      required this.categoryCode,
      required this.isDifference,
      required this.lastOpname});

  ItemModel copyWith(
          {String? barcode,
          String? id,
          String? name,
          String? type,
          int? qty,
          String? imagePath,
          int? price,
          String? lastOpname,
          bool? isDifference,
          String? subCategoryCode,
          String? categoryCode,
          String? locationCode}) =>
      ItemModel(
          id: id ?? this.id,
          name: name ?? this.name,
          barcode: barcode ?? this.barcode,
          imagePath: imagePath ?? this.imagePath,
          price: price ?? this.price,
          qty: qty ?? this.qty,
          type: type ?? this.type,
          categoryCode: categoryCode ?? this.categoryCode,
          subCategoryCode: subCategoryCode ?? this.subCategoryCode,
          locationCode: locationCode ?? this.locationCode,
          isDifference: isDifference ?? this.isDifference,
          lastOpname: lastOpname ?? this.lastOpname);

  factory ItemModel.fromJson(Map<String, dynamic> json) => ItemModel(
      name: json['name'],
      id: json['_id'],
      barcode: json['barcode'],
      imagePath: json['imagePath'],
      price: json['price'],
      qty: json['qty'],
      type: json['type'],
      lastOpname: json['lastOpname'],
      locationCode: json['location_code'],
      categoryCode: json['category_code'],
      subCategoryCode: json['sub_category_code'],
      isDifference: json['isDifference']);

  Map<String, dynamic> toJson() {
    return {
      "name": Encryptor.doEncrypt(name),
      "type": Encryptor.doEncrypt(type),
      "qty": qty,
      "imagePath": Encryptor.doEncrypt(imagePath),
      "barcode": Encryptor.doEncrypt(barcode),
      "price": price,
      "location_code": Encryptor.doEncrypt(locationCode ?? "-"),
      "sub_category_code": Encryptor.doEncrypt(subCategoryCode),
      "category_code": Encryptor.doEncrypt(categoryCode)
    };
  }

  Map<String, dynamic> updateJson() {
    return {
      "name": Encryptor.doEncrypt(name),
      "location_code": Encryptor.doEncrypt(locationCode ?? "-"),
      "qty": qty,
      "category_code": Encryptor.doEncrypt(categoryCode),
      "sub_category_code": Encryptor.doEncrypt(subCategoryCode),
      "price": price
    };
  }

  @override
  List<Object?> get props =>
      [name, type, qty, imagePath, barcode, price, locationCode];
}
