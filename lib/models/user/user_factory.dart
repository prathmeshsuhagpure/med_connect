import 'base_user_model.dart';
import 'patient_model.dart';
import 'hospital_model.dart';
import 'doctor_model.dart';

class UserFactory {
  /// Creates the appropriate user model based on role
  static BaseUser fromJson(Map<String, dynamic> json) {
    final role = json['role']?.toString().toLowerCase() ?? '';

    switch (role) {
      case 'patient':
        return PatientModel.fromJson(json);
      case 'hospital':
        return HospitalModel.fromJson(json);
      case 'doctor':
        return DoctorModel.fromJson(json);
      default:
      // Default to patient if role is unknown
        return PatientModel.fromJson(json);
    }
  }

  /// Type-safe way to get user as specific type
  static T? as<T extends BaseUser>(BaseUser user) {
    if (user is T) {
      return user;
    }
    return null;
  }

  /// Check if user is of specific type
  static bool isPatient(BaseUser user) => user is PatientModel;
  static bool isHospital(BaseUser user) => user is HospitalModel;
  static bool isDoctor(BaseUser user) => user is DoctorModel;
}

// Extension methods for easier type checking
extension UserTypeExtension on BaseUser {
  bool get isPatient => this is PatientModel;
  bool get isHospital => this is HospitalModel;
  bool get isDoctor => this is DoctorModel;

  PatientModel? get asPatient => this is PatientModel ? this as PatientModel : null;
  HospitalModel? get asHospital => this is HospitalModel ? this as HospitalModel : null;
  DoctorModel? get asDoctor => this is DoctorModel ? this as DoctorModel : null;
}