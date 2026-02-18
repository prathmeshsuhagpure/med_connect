import 'base_user_model.dart';

class HospitalModel extends BaseUser {
  final String? hospitalName;
  final String? registrationNumber;
  final String? licenseNumber;
  final String? specialties;
  final List<String>? facilities;
  final Map<String, dynamic>? operatingHours;
  final bool? isVerified;
  final double? rating;
  final int? totalReviews;
  final bool isOpen;
  final double? distance;
  final String? description;
  final String? coverPhoto;
  final String? logo;
  final String? emergencyPhoneNumber;
  final String? website;
  final String? city;
  final String? state;
  final String? zip;
  final int? bedCount;
  final int? icuBedCount;
  final int? emergencyBedCount;
  final String? type;
  final bool? hasEmergency;
  final bool? is24x7;
  final List<String>? departments;
  final List<String>? accreditations;
  final List<String>? hospitalImages;
  final bool? ambulanceService;

  HospitalModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
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
    required this.isOpen,
    required this.distance,
    this.description,
    this.coverPhoto,
    this.logo,
    this.emergencyPhoneNumber,
    this.website,
    this.city,
    this.state,
    this.zip,
    this.bedCount,
    this.icuBedCount,
    this.emergencyBedCount,
    this.type,
    this.hasEmergency,
    this.is24x7,
    this.departments,
    this.accreditations,
    this.hospitalImages,
    this.ambulanceService,
  }) : super(role: 'hospital');

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone'] ?? json['phoneNumber'] ?? '',
      address: json['address'],
      hospitalName: json['hospitalName'],
      registrationNumber: json['registrationNumber'],
      licenseNumber: json['licenseNumber'],
      specialties: json['specialties'],
      isVerified: json['isVerified'] ?? false,
      rating: _parseDouble(json['rating']),
      totalReviews: json['totalReviews'],
      isOpen: json['isOpen'] ?? false,
      distance: _parseDouble(json['distance']),
      description: json['description'],
      coverPhoto: json['coverPhoto'],
      logo: json['logo'],
      emergencyPhoneNumber: json['emergencyPhoneNumber'],
      website: json['website'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      bedCount: json['bedCount'],
      icuBedCount: json['icuBedCount'],
      emergencyBedCount: json['emergencyBedCount'],
      type: json['type'],
      hasEmergency: json['hasEmergency'],
      is24x7: json['is24x7'],
      departments: json['departments'] != null
          ? List<String>.from(json['departments'])
          : null,
      accreditations: json['accreditations'] != null
          ? List<String>.from(json['accreditations'])
          : null,
      hospitalImages: json['hospitalImages'] != null
          ? List<String>.from(json['hospitalImages'])
          : null,
      facilities: json['facilities'] != null
          ? List<String>.from(json['facilities'])
          : null,
      operatingHours: json['operatingHours'] != null
          ? Map<String, dynamic>.from(json['operatingHours'])
          : null,
      ambulanceService: json['ambulanceService'] ?? false,
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
      'isOpen': isOpen,
      'distance': distance,
      'description': description,
      'coverPhoto': coverPhoto,
      'logo': logo,
      'emergencyPhoneNumber': emergencyPhoneNumber,
      'website': website,
      'city': city,
      'state': state,
      'zip': zip,
      'bedCount': bedCount,
      'icuBedCount': icuBedCount,
      'emergencyBedCount': emergencyBedCount,
      'type': type,
      'hasEmergency': hasEmergency,
      'is24x7': is24x7,
      'departments': departments,
      'accreditations': accreditations,
      'hospitalImages': hospitalImages,
      'ambulanceService': ambulanceService,
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
    List<String>? facilities,
    Map<String, dynamic>? operatingHours,
    bool? isVerified,
    double? rating,
    int? totalReviews,
    double? distance,
    String? description,
    String? coverPhoto,
    String? logo,
    String? emergencyPhoneNumber,
    String? website,
    String? city,
    String? state,
    String? zip,
    int? bedCount,
    int? icuBedCount,
    int? emergencyBedCount,
    String? type,
    bool? hasEmergency,
    bool? is24x7,
    List<String>? departments,
    List<String>? accreditations,
    List<String>? hospitalImages,
    bool? ambulanceService,
    bool? isOpen,
  }) {
    return HospitalModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      //profilePicture: profilePicture ?? this.profilePicture,
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
      isOpen: this.isOpen,
      distance: distance ?? this.distance,
      description: description ?? this.description,
      coverPhoto: coverPhoto ?? this.coverPhoto,
      logo: logo ?? this.logo,
      emergencyPhoneNumber: emergencyPhoneNumber ?? this.emergencyPhoneNumber,
      website: website ?? this.website,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      bedCount: bedCount ?? this.bedCount,
      icuBedCount: icuBedCount ?? this.icuBedCount,
      emergencyBedCount: emergencyBedCount ?? this.emergencyBedCount,
      type: type ?? this.type,
      hasEmergency: hasEmergency ?? this.hasEmergency,
      is24x7: is24x7 ?? this.is24x7,
      departments: departments ?? this.departments,
      accreditations: accreditations ?? this.accreditations,
      hospitalImages: hospitalImages ?? this.hospitalImages,
      ambulanceService: ambulanceService ?? this.ambulanceService,
    );
  }

  @override
  String get displayName => hospitalName ?? name;

  // Helper getters
  bool get hasCompleteProfile =>
      hospitalName != null && registrationNumber != null && address != null;

  String get verificationStatus =>
      isVerified == true ? 'Verified' : 'Pending Verification';
}
