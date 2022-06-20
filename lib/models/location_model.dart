List<LocationModel> listLocationFromJson(List<dynamic> data) =>
    List<LocationModel>.from(data.map((e) => LocationModel.fromJson(e)));

class LocationModel {
  String id;
  String locationCode;
  String locationName;

  LocationModel(
      {required this.locationCode,
      required this.locationName,
      required this.id});

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
      id: json['_id'],
      locationCode: json['location_code'],
      locationName: json['location_name']);

  Map<String, dynamic> toJson() =>
      {"location_code": locationCode, "location_name": locationName};
}

class EditLocationModel {
  String id;
  String locationName;

  EditLocationModel({required this.locationName, required this.id});

  factory EditLocationModel.fromJson(Map<String, dynamic> json) =>
      EditLocationModel(id: json['_id'], locationName: json['location_name']);

  Map<String, dynamic> toJson() => {"_id": id, "location_name": locationName};
}
