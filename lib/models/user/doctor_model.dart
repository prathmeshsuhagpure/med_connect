import 'base_user_model.dart';

class DoctorModel extends BaseUser {
  final String? specialization;
  final String? qualification;
  final String? licenseNumber;
  final String? experience;
  final String? hospitalAffiliation;
  final String? consultationFee;
  final String? availableHours;
  final bool? isVerified;
  final double? rating;
  final int? totalReviews;
  bool isAvailable;
  final String? department;
  final String? hospitalId;
  final String? gender;
  final String? bio;

  DoctorModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
    super.profilePicture,
    super.address,
    super.createdAt,
    super.updatedAt,
    this.specialization,
    this.qualification,
    this.licenseNumber,
    this.experience,
    this.hospitalAffiliation,
    this.consultationFee,
    this.availableHours,
    this.isVerified,
    this.rating,
    this.totalReviews,
    required this.isAvailable,
    this.department,
    this.hospitalId,
    this.gender,
    this.bio,
  }) : super(role: 'doctor');

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['_id'] ?? json['id'] ?? "",
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone'] ?? json['phoneNumber'] ?? '',
      profilePicture: json['profileImage'] ?? json['profilePicture'],
      address: json['address'],
      specialization: json['specialization'],
      qualification: json['qualification'],
      licenseNumber: json['licenseNumber'],
      experience: json['experience'],
      hospitalAffiliation: json['hospitalAffiliation'],
      consultationFee: json['consultationFee'],
      availableHours: json['availableHours'],
      isVerified: json['isVerified'] ?? false,
      rating: _parseDouble(json['rating']),
      totalReviews: json['totalReviews'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      isAvailable: json['isAvailable'] ?? false,
      department: json['department'],
      hospitalId: json['hospitalId'],
      gender: json['gender'],
      bio: json['bio'],
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
      'specialization': specialization,
      'qualification': qualification,
      'licenseNumber': licenseNumber,
      'experience': experience,
      'hospitalAffiliation': hospitalAffiliation,
      'consultationFee': consultationFee,
      'availableHours': availableHours,
      'isVerified': isVerified,
      'rating': rating,
      'totalReviews': totalReviews,
      'department': department,
      'isAvailable': isAvailable,
      'hospitalId': hospitalId,
      'gender': gender,
      'bio': bio,
    };
  }

  DoctorModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    String? address,
    String? specialization,
    String? qualification,
    String? licenseNumber,
    String? experience,
    String? hospitalAffiliation,
    String? consultationFee,
    String? availableHours,
    bool? isVerified,
    double? rating,
    int? totalReviews,
    bool? isAvailable,
    String? department,
    String? hospitalId,
    String? gender,
    String? bio,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      address: address ?? this.address,
      specialization: specialization ?? this.specialization,
      qualification: qualification ?? this.qualification,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      experience: experience ?? this.experience,
      hospitalAffiliation: hospitalAffiliation ?? this.hospitalAffiliation,
      consultationFee: consultationFee ?? this.consultationFee,
      availableHours: availableHours ?? this.availableHours,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      isAvailable: isAvailable ?? this.isAvailable,
      department: department ?? this.department,
      hospitalId: hospitalId ?? this.hospitalId,
      gender: gender ?? this.gender,
      bio: bio ?? this.bio,
    );
  }

  @override
  String get displayName => 'Dr. $name';

  String get verificationStatus =>
      isVerified == true ? 'Verified' : 'Pending Verification';
}
