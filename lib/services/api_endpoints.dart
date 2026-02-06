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

}
