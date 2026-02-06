import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_endpoints.dart';

class ApiService {
  final String? baseUrl = ApiEndpoints.baseUrl;

  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Map<String, String> _getHeaders({bool includeAuth = false}) {
    final headers = {'Content-Type': 'application/json'};

    if (includeAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.login}'),
        headers: _getHeaders(),
        body: jsonEncode({'email': email, 'password': password, 'role': role}),
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phoneNumber,
    required String confirmPassword,
    String? hospitalName,
    String? registrationNumber,
    String? specialization,
    String? qualification,
    String? licenseNumber,
    String? address,
  }) async {
    try {
      final body = {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
        'phoneNumber': phoneNumber,
        'confirmPassword': confirmPassword,
      };

      // Add role-specific fields only if provided
      if (address?.isNotEmpty ?? false) body['address'] = address!;

      // Hospital-specific fields
      if (role == 'hospital') {
        if (hospitalName?.isNotEmpty ?? false)
          body['hospitalName'] = hospitalName!;
        if (registrationNumber?.isNotEmpty ?? false)
          body['registrationNumber'] = registrationNumber!;
      }

      // Doctor-specific fields
      if (role == 'doctor') {
        if (specialization?.isNotEmpty ?? false)
          body['specialization'] = specialization!;
        if (qualification?.isNotEmpty ?? false)
          body['qualification'] = qualification!;
        if (licenseNumber?.isNotEmpty ?? false)
          body['licenseNumber'] = licenseNumber!;
      }

      final response = await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.signup}'),
        headers: _getHeaders(),
        body: jsonEncode(body),
      );

      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      // Remove null and empty string values
      final cleanData = Map<String, dynamic>.from(profileData)
        ..removeWhere((key, value) => value == null || value == '');

      final response = await http.put(
        Uri.parse('$baseUrl${ApiEndpoints.updateUserProfile}'),
        headers: _getHeaders(includeAuth: true),
        body: jsonEncode(cleanData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update profile',
        };
      }
    } catch (e) {
      print('Update profile error: $e');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> verifyToken() async {
    try {
      if (_token == null) {
        return {'success': false, 'message': 'No token available'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.verifyToken}'),
        headers: _getHeaders(includeAuth: true),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Token verification failed',
        };
      }
    } catch (e) {
      print('Token verification error: $e');
      return {
        'success': false,
        'message': 'Network error during token verification',
      };
    }
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiEndpoints.getUserProfile}'),
        headers: _getHeaders(includeAuth: true),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get profile',
        };
      }
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  Future<void> logout() async {
    try {
      await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: _getHeaders(includeAuth: true),
      );
    } catch (e) {
      print('Logout error: $e');
    }
  }
}
