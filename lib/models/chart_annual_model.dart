List<ChartAnnual> listChartAnnualFromJson(List<dynamic> data) =>
    List<ChartAnnual>.from(data.map((e) => ChartAnnual.fromJson(e)));

class ChartAnnual {
  int value;
  String month;

  ChartAnnual({required this.value, required this.month});

  factory ChartAnnual.fromJson(Map<String, dynamic> json) =>
      ChartAnnual(value: json['value'], month: json['month']);

  Map<String, dynamic> toJson() {
    return {"value": value, "month": month};
  }
}
