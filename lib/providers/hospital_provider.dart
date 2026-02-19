import 'package:flutter/material.dart';
import '../models/user/hospital_model.dart';
import '../services/api_service.dart';

class HospitalProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<HospitalModel> _hospitals = [];
  HospitalModel? _currentHospital;

  bool _isLoading = false;
  String? _errorMessage;

  List<HospitalModel> get hospitals => [..._hospitals];

  HospitalModel? get currentHospital => _currentHospital;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> loadHospitals({
    int page = 1,
    int limit = 10,
    String? token,
  }) async {
    _setLoading(true);

    try {
      _hospitals = await _apiService.fetchHospitals(
        page: page,
        limit: limit,
        token: token,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _setLoading(false);
  }

  /// LOAD SINGLE
  Future<void> loadHospital(String id, String? token) async {
    _setLoading(true);

    try {
      _currentHospital = await _apiService.fetchHospital(id, token);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  /// UPDATE
  Future<bool> updateHospital(
    String id,
    HospitalModel hospital,
    String? token,
  ) async {
    try {
      final updated = await _apiService.updateHospital(id, hospital, token);

      final index = _hospitals.indexWhere((h) => h.id == id);
      if (index != -1) {
        _hospitals[index] = updated;
      }

      if (_currentHospital?.id == id) {
        _currentHospital = updated;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// DELETE
  Future<void> deleteAccount(String id) async {
    try {
      // Call backend to delete account from MongoDB
      await _apiService.deleteAccount(id);

      _hospitals.removeWhere((h) => h.id == id);

      _currentHospital = null;

      await _apiService.logout();

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// TOGGLE
  /*Future<void> toggleStatus(String id, String? token) async {
    try {
      final isActive = await _apiService.toggleStatus(id, token);

      final index = _hospitals.indexWhere((h) => h.id == id);
      if (index != -1) {
        _hospitals[index] =
            _hospitals[index].copyWith(isAvailable: isActive);
      }

      if (_currentHospital?.id == id) {
        _currentHospital =
            _currentHospital?.copyWith(isAvailable: isActive);
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }*/

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
