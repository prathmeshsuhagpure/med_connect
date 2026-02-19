/*
import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../services/api_service.dart';

class AppointmentProvider extends ChangeNotifier {
  final List<AppointmentModel> _appointments = [];
  bool _isLoading = false;
  String? _error;

  final ApiService _apiService = ApiService();

  bool get isLoading => _isLoading;

  String? get error => _error;

  List<AppointmentModel> get appointments => List.unmodifiable(_appointments);

  List<AppointmentModel> get upcomingAppointments {
    return _appointments.where((apt) => apt.isUpcoming).toList()
      ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
  }

  List<AppointmentModel> get pastAppointments {
    return _appointments.where((apt) => apt.isPast).toList()
      ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
  }

  List<AppointmentModel> get cancelledAppointments {
    return _appointments.where((apt) => apt.isCancelled).toList()
      ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
  }

  Future<Map<String, dynamic>> addAppointment(
    AppointmentModel appointment,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    Map<String, dynamic> result = {
      'success': false,
      'message': 'Unknown error',
    };

    try {
      result = await _apiService.createAppointment(appointment);

      if (result['success'] == true && result['data'] != null) {
        final newAppointment = AppointmentModel.fromJson(result['data']);
        _appointments.add(newAppointment);
      } else {
        _error = result['message'] ?? 'An unknown error occurred';
      }
    } catch (e) {
      _error = e.toString();
      result = {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return result;
  }

  Future<void> loadAppointmentsByPatient(String patientId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.getAppointmentsByPatient(patientId);

      if (result['success'] == true && result['data'] != null) {
        _appointments.clear();

        final List data = result['data'];

        _appointments.addAll(
          data.map((json) => AppointmentModel.fromJson(json)).toList(),
        );
      } else {
        _error = result['message'] ?? 'Failed to load appointments';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAppointmentsByHospital(String hospitalId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.getAppointmentsByHospital(hospitalId);

      if (result['success'] == true && result['data'] != null) {
        _appointments.clear();

        final List data = result['data'];

        _appointments.addAll(
          data.map((json) => AppointmentModel.fromJson(json)).toList(),
        );
      } else {
        _error = result['message'] ?? 'Failed to load appointments';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAppointmentsByDoctor(String doctorId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.getAppointmentsByDoctor(doctorId);

      if (result['success'] == true && result['data'] != null) {
        _appointments.clear();

        final List data = result['data'];

        _appointments.addAll(
          data.map((json) => AppointmentModel.fromJson(json)).toList(),
        );
      } else {
        _error = result['message'] ?? 'Failed to load appointments';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> cancelAppointmentByPatient(
    String appointmentId,
    String reason,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    Map<String, dynamic> result = {
      'success': false,
      'message': 'Unknown error',
    };
    try {
      result = await _apiService.cancelAppointmentByPatient(appointmentId);
      if (result['success'] == true) {
        final index = _appointments.indexWhere(
          (apt) => apt.id == appointmentId,
        );
        if (index != -1) {
          _appointments[index] = _appointments[index].copyWith(
            status: AppointmentStatus.cancelledByPatient,
            cancellationReason: result['reason'] ?? 'Cancelled by patient',
          );
        }
      } else {
        _error = result['message'] ?? 'Failed to cancel appointment';
      }
    } catch (e) {
      _error = e.toString();
      result = {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return result;
  }

  Future<Map<String, dynamic>> cancelAppointmentByHospital(
    String appointmentId,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    Map<String, dynamic> result = {
      'success': false,
      'message': 'Unknown error',
    };
    try {
      result = await _apiService.cancelAppointmentByHospital(appointmentId);
      if (result['success'] == true) {
        final index = _appointments.indexWhere(
          (apt) => apt.id == appointmentId,
        );
        if (index != -1) {
          _appointments[index] = _appointments[index].copyWith(
            status: AppointmentStatus.cancelledByHospital,
            cancellationReason: result['reason'] ?? 'Cancelled by hospital',
          );
        }
      } else {
        _error = result['message'] ?? 'Failed to cancel appointment';
      }
    } catch (e) {
      _error = e.toString();
      result = {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return result;
  }

  Future<Map<String, dynamic>> cancelAppointmentByHospital(
      String appointmentId,
      String reason,
      ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    Map<String, dynamic> result = {
      'success': false,
      'message': 'Unknown error',
    };

    try {
      result = await _apiService.cancelAppointmentByHospital(
        appointmentId,
        reason,
      );

      if (result['success'] == true) {
        final index = _appointments.indexWhere((apt) => apt.id == appointmentId);
        if (index != -1) {
          _appointments[index] = _appointments[index].copyWith(
            status: AppointmentStatus.cancelledByHospital,
            cancellationReason: reason,
          );
        }
      } else {
        _error = result['message'] ?? 'Failed to cancel appointment';
      }
    } catch (e) {
      _error = e.toString();
      result = {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return result;
  }

  Future<Map<String, dynamic>> rescheduleAppointment(
      String appointmentId,
      DateTime newDate,
      String newTime,
      ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    Map<String, dynamic> result = {'success': false, 'message': 'Unknown error'};

    try {
      result = await _apiService.rescheduleAppointment(
        appointmentId,
        newDate,
        newTime,
      );

      if (result['success'] == true && result['data'] != null) {
        final updatedAppointment = AppointmentModel.fromJson(result['data']);

        final index = _appointments.indexWhere((apt) => apt.id == appointmentId);
        if (index != -1) {
          _appointments[index] = updatedAppointment;
        }
      } else {
        _error = result['message'] ?? 'Failed to reschedule appointment';
      }
    } catch (e) {
      _error = e.toString();
      result = {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return result;
  }

  Future<Map<String, dynamic>> updateAppointmentStatus(
      String appointmentId,
      AppointmentStatus newStatus,
      ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    Map<String, dynamic> result = {
      'success': false,
      'message': 'Unknown error',
    };

    try {
      result = await _apiService.updateAppointmentStatus(
        appointmentId,
        newStatus.name,
      );

      if (result['success'] == true) {
        final index = _appointments.indexWhere((apt) => apt.id == appointmentId);
        if (index != -1) {
          _appointments[index] = _appointments[index].copyWith(
            status: newStatus,
          );
        }
      } else {
        _error = result['message'] ?? 'Failed to update appointment status';
      }
    } catch (e) {
      _error = e.toString();
      result = {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return result;
  }

  void clearAppointments() {
    _appointments.clear();
    notifyListeners();
  }

  Future<void> refreshAppointments(String userId, {String? role}) async {
    if (role == 'hospital') {
      await loadAppointmentsByHospital(userId);
    } else if (role == 'doctor') {
      await loadAppointmentsByDoctor(userId);
    } else {
      await loadAppointmentsByPatient(userId);
    }
  }
}
*/

