class GetAnnualChartParam {
  String barcode;
  String type;
  String locationCode;

  GetAnnualChartParam(this.barcode, this.type, this.locationCode);

  Map<String, dynamic> toJson() =>
      {"barcode": barcode, "type": type, "location_code": locationCode};
}
