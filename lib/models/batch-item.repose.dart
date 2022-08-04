class BatchItemResponse {
  List<dynamic> duplicated;
  List<dynamic> listGeneratedBarcode;
  int successfullyAdded;

  BatchItemResponse(
      {required this.duplicated,
      required this.successfullyAdded,
      required this.listGeneratedBarcode});

  factory BatchItemResponse.fromJson(Map<String, dynamic> data) =>
      BatchItemResponse(
          duplicated: data['duplicated'],
          listGeneratedBarcode: data["listBarcode"],
          successfullyAdded: data['successfullyAdded']);
}
