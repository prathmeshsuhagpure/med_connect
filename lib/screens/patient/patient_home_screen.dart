import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:med_connect/models/appointment_model.dart';
import 'package:med_connect/models/user/hospital_model.dart';
import 'package:med_connect/screens/notification/notification_screen.dart';
import 'package:med_connect/screens/patient/patient_appointment_screen.dart';
import 'package:med_connect/screens/patient/specializations_screen.dart';
import 'package:med_connect/theme/theme.dart';
import 'package:med_connect/utils/responsive.dart';
import 'package:provider/provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/authentication_provider.dart';
import '../../providers/hospital_provider.dart';
import '../doctor/doctor_list_screen.dart';
import '../doctor/instant_opd_screen.dart';
import '../hospital/hospital_detail_screen.dart';
import '../hospital/hospital_list_screen.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAppointments();
      _loadHospital();
    });
  }

  void _loadAppointments() {
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    final appointmentProvider = Provider.of<AppointmentProvider>(
      context,
      listen: false,
    );
    final patientId = authProvider.patient?.id;

    if (patientId != null) {
      appointmentProvider.loadAppointmentsByPatient(patientId);
    }
  }

  void _loadHospital() {
    final hospitalProvider = Provider.of<HospitalProvider>(
      context,
      listen: false,
    );

    hospitalProvider.loadHospitals();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final appointmentProvider = Provider.of<AppointmentProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    final patientId = authProvider.patient?.id;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () {
          return appointmentProvider.refreshAppointments(patientId!);
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, isMobile, isDarkMode),
                  const SizedBox(height: 32),
                  _buildSectionHeader(context, "Quick Actions", "", isDarkMode),
                  const SizedBox(height: 16),
                  _buildQuickActions(context, isMobile, isDarkMode),
                  const SizedBox(height: 16),
                  _buildSectionHeader(
                    context,
                    "Upcoming Appointments",
                    "View All",
                    isDarkMode,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientAppointmentsScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildUpcomingAppointments(context, isMobile, isDarkMode),
                  const SizedBox(height: 32),

                  _buildSectionHeader(
                    context,
                    "Top Hospitals Near You",
                    "See All",
                    isDarkMode,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HospitalListScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTopHospitals(context, isMobile, isDarkMode),
                  const SizedBox(height: 32),

                  _buildSectionHeader(
                    context,
                    "Browse by Specialization",
                    "",
                    isDarkMode,
                  ),
                  const SizedBox(height: 16),
                  _buildSpecializations(context, isMobile, isDarkMode),
                  const SizedBox(height: 32),

                  _buildHealthTipsBanner(context, isMobile, isDarkMode),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile, bool isDarkMode) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final patient = authProvider.patient;
    final hour = DateTime.now().hour;
    String greeting = hour < 12
        ? "Good Morning"
        : hour < 17
        ? "Good Afternoon"
        : "Good Evening";

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.grey[850]!, Colors.grey[900]!]
              : [
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  Theme.of(context).primaryColor.withValues(alpha: 0.05),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: isMobile ? 60 : 70,
                    height: isMobile ? 60 : 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: isDarkMode
                            ? [Colors.grey[700]!, Colors.grey[800]!]
                            : [
                                Theme.of(context).primaryColor,
                                Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: 0.7),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDarkMode ? Colors.grey[850] : Colors.white,
                      ),
                      child: ClipOval(
                        child:
                            patient!.profilePicture != null &&
                                patient.profilePicture!.isNotEmpty
                            ? Image.network(
                                patient.profilePicture!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) {
                                  return _defaultProfileIcon(isDarkMode);
                                },
                              )
                            : _defaultProfileIcon(isDarkMode),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDarkMode ? Colors.grey[850]! : Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          greeting,
                          style: TextStyle(
                            fontSize: isMobile ? 13 : 14,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _getGreetingEmoji(hour),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      patient.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 20 : 24,
                        letterSpacing: -0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              Row(
                children: [
                  _buildActionButton(
                    context,
                    Icons.notifications_outlined,
                    isDarkMode,
                    hasNotification: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NotificationScreen(/*userRole: UserRole.patient*/),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildQuickStat(
                  context,
                  Icons.calendar_today_outlined,
                  "Upcoming",
                  "3",
                  isDarkMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickStat(
                  context,
                  Icons.local_hospital_outlined,
                  "Doctors",
                  "5",
                  isDarkMode,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickStat(
                  context,
                  Icons.description_outlined,
                  "Reports",
                  "12",
                  isDarkMode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    bool isDarkMode, {
    bool hasNotification = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                icon,
                size: 22,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            if (hasNotification)
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDarkMode ? Colors.grey[800]! : Colors.white,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.grey[800]!.withValues(alpha: 0.5)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: Theme.of(context).primaryColor),
              const SizedBox(width: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getGreetingEmoji(int hour) {
    if (hour < 12) return "☀️";
    if (hour < 17) return "👋";
    return "🌙";
  }

  Widget _defaultProfileIcon(bool isDarkMode) {
    return Center(
      child: Icon(
        Icons.person,
        color: isDarkMode ? Colors.grey[600] : Theme.of(context).primaryColor,
        size: 32,
      ),
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
  ) {
    final actions = [
      _QuickAction(
        icon: Icons.local_hospital,
        label: "Find Hospital",
        color: Colors.blue,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HospitalListScreen()),
          );
        },
      ),
      _QuickAction(
        icon: Icons.medical_services,
        label: "Find Doctor",
        color: Colors.green,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DoctorListScreen()),
          );
        },
      ),
      _QuickAction(
        icon: Icons.flash_on,
        label: "Instant OPD",
        color: Colors.red,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InstantOPDScreen()),
          );
        },
      ),
      _QuickAction(
        icon: Icons.emergency,
        label: "Emergency",
        color: Colors.orange,
        onTap: () {},
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.grey[850]!, Colors.grey[900]!]
              : [
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  Theme.of(context).primaryColor.withValues(alpha: 0.05),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1.5,
        ),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 2 : 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: isMobile ? 1.3 : 1.5,
        ),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return _buildQuickActionCard(
            context,
            action.icon,
            action.label,
            action.color,
            isDarkMode,
            action.onTap,
          );
        },
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    bool isDarkMode,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.grey[800]!.withValues(alpha: 0.5)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String actionText,
    bool isDarkMode, {
    VoidCallback? onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (actionText.isNotEmpty)
          TextButton(
            onPressed: onTap,
            child: Row(
              children: [
                Text(
                  actionText,
                  style: TextStyle(
                    color: isDarkMode
                        ? DarkThemeColors.white
                        : Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: isDarkMode
                      ? DarkThemeColors.white
                      : Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildUpcomingAppointments(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
  ) {
    return Consumer<AppointmentProvider>(
      builder: (context, appointmentProvider, child) {
        final appointments = appointmentProvider.upcomingAppointments;

        if (appointmentProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (appointmentProvider.error != null) {
          return _buildEmptyState(
            context,
            Icons.error_outline,
            "Error Loading Appointments",
            appointmentProvider.error!,
            isDarkMode,
          );
        }
        if (appointments.isEmpty) {
          return _buildEmptyState(
            context,
            Icons.calendar_today_outlined,
            "No Upcoming Appointments",
            "Book your first appointment",
            isDarkMode,
          );
        }
        final upcomingAppointments = appointments.take(3).toList();
        return Column(
          children: upcomingAppointments.map((AppointmentModel appointment) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildAppointmentCard(
                context,
                appointment,
                isMobile,
                isDarkMode,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildAppointmentCard(
    BuildContext context,
    AppointmentModel appointment,
    bool isMobile,
    bool isDarkMode,
  ) {
    DateTime date = appointment.appointmentDate;
    String formattedDate = DateFormat('d MMM yyyy').format(date);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.grey[850]!, Colors.grey[900]!]
              : [
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  Theme.of(context).primaryColor.withValues(alpha: 0.05),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
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
      child: Row(
        children: [
          // Doctor Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: const Icon(Icons.person, color: Colors.green, size: 32),
          ),
          const SizedBox(width: 16),

          // Appointment Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.doctorName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  appointment.specialization,
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "$formattedDate, ${appointment.appointmentTime}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Button
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_ios),
            iconSize: 18,
          ),
        ],
      ),
    );
  }

  Widget _buildTopHospitals(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
  ) {
    return Consumer<HospitalProvider>(
      builder: (context, hospitalProvider, child) {
        final hospitals = hospitalProvider.hospitals;

        if (hospitalProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (hospitals.isEmpty) {
          return _buildEmptyState(
            context,
            Icons.local_hospital_outlined,
            "No Hospitals Found",
            "Failed to load hospitals.",
            isDarkMode,
          );
        }

        return SizedBox(
          height: isMobile ? 200 : 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hospitals.length,
            itemBuilder: (context, index) {
              final hospital = hospitals[index];
              return Padding(
                padding: EdgeInsets.only(right: 16, left: index == 0 ? 0 : 0),
                child: _buildHospitalCard(
                  context,
                  hospital,
                  isMobile,
                  isDarkMode,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHospitalCard(
    BuildContext context,
    HospitalModel hospital,
    bool isMobile,
    bool isDarkMode,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HospitalDetailsScreen(hospitalId: hospital.id!),
          ),
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: isMobile ? 280 : 320,
        height: 240,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.grey[850]!, Colors.grey[900]!]
                : [
                    Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    Theme.of(context).primaryColor.withValues(alpha: 0.05),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hospital Cover Image with Gradient Overlay
            Stack(
              children: [
                // Cover Image
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor.withValues(alpha: 0.8),
                        Theme.of(context).primaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child:
                      hospital.coverPhoto != null &&
                          hospital.coverPhoto!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: Image.network(
                            hospital.coverPhoto!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, _, _) =>
                                _buildDefaultCover(context),
                          ),
                        )
                      : _buildDefaultCover(context),
                ),

                // Gradient Overlay
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.1),
                        Colors.black.withValues(alpha: 0.4),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),

                if (hospital.isVerified ?? false)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(6),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 3),
                          const Text(
                            'Verified',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            // Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                // Reduced padding
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 5),
                    Expanded(
                      child: Text(
                        hospital.displayName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14, // Reduced from 15
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Specialties
                    if (hospital.specialties != null &&
                        hospital.specialties!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: 0.2)
                              : Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          hospital.specialties!,
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 10, // Reduced from 11
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    const Spacer(),

                    // Info Row: Location & Rating
                    Row(
                      children: [
                        // Location
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 13, // Reduced from 14
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                  hospital.address ?? "N/A",
                                  style: TextStyle(
                                    fontSize: 10, // Reduced from 11
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),

                        // Rating
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 11,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                (hospital.rating ?? 0.0).toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.amber,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6), // Reduced from 8
                    // Quick Info Tags
                    if (hospital.hasEmergency ?? false)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(
                            alpha: isDarkMode ? 0.2 : 0.1,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.emergency,
                              size: 10,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 3),
                            const Text(
                              '24/7 Emergency',
                              style: TextStyle(
                                fontSize: 9, // Reduced from 10
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Default cover image widget
  Widget _buildDefaultCover(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
            Theme.of(context).primaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.local_hospital,
          size: 40,
          color: Colors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Widget _buildSpecializations(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
  ) {
    final specializations = [
      _Specialization(
        name: "Cardiology",
        icon: FontAwesomeIcons.heartPulse,
        color: Colors.red,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpecializationListScreen(
                specialization: "Cardiology",
                icon: FontAwesomeIcons.heartPulse,
                color: Colors.red,
              ),
            ),
          );
        },
      ),
      _Specialization(
        name: "Dentistry",
        icon: FontAwesomeIcons.tooth,
        color: Colors.blue,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpecializationListScreen(
                specialization: "Dentistry",
                icon: FontAwesomeIcons.tooth,
                color: Colors.blue,
              ),
            ),
          );
        },
      ),
      _Specialization(
        name: "Orthopedics",
        icon: FontAwesomeIcons.bone,
        color: Colors.green,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpecializationListScreen(
                specialization: "Orthopedics",
                icon: FontAwesomeIcons.bone,
                color: Colors.green,
              ),
            ),
          );
        },
      ),
      _Specialization(
        name: "Neurology",
        icon: FontAwesomeIcons.brain,
        color: Colors.purple,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpecializationListScreen(
                specialization: "Neurology",
                icon: FontAwesomeIcons.brain,
                color: Colors.purple,
              ),
            ),
          );
        },
      ),
      _Specialization(
        name: "Pediatrics",
        icon: Icons.child_care,
        color: Colors.orange,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpecializationListScreen(
                specialization: "Pediatrics",
                icon: Icons.child_care,
                color: Colors.orange,
              ),
            ),
          );
        },
      ),
      _Specialization(
        name: "Dermatology",
        icon: Icons.face,
        color: Colors.pink,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpecializationListScreen(
                specialization: "Dermatology",
                icon: Icons.face,
                color: Colors.pink,
              ),
            ),
          );
        },
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 3 : 6,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: specializations.length,
      itemBuilder: (context, index) {
        final spec = specializations[index];
        return _buildSpecializationCard(context, spec, isDarkMode);
      },
    );
  }

  Widget _buildSpecializationCard(
    BuildContext context,
    _Specialization specialization,
    bool isDarkMode,
  ) {
    return InkWell(
      onTap: specialization.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.grey[850]!, Colors.grey[900]!]
                : [
                    Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    Theme.of(context).primaryColor.withValues(alpha: 0.05),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: specialization.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                specialization.icon,
                color: specialization.color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              specialization.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHealthTipsBanner(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isDarkMode
            ? const LinearGradient(
                colors: [Color(0xFF0F2027), Color(0xFF203A43)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Health Tips",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Stay healthy with daily health tips and advice",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Read More"),
                ),
              ],
            ),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.health_and_safety,
                size: 60,
                color: Colors.white,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool isDarkMode,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 64,
            color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

// Helper classes
class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}

class _Specialization {
  final String name;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _Specialization({
    required this.name,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
