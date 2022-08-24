import 'package:encryptor_flutter_nagatech/main.dart';

List<CategoryModel> listCategoryFromJson(List<dynamic> data) =>
    List<CategoryModel>.from(data.map((e) => CategoryModel.fromJson(e)));

class CategoryModel {
  final String id;
  final String categoryCode;
  final String name;
  final String description;

  CategoryModel(
      {required this.categoryCode,
      required this.id,
      required this.description,
      required this.name});

  Map<String, dynamic> toJson() => {
        "category_code": Encryptor.doEncrypt(categoryCode),
        "name": Encryptor.doEncrypt(name),
        "description": Encryptor.doEncrypt(description),
      };

  Map<String, dynamic> toJsonEdit() => {
        "name": Encryptor.doEncrypt(name),
        "description": Encryptor.doEncrypt(description),
      };

  factory CategoryModel.fromJson(Map<String, dynamic> data) => CategoryModel(
      id: data['_id'],
      categoryCode: data['category_code'],
      description: data['description'],
      name: data['name']);
}

List<SubCategoryModel> listSubCategoryFromJson(List<dynamic> data) =>
    List<SubCategoryModel>.from(data.map((e) => SubCategoryModel.fromJson(e)));

class SubCategoryModel {
  final String id;
  final String subCategoryCode;
  final String categoryCode;
  final String name;
  final String description;

  SubCategoryModel(
      {required this.categoryCode,
      required this.id,
      required this.description,
      required this.name,
      required this.subCategoryCode});

  Map<String, dynamic> toJson() => {
        "sub_category_code": Encryptor.doEncrypt(subCategoryCode),
        "category_code": Encryptor.doEncrypt(categoryCode),
        "name": Encryptor.doEncrypt(name),
        "description": Encryptor.doEncrypt(description),
      };

  Map<String, dynamic> toJsonEdit() => {
        "name": Encryptor.doEncrypt(name),
        "description": Encryptor.doEncrypt(description),
      };

  factory SubCategoryModel.fromJson(Map<String, dynamic> data) =>
      SubCategoryModel(
          id: data['_id'],
          categoryCode: data['category_code'],
          description: data['description'],
          name: data['name'],
          subCategoryCode: data['sub_category_code']);
}
