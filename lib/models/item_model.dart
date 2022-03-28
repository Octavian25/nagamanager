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

  ItemModel copyWith({
    String? barcode,
    String? name,
    String? type,
    int? qty,
    String? imagePath,
    int? price,
    String? lastOpname,
    bool? isDifference,
  }) =>
      ItemModel(
          name: name ?? this.name,
          barcode: barcode ?? this.barcode,
          imagePath: imagePath ?? this.imagePath,
          price: price ?? this.price,
          qty: qty ?? this.qty,
          type: type ?? this.type,
          isDifference: isDifference ?? this.isDifference,
          lastOpname: lastOpname ?? this.lastOpname);

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
