import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user/doctor_model.dart';
import '../models/user/hospital_model.dart';
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
        if (hospitalName?.isNotEmpty ?? false) {
          body['hospitalName'] = hospitalName!;
        }
        if (registrationNumber?.isNotEmpty ?? false) {
          body['registrationNumber'] = registrationNumber!;
        }
      }

      // Doctor-specific fields
      if (role == 'doctor') {
        if (specialization?.isNotEmpty ?? false) {
          body['specialization'] = specialization!;
        }
        if (qualification?.isNotEmpty ?? false) {
          body['qualification'] = qualification!;
        }
        if (licenseNumber?.isNotEmpty ?? false) {
          body['licenseNumber'] = licenseNumber!;
        }
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

      if (response.statusCode == 200 && data['success'] == true) {
        return data;
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get profile',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  Future<String?> uploadProfileImage(File imageFile, String token) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl${ApiEndpoints.uploadProfileImage}'),
      );
      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        return data['imageUrl'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await http.post(
        Uri.parse('$baseUrl${ApiEndpoints.logout}'),
        headers: _getHeaders(includeAuth: true),
      );
    } catch (e) {
      throw Exception('Logout error: $e');
    }
  }

  Future<List<DoctorModel>> fetchAllDoctors(String? token) async {
    final response = await http.get(
      Uri.parse('$baseUrl${ApiEndpoints.getAllDoctors}'),
      headers: _getHeaders(includeAuth: true),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];
      return data.map((e) => DoctorModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  Future<List<DoctorModel>> fetchDoctorsByHospital(
    String hospitalId,
    String? token,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl${ApiEndpoints.getDoctorsByHospital}/$hospitalId/doctors',
      ),
      headers: _getHeaders(includeAuth: true),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];
      return data.map((e) => DoctorModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load hospital doctors');
    }
  }

  Future<DoctorModel> addDoctor(DoctorModel doctor, String? token) async {
    final response = await http.post(
      Uri.parse('$baseUrl${ApiEndpoints.addDoctor}'),
      headers: _getHeaders(includeAuth: true),
      body: json.encode(doctor.toJson()),
    );

    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      return DoctorModel.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to add doctor');
    }
  }

  Future<DoctorModel> updateDoctor(
    String id,
    DoctorModel doctor,
    String? token,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl${ApiEndpoints.updateDoctor}/$id}'),
      headers: _getHeaders(includeAuth: true),
      body: json.encode(doctor.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return DoctorModel.fromJson(jsonData['data']);
    } else {
      throw Exception('Failed to update doctor');
    }
  }

  Future<void> deleteDoctor(String id, String? token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl${ApiEndpoints.deleteDoctor}/$id}'),
      headers: _getHeaders(includeAuth: true),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete doctor');
    }
  }

  // Hospital

  Future<List<HospitalModel>> fetchHospitals({
    required int page,
    required int limit,
    String? search,
    String? type,
    String? city,
    String? state,
    bool? is24x7,
    bool? isVerified,
    String? token,
  }) async {
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (search != null) 'search': search,
      if (type != null) 'type': type,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (is24x7 != null) 'is24x7': is24x7.toString(),
      if (isVerified != null) 'isVerified': isVerified.toString(),
    };

    final uri = Uri.parse(
      '$baseUrl${ApiEndpoints.getHospitals}',
    ).replace(queryParameters: queryParams);

    final response = await http.get(uri, headers: _getHeaders(includeAuth: true));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((e) => HospitalModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load hospitals');
    }
  }

  Future<HospitalModel> fetchHospital(
      String hospitalId,
      String? token,
      ) async {
    final uri =
    Uri.parse('$baseUrl${ApiEndpoints.getHospital}/$hospitalId');

    final response = await http.get(
      uri,
      headers: _getHeaders(includeAuth: true),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> decoded =
      json.decode(response.body);

      final Map<String, dynamic> hospitalData =
      decoded['data'] as Map<String, dynamic>;

      return HospitalModel.fromJson(hospitalData);
    } else {
      throw Exception(
        "Failed to load hospital (Status: ${response.statusCode})",
      );
    }
  }


  Future<HospitalModel> addHospital(
    HospitalModel hospital,
    String? token,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl${ApiEndpoints.addHospital}'),
      headers: _getHeaders(includeAuth: true),
      body: json.encode(hospital.toJson()),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body)['data'];
      return HospitalModel.fromJson(data);
    } else {
      throw Exception('Failed to add hospital');
    }
  }

  Future<HospitalModel> updateHospital(
    String id,
    HospitalModel hospital,
    String? token,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl${ApiEndpoints.updateHospital}/$id}'),
      headers: _getHeaders(includeAuth: true),
      body: json.encode(hospital.toJson()),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return HospitalModel.fromJson(data);
    } else {
      throw Exception('Failed to update hospital');
    }
  }

  Future<void> deleteHospital(String id, String? token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl${ApiEndpoints.deleteHospital}/$id}'),
      headers: _getHeaders(includeAuth: true,)
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete hospital');
    }
  }

  Future<bool> toggleStatus(String id, String? token) async {
    final response = await http.patch(
      Uri.parse('$baseUrl${ApiEndpoints.toggleStatus}/$id/toggle-status}'),
      headers: _getHeaders(includeAuth: true,)
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['data']['isActive'];
    } else {
      throw Exception('Failed to toggle status');
    }
  }
}
