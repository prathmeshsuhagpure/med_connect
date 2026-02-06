/*
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:med_connect/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final _secureStorage = const FlutterSecureStorage();

  bool _isLoading = false;
  String? _token;
  UserModel? _user;
  String? _error;
  bool _isHospital = false;

  static const String TOKEN_KEY = 'auth_token';
  static const String LOGIN_KEY = 'isLoggedIn';
  static const String USER_KEY = 'user';
  static const String HOSPITAL_KEY = 'isHospital';

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;
  UserModel? get user => _user;
  String? get error => _error;
  bool get isHospital => _isHospital;

  Future<void> _clearAllData() async {
    _user = null;
    _token = null;
    _isHospital = false;

    _apiService.setToken(null);

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    await prefs.remove('is_hospital');
    await prefs.remove('user_id');

    await _secureStorage.deleteAll();
  }

  Future<void> _saveUserToStorage(UserModel user) async {
    try {
      await _secureStorage.write(
        key: USER_KEY,
        value: json.encode(user.toJson()),
      );
    } catch (e) {
      _error = 'Failed to save user data';
    }
  }

  Future<Map<String, dynamic>?> login(
    String email,
    String password, {
    String role = 'patient',
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.login(
        email: email,
        password: password,
        role: role,
      );

      if (response['success'] == true) {
        _token = response['token'];
        _user = UserModel.fromJson(response['user']);

        if (_token != null) {
          await _secureStorage.write(key: TOKEN_KEY, value: _token!);
          await _secureStorage.write(key: 'user_data', value: jsonEncode(_user!.toJson()));

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(LOGIN_KEY, true);
          await prefs.setBool(HOSPITAL_KEY, _user!.role.toLowerCase() == 'hospital');

          */
/*if (_user != null) {
            await _secureStorage.write(
              key: 'user_data',
              value: jsonEncode(_user!.toJson()),
            );
          }*//*


          _apiService.setToken(_token);
        }
      } else {
        _error = response['message'] ?? 'Login failed';
      }

      notifyListeners();
      return response;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> signup({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phoneNumber,
    required String confirmPassword,
    String? hospitalName,
    String? registrationNumber,
    String? address,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.signup(
        name: name,
        email: email,
        password: password,
        role: role,
        phoneNumber: phoneNumber,
        confirmPassword: confirmPassword,
        hospitalName: hospitalName,
        registrationNumber: registrationNumber,
        address: address,
      );

      if (response['success'] == true) {
        _token = response['token'];
        _user = UserModel.fromJson(response['user']);


        if (_token != null) {
          await _secureStorage.write(key: 'auth_token', value: _token!);

          if (_user != null) {
            await _secureStorage.write(
              key: 'user_data',
              value: jsonEncode(_user!.toJson()),
            );
          }

          _apiService.setToken(_token);
        }
      } else {
        _error = response['message'] ?? 'Signup failed';
      }

      return response;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> tryAutoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load token from secure storage
      _token = await _secureStorage.read(key: TOKEN_KEY);

      final isLoggedIn = prefs.getBool(LOGIN_KEY) ?? false;
      if (!isLoggedIn) return false;

      if (_token == null) {
        await _clearAllData();
        return false;
      }

      _apiService.setToken(_token!);

      final userProfile = await _apiService.getUserProfile();

      if (userProfile != null) {
        _user = userProfile;
        _isHospital = _user!.role.toLowerCase() == 'hospital';
        await _saveUserToStorage(userProfile);
        notifyListeners();
        return true;
      } else {
        await _clearAllData();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      await _clearAllData();
      return false;
    }
  }

  // Update profile method
  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.updateUserProfile(profileData);

      if (response['success'] == true) {
        _user = UserModel.fromJson(response['user']);

        if (_user != null) {
          await _secureStorage.write(
            key: 'user_data',
            value: jsonEncode(_user!.toJson()),
          );
        }

        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Failed to update profile';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      print('Backend logout error: $e');
    }

    _token = null;
    _user = null;
    _error = null;

    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'user_data');
    _apiService.setToken(null);

    notifyListeners();
  }

  Future<void> forceLogout() async {
    await _clearAllData();
    notifyListeners();
  }

  */
