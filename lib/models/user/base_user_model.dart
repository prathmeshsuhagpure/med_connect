abstract class BaseUser {
  final String? id;
  final String name;
  final String? email;
  final String role;
  final String? phoneNumber;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BaseUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phoneNumber,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson();

  // Common method to get display name
  String get displayName => name;
}