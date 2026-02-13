import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost';

  // Auth endpoints
  static const signup = '/api/auth/signup';
  static const login = '/api/auth/login';
  static const logout = '/api/auth/logout';
  static const verifyToken = '/api/auth/verify-token';

  // User EndPoints
  static const updateUserProfile = '/api/user/update-profile';
  static const getUserProfile = '/api/user/profile';
  static const deleteUserProfile = '/api/user/profile';
  static const uploadProfileImage = '/api/user/upload/profile-picture';

  // Doctor EndPoints
  static const getAllDoctors = '/api/doctor/getDoctors';
  static const getDoctorsByHospital = '/api/doctor/hospitals';
  static const addDoctor = '/api/doctor/addDoctors';
  static const updateDoctor = '/api/doctor/updateDoctor';
  static const deleteDoctor = '/api/doctor/deleteDoctor';

  // Hospital EndPoints
  static const getHospitals = '/api/hospital/';
  static const getHospital = '/api/hospital';
  static const addHospital = '/api/hospital/addHospital';
  static const updateHospital = '/api/hospital/updateHospital';
  static const deleteHospital = '/api/hospital/deleteHospital';
  static const toggleStatus = '/api/hospital';
}
