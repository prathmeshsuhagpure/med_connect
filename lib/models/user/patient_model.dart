import 'package:intl/intl.dart';

import 'base_user_model.dart';

class PatientModel extends BaseUser {
  final DateTime? dateOfBirth;
  final String? gender;
  final String? bloodGroup;
  final double? height;
  final double? weight;
  final String? emergencyName;
  final String? emergencyContact;
  final String? allergies;
  final String? medications;
  final String? conditions;
  final bool? isActive;

  PatientModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
    super.profilePicture,
    super.address,
    super.createdAt,
    super.updatedAt,
    this.dateOfBirth,
    this.gender,
    this.bloodGroup,
    this.height,
    this.weight,
    this.emergencyName,
    this.emergencyContact,
    this.allergies,
    this.medications,
    this.conditions,
    this.isActive,
  }) : super(role: 'patient');

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDob;
    if (json['dob'] != null) {
      parsedDob = DateTime.tryParse(json['dob']);
      parsedDob ??= DateFormat("MMMM d, yyyy").parse(json['dob']);
    } else if (json['dateOfBirth'] != null) {
      parsedDob = DateTime.tryParse(json['dateOfBirth']);
      parsedDob ??= DateFormat("MMMM d, yyyy").parse(json['dateOfBirth']);
    }
    return PatientModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone'] ?? json['phoneNumber'] ?? '',
      profilePicture: json['profileImage'] ?? json['profilePicture'],
      address: json['address'],
      dateOfBirth: parsedDob,
      gender: json['gender'],
      bloodGroup: json['bloodGroup'],
      height: _parseDouble(json['height']),
      weight: _parseDouble(json['weight']),
      emergencyName: json['emergencyName'],
      emergencyContact: json['emergencyContact']?.toString(),
      allergies: json['allergies'],
      medications: json['medications'],
      conditions: json['conditions'],
      isActive: json['isActive'] ?? json['active'] ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
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

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'address': address,
      'dob': dateOfBirth,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'height': height,
      'weight': weight,
      'emergencyName': emergencyName,
      'emergencyContact': emergencyContact,
      'allergies': allergies,
      'medications': medications,
      'conditions': conditions,
      'isActive': isActive,
    };
  }

  // Convenience method to create a copy with updated fields
  PatientModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    String? address,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodGroup,
    double? height,
    double? weight,
    String? emergencyName,
    String? emergencyContact,
    String? allergies,
    String? medications,
    String? conditions,
    bool? isActive,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      emergencyName: emergencyName ?? this.emergencyName,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      conditions: conditions ?? this.conditions,
      isActive: isActive ?? this.isActive,
    );
  }

  // Helper getters
  int? get age {
    if (dateOfBirth == null) return null;

    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;

    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }

    return age;
  }

  String get statusText => (isActive ?? false) ? 'Active' : 'Inactive';

  bool get hasEmergencyContact =>
      emergencyName != null && emergencyContact != null;

  String? get formattedDateOfBirth {
    if (dateOfBirth == null) {
      return null;
    }
    return DateFormat('dd MMM yyyy').format(dateOfBirth!);
  }

  bool get hasCompleteProfile =>
      dateOfBirth != null && gender != null && bloodGroup != null;
}
