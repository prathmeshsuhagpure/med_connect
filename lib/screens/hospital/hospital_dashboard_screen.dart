import 'package:flutter/material.dart';

class HospitalDashboardScreen extends StatefulWidget {
  const HospitalDashboardScreen({super.key});

  @override
  State<HospitalDashboardScreen> createState() =>
      _HospitalDashboardScreenState();
}

class _HospitalDashboardScreenState extends State<HospitalDashboardScreen> {
  String _selectedPeriod = "Today";

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
                _buildQuickActions(context, isMobile, isDarkMode),
                const SizedBox(height: 32),

                // Today's Appointments
                _buildSectionHeader(
                  context,
                  "Today's Appointments",
                  "View All",
                  isDarkMode,
                  onTap: () {},
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
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildRecentPatients(context, isMobile, isDarkMode),
                const SizedBox(height: 32),

                // Doctors Status
                _buildSectionHeader(
                  context,
                  "Doctors Availability",
                  "Manage",
                  isDarkMode,
                  onTap: () {},
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
    return Row(
      children: [
        Container(
          width: isMobile ? 50 : 60,
          height: isMobile ? 50 : 60,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
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
                "City General Hospital",
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
            color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
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
            onPressed: () {},
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
              selectedColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDarkMode ? Colors.grey[300] : Colors.grey[700]),
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected
                      ? Theme.of(context).primaryColor
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
          Icons.people,
          Colors.blue,
          isDarkMode,
          isIncrease: true,
        ),
        _buildStatCard(
          context,
          "Appointments",
          "48",
          "+8%",
          Icons.calendar_today,
          Colors.green,
          isDarkMode,
          isIncrease: true,
        ),
        _buildStatCard(
          context,
          "Active Doctors",
          "24",
          "2 on leave",
          Icons.medical_services,
          Colors.orange,
          isDarkMode,
        ),
        _buildStatCard(
          context,
          "Revenue",
          "\$12.5K",
          "+15%",
          Icons.attach_money,
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
                  child: Icon(icon, color: color, size: 24),
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

  Widget _buildQuickActions(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
  ) {
    final actions = [
      _QuickAction(
        icon: Icons.person_add,
        label: "Add Patient",
        color: Colors.blue,
        onTap: () {},
      ),
      _QuickAction(
        icon: Icons.calendar_month,
        label: "Schedule",
        color: Colors.green,
        onTap: () {},
      ),
      _QuickAction(
        icon: Icons.medical_services,
        label: "Add Doctor",
        color: Colors.orange,
        onTap: () {},
      ),
      _QuickAction(
        icon: Icons.description,
        label: "Reports",
        color: Colors.purple,
        onTap: () {},
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: isMobile ? 1.5 : 2,
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
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                ),
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
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Theme.of(context).primaryColor,
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
    final appointments = [
      _AppointmentData(
        time: "09:00 AM",
        patientName: "Sarah Johnson",
        doctorName: "Dr. Michael Brown",
        type: "Consultation",
        status: "Confirmed",
        color: Colors.green,
      ),
      _AppointmentData(
        time: "10:30 AM",
        patientName: "Robert Williams",
        doctorName: "Dr. Emily Davis",
        type: "Follow-up",
        status: "Confirmed",
        color: Colors.blue,
      ),
      _AppointmentData(
        time: "02:00 PM",
        patientName: "Lisa Anderson",
        doctorName: "Dr. Sarah Johnson",
        type: "Check-up",
        status: "Pending",
        color: Colors.orange,
      ),
    ];

    return Column(
      children: appointments.map((appointment) {
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
    _AppointmentData appointment,
    bool isMobile,
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
          // Time Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: appointment.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: appointment.color.withValues(alpha: 0.3),
              ),
            ),
            child: Text(
              appointment.time,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: appointment.color,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Appointment Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.patientName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "with ${appointment.doctorName}",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: appointment.status == "Confirmed"
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        appointment.status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: appointment.status == "Confirmed"
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      appointment.type,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Button
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
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
    final doctors = [
      _DoctorStatus(
        name: "Dr. Sarah Johnson",
        specialization: "Cardiologist",
        status: "Available",
        patients: 12,
        color: Colors.green,
      ),
      _DoctorStatus(
        name: "Dr. Michael Brown",
        specialization: "Orthopedic",
        status: "In Consultation",
        patients: 8,
        color: Colors.orange,
      ),
      _DoctorStatus(
        name: "Dr. Emily Davis",
        specialization: "Pediatrician",
        status: "Available",
        patients: 15,
        color: Colors.green,
      ),
    ];

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
    _DoctorStatus doctor,
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
              color: doctor.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.medical_services, color: doctor.color, size: 28),
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
                  doctor.specialization,
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
                        color: doctor.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      doctor.status,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: doctor.color,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.people,
                      size: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${doctor.patients} patients",
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

class _AppointmentData {
  final String time;
  final String patientName;
  final String doctorName;
  final String type;
  final String status;
  final Color color;

  _AppointmentData({
    required this.time,
    required this.patientName,
    required this.doctorName,
    required this.type,
    required this.status,
    required this.color,
  });
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

class _DoctorStatus {
  final String name;
  final String specialization;
  final String status;
  final int patients;
  final Color color;

  _DoctorStatus({
    required this.name,
    required this.specialization,
    required this.status,
    required this.patients,
    required this.color,
  });
}
