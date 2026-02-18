import 'package:flutter/material.dart';
import 'package:med_connect/models/appointment_model.dart';
import 'package:med_connect/models/user/doctor_model.dart';
import 'package:med_connect/screens/doctor/add_doctor_screen.dart';
import 'package:med_connect/screens/doctor/doctor_management_screen.dart';
import 'package:med_connect/screens/hospital/appointment_management_screen.dart';
import 'package:med_connect/screens/patient/patient_list_screen.dart';
import 'package:med_connect/theme/theme.dart';
import 'package:provider/provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/authentication_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../providers/doctor_provider.dart';
import '../notification/notification_screen.dart';
import '../patient/add_patient_screen.dart';

class HospitalDashboardScreen extends StatefulWidget {
  const HospitalDashboardScreen({super.key});

  @override
  State<HospitalDashboardScreen> createState() =>
      HospitalDashboardScreenState();
}

class HospitalDashboardScreenState extends State<HospitalDashboardScreen> {
  String _selectedPeriod = "Today";

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hospital = context.read<AuthenticationProvider>().hospital;

      if (hospital != null) {
        context.read<DoctorProvider>().loadDoctorsByHospital(
          hospital.id.toString(),
          null,
        );
      }
      final appointment = context.read<AppointmentProvider>();
      appointment.loadAppointmentsByHospital(hospital!.id.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 650;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section
                _buildHeader(context, isMobile, isDarkMode),
                const SizedBox(height: 24),

                // Period Selector
                _buildPeriodSelector(context, isDarkMode),
                const SizedBox(height: 24),

                // Statistics Cards
                _buildStatisticsCards(context, isMobile, isDarkMode),
                const SizedBox(height: 24),

                // Quick Actions
                _buildQuickActions(context, isDarkMode),
                const SizedBox(height: 32),

                // Today's Appointments
                _buildSectionHeader(
                  context,
                  "Today's Appointments",
                  "View All",
                  isDarkMode,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AppointmentManagementScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildTodaysAppointments(context, isMobile, isDarkMode),
                const SizedBox(height: 32),

                // Recent Patients
                _buildSectionHeader(
                  context,
                  "Recent Patients",
                  "View All",
                  isDarkMode,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientListScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildRecentPatients(context, isMobile, isDarkMode),
                const SizedBox(height: 32),

                // Doctors Status
                _buildSectionHeader(
                  context,
                  "Doctors Available",
                  "Manage",
                  isDarkMode,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoctorManagementScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildDoctorsStatus(context, isMobile, isDarkMode),
                const SizedBox(height: 32),

                // Revenue Chart
                _buildSectionHeader(
                  context,
                  "Revenue Overview",
                  "Details",
                  isDarkMode,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildRevenueChart(context, isMobile, isDarkMode),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile, bool isDarkMode) {
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    final hospital = authProvider.hospital;

    return Row(
      children: [
        Container(
          width: isMobile ? 50 : 60,
          height: isMobile ? 50 : 60,
          decoration: BoxDecoration(
            color: isDarkMode
                ? DarkThemeColors.white
                : Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          ),
          child: Icon(
            Icons.local_hospital,
            color: Theme.of(context).primaryColor,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),

        // Hospital Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hospital!.displayName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 18 : 22,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Admin Dashboard",
                style: TextStyle(
                  fontSize: isMobile ? 13 : 15,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        // Notification Icon
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[850] : Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDarkMode
                            ? Colors.grey[850]!
                            : Colors.grey[100]!,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NotificationScreen(userRole: UserRole.hospital),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector(BuildContext context, bool isDarkMode) {
    final periods = ["Today", "This Week", "This Month", "This Year"];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: periods.map((period) {
          final isSelected = _selectedPeriod == period;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ChoiceChip(
              label: Text(period),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedPeriod = period;
                });
              },
              backgroundColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
              selectedColor: isDarkMode
                  ? DarkThemeColors.buttonPrimary
                  : LightThemeColors.buttonPrimary,
              labelStyle: TextStyle(
                color: isSelected
                    ? (isDarkMode ? Colors.black : Colors.black)
                    : (isDarkMode ? Colors.grey[300] : Colors.grey[700]),
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected
                      ? Colors.white
                      : (isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatisticsCards(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
  ) {
    final doctorProvider = context.watch<DoctorProvider>();
    final doctors = doctorProvider.doctors;
    final activeDoctors = doctors.where((d) => d.isAvailable == true).length;

    final onLeaveDoctors = doctors.where((d) => d.isAvailable == false).length;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isMobile ? 2 : 4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isMobile ? 1.3 : 1.5,
      children: [
        _buildStatCard(
          context,
          "Total Patients",
          "1,234",
          "+12%",
          FontAwesomeIcons.peopleGroup,
          Colors.blue,
          isDarkMode,
          isIncrease: true,
        ),
        _buildStatCard(
          context,
          "Appointments",
          "48",
          "+8%",
          FontAwesomeIcons.calendarCheck,
          Colors.green,
          isDarkMode,
          isIncrease: true,
        ),
        _buildStatCard(
          context,
          "Active Doctors",
          activeDoctors.toString(),
          "$onLeaveDoctors on leave",
          FontAwesomeIcons.userDoctor,
          Colors.orange,
          isDarkMode,
        ),
        _buildStatCard(
          context,
          "Revenue",
          "\$2,12.5K",
          "+15%",
          FontAwesomeIcons.indianRupeeSign,
          Colors.purple,
          isDarkMode,
          isIncrease: true,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    String subValue,
    IconData icon,
    Color color,
    bool isDarkMode, {
    bool isIncrease = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FaIcon(icon, color: color, size: 24),
                ),
                if (isIncrease)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.trending_up,
                          size: 12,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          subValue,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              if (!isIncrease) ...[
                const SizedBox(height: 4),
                Text(
                  subValue,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                isDark,
                icon: Icons.person_add,
                label: 'Add Patient',
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddPatientScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                isDark,
                icon: Icons.schedule,
                label: 'Add Doctor',
                color: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddDoctorScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                isDark,
                icon: Icons.inventory_2,
                label: 'Inventory',
                color: const Color(0xFF9D4EDD),
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
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
                        ? DarkThemeColors.buttonPrimary
                        : LightThemeColors.buttonPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: isDarkMode
                      ? DarkThemeColors.buttonPrimary
                      : LightThemeColors.buttonPrimary,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTodaysAppointments(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
  ) {
    final provider = context.watch<AppointmentProvider>();

    final today = DateTime.now();

    final todaysAppointments = provider.appointments.where((appointment) {
      final date = appointment.appointmentDate;

      return date.year == today.year &&
          date.month == today.month &&
          date.day == today.day;
    }).toList();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (todaysAppointments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            "No appointments today",
            style: TextStyle(
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return Column(
      children: todaysAppointments.map((appointment) {
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
  }

  Widget _buildAppointmentCard(
    BuildContext context,
    AppointmentModel appointment,
    bool isMobile,
    bool isDarkMode,
  ) {
    Color statusColor;

    switch (appointment.status) {
      case AppointmentStatus.confirmed:
        statusColor = Colors.green;
        break;
      case AppointmentStatus.pending:
        statusColor = Colors.orange;
        break;
      case AppointmentStatus.completed:
        statusColor = Colors.blue;
        break;
      case AppointmentStatus.cancelledByPatient:
      case AppointmentStatus.cancelledByHospital:
        statusColor = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              appointment.appointmentTime,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.patientName ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text("Dr. ${appointment.doctorName}"),
                Text(appointment.appointmentType),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              appointment.status.name,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPatients(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
  ) {
    final patients = [
      _PatientData(
        name: "Alice Thompson",
        lastVisit: "2 days ago",
        condition: "Diabetes",
        color: Colors.purple,
      ),
      _PatientData(
        name: "David Martinez",
        lastVisit: "1 week ago",
        condition: "Hypertension",
        color: Colors.red,
      ),
      _PatientData(
        name: "Emma Wilson",
        lastVisit: "2 weeks ago",
        condition: "Asthma",
        color: Colors.blue,
      ),
    ];

    return Column(
      children: patients.map((patient) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildPatientCard(context, patient, isDarkMode),
        );
      }).toList(),
    );
  }

  Widget _buildPatientCard(
    BuildContext context,
    _PatientData patient,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: patient.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.person, color: patient.color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  patient.condition,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                patient.lastVisit,
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsStatus(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
  ) {
    final doctorProvider = context.watch<DoctorProvider>();
    final doctors = doctorProvider.doctors;
    if (doctorProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (doctors.isEmpty) {
      return const Text("No doctors available");
    }

    return Column(
      children: doctors.map((doctor) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildDoctorStatusCard(context, doctor, isDarkMode),
        );
      }).toList(),
    );
  }

  Widget _buildDoctorStatusCard(
    BuildContext context,
    DoctorModel doctor,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? DarkThemeColors.buttonPrimary
                  : LightThemeColors.buttonPrimary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.medical_services, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.specialization ?? "",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      doctor.isAvailable ? "Available" : "Unavailable",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.work,
                      size: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${doctor.department}",
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
  ) {
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\$45,280",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.trending_up,
                        size: 16,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "+23.5% from last month",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Simple bar chart representation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildBarItem(context, "Mon", 0.6, isDarkMode),
              _buildBarItem(context, "Tue", 0.8, isDarkMode),
              _buildBarItem(context, "Wed", 0.5, isDarkMode),
              _buildBarItem(context, "Thu", 0.9, isDarkMode),
              _buildBarItem(context, "Fri", 0.7, isDarkMode),
              _buildBarItem(context, "Sat", 0.4, isDarkMode),
              _buildBarItem(context, "Sun", 0.3, isDarkMode),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBarItem(
    BuildContext context,
    String label,
    double height,
    bool isDarkMode,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Container(
              height: 100 * height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.6),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PatientData {
  final String name;
  final String lastVisit;
  final String condition;
  final Color color;

  _PatientData({
    required this.name,
    required this.lastVisit,
    required this.condition,
    required this.color,
  });
}
