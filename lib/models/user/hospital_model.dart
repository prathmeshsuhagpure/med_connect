import 'base_user_model.dart';

class HospitalModel extends BaseUser {
  final String? hospitalName;
  final String? registrationNumber;
  final String? licenseNumber;
  final String? specialties;
  final String? facilities;
  final String? operatingHours;
  final bool? isVerified;
  final double? rating;
  final int? totalReviews;

  HospitalModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
    super.profilePicture,
    super.address,
    super.createdAt,
    super.updatedAt,
    this.hospitalName,
    this.registrationNumber,
    this.licenseNumber,
    this.specialties,
    this.facilities,
    this.operatingHours,
    this.isVerified,
    this.rating,
    this.totalReviews,
  }) : super(role: 'hospital');

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone'] ?? json['phoneNumber'] ?? '',
      profilePicture: json['profileImage'] ?? json['profilePicture'],
      address: json['address'],
      hospitalName: json['hospitalName'],
      registrationNumber: json['registrationNumber'],
      licenseNumber: json['licenseNumber'],
      specialties: json['specialties'],
      facilities: json['facilities'],
      operatingHours: json['operatingHours'],
      isVerified: json['isVerified'] ?? false,
      rating: _parseDouble(json['rating']),
      totalReviews: json['totalReviews'],
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
      'hospitalName': hospitalName,
      'registrationNumber': registrationNumber,
      'licenseNumber': licenseNumber,
      'specialties': specialties,
      'facilities': facilities,
      'operatingHours': operatingHours,
      'isVerified': isVerified,
      'rating': rating,
      'totalReviews': totalReviews,
    };
  }

  HospitalModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    String? address,
    String? hospitalName,
    String? registrationNumber,
    String? licenseNumber,
    String? specialties,
    String? facilities,
    String? operatingHours,
    bool? isVerified,
    double? rating,
    int? totalReviews,
  }) {
    return HospitalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      address: address ?? this.address,
      hospitalName: hospitalName ?? this.hospitalName,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      specialties: specialties ?? this.specialties,
      facilities: facilities ?? this.facilities,
      operatingHours: operatingHours ?? this.operatingHours,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }

  @override
  String get displayName => hospitalName ?? name;

  // Helper getters
  bool get hasCompleteProfile =>
      hospitalName != null &&
          registrationNumber != null &&
          address != null;

  String get verificationStatus =>
      isVerified == true ? 'Verified' : 'Pending Verification';
}