import 'package:flutter/material.dart';
import 'package:med_connect/providers/doctor_provider.dart';
import 'package:med_connect/screens/doctor/doctor_management_screen.dart';
import 'package:med_connect/screens/hospital/edit_hospital_profile_screen.dart';
import 'package:med_connect/screens/hospital/hospital_settings_screen.dart';
import 'package:med_connect/theme/theme.dart';
import 'package:med_connect/widgets/empty_field.dart';
import 'package:provider/provider.dart';
import '../../providers/authentication_provider.dart';
import '../../utils/helper.dart';

class HospitalProfileScreen extends StatefulWidget {
  const HospitalProfileScreen({super.key});

  @override
  State<HospitalProfileScreen> createState() => _HospitalProfileScreenState();
}

class _HospitalProfileScreenState extends State<HospitalProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 650;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final authProvider = context.watch<AuthenticationProvider>();
    final hospital = authProvider.hospital;

    if (hospital == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, isDarkMode, hospital),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildHospitalInfoHeader(
                  context,
                  isMobile,
                  isDarkMode,
                  hospital,
                ),
                const SizedBox(height: 24),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Stats
                      _buildQuickStats(context, isMobile, isDarkMode, hospital),
                      const SizedBox(height: 24),
                      _buildSectionTitle(context, "Contact Information"),
                      const SizedBox(height: 14),
                      _buildContactInfo(context, isDarkMode, hospital),
                      const SizedBox(height: 24),
                      _buildSectionTitle(context, "About Hospital"),
                      const SizedBox(height: 12),
                      _buildAboutSection(context, isDarkMode, hospital),
                      const SizedBox(height: 24),
                      _buildSectionTitle(context, "Departments"),
                      const SizedBox(height: 12),
                      _buildDepartments(
                        context,
                        isMobile,
                        isDarkMode,
                        hospital,
                      ),
                      const SizedBox(height: 24),
                      if (hospital.is24x7 == true)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(context, "Operating Hours"),
                            const SizedBox(height: 12),
                            _build24x7Banner(context, isDarkMode),
                            const SizedBox(height: 24),
                          ],
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle(context, "Operating Hours"),
                            const SizedBox(height: 12),
                            _buildOperatingHours(context, isDarkMode, hospital),
                            const SizedBox(height: 24),
                          ],
                        ),

                      // Services & Facilities
                      _buildSectionTitle(context, "Services & Facilities"),
                      const SizedBox(height: 12),
                      _buildServicesFacilities(
                        context,
                        isMobile,
                        isDarkMode,
                        hospital,
                      ),
                      const SizedBox(height: 24),

                      // Gallery
                      _buildSectionTitle(context, "Gallery"),
                      const SizedBox(height: 12),
                      _buildGallery(context, isMobile, isDarkMode, hospital),
                      const SizedBox(height: 24),

                      // Reviews & Ratings
                      _buildSectionTitle(context, "Reviews & Ratings"),
                      const SizedBox(height: 12),
                      _buildReviewsSection(context, isDarkMode, hospital),
                      const SizedBox(height: 24),

                      // Accreditations
                      _buildSectionTitle(
                        context,
                        "Accreditations & Certifications",
                      ),
                      const SizedBox(height: 12),
                      _buildAccreditations(context, isDarkMode, hospital),
                      const SizedBox(height: 24),

                      // Management Actions
                      _buildManagementActions(
                        context,
                        isMobile,
                        isDarkMode,
                        hospital,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool isDarkMode, hospital) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                image:
                    hospital!.coverPhoto != null &&
                        hospital.coverPhoto!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(hospital.coverPhoto!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: hospital.coverPhoto == null || hospital.coverPhoto!.isEmpty
                  ? Center(
                      child: Icon(
                        Icons.local_hospital,
                        size: 100,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    )
                  : null,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HospitalSettingsScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHospitalInfoHeader(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    hospital,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDarkMode
                    ? DarkThemeColors.buttonPrimary
                    : LightThemeColors.buttonPrimary,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipOval(
              child: hospital!.logo != null && hospital.logo!.isNotEmpty
                  ? Image.network(
                      hospital.logo!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _fallbackHospitalIcon(context);
                      },
                    )
                  : _fallbackHospitalIcon(context),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            hospital.displayName,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Hospital Type
          if (hospital.type != null && hospital.type!.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.blue.withValues(alpha: 0.2)
                    : Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Text(
                hospital.type!,
                style: TextStyle(
                  color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? DarkThemeColors.buttonSecondary
                      : LightThemeColors.buttonSecondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Reg No: ${hospital.registrationNumber}",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? DarkThemeColors.buttonSecondary
                      : LightThemeColors.buttonSecondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified, size: 14, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      hospital.isVerified ? "Verified" : "Not Verified",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  "${hospital.city}, ${hospital.state}",
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          buildRatingStars(hospital.rating ?? 0.0),
        ],
      ),
    );
  }

  Widget _fallbackHospitalIcon(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      child: Icon(
        Icons.local_hospital,
        size: 50,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget buildRatingStars(double rating, {double size = 20}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor()
              ? Icons.star
              : index < rating
              ? Icons.star_half
              : Icons.star_border,
          color: Colors.amber,
          size: size,
        );
      }),
    );
  }

  Widget _buildQuickStats(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    hospital,
  ) {
    final doctorProvider = context.watch<DoctorProvider>();
    final totalDoctors = doctorProvider.doctors.length;
    final stats = [
      {
        "icon": Icons.hotel,
        "label": "Total Beds",
        "value": hospital.bedCount.toString(),
      },
      {
        "icon": Icons.medical_services,
        "label": "ICU Beds",
        "value": hospital.icuBedCount.toString(),
      },
      {
        "icon": Icons.emergency,
        "label": "Emergency",
        "value": hospital.emergencyBedCount.toString(),
      },
      {
        "icon": Icons.people,
        "label": "Doctors",
        "value": totalDoctors.toString(),
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((stat) {
          return _buildStatItem(stat, isDarkMode);
        }).toList(),
      ),
    );
  }

  Widget _buildStatItem(Map<String, dynamic> stat, bool isDarkMode) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.blue.withValues(alpha: 0.2)
                : Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            stat["icon"] as IconData,
            color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          stat["value"] as String,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          stat["label"] as String,
          style: TextStyle(
            fontSize: 12,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildAboutSection(BuildContext context, bool isDarkMode, hospital) {
    if (hospital.description == null || hospital.description!.isEmpty) {
      return EmptyField(isDarkMode: isDarkMode, value: 'About not available');
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hospital!.description ?? "",
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartments(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    hospital,
  ) {
    final List<String> departments = List<String>.from(hospital.departments);

    if (departments.isEmpty) {
      return EmptyField(
        isDarkMode: isDarkMode,
        value: 'Departments not available',
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 2 : 4,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: departments.length,
          itemBuilder: (context, index) {
            final String deptName = departments[index];

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withValues(alpha: 0.1),
                    Colors.purple.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    getDepartmentIconFromName(deptName),
                    size: 18,
                    color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      deptName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, bool isDarkMode, hospital) {
    final contacts = [
      {
        "icon": Icons.phone,
        "label": "Phone",
        "value": hospital!.phoneNumber ?? "+1 (555) 123-4567",
      },
      {
        "icon": Icons.email,
        "label": "Email",
        "value": hospital.email ?? "contact@hospital.com",
      },
      {
        "icon": Icons.location_on,
        "label": "Address",
        "value": hospital.address ?? "123 Healthcare Ave, Medical District",
      },
      {
        "icon": Icons.language,
        "label": "Website",
        "value": hospital.website ?? "www.hospital.com",
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: contacts.map((contact) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.blue.withValues(alpha: 0.2)
                        : Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    contact["icon"] as IconData,
                    size: 20,
                    color: isDarkMode ? Colors.blue[300] : Colors.blue[700],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact["label"] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        contact["value"] as String,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _build24x7Banner(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withValues(alpha: 0.2),
            Colors.teal.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.access_time,
              color: isDarkMode ? Colors.green[300] : Colors.green[700],
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Open 24/7",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.green[300] : Colors.green[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "This hospital operates around the clock, every day of the year",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperatingHours(BuildContext context, bool isDarkMode, hospital) {
    final Map<String, dynamic> operatingHours =
    Map<String, dynamic>.from(hospital.operatingHours ?? {});

    if (operatingHours.isEmpty) {
      return EmptyField(
        isDarkMode: isDarkMode,
        value: 'Operating Hours not available',
      );
    }

    final now = DateTime.now();
    final currentDay = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ][now.weekday - 1];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: operatingHours.entries.map((entry) {
          final day = entry.key;

          if (entry.value == null || entry.value is! Map<String, dynamic>) {
            return const SizedBox(); // skip invalid data
          }

          final Map<String, dynamic> data = entry.value;

          final bool isOpen = data['isOpen'] as bool? ?? false;
          final String startTime = data['start'] as String? ?? '';
          final String endTime = data['end'] as String? ?? '';

          final bool isToday = day == currentDay;

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isToday
                  ? (isDarkMode
                  ? Colors.blue.withValues(alpha: 0.15)
                  : Colors.blue.withValues(alpha: 0.08))
                  : (isDarkMode ? Colors.grey[800] : Colors.grey[50]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text(
                    day,
                    style: TextStyle(
                      fontWeight:
                      isToday ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  isOpen
                      ? '$startTime - $endTime'
                      : 'Closed',
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildServicesFacilities(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    hospital,
  ) {
    final List<String> facilities = List<String>.from(hospital.facilities);

    if (facilities.isEmpty) {
      return EmptyField(
        isDarkMode: isDarkMode,
        value: 'Services not available',
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 2 : 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: facilities.length,
          itemBuilder: (context, index) {
            final String facilityName = facilities[index];

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withValues(alpha: 0.1),
                    Colors.pink.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(
                    getFacilityIcon(facilityName),
                    size: 18,
                    color: isDarkMode ? Colors.purple[300] : Colors.purple[700],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      facilityName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode
                            ? Colors.purple[300]
                            : Colors.purple[700],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGallery(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    hospital,
  ) {
    if (hospital.hospitalImages == null || hospital.hospitalImages!.isEmpty) {
      return EmptyField(isDarkMode: isDarkMode, value: 'Gallary not available');
    }
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hospital.hospitalImages?.length,
        itemBuilder: (context, index) {
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                hospital.hospitalImages![index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
                    child: Icon(
                      Icons.image,
                      size: 60,
                      color: isDarkMode ? Colors.grey[700] : Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context, bool isDarkMode, hospital) {
    final double rating = (hospital?.rating ?? 0.0).clamp(0.0, 5.0);
    final int reviewCount = hospital?.totalReviews ?? 0;

    if (hospital.rating == null || hospital.rating.isEmpty) {
      return EmptyField(isDarkMode: isDarkMode, value: 'Reviews not available');
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRatingStars(rating, size: 16),
                      const SizedBox(height: 4),
                      Text(
                        "$reviewCount reviews",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              TextButton(onPressed: () {}, child: const Text("View All")),
            ],
          ),
          const SizedBox(height: 16),
          _buildRatingBar("5 ★", rating / 5, isDarkMode),
          _buildRatingBar("4 ★", rating / 6, isDarkMode),
          _buildRatingBar("3 ★", rating / 7, isDarkMode),
          _buildRatingBar("2 ★", rating / 8, isDarkMode),
          _buildRatingBar("1 ★", rating / 9, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildRatingBar(String label, double percentage, bool isDarkMode) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: Text(
            "${(percentage * 100).toInt()}%",
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildAccreditations(BuildContext context, bool isDarkMode, hospital) {
    final List<dynamic> accreditations = hospital.accreditations ?? [];

    if (accreditations.isEmpty) {
      return EmptyField(
        isDarkMode: isDarkMode,
        value: 'Accreditations not available',
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: accreditations.map<Widget>((acc) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.withValues(alpha: 0.1),
                  Colors.purple.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  acc.toString(), // 👈 ensure it's a String
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildManagementActions(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    hospital,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditHospitalProfileScreen(),
                ),
              );
            },
            icon: Icon(Icons.edit, color: Colors.black),
            label: Text(
              "Edit Hospital Profile",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode
                  ? DarkThemeColors.buttonPrimary
                  : LightThemeColors.buttonPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorManagementScreen(
                        hospitalAffiliation: hospital.displayName,
                        hospitalId: hospital?.id,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.medical_services, size: 20),
                label: const Text("Manage Doctors"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  //
                },
                icon: const Icon(Icons.analytics, size: 20),
                label: const Text("Analytics"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
