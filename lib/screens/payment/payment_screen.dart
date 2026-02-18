import 'package:flutter/material.dart';
import 'package:med_connect/screens/patient/patient_home_screen.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../models/appointment_model.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/authentication_provider.dart';
import '../../services/payment_service.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final String hospitalName;
  final String hospitalAddress;
  final String doctorName;
  final String doctorSpecialization;
  final String? doctorImage;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String appointmentType;
  final double consultationFee;
  final String patientName;
  final String patientPhoneNumber;
  final bool? isFirstVisit;
  final String? patientSymptoms;
  final String? hospitalId;
  final String? doctorId;



  const PaymentConfirmationScreen({
    super.key,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.doctorName,
    required this.doctorSpecialization,
    this.doctorImage,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentType,
    required this.consultationFee,
    required this.patientName,
    required this.patientPhoneNumber,
    this.isFirstVisit,
    this.patientSymptoms,
    this.hospitalId,
    this.doctorId,
  });

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  String _selectedPaymentMethod = 'pay_now'; // 'pay_now' or 'pay_later'
  bool _isProcessing = false;
  late Razorpay _razorpay;

  String? currentOrderId;
  String? _createdAppointmentId;

  @override
  void initState() {
    super.initState();
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      final paymentService = context.read<PaymentService>();

      final verifyRes = await paymentService.verifyPayment(
        response,
        appointmentId: _createdAppointmentId,
      );

      if (verifyRes['success'] == true) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Appointment confirmed successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const PatientHomeScreen()),
          (route) => false,
        );
      } else {
        throw Exception('Payment verification failed');
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment Failed: ${response.message ?? 'Unknown error'}'),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    setState(() {
      _isProcessing = false;
    });
  }

  void _openRazorpayCheckout() async {
    try {
      final userProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      final currentUser = userProvider.patient;

      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      final paymentService = context.read<PaymentService>();
      final orderResponse = await paymentService.createRazorpayOrder(
        amount: widget.consultationFee,
        appointmentId: _createdAppointmentId,
      );

      if (orderResponse['success'] != true ||
          orderResponse['orderId'] == null) {
        throw Exception('Failed to create order');
      }

      currentOrderId = orderResponse['orderId'];

      var options = {
        'key': 'rzp_test_S8W9WfUPHAiIA9',
        'amount': (widget.consultationFee * 100).toInt(),
        'name': 'Med Connect',
        'description': 'Patient Appointment Booking',
        'order_id': currentOrderId,
        'currency': 'INR',
        'prefill': {
          'name': currentUser.name,
          'email': currentUser.email,
          'contact': currentUser.phoneNumber ?? '',
        },
        'theme': {'color': '#2E7D57'},
      };

      _razorpay.open(options);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _confirmBooking() async {
    setState(() => _isProcessing = true);

    if (_selectedPaymentMethod == 'pay_now') {
      final appointment = AppointmentModel(
        id: "",
        hospitalName: widget.hospitalName,
        hospitalAddress: widget.hospitalAddress,
        doctorName: widget.doctorName,
        specialization: widget.doctorSpecialization,
        appointmentDate: widget.appointmentDate,
        appointmentTime: widget.appointmentTime,
        status: AppointmentStatus.pending,
        appointmentType: widget.appointmentType,
        paymentStatus: _selectedPaymentMethod == 'pay_now'
            ? PaymentStatus.paidOnline
            : PaymentStatus.payAtHospital,
        cancellationReason: null,
        patientName: widget.patientName,
        patientPhoneNumber: widget.patientPhoneNumber,
        isFirstVisit: widget.isFirstVisit,
        patientSymptoms: widget.patientSymptoms,
        consultationFee: widget.consultationFee,
        doctorId: widget.doctorId,
        hospitalId: widget.hospitalId,
      );
      final result = await context.read<AppointmentProvider>().addAppointment(
        appointment,
      );

      if (result['success'] != true) {
        setState(() => _isProcessing = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to create appointment'),
          ),
        );
        return;
      }

      _createdAppointmentId = result['data']['_id'];
      _openRazorpayCheckout();
    } else {
      _confirmPayLaterBooking();
    }
  }

  Future<void> _confirmPayLaterBooking() async {
    setState(() => _isProcessing = true);

    final appointment = AppointmentModel(
      id: "",
      hospitalName: widget.hospitalName,
      hospitalAddress: widget.hospitalAddress,
      doctorName: widget.doctorName,
      specialization: widget.doctorSpecialization,
      appointmentDate: widget.appointmentDate,
      appointmentTime: widget.appointmentTime,
      status: AppointmentStatus.pending,
      appointmentType: widget.appointmentType,
      cancellationReason: null,
      patientName: widget.patientName,
      patientPhoneNumber: widget.patientPhoneNumber,
      isFirstVisit: widget.isFirstVisit,
      patientSymptoms: widget.patientSymptoms,
      consultationFee: widget.consultationFee,
      paymentStatus: _selectedPaymentMethod == 'pay_now'
          ? PaymentStatus.paidOnline
          : PaymentStatus.payAtHospital,
      hospitalId: widget.hospitalId,
      doctorId: widget.doctorId
    );

    final result = await context.read<AppointmentProvider>().addAppointment(
      appointment,
    );

    setState(() => _isProcessing = false);

    if (!mounted) return;

    if (result['success'] == true) {
      _showSuccessDialog(
        'Booking Confirmed!',
        'Your appointment has been scheduled. Please pay at the hospital.',
        isPaid: false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Booking failed')),
      );
    }
  }

  void _showSuccessDialog(
    String title,
    String message, {
    required bool isPaid,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.zero,
        content: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(Icons.person, 'Doctor', widget.doctorName),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      Icons.calendar_today,
                      'Date',
                      _formatDate(widget.appointmentDate),
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      Icons.access_time,
                      'Time',
                      widget.appointmentTime,
                    ),
                    const SizedBox(height: 8),
                    _buildDetailRow(
                      Icons.payment,
                      'Payment',
                      isPaid
                          ? 'Paid ₹${widget.consultationFee}'
                          : 'Pay at Hospital',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate back to home or appointment list
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment & Confirmation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isProcessing
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Appointment Summary Card
                  _buildAppointmentSummary(isDarkMode),
                  const SizedBox(height: 24),

                  // Payment Method Selection
                  _buildSectionTitle('Select Payment Method'),
                  const SizedBox(height: 16),
                  _buildPaymentMethodCard(
                    title: 'Pay Now',
                    subtitle: 'Pay consultation fee online',
                    icon: Icons.payment,
                    value: 'pay_now',
                    color: Colors.blue,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentMethodCard(
                    title: 'Pay at Hospital',
                    subtitle: 'Pay during your visit',
                    icon: Icons.medical_services,
                    value: 'pay_later',
                    color: Colors.orange,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 24),

                  // Fee Breakdown
                  _buildFeeBreakdown(isDarkMode),
                  const SizedBox(height: 24),

                  // Terms and Conditions
                  _buildTermsCheckbox(isDarkMode),
                  const SizedBox(height: 32),

                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _confirmBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _selectedPaymentMethod == 'pay_now'
                            ? 'Proceed to Payment'
                            : 'Confirm Booking',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildAppointmentSummary(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointment Summary',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Doctor Info
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: widget.doctorImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.doctorImage!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(Icons.person, size: 30, color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doctorName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.doctorSpecialization,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Appointment Details
          _buildInfoRow(
            Icons.calendar_today,
            'Date',
            _formatDate(widget.appointmentDate),
            isDarkMode,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.access_time,
            'Time',
            widget.appointmentTime,
            isDarkMode,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.medical_information,
            'Type',
            widget.appointmentType,
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    bool isDarkMode,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildPaymentMethodCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required Color color,
    required bool isDarkMode,
  }) {
    final isSelected = _selectedPaymentMethod == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.1)
              : (isDarkMode ? Colors.grey[850] : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? color
                : (isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedPaymentMethod,
              onChanged: (val) {
                setState(() {
                  _selectedPaymentMethod = val!;
                });
              },
              activeColor: color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeeBreakdown(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Fee Breakdown',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFeeRow('Consultation Fee', widget.consultationFee, isDarkMode),
          const SizedBox(height: 12),
          _buildFeeRow('Platform Fee', 0, isDarkMode),
          const SizedBox(height: 12),
          Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[300]),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                '₹${widget.consultationFee.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeeRow(String label, double amount, bool isDarkMode) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox(bool isDarkMode) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: true,
          onChanged: (val) {},
          activeColor: Theme.of(context).primaryColor,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'I agree to the terms and conditions and cancellation policy',
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