import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../services/api_service.dart';

class AppointmentProvider extends ChangeNotifier {
  final List<AppointmentModel> _appointments = [];
  bool _isLoading = false;
  String? _error;

  final ApiService _apiService = ApiService();

  bool get isLoading => _isLoading;

  String? get error => _error;

  List<AppointmentModel> get appointments => List.unmodifiable(_appointments);

  List<AppointmentModel> get upcomingAppointments {
    return _appointments.where((apt) => apt.isUpcoming).toList()
      ..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
  }

  List<AppointmentModel> get pastAppointments {
    return _appointments.where((apt) => apt.isPast).toList()
      ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
  }

  List<AppointmentModel> get cancelledAppointments {
    return _appointments.where((apt) => apt.isCancelled).toList()
      ..sort((a, b) => b.appointmentDate.compareTo(a.appointmentDate));
  }

  List<AppointmentModel> get todayAppointments {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _appointments.where((apt) {
      final aptDate = DateTime(
        apt.appointmentDate.year,
        apt.appointmentDate.month,
        apt.appointmentDate.day,
      );
      return aptDate == today;
    }).toList()..sort((a, b) => a.appointmentDate.compareTo(b.appointmentDate));
  }

  int get pendingCount => _appointments
      .where((apt) => apt.status == AppointmentStatus.pending)
      .length;

  int get confirmedCount => _appointments
      .where((apt) => apt.status == AppointmentStatus.confirmed)
      .length;

