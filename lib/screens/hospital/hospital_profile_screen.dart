import 'package:flutter/material.dart';
import 'package:med_connect/screens/hospital/hospital_settings_screen.dart';

class HospitalProfileScreen extends StatefulWidget {
  const HospitalProfileScreen({super.key});

  @override
  State<HospitalProfileScreen> createState() => _HospitalProfileScreenState();
}

class _HospitalProfileScreenState extends State<HospitalProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 650;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Cover Image
          _buildSliverAppBar(context, isDarkMode),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Hospital Info Header
                _buildHospitalInfoHeader(context, isMobile, isDarkMode),
                const SizedBox(height: 24),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Stats
                      _buildQuickStats(context, isMobile, isDarkMode),
                      const SizedBox(height: 24),

                      // About Section
                      _buildSectionTitle(context, "About Hospital"),
                      const SizedBox(height: 12),
                      _buildAboutSection(context, isDarkMode),
                      const SizedBox(height: 24),

                      // Contact Information
                      _buildSectionTitle(context, "Contact Information"),
                      const SizedBox(height: 12),
                      _buildContactInfo(context, isDarkMode),
                      const SizedBox(height: 24),

                      // Operating Hours
                      _buildSectionTitle(context, "Operating Hours"),
                      const SizedBox(height: 12),
                      _buildOperatingHours(context, isDarkMode),
                      const SizedBox(height: 24),

                      // Services & Facilities
                      _buildSectionTitle(context, "Services & Facilities"),
                      const SizedBox(height: 12),
                      _buildServicesFacilities(context, isMobile, isDarkMode),
                      const SizedBox(height: 24),

                      // Departments
                      _buildSectionTitle(context, "Departments"),
                      const SizedBox(height: 12),
                      _buildDepartments(context, isMobile, isDarkMode),
                      const SizedBox(height: 24),

                      // Gallery
                      _buildSectionTitle(context, "Gallery"),
                      const SizedBox(height: 12),
                      _buildGallery(context, isMobile, isDarkMode),
                      const SizedBox(height: 24),

                      // Reviews & Ratings
                      _buildSectionTitle(context, "Reviews & Ratings"),
                      const SizedBox(height: 12),
                      _buildReviewsSection(context, isDarkMode),
                      const SizedBox(height: 24),

                      // Accreditations
                      _buildSectionTitle(
                        context,
                        "Accreditations & Certifications",
                      ),
                      const SizedBox(height: 12),
                      _buildAccreditations(context, isDarkMode),
                      const SizedBox(height: 24),

                      // Management Actions
                      _buildManagementActions(context, isMobile, isDarkMode),
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

  Widget _buildSliverAppBar(BuildContext context, bool isDarkMode) {
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
              ),
              child: Icon(
                Icons.local_hospital,
                size: 100,
                color: Colors.white.withValues(alpha: 0.3),
              ),
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
  ) {
    return Container(
      transform: Matrix4.translationValues(0, -40, 0),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      child: Column(
        children: [
          // Hospital Logo
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).primaryColor,
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
            child: Icon(
              Icons.local_hospital,
              size: 50,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),

          // Hospital Name
          Text(
            "City General Hospital",
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Hospital ID and Type
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "ID: HOS123456",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
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
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified, size: 14, color: Colors.green),
                    SizedBox(width: 4),
                    Text(
                      "Verified",
                      style: TextStyle(
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

          // Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < 4 ? Icons.star : Icons.star_half,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "4.8 (1,234 reviews)",
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            "50+",
            "Doctors",
            Icons.medical_services,
            Colors.blue,
            isDarkMode,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            "20+",
            "Departments",
            Icons.business,
            Colors.green,
            isDarkMode,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            "500+",
            "Beds",
            Icons.hotel,
            Colors.orange,
            isDarkMode,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            context,
            "24/7",
            "Emergency",
            Icons.emergency,
            Colors.red,
            isDarkMode,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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

  Widget _buildAboutSection(BuildContext context, bool isDarkMode) {
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
            "City General Hospital is a leading multi-specialty healthcare institution committed to providing world-class medical care. Established in 1985, we have been serving the community for over 35 years with dedication and excellence.",
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChip("Multi-Specialty", Colors.blue, isDarkMode),
              _buildChip("Trauma Center", Colors.red, isDarkMode),
              _buildChip("Research Facility", Colors.purple, isDarkMode),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, bool isDarkMode) {
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
          _buildContactTile(
            context,
            Icons.location_on,
            "Address",
            "123 Medical Street, Downtown\nNew York, NY 10001",
            Colors.red,
            isDarkMode,
          ),
          Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[200]),
          _buildContactTile(
            context,
            Icons.phone,
            "Phone",
            "+1 (234) 567-8900",
            Colors.green,
            isDarkMode,
          ),
          Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[200]),
          _buildContactTile(
            context,
            Icons.email,
            "Email",
            "contact@citygeneralhospital.com",
            Colors.blue,
            isDarkMode,
          ),
          Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[200]),
          _buildContactTile(
            context,
            Icons.language,
            "Website",
            "www.citygeneralhospital.com",
            Colors.purple,
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
    bool isDarkMode,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          Icon(
            Icons.copy,
            size: 18,
            color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
          ),
        ],
      ),
    );
  }

  Widget _buildOperatingHours(BuildContext context, bool isDarkMode) {
    final hours = [
      {"day": "Monday - Friday", "time": "8:00 AM - 8:00 PM"},
      {"day": "Saturday", "time": "9:00 AM - 6:00 PM"},
      {"day": "Sunday", "time": "10:00 AM - 4:00 PM"},
      {"day": "Emergency", "time": "24/7 Open", "isEmergency": true},
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
        children: hours.asMap().entries.map((entry) {
          final index = entry.key;
          final hour = entry.value;
          final isEmergency = hour["isEmergency"] == true;

          return Column(
            children: [
              if (index > 0)
                Divider(
                  color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    if (isEmergency)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.emergency,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    if (isEmergency) const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        hour["day"].toString(),
                        style: TextStyle(
                          fontWeight: isEmergency
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: isEmergency ? Colors.red : null,
                        ),
                      ),
                    ),
                    Text(
                      hour["time"].toString(),
                      style: TextStyle(
                        color: isEmergency
                            ? Colors.red
                            : (isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600]),
                        fontWeight: isEmergency
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildServicesFacilities(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
  ) {
    final services = [
      {"icon": Icons.emergency, "label": "Emergency Care", "color": Colors.red},
      {"icon": Icons.healing, "label": "ICU", "color": Colors.orange},
      {"icon": Icons.child_care, "label": "Maternity", "color": Colors.pink},
      {"icon": Icons.science, "label": "Laboratory", "color": Colors.blue},
      {"icon": Icons.medication, "label": "Pharmacy", "color": Colors.green},
      {"icon": Icons.local_parking, "label": "Parking", "color": Colors.purple},
      {"icon": Icons.restaurant, "label": "Cafeteria", "color": Colors.brown},
      {"icon": Icons.wifi, "label": "Free WiFi", "color": Colors.cyan},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 4 : 8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                service["icon"] as IconData,
                color: service["color"] as Color,
                size: 24,
              ),
              const SizedBox(height: 6),
              Text(
                service["label"] as String,
                style: TextStyle(
                  fontSize: 10,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDepartments(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
  ) {
    final departments = [
      {"name": "Cardiology", "icon": Icons.favorite, "color": Colors.red},
      {"name": "Neurology", "icon": Icons.psychology, "color": Colors.purple},
      {
        "name": "Orthopedics",
        "icon": Icons.accessibility_new,
        "color": Colors.blue,
      },
      {"name": "Pediatrics", "icon": Icons.child_care, "color": Colors.pink},
      {"name": "Oncology", "icon": Icons.healing, "color": Colors.orange},
      {"name": "Radiology", "icon": Icons.camera_alt, "color": Colors.cyan},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.5,
      ),
      itemCount: departments.length,
      itemBuilder: (context, index) {
        final dept = departments[index];
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
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (dept["color"] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  dept["icon"] as IconData,
                  color: dept["color"] as Color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  dept["name"] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGallery(BuildContext context, bool isMobile, bool isDarkMode) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 12, left: index == 0 ? 0 : 0),
            child: Container(
              width: 160,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Icon(
                      Icons.image,
                      size: 50,
                      color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.5),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Text(
                        "Photo ${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context, bool isDarkMode) {
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "4.8",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (index) => Icon(
                                index < 4 ? Icons.star : Icons.star_half,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "1,234 reviews",
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
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  //  reviews
                },
                child: const Text("View All"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRatingBar("5 ★", 0.7, isDarkMode),
          const SizedBox(height: 8),
          _buildRatingBar("4 ★", 0.2, isDarkMode),
          const SizedBox(height: 8),
          _buildRatingBar("3 ★", 0.05, isDarkMode),
          const SizedBox(height: 8),
          _buildRatingBar("2 ★", 0.03, isDarkMode),
          const SizedBox(height: 8),
          _buildRatingBar("1 ★", 0.02, isDarkMode),
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

  Widget _buildAccreditations(BuildContext context, bool isDarkMode) {
    final accreditations = [
      "JCI Accredited",
      "NABH Certified",
      "ISO 9001:2015",
      "Green OT Certified",
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
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: accreditations.map((acc) {
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
                  acc,
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
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {
              //  profile
            },
            icon: const Icon(Icons.edit),
            label: const Text(
              "Edit Hospital Profile",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
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
                  //
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
