import 'package:flutter/material.dart';
import '../models/user/patient_model.dart';
import '../services/api_service.dart';

class PatientProvider extends ChangeNotifier {
  final List<PatientModel> _patients = [];

  bool _isLoading = false;
  String? _error;

  final ApiService _apiService = ApiService();

  List<PatientModel> get patients => List.unmodifiable(_patients);
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalPatients => _patients.length;

  // ✅ Get filtered patient lists by status
  List<PatientModel> get activePatients {
    return _patients.where((p) => p.isActive ?? false).toList();
  }

  List<PatientModel> get inactivePatients {
    return _patients.where((p) => !(p.isActive ?? true)).toList();
  }

  List<PatientModel> get criticalPatients {
    // TODO: Add critical status logic if needed
    // For now, return empty list or implement based on your business logic
    return [];
  }

  // ✅ Get stats counts
  int get activeCount => activePatients.length;
  int get inactiveCount => inactivePatients.length;
  int get criticalCount => criticalPatients.length;

  // ✅ Fetch recent patients
  Future<void> fetchRecentPatients() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.fetchRecentPatients();

      if (result['success'] == true && result['data'] != null) {
        _patients.clear();

        final List data = result['data'];

        _patients.addAll(
          data.map((json) => PatientModel.fromJson(json)).toList(),
        );
      } else {
        _error = result['message'] ?? 'Failed to load recent patients';
      }
    } catch (e) {
      _error = e.toString();
      debugPrint("Error fetching recent patients: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Fetch all patients
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
      debugPrint("Error fetching all patients: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Fetch patients by hospital ID
  Future<void> fetchPatientsByHospital(String hospitalId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint("Fetching patients for hospital: $hospitalId");

      final result = await _apiService.fetchPatientsByHospital(hospitalId);

      if (result['success'] == true && result['data'] != null) {
        _patients.clear();

        final List data = result['data'];

        _patients.addAll(
          data.map((json) => PatientModel.fromJson(json)).toList(),
        );

        debugPrint("Successfully loaded ${_patients.length} patients");
      } else {
        _error = result['message'] ?? 'Failed to load hospital patients';
        debugPrint("Error loading hospital patients: $_error");
      }
    } catch (e) {
      _error = e.toString();
      debugPrint("Exception fetching hospital patients: $e");
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
      final emailMatch = (patient.email ?? "").toLowerCase().contains(lowercaseQuery);
      final phoneMatch = patient.phoneNumber?.toLowerCase().contains(lowercaseQuery) ?? false;

      return nameMatch || emailMatch || phoneMatch;
    }).toList();
  }

  // ✅ Sort patients
  List<PatientModel> sortPatients(
      List<PatientModel> patients,
      String sortBy,
      ) {
    final sorted = List<PatientModel>.from(patients);

    switch (sortBy) {
      case 'Name':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Recent':
      // Sort by creation date (newest first)
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
          // Younger first
        });
        break;

      default:
      // Default to name sorting
        sorted.sort((a, b) => a.name.compareTo(b.name));
    }

    return sorted;
  }

  Future<void> refreshRecentPatients() async {
    await fetchRecentPatients();
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