class BatchItemResponse {
  List<dynamic> duplicated;
  int successfullyAdded;

  BatchItemResponse(
      {required this.duplicated, required this.successfullyAdded});

  factory BatchItemResponse.fromJson(Map<String, dynamic> data) =>
      BatchItemResponse(
          duplicated: data['duplicated'],
          successfullyAdded: data['successfullyAdded']);
}
