class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String phoneNumber;
  final String confirmPassword;
  final String? hospitalName;
  final String? registrationNumber;
  final String? profilePicture;
  final String? dateOfBirth;
  final String? gender;
  final String? bloodGroup;
  final double? height;
  final double? weight;
  final String? address;
  final String? emergencyName;
  final String? emergencyContact;
  final String? allergies;
  final String? medications;
  final String? conditions;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.phoneNumber,
    required this.confirmPassword,
    this.hospitalName,
    this.registrationNumber,
    this.profilePicture,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.height,
    this.weight,
    this.address,
    this.emergencyName,
    this.emergencyContact,
    this.allergies,
    this.medications,
    this.conditions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"] ?? '',
      name: json["name"] ?? '',
      email: json["email"] ?? '',
      password: json["password"] ?? '',
      role: json["role"] ?? '',
      phoneNumber: json["phoneNumber"] ?? '',
      confirmPassword: json["confirmPassword"] ?? '',
      hospitalName: json["hospitalName"],
      registrationNumber: json["registrationNumber"],
      profilePicture: json["profilePicture"],
      dateOfBirth: json["dateOfBirth"],
      gender: json["gender"],
      bloodGroup: json["bloodGroup"],
      height: _parseDouble(json['height']),
      weight: _parseDouble(json['weight']),
      address: json["address"],
      emergencyName: json["emergencyName"],
      emergencyContact: json["emergencyContact"],
      allergies: json["allergies"],
      medications: json["medications"],
      conditions: json["conditions"],
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      if (value.isEmpty) return null;
      return double.tryParse(value);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "role": role,
      "phoneNumber": phoneNumber,
      "confirmPassword": confirmPassword,
      "hospitalName": hospitalName,
      "registrationNumber": registrationNumber,
      "profilePicture": profilePicture,
      "dateOfBirth": dateOfBirth,
      "gender": gender,
      "bloodGroup": bloodGroup,
      "height": height,
      "weight": weight,
      "address": address,
      "emergencyName": emergencyName,
      "emergencyContact": emergencyContact,
      "allergies": allergies,
      "medications": medications,
      "conditions": conditions,
    };
  }

  bool get isHospital => role.toLowerCase() == 'hospital';

}
