import 'package:encryptor_flutter_nagatech/main.dart';
import 'package:equatable/equatable.dart';

List<DetailStockModel> listDetailStockFromJson(List<dynamic> data) =>
    List<DetailStockModel>.from(data.map((e) => DetailStockModel.fromJson(e)));

class DetailStockModel extends Equatable {
  DetailStockModel(
      {required this.isDifference,
      required this.lastOpname,
      required this.barcode,
      required this.name,
      required this.price,
      required this.imagePath,
      required this.type,
      required this.totalStockIn,
      required this.isShow});

  bool isDifference;
  String lastOpname;
  String barcode;
  String name;
  int price;
  String imagePath;
  String type;
  int totalStockIn;
  bool isShow;

  void hide() {
    isShow = false;
  }

  void show() {
    isShow = true;
  }

  DetailStockModel copyWith({
    bool? isDifference,
    String? lastOpname,
    String? barcode,
    String? name,
    int? price,
    String? imagePath,
    String? type,
    int? totalStockIn,
    bool? isShow,
  }) =>
      DetailStockModel(
          isDifference: isDifference ?? this.isDifference,
          lastOpname: lastOpname ?? this.lastOpname,
          barcode: barcode ?? this.barcode,
          name: name ?? this.name,
          price: price ?? this.price,
          imagePath: imagePath ?? this.imagePath,
          type: type ?? this.type,
          totalStockIn: totalStockIn ?? this.totalStockIn,
          isShow: isShow ?? this.isShow);

  factory DetailStockModel.fromJson(dynamic json) => DetailStockModel(
      isDifference: json['isDifference'],
      lastOpname: json['lastOpname'],
      barcode: json['barcode'],
      name: json['name'],
      price: json['price'],
      imagePath: json['imagePath'],
      type: json['type'],
      totalStockIn: json['totalStockIn'],
      isShow: true);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isDifference'] = isDifference;
    map['lastOpname'] = lastOpname;
    map['barcode'] = barcode;
    map['name'] = Encryptor.doEncrypt(name);
    map['price'] = price;
    map['imagePath'] = imagePath;
    map['type'] = type;
    map['totalStockIn'] = totalStockIn;
    map['isShow'] = isShow;
    return map;
  }

  @override
  List<Object?> get props => [
        isDifference,
        lastOpname,
        barcode,
        name,
        price,
        imagePath,
        type,
        totalStockIn,
        isShow
      ];
}