  Future<Map<String, dynamic>> addAppointment(
    AppointmentModel appointment,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    Map<String, dynamic> result = {
      'success': false,
      'message': 'Unknown error',
    };

    try {
      result = await _apiService.createAppointment(appointment);

      if (result['success'] == true && result['data'] != null) {
        final newAppointment = AppointmentModel.fromJson(result['data']);
        _appointments.add(newAppointment);
      } else {
        _error = result['message'] ?? 'An unknown error occurred';
      }
    } catch (e) {
      _error = e.toString();
      result = {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return result;
  }

  Future<void> loadAppointmentsByPatient(String patientId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.getAppointmentsByPatient(patientId);

      if (result['success'] == true && result['data'] != null) {
        _appointments.clear();

        final List data = result['data'];

        _appointments.addAll(
          data.map((json) => AppointmentModel.fromJson(json)).toList(),
        );
      } else {
        _error = result['message'] ?? 'Failed to load appointments';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAppointmentsByHospital(String hospitalId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.getAppointmentsByHospital(hospitalId);

      if (result['success'] == true && result['data'] != null) {
        _appointments.clear();

        final List data = result['data'];

        _appointments.addAll(
          data.map((json) => AppointmentModel.fromJson(json)).toList(),
        );
      } else {
        _error = result['message'] ?? 'Failed to load appointments';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ NEW: Doctor methods - Load appointments by doctor
  Future<void> loadAppointmentsByDoctor(String doctorId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.getAppointmentsByDoctor(doctorId);

      if (result['success'] == true && result['data'] != null) {
        _appointments.clear();

        final List data = result['data'];

        _appointments.addAll(
          data.map((json) => AppointmentModel.fromJson(json)).toList(),
        );
      } else {
        _error = result['message'] ?? 'Failed to load appointments';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Cancel appointment by patient
  Future<Map<String, dynamic>> cancelAppointmentByPatient(
    String appointmentId,
    String reason,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    Map<String, dynamic> result = {
      'success': false,
      'message': 'Unknown error',
    };

    try {
      result = await _apiService.cancelAppointmentByPatient(
        appointmentId,
        reason,
      );

      if (result['success'] == true) {
        final index = _appointments.indexWhere(
          (apt) => apt.id == appointmentId,
        );
        if (index != -1) {
          _appointments[index] = _appointments[index].copyWith(
            status: AppointmentStatus.cancelledByPatient,
            cancellationReason: reason,
          );
        }
      } else {
        _error = result['message'] ?? 'Failed to cancel appointment';
      }
    } catch (e) {
      _error = e.toString();
      result = {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return result;
  }

  // ✅ Cancel appointment by hospital
  Future<Map<String, dynamic>> cancelAppointmentByHospital(
    String appointmentId,
    String reason,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    Map<String, dynamic> result = {
      'success': false,
      'message': 'Unknown error',
    };

    try {
      result = await _apiService.cancelAppointmentByHospital(
        appointmentId,
        reason,
      );

      if (result['success'] == true) {
        final index = _appointments.indexWhere(
          (apt) => apt.id == appointmentId,
        );
        if (index != -1) {
          _appointments[index] = _appointments[index].copyWith(
            status: AppointmentStatus.cancelledByHospital,
            cancellationReason: reason,
          );
        }
      } else {
        _error = result['message'] ?? 'Failed to cancel appointment';
      }
    } catch (e) {
      _error = e.toString();
      result = {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return result;
  }

  // ✅ Reschedule appointment
  Future<Map<String, dynamic>> rescheduleAppointment(
    String appointmentId,
    DateTime newDate,
    String newTime,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    Map<String, dynamic> result = {
      'success': false,
      'message': 'Unknown error',
    };

    try {
      result = await _apiService.rescheduleAppointment(
        appointmentId,
        newDate,
        newTime,
      );

      if (result['success'] == true && result['data'] != null) {
        final updatedAppointment = AppointmentModel.fromJson(result['data']);

        final index = _appointments.indexWhere(
          (apt) => apt.id == appointmentId,
        );
        if (index != -1) {
          _appointments[index] = updatedAppointment;
        }
      } else {
        _error = result['message'] ?? 'Failed to reschedule appointment';
      }
    } catch (e) {
      _error = e.toString();
      result = {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return result;
  }

  Future<Map<String, dynamic>> updateAppointmentStatus(
    String appointmentId,
    AppointmentStatus newStatus,
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    Map<String, dynamic> result = {
      'success': false,
      'message': 'Unknown error',
    };

    try {
      result = await _apiService.updateAppointmentStatus(
        appointmentId,
        newStatus.name,
      );

      if (result['success'] == true) {
        final index = _appointments.indexWhere(
          (apt) => apt.id == appointmentId,
        );
        if (index != -1) {
          _appointments[index] = _appointments[index].copyWith(
            status: newStatus,
          );
        }
      } else {
        _error = result['message'] ?? 'Failed to update appointment status';
      }
    } catch (e) {
      _error = e.toString();
      result = {'success': false, 'message': e.toString()};
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return result;
  }

  Future<void> completeAppointment(String appointmentId, String token) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.completeAppointment(appointmentId, token);

      // Update local appointment status
      final index = _appointments.indexWhere((a) => a.id == appointmentId);

      if (index != -1) {
        _appointments[index] = _appointments[index].copyWith(
          status: AppointmentStatus.completed,
        );
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearAppointments() {
    _appointments.clear();
    notifyListeners();
  }

  Future<void> refreshAppointments(String userId, {String? role}) async {
    if (role == 'hospital') {
      await loadAppointmentsByHospital(userId);
    } else if (role == 'doctor') {
      await loadAppointmentsByDoctor(userId);
    } else {
      await loadAppointmentsByPatient(userId);
    }
  }
}