/*Future<bool> refreshUserData() async {
    try {
      final response = await _apiService.verifyToken();

      if (response['success'] == true && response['user'] != null) {
        _user = response['user'];

        await _secureStorage.write(
          key: 'user_data',
          value: jsonEncode(_user),
        );

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error refreshing user data: $e');
      return false;
    }
  }*//*

}
*/
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:med_connect/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final _secureStorage = const FlutterSecureStorage();

  bool _isLoading = false;
  String? _token;
  UserModel? _user;
  String? _error;
  bool _isHospital = false;

  static const String TOKEN_KEY = 'auth_token';
  static const String LOGIN_KEY = 'isLoggedIn';
  static const String USER_KEY = 'user';
  static const String HOSPITAL_KEY = 'isHospital';

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;
  UserModel? get user => _user;
  String? get error => _error;
  bool get isHospital => _isHospital;

  Future<void> _clearAllData() async {
    print('🧹 Clearing all data...');
    _user = null;
    _token = null;
    _isHospital = false;

    _apiService.setToken(null);

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(TOKEN_KEY);
    await prefs.remove(LOGIN_KEY);
    await prefs.remove(HOSPITAL_KEY);
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
    await prefs.remove('is_hospital');
    await prefs.remove('user_id');

    await _secureStorage.deleteAll();
    print('✅ All data cleared');
  }

  Future<void> _saveUserToStorage(UserModel user) async {
    try {
      await _secureStorage.write(
        key: USER_KEY,
        value: json.encode(user.toJson()),
      );
      print('✅ User saved to storage');
    } catch (e) {
      print('❌ Failed to save user data: $e');
      _error = 'Failed to save user data';
    }
  }

  Future<Map<String, dynamic>?> login(
      String email,
      String password, {
        String role = 'patient',
      }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('🔐 Attempting login for: $email');

      final response = await _apiService.login(
        email: email,
        password: password,
        role: role,
      );

      if (response['success'] == true) {
        _token = response['token'];
        _user = UserModel.fromJson(response['user']);

        print('✅ Login successful, token: ${_token?.substring(0, 20)}...');
        print('✅ User role: ${_user?.role}');

        if (_token != null) {
          await _secureStorage.write(key: TOKEN_KEY, value: _token!);
          await _secureStorage.write(key: 'user_data', value: jsonEncode(_user!.toJson()));

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool(LOGIN_KEY, true);
          await prefs.setBool(HOSPITAL_KEY, _user!.role.toLowerCase() == 'hospital');

          print('✅ Token and user data saved to storage');
          print('✅ LOGIN_KEY set to: true');

          _apiService.setToken(_token);
        }
      } else {
        print('❌ Login failed: ${response['message']}');
        _error = response['message'] ?? 'Login failed';
      }

      notifyListeners();
      return response;
    } catch (e) {
      print('❌ Login error: $e');
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> signup({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phoneNumber,
    required String confirmPassword,
    String? hospitalName,
    String? registrationNumber,
    String? address,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.signup(
        name: name,
        email: email,
        password: password,
        role: role,
        phoneNumber: phoneNumber,
        confirmPassword: confirmPassword,
        hospitalName: hospitalName,
        registrationNumber: registrationNumber,
        address: address,
      );

      if (response['success'] == true) {
        _token = response['token'];
        _user = UserModel.fromJson(response['user']);


        if (_token != null) {
          await _secureStorage.write(key: 'auth_token', value: _token!);

          if (_user != null) {
            await _secureStorage.write(
              key: 'user_data',
              value: jsonEncode(_user!.toJson()),
            );
          }

          _apiService.setToken(_token);
        }
      } else {
        _error = response['message'] ?? 'Signup failed';
      }

      return response;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> tryAutoLogin() async {
    try {
      print('🔍 Trying auto login...');

      final prefs = await SharedPreferences.getInstance();

      // Check if user was logged in
      final isLoggedIn = prefs.getBool(LOGIN_KEY) ?? false;
      print('📌 LOGIN_KEY value: $isLoggedIn');

      if (!isLoggedIn) {
        print('❌ User not logged in (LOGIN_KEY is false)');
        await _clearAllData();
        return false;
      }

      // Load token from secure storage
      _token = await _secureStorage.read(key: TOKEN_KEY);
      print('📌 Token loaded: ${_token != null ? "${_token!.substring(0, 20)}..." : "null"}');

      if (_token == null) {
        print('❌ No token found in secure storage');
        await _clearAllData();
        return false;
      }

      _apiService.setToken(_token!);
      print('✅ Token set in API service');

      print('🌐 Fetching user profile...');
      final userProfile = await _apiService.getUserProfile();

      if (userProfile != null) {
        _user = userProfile;
        _isHospital = _user!.role.toLowerCase() == 'hospital';
        print('✅ User profile loaded: ${_user!.name}, role: ${_user!.role}');

        await _saveUserToStorage(userProfile);
        notifyListeners();
        return true;
      } else {
        print('❌ Failed to fetch user profile');
        await _clearAllData();
        return false;
      }
    } catch (e) {
      print('❌ Auto login error: $e');
      _error = e.toString();
      await _clearAllData();
      return false;
    }
  }

  // Update profile method
  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.updateUserProfile(profileData);

      if (response['success'] == true) {
        _user = UserModel.fromJson(response['user']);

        if (_user != null) {
          await _secureStorage.write(
            key: 'user_data',
            value: jsonEncode(_user!.toJson()),
          );
        }

        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Failed to update profile';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    print('👋 Logging out...');
    try {
      await _apiService.logout();
    } catch (e) {
      print('Backend logout error: $e');
    }

    _token = null;
    _user = null;
    _error = null;

    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'user_data');

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(LOGIN_KEY);
    await prefs.remove(HOSPITAL_KEY);

    _apiService.setToken(null);

    notifyListeners();
    print('✅ Logout complete');
  }

  Future<void> forceLogout() async {
    await _clearAllData();
    notifyListeners();
  }
}