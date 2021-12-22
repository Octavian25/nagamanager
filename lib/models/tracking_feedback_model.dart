class TrackingFeedback {
  String barcode;
  String name;
  int qty;

  TrackingFeedback({required this.barcode, required this.name, required this.qty});

  factory TrackingFeedback.fromJson(Map<String, dynamic> json ) =>  TrackingFeedback(barcode: json['barcode'], name: json['name'], qty: json['qty']);
}