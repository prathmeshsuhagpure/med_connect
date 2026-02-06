import 'package:flutter/material.dart';

class HospitalDetailsScreen extends StatefulWidget {
  const HospitalDetailsScreen({super.key});

  @override
  State<HospitalDetailsScreen> createState() => _HospitalDetailsScreenState();
}

class _HospitalDetailsScreenState extends State<HospitalDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 650;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Sliver App Bar with Image
          _buildSliverAppBar(context, isDarkMode),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Hospital Header Info
                _buildHospitalHeader(context, isMobile, isDarkMode),

                const SizedBox(height: 16),

                // Quick Info Cards
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
                  child: _buildQuickInfoCards(context, isMobile, isDarkMode),
                ),

                const SizedBox(height: 24),

                // Tab Bar
                Container(
                  color: isDarkMode ? Colors.grey[900] : Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Theme.of(context).primaryColor,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(text: "About"),
                      Tab(text: "Doctors"),
                      Tab(text: "Services"),
                      Tab(text: "Reviews"),
                    ],
                  ),
                ),

                // Tab Content
                SizedBox(
                  height: 800, // Fixed height for tab content
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAboutTab(context, isMobile, isDarkMode),
                      _buildDoctorsTab(context, isMobile, isDarkMode),
                      _buildServicesTab(context, isMobile, isDarkMode),
                      _buildReviewsTab(context, isMobile, isDarkMode),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, isDarkMode),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool isDarkMode) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Hospital Image/Placeholder
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
                size: 120,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
            // Gradient Overlay
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
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isFavorite = !_isFavorite;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // TODO: Share hospital
          },
        ),
      ],
    );
  }

  Widget _buildHospitalHeader(
      BuildContext context, bool isMobile, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hospital Name
          Text(
            "City General Hospital",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Specialization
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Multi-Specialty Hospital",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Rating and Distance
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  const Text(
                    "4.8",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    " (1,234 reviews)",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Container(
                width: 1,
                height: 16,
                color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
              ),
              const SizedBox(width: 16),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 18,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "2.5 km away",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_city,
                size: 18,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "123 Medical Street, Downtown, New York, NY 10001",
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoCards(
      BuildContext context, bool isMobile, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            context,
            Icons.access_time,
            "Open Now",
            "24/7",
            Colors.green,
            isDarkMode,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            context,
            Icons.phone,
            "Call",
            "Contact",
            Colors.blue,
            isDarkMode,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            context,
            Icons.directions,
            "Navigate",
            "Get Directions",
            Colors.orange,
            isDarkMode,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle,
      Color color,
      bool isDarkMode,
      ) {
    return InkWell(
      onTap: () {
        // TODO: Handle action
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
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
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            Text(
              subtitle,
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

  Widget _buildAboutTab(BuildContext context, bool isMobile, bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          _buildSectionTitle(context, "About Hospital"),
          const SizedBox(height: 12),
          Text(
            "City General Hospital is a leading multi-specialty healthcare institution committed to providing world-class medical care. Established in 1985, we have been serving the community for over 35 years with dedication and excellence.\n\nOur state-of-the-art facility is equipped with the latest medical technology and staffed by highly qualified professionals dedicated to your health and well-being.",
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 24),

          // Facilities
          _buildSectionTitle(context, "Facilities & Amenities"),
          const SizedBox(height: 12),
          _buildFacilitiesGrid(context, isDarkMode),
          const SizedBox(height: 24),

          // Operating Hours
          _buildSectionTitle(context, "Operating Hours"),
          const SizedBox(height: 12),
          _buildOperatingHours(context, isDarkMode),
          const SizedBox(height: 24),

          // Contact Information
          _buildSectionTitle(context, "Contact Information"),
          const SizedBox(height: 12),
          _buildContactInfo(context, isDarkMode),
          const SizedBox(height: 24),

          // Gallery
          _buildSectionTitle(context, "Photo Gallery"),
          const SizedBox(height: 12),
          _buildGallery(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildDoctorsTab(BuildContext context, bool isMobile, bool isDarkMode) {
    final doctors = [
      _DoctorData(
        name: "Dr. Sarah Johnson",
        specialization: "Cardiologist",
        experience: "15 years",
        rating: 4.9,
        reviews: 234,
        available: true,
        color: Colors.blue,
      ),
      _DoctorData(
        name: "Dr. Michael Brown",
        specialization: "Orthopedic Surgeon",
        experience: "12 years",
        rating: 4.8,
        reviews: 189,
        available: true,
        color: Colors.green,
      ),
      _DoctorData(
        name: "Dr. Emily Davis",
        specialization: "Pediatrician",
        experience: "10 years",
        rating: 4.7,
        reviews: 156,
        available: false,
        color: Colors.orange,
      ),
      _DoctorData(
        name: "Dr. Robert Wilson",
        specialization: "Neurologist",
        experience: "18 years",
        rating: 4.9,
        reviews: 298,
        available: true,
        color: Colors.purple,
      ),
    ];

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildDoctorCard(context, doctors[index], isDarkMode),
        );
      },
    );
  }

  Widget _buildServicesTab(BuildContext context, bool isMobile, bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, "Departments"),
          const SizedBox(height: 12),
          _buildDepartmentsList(context, isDarkMode),
          const SizedBox(height: 24),

          _buildSectionTitle(context, "Medical Services"),
          const SizedBox(height: 12),
          _buildServicesList(context, isDarkMode),
          const SizedBox(height: 24),

          _buildSectionTitle(context, "Diagnostic Services"),
          const SizedBox(height: 12),
          _buildDiagnosticServices(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(BuildContext context, bool isMobile, bool isDarkMode) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Overall Rating
          _buildOverallRating(context, isDarkMode),
          const SizedBox(height: 24),

          // Reviews List
          _buildSectionTitle(context, "Patient Reviews"),
          const SizedBox(height: 12),
          _buildReviewsList(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFacilitiesGrid(BuildContext context, bool isDarkMode) {
    final facilities = [
      {"icon": Icons.emergency, "label": "Emergency"},
      {"icon": Icons.local_parking, "label": "Parking"},
      {"icon": Icons.restaurant, "label": "Cafeteria"},
      {"icon": Icons.wifi, "label": "Free WiFi"},
      {"icon": Icons.wheelchair_pickup, "label": "Wheelchair"},
      {"icon": Icons.medication, "label": "Pharmacy"},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: facilities.length,
      itemBuilder: (context, index) {
        final facility = facilities[index];
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
                facility["icon"] as IconData,
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                facility["label"] as String,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
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
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
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
              if (index > 0) Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[200], height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (isEmergency) ...[
                      const Icon(Icons.emergency, color: Colors.red, size: 20),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Text(
                        hour["day"]!.toString(),
                        style: TextStyle(
                          fontWeight: isEmergency ? FontWeight.bold : FontWeight.w500,
                          color: isEmergency ? Colors.red : null,
                        ),
                      ),
                    ),
                    Text(
                      hour["time"]!.toString(),
                      style: TextStyle(
                        color: isEmergency
                            ? Colors.red
                            : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                        fontWeight: isEmergency ? FontWeight.bold : null,
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

  Widget _buildContactInfo(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          _buildContactTile(Icons.phone, "Phone", "+1 (234) 567-8900", Colors.green, isDarkMode),
          const SizedBox(height: 16),
          _buildContactTile(Icons.email, "Email", "contact@citygeneralhospital.com", Colors.blue, isDarkMode),
          const SizedBox(height: 16),
          _buildContactTile(Icons.language, "Website", "www.citygeneralhospital.com", Colors.purple, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildContactTile(
      IconData icon,
      String label,
      String value,
      Color color,
      bool isDarkMode,
      ) {
    return Row(
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
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGallery(BuildContext context, bool isDarkMode) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 12, left: index == 0 ? 0 : 0),
            child: Container(
              width: 160,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(
                  Icons.image,
                  size: 50,
                  color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoctorCard(
      BuildContext context, _DoctorData doctor, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          // Doctor Avatar
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: doctor.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.person,
              color: doctor.color,
              size: 35,
            ),
          ),
          const SizedBox(width: 16),

          // Doctor Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      "${doctor.rating}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      " (${doctor.reviews})",
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: doctor.available
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        doctor.available ? "Available" : "Busy",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: doctor.available ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Book Button
          ElevatedButton(
            onPressed: () {
              // TODO: Book appointment
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text("Book"),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentsList(BuildContext context, bool isDarkMode) {
    final departments = [
      "Cardiology",
      "Neurology",
      "Orthopedics",
      "Pediatrics",
      "Oncology",
      "Radiology",
    ];

    return Column(
      children: departments.map((dept) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
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
                Icon(
                  Icons.medical_services,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 16),
                Text(
                  dept,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildServicesList(BuildContext context, bool isDarkMode) {
    final services = [
      "Emergency Care",
      "ICU & CCU",
      "Operation Theater",
      "Blood Bank",
      "Pharmacy",
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: services.map((service) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
            ),
          ),
          child: Text(
            service,
            style: const TextStyle(fontSize: 13),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDiagnosticServices(BuildContext context, bool isDarkMode) {
    final diagnostics = [
      "X-Ray",
      "CT Scan",
      "MRI",
      "Ultrasound",
      "ECG",
      "Blood Tests",
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: diagnostics.map((diagnostic) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            diagnostic,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOverallRating(BuildContext context, bool isDarkMode) {
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
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "4.8",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
              const SizedBox(height: 4),
              Text(
                "Based on 1,234 reviews",
                style: TextStyle(
                  fontSize: 13,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildRatingBar("5", 0.7, isDarkMode),
              _buildRatingBar("4", 0.2, isDarkMode),
              _buildRatingBar("3", 0.05, isDarkMode),
              _buildRatingBar("2", 0.03, isDarkMode),
              _buildRatingBar("1", 0.02, isDarkMode),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(String stars, double percentage, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            stars,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 12, color: Colors.amber),
          const SizedBox(width: 8),
          Container(
            width: 80,
            height: 6,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList(BuildContext context, bool isDarkMode) {
    final reviews = [
      {
        "name": "John Doe",
        "rating": 5,
        "date": "2 days ago",
        "comment": "Excellent service and very professional staff. The facilities are top-notch and the doctors are very caring.",
      },
      {
        "name": "Jane Smith",
        "rating": 4,
        "date": "1 week ago",
        "comment": "Good hospital with modern equipment. Wait times can be a bit long during peak hours.",
      },
      {
        "name": "Mike Johnson",
        "rating": 5,
        "date": "2 weeks ago",
        "comment": "Highly recommend! The emergency department was quick and efficient when I needed it most.",
      },
    ];

    return Column(
      children: reviews.map((review) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      child: Text(
                        review["name"].toString()[0],
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review["name"] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            review["date"] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: List.generate(
                        review["rating"] as int,
                            (index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  review["comment"] as String,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomBar(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Call hospital
                },
                icon: const Icon(Icons.phone),
                label: const Text("Call Now"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Book appointment
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text("Book Appointment"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper class
class _DoctorData {
  final String name;
  final String specialization;
  final String experience;
  final double rating;
  final int reviews;
  final bool available;
  final Color color;

  _DoctorData({
    required this.name,
    required this.specialization,
    required this.experience,
    required this.rating,
    required this.reviews,
    required this.available,
    required this.color,
  });
}