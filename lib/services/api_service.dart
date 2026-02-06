/*
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:med_connect/models/user_model.dart';
import 'package:med_connect/services/api_endpoints.dart';

class ApiService {
  final String? baseUrl = ApiEndpoints.baseUrl;
  final _secureStorage = const FlutterSecureStorage();

  String? _token;
  UserModel? _cachedUserProfile;

  void setToken(String? token) {
    _token = token;
    _cachedUserProfile = null;
  }

  Future<String?> getToken() async {
    if (_token != null) return _token;
    _token = await _secureStorage.read(key: 'auth_token');
    return _token;
  }

  Future<Map<String, String>> getHeaders() async {
    final token = await getToken();

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
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
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password, 'role': role}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        // FIXED: Return user data from backend response
        return {
          'success': true,
          'token': data['token'],
          'user': data['user'],
          'message': data['message'] ?? 'Login successful',
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      print('Error in loginWithEmail: $e');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phoneNumber,
    required confirmPassword,
    String? hospitalName,
    String? registrationNumber,
    String? address,
  }) async {
    try {
      final url = Uri.parse('$baseUrl${ApiEndpoints.signup}');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
          'phoneNumber': phoneNumber,
          'confirmPassword': confirmPassword,
          'hospitalName': hospitalName,
          'registrationNumber': registrationNumber,
          'address': address,
        }),
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'token': data['token'],
          'user': data['user'],
          'message': data['message'] ?? 'Signup successful',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Signup failed',
        };
      }
    } catch (e) {
      print('Error in signupWithEmail: $e');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<void> logout() async {
    final headers = await getHeaders();
    try {
      await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.logout}'),
        headers: headers,
      );
    } catch (e) {
      print('Logout error: $e');
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(
    Map<String, dynamic> userData,
  ) async {
    try {
      final headers = await getHeaders();

      final response = await http.put(
        Uri.parse('$baseUrl${ApiEndpoints.updateUserProfile}'),
        headers: headers,
        body: jsonEncode(userData),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          responseData is Map<String, dynamic> &&
          responseData.containsKey('user')) {
        return {'success': true, 'user': responseData['user']};
      }

      return {
        'success': false,
        'message': responseData['message'] ?? 'Profile update failed.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred while updating your profile.',
      };
    }
  }

  Future<UserModel?> getUserProfile({bool forceRefresh = false}) async {
    final headers = await getHeaders();
    if (forceRefresh) {
      _cachedUserProfile = null;
    }

    if (_cachedUserProfile != null) {
      return _cachedUserProfile;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl${ApiEndpoints.getUserProfile}'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = UserModel.fromJson(data['user'] ?? data);

        _cachedUserProfile = user;

        return user;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }
}
*/
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:med_connect/models/user_model.dart';
import 'package:med_connect/services/api_endpoints.dart';

class ApiService {
  final String? baseUrl = ApiEndpoints.baseUrl;
  final _secureStorage = const FlutterSecureStorage();

  String? _token;
  UserModel? _cachedUserProfile;

  void setToken(String? token) {
    _token = token;
    _cachedUserProfile = null;
  }

  Future<String?> getToken() async {
    if (_token != null) {
      print('🔑 Token from memory: ${_token!.substring(0, 20)}...');
      return _token;
    }

    _token = await _secureStorage.read(key: 'auth_token');

    if (_token != null) {
      print('🔑 Token loaded from storage: ${_token!.substring(0, 20)}...');
    } else {
      print('⚠️ No token found in storage');
    }

    return _token;
  }

  Future<Map<String, String>> getHeaders() async {
    final token = await getToken();
    print('🔑 Getting headers, token exists: ${token != null && token.isNotEmpty}');

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
      print('🔑 Authorization header added');
    } else {
      print('⚠️ No token available for authorization');
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
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password, 'role': role}),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200) {
        // FIXED: Return user data from backend response
        return {
          'success': true,
          'token': data['token'],
          'user': data['user'],
          'message': data['message'] ?? 'Login successful',
        };
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      print('Error in loginWithEmail: $e');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phoneNumber,
    required confirmPassword,
    String? hospitalName,
    String? registrationNumber,
    String? address,
  }) async {
    try {
      final url = Uri.parse('$baseUrl${ApiEndpoints.signup}');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
          'phoneNumber': phoneNumber,
          'confirmPassword': confirmPassword,
          'hospitalName': hospitalName,
          'registrationNumber': registrationNumber,
          'address': address,
        }),
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'token': data['token'],
          'user': data['user'],
          'message': data['message'] ?? 'Signup successful',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Signup failed',
        };
      }
    } catch (e) {
      print('Error in signupWithEmail: $e');
      return {'success': false, 'message': 'Network error: ${e.toString()}'};
    }
  }

  Future<void> logout() async {
    final headers = await getHeaders();
    try {
      await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.logout}'),
        headers: headers,
      );
    } catch (e) {
      print('Logout error: $e');
    }
  }

  Future<Map<String, dynamic>> updateUserProfile(
      Map<String, dynamic> userData,
      ) async {
    try {
      final headers = await getHeaders();

      final response = await http.put(
        Uri.parse('$baseUrl${ApiEndpoints.updateUserProfile}'),
        headers: headers,
        body: jsonEncode(userData),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          responseData is Map<String, dynamic> &&
          responseData.containsKey('user')) {
        return {'success': true, 'user': responseData['user']};
      }

      return {
        'success': false,
        'message': responseData['message'] ?? 'Profile update failed.',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred while updating your profile.',
      };
    }
  }

  Future<UserModel?> getUserProfile({bool forceRefresh = false}) async {
    print('📡 Getting user profile... (forceRefresh: $forceRefresh)');

    final headers = await getHeaders();
    print('📡 Headers: ${headers.keys.toList()}');
    print('📡 Has Authorization: ${headers.containsKey('Authorization')}');

    if (forceRefresh) {
      _cachedUserProfile = null;
    }

    if (_cachedUserProfile != null) {
      print('✅ Returning cached user profile');
      return _cachedUserProfile;
    }

    try {
      final url = Uri.parse('$baseUrl${ApiEndpoints.getUserProfile}');
      print('📡 Fetching from: $url');

      final response = await http.get(
        url,
        headers: headers,
      );

      print('📡 Response status: ${response.statusCode}');
      print('📡 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = UserModel.fromJson(data['user'] ?? data);

        _cachedUserProfile = user;
        print('✅ User profile fetched successfully: ${user.name}');

        return user;
      } else {
        print('❌ Failed to get profile. Status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('❌ Exception in getUserProfile: $e');
      throw Exception('Failed to get user profile: $e');
    }
  }
}