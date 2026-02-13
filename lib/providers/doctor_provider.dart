import 'package:flutter/material.dart';
import '../models/user/doctor_model.dart';
import '../services/api_service.dart';

class DoctorProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<DoctorModel> _doctors = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<DoctorModel> get doctors => [..._doctors];
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load all doctors
  Future<void> loadDoctors(String? token) async {
    _setLoading(true);

    try {
      _doctors = await _apiService.fetchAllDoctors(token);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _setLoading(false);
  }

  // Load by hospital
  Future<void> loadDoctorsByHospital(String hospitalId, String? token) async {
    _setLoading(true);

    try {
      _doctors = await _apiService.fetchDoctorsByHospital(hospitalId, token);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _setLoading(false);
  }

  Future<bool> addDoctor(DoctorModel doctor, String? token) async {
    _setLoading(true);

    try {
      final newDoctor = await _apiService.addDoctor(doctor, token);
      _doctors.add(newDoctor);
      _errorMessage = null;

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateDoctor(
    String id,
    DoctorModel doctor,
    String? token,
  ) async {
    _setLoading(true);

    try {
      final updated = await _apiService.updateDoctor(id, doctor, token);

      final index = _doctors.indexWhere((d) => d.id == id);
      if (index != -1) {
        _doctors[index] = updated;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteDoctor(String id, String? token) async {
    _setLoading(true);

    try {
      await _apiService.deleteDoctor(id, token);
      _doctors.removeWhere((d) => d.id == id);

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
