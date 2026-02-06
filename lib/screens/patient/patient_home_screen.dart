import 'package:flutter/material.dart';
import 'package:med_connect/theme/theme.dart';
import 'package:med_connect/utils/responsive.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, isMobile, isDarkMode),
                const SizedBox(height: 24),

                _buildSearchBar(context, isMobile, isDarkMode),
                const SizedBox(height: 24),

                _buildQuickActions(context, isMobile, isDarkMode),
                const SizedBox(height: 32),

                _buildSectionHeader(
                  context,
                  "Upcoming Appointments",
                  "View All",
                  isDarkMode,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
                _buildUpcomingAppointments(context, isMobile, isDarkMode),
                const SizedBox(height: 32),

                _buildSectionHeader(
                  context,
                  "Top Hospitals Near You",
                  "See All",
                  isDarkMode,
                  onTap: () {},
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
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile, bool isDarkMode) {
    return Row(
      children: [
        Container(
          width: isMobile ? 50 : 60,
          height: isMobile ? 50 : 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: isDarkMode
                ? LinearGradient(colors: [Colors.white, Colors.grey])
                : LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withValues(alpha: 0.7),
                    ],
                  ),
          ),
          child: Center(
            child: Icon(
              Icons.person,
              color: isDarkMode ? Colors.black : Colors.white,
              size: 28,
            ),
          ),
        ),
        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome",
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "John Doe",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 20 : 24,
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

  Widget _buildSearchBar(BuildContext context, bool isMobile, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search hospitals, doctors, specializations...",
          prefixIcon: Icon(
            Icons.search,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
          suffixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.tune, color: Colors.white, size: 20),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
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
        onTap: () {},
      ),
      _QuickAction(
        icon: Icons.medical_services,
        label: "Find Doctor",
        color: Colors.green,
        onTap: () {},
      ),
      _QuickAction(
        icon: Icons.local_hospital,
        label: "Instant OPD",
        color: Colors.red,
        onTap: () {},
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
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.1),
            Theme.of(context).primaryColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Quick Actions",
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
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
        ],
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
          color: isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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
    // Sample appointments
    final appointments = [
      _Appointment(
        hospitalName: "City General Hospital",
        doctorName: "Dr. Sarah Johnson",
        specialization: "Cardiologist",
        date: "Today",
        time: "10:30 AM",
        avatarColor: Colors.blue,
      ),
      _Appointment(
        hospitalName: "Medical Center Plus",
        doctorName: "Dr. Michael Brown",
        specialization: "Orthopedic",
        date: "Tomorrow",
        time: "2:00 PM",
        avatarColor: Colors.green,
      ),
    ];

    if (appointments.isEmpty) {
      return _buildEmptyState(
        context,
        Icons.calendar_today_outlined,
        "No Upcoming Appointments",
        "Book your first appointment",
        isDarkMode,
      );
    }

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
    _Appointment appointment,
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
          // Doctor Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: appointment.avatarColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.person, color: appointment.avatarColor, size: 32),
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
                      "${appointment.date}, ${appointment.time}",
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
    final hospitals = [
      _Hospital(
        name: "City General Hospital",
        specialties: "Multi-specialty",
        distance: "2.5 km",
        rating: 4.8,
        image: Icons.local_hospital,
        color: Colors.blue,
      ),
      _Hospital(
        name: "Care Medical Center",
        specialties: "Emergency Care",
        distance: "3.2 km",
        rating: 4.6,
        image: Icons.local_hospital,
        color: Colors.green,
      ),
      _Hospital(
        name: "Health Plus Clinic",
        specialties: "General Practice",
        distance: "1.8 km",
        rating: 4.9,
        image: Icons.local_hospital,
        color: Colors.orange,
      ),
    ];

    return SizedBox(
      height: isMobile ? 200 : 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hospitals.length,
        itemBuilder: (context, index) {
          final hospital = hospitals[index];
          return Padding(
            padding: EdgeInsets.only(right: 16, left: index == 0 ? 0 : 0),
            child: _buildHospitalCard(context, hospital, isMobile, isDarkMode),
          );
        },
      ),
    );
  }

  Widget _buildHospitalCard(
    BuildContext context,
    _Hospital hospital,
    bool isMobile,
    bool isDarkMode,
  ) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: isMobile ? 280 : 320,
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
          children: [
            // Hospital Image/Icon
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: hospital.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(hospital.image, size: 40, color: hospital.color),
              ),
            ),

            const SizedBox(height: 10),

            // Flexible content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    hospital.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    hospital.specialties,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        hospital.distance,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        hospital.rating.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
        icon: Icons.favorite,
        color: Colors.red,
      ),
      _Specialization(
        name: "Dentistry",
        icon: Icons.local_hospital,
        color: Colors.blue,
      ),
      _Specialization(
        name: "Orthopedics",
        icon: Icons.accessibility_new,
        color: Colors.green,
      ),
      _Specialization(
        name: "Neurology",
        icon: Icons.psychology,
        color: Colors.purple,
      ),
      _Specialization(
        name: "Pediatrics",
        icon: Icons.child_care,
        color: Colors.orange,
      ),
      _Specialization(
        name: "Dermatology",
        icon: Icons.face,
        color: Colors.pink,
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
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
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
            ? LinearGradient(
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

class _Appointment {
  final String hospitalName;
  final String doctorName;
  final String specialization;
  final String date;
  final String time;
  final Color avatarColor;

  _Appointment({
    required this.hospitalName,
    required this.doctorName,
    required this.specialization,
    required this.date,
    required this.time,
    required this.avatarColor,
  });
}

class _Hospital {
  final String name;
  final String specialties;
  final String distance;
  final double rating;
  final IconData image;
  final Color color;

  _Hospital({
    required this.name,
    required this.specialties,
    required this.distance,
    required this.rating,
    required this.image,
    required this.color,
  });
}

class _Specialization {
  final String name;
  final IconData icon;
  final Color color;

  _Specialization({
    required this.name,
    required this.icon,
    required this.color,
  });
}
