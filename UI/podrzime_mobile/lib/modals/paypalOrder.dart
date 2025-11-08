class PaypalOrder {
  final String id;
  final String? status;
  final String? approveUrl;

  PaypalOrder({required this.id, this.status, this.approveUrl});

  factory PaypalOrder.fromJson(Map<String, dynamic> json) {
    return PaypalOrder(
      id: json['id'] ?? '',
      status: json['status'],
      approveUrl: json['approveUrl'],
    );
  }
}
