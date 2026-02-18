enum AppointmentStatus {
  confirmed,
  pending,
  completed,
  cancelledByPatient,
  cancelledByHospital,
}

enum PaymentStatus {
  unpaid,
  paidOnline,
  payAtHospital,
}

class AppointmentModel {
  final String id;
  final String? patientId;
  final String? doctorId;
  final String? hospitalId;
  final String hospitalName;
  final String hospitalAddress;
  final String doctorName;
  final String specialization;
  final DateTime appointmentDate;
  final String appointmentTime;
  final AppointmentStatus status;
  final String appointmentType;
  final PaymentStatus paymentStatus;
  final String? cancellationReason;
  final double? consultationFee;
  final String? patientName;
  final String? doctorImage;
  final String? patientPhoneNumber;
  final bool? isFirstVisit;
  final String? patientSymptoms;


  AppointmentModel({
    required this.id,
    this.patientId,
    this.doctorId,
    this.hospitalId,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.doctorName,
    required this.specialization,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    required this.appointmentType,
    this.paymentStatus = PaymentStatus.unpaid,
    this.cancellationReason,
    this.consultationFee,
    this.patientName,
    this.doctorImage,
    this.patientPhoneNumber,
    this.isFirstVisit,
    this.patientSymptoms,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    final patientData = json['patientId'];
    final doctorData = json['doctorId'];
    return AppointmentModel(
      id: json['_id'] ?? json['id'] ?? '',
      /*patientId: json['patientId'] ?? json['patient']?['_id'],
      doctorId: json['doctorId'] ?? json['doctor']?['_id'],*/
      patientId: patientData is Map<String, dynamic>
          ? patientData['_id'] ?? ''
          : patientData ?? '',

      doctorId: doctorData is Map<String, dynamic>
          ? doctorData['_id'] ?? ''
          : doctorData ?? '',
      hospitalId: json['hospitalId'] ?? json['hospital']?['_id'],
      hospitalName: json['hospitalName'] ?? '',
      hospitalAddress: json['hospitalAddress'] ?? '',
      /*doctorName: json['doctorName'] ?? '',
      specialization: json['specialization'] ?? '',*/
      doctorName: doctorData is Map<String, dynamic>
          ? doctorData['name'] ?? ''
          : json['doctorName'] ?? '',

      specialization: doctorData is Map<String, dynamic>
          ? doctorData['specialization'] ?? ''
          : json['specialization'] ?? '',
      appointmentDate: DateTime.parse(json['appointmentDate']),
      appointmentTime: json['appointmentTime'] ?? '',
      status: _parseStatus(json['status']),
      appointmentType: json['appointmentType'] ?? 'In-Person',
      paymentStatus: _parsePaymentStatus(json['paymentStatus']),
      cancellationReason: json['cancellationReason'],
      consultationFee: json['consultationFee']?.toDouble(),
      patientName: json['patientName'],
      doctorImage: json['doctorImage'],
      patientPhoneNumber: json['patientPhoneNumber'],
      isFirstVisit: json['isFirstVisit'],
      patientSymptoms: json['patientSymptoms'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (patientId != null) 'patientId': patientId,
      if (doctorId != null) 'doctorId': doctorId,
      if (hospitalId != null) 'hospitalId': hospitalId,
      'hospitalName': hospitalName,
      'hospitalAddress': hospitalAddress,
      'doctorName': doctorName,
      'specialization': specialization,
      'appointmentDate': appointmentDate.toIso8601String(),
      'appointmentTime': appointmentTime,
      'status': status.name,
      'appointmentType': appointmentType,
      'paymentStatus': paymentStatus.name,
      if (cancellationReason != null) 'cancellationReason': cancellationReason,
      if (consultationFee != null) 'consultationFee': consultationFee,
      'patientName': patientName,
      'doctorImage': doctorImage,
      'patientPhoneNumber': patientPhoneNumber,
      'isFirstVisit': isFirstVisit,
      'patientSymptoms': patientSymptoms,
    };
  }

  static AppointmentStatus _parseStatus(String? value) {
    switch (value) {
      case 'confirmed':
        return AppointmentStatus.confirmed;
      case 'pending':
        return AppointmentStatus.pending;
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelledByPatient':
        return AppointmentStatus.cancelledByPatient;
      case 'cancelledByHospital':
        return AppointmentStatus.cancelledByHospital;
      default:
        return AppointmentStatus.pending;
    }
  }

  static PaymentStatus _parsePaymentStatus(String? value) {
    switch (value) {
      case 'paidOnline':
        return PaymentStatus.paidOnline;
      case 'payAtHospital':
        return PaymentStatus.payAtHospital;
      case 'unpaid':
      default:
        return PaymentStatus.unpaid;
    }
  }

  bool get isUpcoming =>
      (status == AppointmentStatus.confirmed ||
          status == AppointmentStatus.pending) &&
          appointmentDate.isAfter(
              DateTime.now().subtract(const Duration(days: 1)));

  bool get isPast =>
      status == AppointmentStatus.completed ||
          (appointmentDate.isBefore(DateTime.now()) &&
              status != AppointmentStatus.cancelledByPatient &&
              status != AppointmentStatus.cancelledByHospital);

  bool get isCancelled =>
      status == AppointmentStatus.cancelledByPatient ||
          status == AppointmentStatus.cancelledByHospital;

  String get statusDisplayText {
    switch (status) {
      case AppointmentStatus.confirmed:
        return 'Confirmed';
      case AppointmentStatus.pending:
        return 'Pending';
      case AppointmentStatus.completed:
        return 'Completed';
      case AppointmentStatus.cancelledByPatient:
        return 'Cancelled by Patient';
      case AppointmentStatus.cancelledByHospital:
        return 'Cancelled by Hospital';
    }
  }

  AppointmentModel copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? hospitalId,
    String? hospitalName,
    String? hospitalAddress,
    String? doctorName,
    String? specialization,
    DateTime? appointmentDate,
    String? appointmentTime,
    AppointmentStatus? status,
    String? appointmentType,
    PaymentStatus? paymentStatus,
    String? cancellationReason,
    double? consultationFee,
    String? patientName,
    String? doctorImage,
    String? patientPhoneNumber,
    bool? isFirstVisit,
    String? patientSymptoms,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      hospitalId: hospitalId ?? this.hospitalId,
      hospitalName: hospitalName ?? this.hospitalName,
      hospitalAddress: hospitalAddress ?? this.hospitalAddress,
      doctorName: doctorName ?? this.doctorName,
      specialization: specialization ?? this.specialization,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      appointmentTime: appointmentTime ?? this.appointmentTime,
      status: status ?? this.status,
      appointmentType: appointmentType ?? this.appointmentType,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      consultationFee: consultationFee ?? this.consultationFee,
      patientName: patientName ?? this.patientName,
      doctorImage: doctorImage ?? this.doctorImage,
      patientPhoneNumber: patientPhoneNumber ?? this.patientPhoneNumber,
      isFirstVisit: isFirstVisit ?? this.isFirstVisit,
      patientSymptoms: patientSymptoms ?? this.patientSymptoms,
    );
  }
}

