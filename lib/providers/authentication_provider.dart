import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/api_endpoints.dart';
import '../services/api_service.dart';
import '../models/user/base_user_model.dart';
import '../models/user/patient_model.dart';
import '../models/user/hospital_model.dart';
import '../models/user/doctor_model.dart';
import '../models/user/user_factory.dart';
import 'dart:convert';

class AuthenticationProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final _secureStorage = const FlutterSecureStorage();

  bool _isLoading = false;
  String? _token;
  BaseUser? _currentUser;
  String? _error;

  // Getters
  bool get isLoading => _isLoading;

  bool get isAuthenticated => _token != null && _currentUser != null;

  String? get error => _error;

  BaseUser? get currentUser => _currentUser;

  String? get userRole => _currentUser?.role;

  // Type-safe getters
  PatientModel? get patient => _currentUser?.asPatient;

  HospitalModel? get hospital => _currentUser?.asHospital;

  DoctorModel? get doctor => _currentUser?.asDoctor;

  // Role checks
  bool get isPatient => _currentUser?.isPatient ?? false;

  bool get isHospital => _currentUser?.isHospital ?? false;

  bool get isDoctor => _currentUser?.isDoctor ?? false;

  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Login
  Future<Map<String, dynamic>?> login(
    String email,
    String password, {
    required String role,
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

        // Create appropriate user model based on role
        if (response['user'] != null) {
          _currentUser = UserFactory.fromJson(response['user']);

          // Save to secure storage
          await _secureStorage.write(key: 'auth_token', value: _token!);
          await _secureStorage.write(
            key: 'user_data',
            value: jsonEncode(response['user']),
          );
          await _secureStorage.write(key: 'user_role', value: role);

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

  /// Signup for Patient
  Future<Map<String, dynamic>?> signupPatient({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String confirmPassword,
    String? address,
  }) async {
    return _signup(
      name: name,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      confirmPassword: confirmPassword,
      role: 'patient',
      address: address,
    );
  }

  /// Signup for Hospital
  Future<Map<String, dynamic>?> signupHospital({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String confirmPassword,
    required String hospitalName,
    required String registrationNumber,
    String? address,
  }) async {
    return _signup(
      name: name,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      confirmPassword: confirmPassword,
      role: 'hospital',
      hospitalName: hospitalName,
      registrationNumber: registrationNumber,
      address: address,
    );
  }

  /// Signup for Doctor
  Future<Map<String, dynamic>?> signupDoctor({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String confirmPassword,
    required String specialization,
    required String qualification,
    String? licenseNumber,
    String? address,
  }) async {
    return _signup(
      name: name,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      confirmPassword: confirmPassword,
      role: 'doctor',
      specialization: specialization,
      qualification: qualification,
      licenseNumber: licenseNumber,
      address: address,
    );
  }

  /// Internal signup method
  Future<Map<String, dynamic>?> _signup({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String confirmPassword,
    required String role,
    String? hospitalName,
    String? registrationNumber,
    String? specialization,
    String? qualification,
    String? licenseNumber,
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
        specialization: specialization,
        qualification: qualification,
        licenseNumber: licenseNumber,
        address: address,
      );

      if (response['success'] == true) {
        _token = response['token'];

        if (response['user'] != null) {
          _currentUser = UserFactory.fromJson(response['user']);

          await _secureStorage.write(key: 'auth_token', value: _token!);
          await _secureStorage.write(
            key: 'user_data',
            value: jsonEncode(response['user']),
          );
          await _secureStorage.write(key: 'user_role', value: role);

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

  Future<bool> updateProfile(Map<String, dynamic> profileData) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _apiService.updateProfile(profileData);

      if (response['success'] == true) {
        if (response['user'] != null) {
          _currentUser = UserFactory.fromJson(response['user']);

          await _secureStorage.write(
            key: 'user_data',
            value: jsonEncode(response['user']),
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

  /// Logout
  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (e) {
      throw Exception("Backend logout error: $e");
    }

    _token = null;
    _currentUser = null;
    _error = null;

    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'user_data');
    await _secureStorage.delete(key: 'user_role');
    _apiService.setToken(null);

    notifyListeners();
  }

  /// Load stored authentication
  Future<void> loadStoredAuth() async {
    try {
      _token = await _secureStorage.read(key: 'auth_token');

      if (_token != null) {
        _apiService.setToken(_token);

        // Verify token with backend
        final isValid = await _validateToken();

        if (isValid) {
          // Load stored user data
          final userDataString = await _secureStorage.read(key: 'user_data');
          if (userDataString != null) {
            try {
              final userData = jsonDecode(userDataString);
              _currentUser = UserFactory.fromJson(userData);
            } catch (e) {
              throw Exception("Error parsing user data: $e");
            }
          }
        } else {
          await logout();
        }
      }

      notifyListeners();
    } catch (e) {
      await logout();
      throw Exception("Error loading stored auth: $e");

    }
  }

  /// Validate token with backend
  Future<bool> _validateToken() async {
    try {
      final response = await _apiService.verifyToken();

      if (response['success'] == true) {
        if (response['user'] != null) {
          _currentUser = UserFactory.fromJson(response['user']);

          await _secureStorage.write(
            key: 'user_data',
            value: jsonEncode(response['user']),
          );
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchUserProfile() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _apiService.getUserProfile();

      if (result['success'] == true && result['user'] != null) {
        _currentUser = UserFactory.fromJson(result['user']);

        await _secureStorage.write(
          key: 'user_data',
          value: jsonEncode(result['user']),
        );

        notifyListeners();
        return true;
      } else {
        _error = result['message'] ?? 'Failed to fetch profile';
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

  Future<String?> uploadProfilePicture(File imageFile) async {
    if (_token == null) return null;

    final result = await _apiService.uploadImages(
      files: [imageFile],
      token: _token!,
      endpoint: ApiEndpoints.uploadProfileImage,
      fieldName: 'image',
    );

    return result?.first;
  }

  Future<String?> uploadCoverPhoto(File imageFile) async {
    if (_token == null) return null;

    final result = await _apiService.uploadImages(
      files: [imageFile],
      token: _token!,
      endpoint: ApiEndpoints.uploadCoverPhoto,
      fieldName: 'image',
    );

    return result?.first;
  }

  Future<List<String>?> uploadHospitalImages(List<File> images) async {
    if (_token == null) return null;

    return await _apiService.uploadImages(
      files: images,
      token: _token!,
      endpoint: ApiEndpoints.uploadHospitalImages,
      fieldName: 'images',
    );
  }


}
