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

  // Upload Image EndPoints
  static const uploadProfileImage = '/api/user/upload/profile-picture';
  static const uploadCoverPhoto = '/api/user/upload/cover-photo';
  static const uploadHospitalImages = '/api/user/upload/hospital-images';

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
  static const deleteAccount = '/api/hospital/deleteHospital';

  //Razorpay Endpoints
  static const String createRazorpayOrder = '/api/payment/razorpay/create-order';
  static const String verifyRazorpayPayment = '/api/payment/razorpay/verify';
  static const String getPaymentHistory = '/api/payment/history';
  static const String getPaymentById = '/api/payment';
  static const String refundPayment = '/api/payment/refund';

  // Appointment EndPoints
  static const createAppointment = '/api/appointment/createAppointment';
  static const getAppointmentsByPatient = '/api/appointment/getAppointment/patient';
  static const getAppointmentsByHospital = '/api/appointment/getAppointment/hospital';
  static const getAppointmentsByDoctor = '/api/appointment/getAppointment';
  static const updateAppointmentStatus = '/api/appointment';
  static const rescheduleAppointment = '/api/appointment';
  static const cancelAppointment = '/api/appointment';
  static const completeAppointment = '/api/appointment';

  // Patient EndPoints
  static const getRecentPatients = '/api/patient/getRecentPatients';
  static const getPatientsByHospital = '/api/patient/getPatientByHospital';
  static const getAllPatients = '/api/patient/getAllPatients';
  static const getRecentPatientsByHospital = '/api/patient/getPatientByHospital';

  // FCM Token
  static const saveFcmToken = '/api/auth/save-fcm-token';

}
