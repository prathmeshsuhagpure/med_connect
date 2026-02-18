import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'api_endpoints.dart';
import 'api_service.dart';

class PaymentService {
  final ApiService apiService;

  PaymentService(this.apiService);

  static String? baseUrl = ApiEndpoints.baseUrl;

  // Create Razorpay Order
  Future<Map<String, dynamic>> createRazorpayOrder({
    String? appointmentId,
    required double amount,
  }) async {
    try {
      final headers = apiService.getHeaders(includeAuth: true);
      final response = await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.createRazorpayOrder}'),
        headers: headers,
        body: jsonEncode({'amount': amount, 'appointmentId': appointmentId}),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['success'] == true && result['orderId'] != null) {
          return {
            'success': true,
            'orderId': result['orderId'],
            'amount': result['amount'],
          };
        } else {
          return {
            'success': false,
            'message': result['message'] ?? 'Failed to create order',
          };
        }
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to create order',
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> verifyPayment(
    PaymentSuccessResponse response, {
    String? appointmentId,
  }) async {
    try {
      final headers = ApiService().getHeaders(includeAuth: true);

      final body = {
        'razorpay_order_id': response.orderId,
        'razorpay_payment_id': response.paymentId,
        'razorpay_signature': response.signature,
      };

      final res = await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.verifyRazorpayPayment}'),
        headers: {...headers, 'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final result = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return {
          'success': true,
          'message': result['message'],
          'paymentId': result['paymentId'],
        };
      }

      return {
        'success': false,
        'message': result['message'] ?? 'Verification failed',
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get Payment History
  Future<Map<String, dynamic>> getPaymentHistory() async {
    try {
      final headers = ApiService().getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl${ApiEndpoints.getPaymentHistory}'),
        headers: headers,
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'payments': result['payments'] ?? []};
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to fetch payment history',
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get Payment Details by ID
  Future<Map<String, dynamic>> getPaymentById(String paymentId) async {
    try {
      final headers = ApiService().getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl${ApiEndpoints.getPaymentById}/$paymentId'),
        headers: headers,
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'payment': result['payment']};
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Failed to fetch payment details',
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Refund Payment (if needed)
  Future<Map<String, dynamic>> refundPayment({
    required String paymentId,
    required double amount,
    String? reason,
  }) async {
    try {
      final headers = ApiService().getHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.refundPayment}'),
        headers: headers,
        body: jsonEncode({
          'paymentId': paymentId,
          'amount': amount,
          'reason': reason ?? 'Booking cancellation',
        }),
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': result['success'] ?? false,
          'message': result['message'] ?? 'Refund processed',
          'refundId': result['refundId'],
        };
      } else {
        return {
          'success': false,
          'message': result['message'] ?? 'Refund failed',
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
