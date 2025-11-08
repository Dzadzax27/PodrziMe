import 'dart:convert';
import 'package:podrzime_mobile/modals/paypalOrder.dart';
import 'package:podrzime_mobile/providers/base_provider.dart';
import 'package:podrzime_mobile/utils/urls.dart';

class PaypalProvider extends ApiProvider<PaypalOrder> {
  PaypalProvider() : super("Checkout");

  @override
  PaypalOrder fromJson(data) {
    return PaypalOrder.fromJson(data);
  }

  /// ✅ Create PayPal order
  Future<Map<String, dynamic>> createOrder({
    required double amount,
    required String currency,
    required String returnUrl,
    required String cancelUrl,
    required String merchantName,
  }) async {
    var _baseUrl = AppConfig.baseApiUrl;
    var url = _baseUrl + "api/Checkout/create-order";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var body = jsonEncode({
      "amount": amount,
      "currency": currency,
      "returnUrl": returnUrl,
      "cancelUrl": cancelUrl,
      "merchantName": merchantName,
    });

    print("Creating PayPal order: $uri");

    final response = await http!.post(uri, headers: headers, body: body);

    if (isValidResponse(response)) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Failed to create PayPal order");
    }
  }

  /// ✅ Capture PayPal order
  Future<Map<String, dynamic>> captureOrder(String orderId) async {
    var _baseUrl = AppConfig.baseApiUrl;
    var url = _baseUrl + "api/Checkout/capture-order";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    final response = await http!.post(
      uri,
      headers: headers,
      body: jsonEncode({"orderId": orderId}),
    );

    if (isValidResponse(response)) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception("Failed to capture PayPal order");
    }
  }
}
