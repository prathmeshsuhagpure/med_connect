import 'package:flutter/material.dart';
import '../models/user/patient_model.dart';
import '../services/api_service.dart';

class PatientProvider extends ChangeNotifier {
  final List<PatientModel> _patients = [];
  final List<PatientModel> _recentPatients = [];

  bool _isLoading = false;
  String? _error;

  final ApiService _apiService = ApiService();

  List<PatientModel> get patients => List.unmodifiable(_patients);

  List<PatientModel> get recentPatients => List.unmodifiable(_recentPatients);

  bool get isLoading => _isLoading;

  String? get error => _error;

  int get totalPatients => _patients.length;

  List<PatientModel> get activePatients {
    return _patients.where((p) => p.isActive ?? false).toList();
  }

  List<PatientModel> get inactivePatients {
    return _patients.where((p) => !(p.isActive ?? true)).toList();
  }

  List<PatientModel> get criticalPatients {
    return [];
  }

  int get activeCount => activePatients.length;

  int get inactiveCount => inactivePatients.length;

  int get criticalCount => criticalPatients.length;

  Future<void> fetchRecentPatients(String hospitalId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final patients = await _apiService.getRecentPatientsByHospital(
        hospitalId,
      );
      _recentPatients
        ..clear()
        ..addAll(patients);
    } catch (e) {
      print("Error fetching recent patients: $e");
      _recentPatients.clear();
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllPatients() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.fetchAllPatients();

      if (result['success'] == true && result['data'] != null) {
        _patients.clear();

        final List data = result['data'];

        _patients.addAll(
          data.map((json) => PatientModel.fromJson(json)).toList(),
        );
      } else {
        _error = result['message'] ?? 'Failed to load patients';
      }
    } catch (e) {
      _error = e.toString();
      print("Error fetching all patients: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPatientsByHospital(String hospitalId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.fetchPatientsByHospital(hospitalId);

      if (result['success'] == true && result['data'] != null) {
        _patients.clear();

        final List data = result['data'];

        _patients.addAll(
          data.map((json) => PatientModel.fromJson(json)).toList(),
        );
      } else {
        _error = result['message'] ?? 'Failed to load hospital patients';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<PatientModel> searchPatients(String query) {
    if (query.isEmpty) return _patients;

    final lowercaseQuery = query.toLowerCase();
    return _patients.where((patient) {
      final nameMatch = patient.name.toLowerCase().contains(lowercaseQuery);
      final emailMatch = (patient.email ?? "").toLowerCase().contains(
        lowercaseQuery,
      );
      final phoneMatch =
          patient.phoneNumber?.toLowerCase().contains(lowercaseQuery) ?? false;

      return nameMatch || emailMatch || phoneMatch;
    }).toList();
  }

  List<PatientModel> sortPatients(List<PatientModel> patients, String sortBy) {
    final sorted = List<PatientModel>.from(patients);

    switch (sortBy) {
      case 'Name':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Recent':
        sorted.sort((a, b) {
          final aDate = a.createdAt ?? DateTime(1970);
          final bDate = b.createdAt ?? DateTime(1970);
          return bDate.compareTo(aDate);
        });
        break;
      case 'Age':
        sorted.sort((a, b) {
          if (a.dateOfBirth == null && b.dateOfBirth == null) return 0;
          if (a.dateOfBirth == null) return 1;
          if (b.dateOfBirth == null) return -1;

          return b.dateOfBirth!.compareTo(a.dateOfBirth!);
        });
        break;

      default:
        sorted.sort((a, b) => a.name.compareTo(b.name));
    }

    return sorted;
  }

  Future<void> refreshRecentPatients(String hospitalId) async {
    await fetchRecentPatients(hospitalId);
  }

  Future<void> refreshAllPatients() async {
    await fetchAllPatients();
  }

  Future<void> refreshPatientsByHospital(String hospitalId) async {
    await fetchPatientsByHospital(hospitalId);
  }

  void clearPatients() {
    _patients.clear();
    notifyListeners();
  }
}
