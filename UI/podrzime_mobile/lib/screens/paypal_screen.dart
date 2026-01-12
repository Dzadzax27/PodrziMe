import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:podrzime_mobile/modals/donacija.dart';
import 'package:podrzime_mobile/modals/takmicar.dart';
import 'package:podrzime_mobile/providers/donacije_provider.dart';
import 'package:podrzime_mobile/providers/donor_provider.dart';
import 'package:podrzime_mobile/utils/logiraniKorisnik.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:podrzime_mobile/providers/paypal_provider.dart';

class PayPalPaymentScreen extends StatefulWidget {
  final double amount;
  final String description;
  final Takmicar takmicar;

  const PayPalPaymentScreen({
    Key? key,
    required this.amount,
    required this.description,
    required this.takmicar,
  }) : super(key: key);

  @override
  State<PayPalPaymentScreen> createState() => _PayPalPaymentScreenState();
}

class _PayPalPaymentScreenState extends State<PayPalPaymentScreen> {
  final PaypalProvider _paypalProvider = PaypalProvider();
  final DonacijaProvider _donacijaProvider = DonacijaProvider();
  final DonorProvider _donorProvider = DonorProvider();

  bool _isLoading = true;
  String? _approvalUrl;
  String? _orderId;

  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    // Initialize controller with default config
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            // optional: show loading indicator
          },
          onProgress: (progress) {
            // optional: progress updates
          },
          onPageFinished: (url) {
            // optional
          },
          onNavigationRequest: (NavigationRequest request) {
            // Intercept return/cancel URLs here
            final url = request.url;
            if (url.contains('https://yourapp.com/return')) {
              // extract token/order id from query params if present
              final uri = Uri.parse(url);
              final token =
                  uri.queryParameters['token'] ??
                  uri.queryParameters['orderId'];
              if (token != null) {
                // trigger capture
                _handleCapture(token);
              } else if (_orderId != null) {
                _handleCapture(_orderId!);
              }
              // prevent navigation to return url
              return NavigationDecision.prevent;
            }

            if (url.contains('https://yourapp.com/cancel')) {
              Navigator.of(context).pop(false);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onWebResourceError: (err) {
            debugPrint('WebView error: $err');
          },
        ),
      );

    _createOrder();
  }

  Future<void> _createOrder() async {
    setState(() => _isLoading = true);

    try {
      debugPrint('🪙 Creating PayPal order for amount: ${widget.amount}');

      final result = await _paypalProvider.createOrder(
        amount: widget.amount,
        currency: "USD",
        returnUrl: "https://yourapp.com/return",
        cancelUrl: "https://yourapp.com/cancel",
        merchantName: "PodrziMe",
      );

      final approveUrl =
          result['approveUrl'] ??
          (result['links'] as List?)?.firstWhere(
            (l) => l['rel'] == 'approve',
            orElse: () => null,
          )?['href'];

      final id = result['orderId'] ?? result['id'];

      if (approveUrl == null || id == null) {
        throw Exception('approveUrl or orderId missing in response.');
      }

      setState(() {
        _approvalUrl = approveUrl;
        _orderId = id;
      });

      if (_webViewController != null && _approvalUrl != null) {
        await _webViewController!.loadRequest(Uri.parse(_approvalUrl!));
      }
    } catch (e, stackTrace) {
      debugPrint('❌ PayPal order error: $e');
      debugPrintStack(stackTrace: stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PayPal order failed. Please try again.')),
      );
      Navigator.of(context).pop(false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCapture(String orderId) async {
    setState(() => _isLoading = true);

    try {
      await _paypalProvider.captureOrder(orderId);

      final today = DateTime.now();
      var donori = await _donorProvider.get();
      var donor = donori.firstWhere(
        (x) => x.korisnikId == Logiranikorisnik.korisnik?.korisnikId,
      );

      var donation = Donacija(
        datumDonacije: DateTime(today.year, today.month, today.day),
        iznosDonacije: widget.amount.toInt(),
        kandidatId: widget.takmicar.kandidatId,
        donorId: donor.donorId,
      );

      await _donacijaProvider.insert(donation);

      // 🔑 WAIT for dialog to close
      await showDialog(
        context: context,
        barrierDismissible: false, // user must press OK
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 12),
              Expanded(
                child: Text('Hvala vam! Donacija je uspješno evidentirana.'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      // ✅ NOW safely return to previous screen
      Navigator.of(context).pop(true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Capture failed: $e')));
      Navigator.of(context).pop(false);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pay with PayPal')),
      body: Stack(
        children: [
          // If approvalUrl is not ready yet, show a placeholder
          if (_approvalUrl == null)
            const Center(child: CircularProgressIndicator())
          else
            WebViewWidget(controller: _webViewController),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
