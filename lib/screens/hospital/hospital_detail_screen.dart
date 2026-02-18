import 'package:flutter/material.dart';
import 'package:med_connect/models/user/hospital_model.dart';
import 'package:med_connect/screens/appointments/book_appointment_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/doctor_provider.dart';
import '../../providers/hospital_provider.dart';

class HospitalDetailsScreen extends StatefulWidget {
  final String hospitalId;

  const HospitalDetailsScreen({super.key, required this.hospitalId});

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<DoctorProvider>().loadDoctorsByHospital(
        widget.hospitalId,
        null,
      );

      context.read<HospitalProvider>().loadHospital(widget.hospitalId, null);
    });
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

    return Consumer<HospitalProvider>(
      builder: (context, hospitalProvider, child) {
        if (hospitalProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final hospital = hospitalProvider.currentHospital;

        if (hospital == null) {
          return const Scaffold(
            body: Center(child: Text('Hospital not found')),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context, isDarkMode, hospital),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildHospitalHeader(
                      context,
                      isMobile,
                      isDarkMode,
                      hospital,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16 : 24,
                      ),
                      child: _buildQuickInfoCards(
                        context,
                        isMobile,
                        isDarkMode,
                        hospital,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      color: isDarkMode ? Colors.grey[900] : Colors.white,
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: Theme.of(context).primaryColor,
                        labelColor: Theme.of(context).primaryColor,
                        unselectedLabelColor: isDarkMode
                            ? Colors.grey[400]
                            : Colors.grey[600],
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
                    SizedBox(
                      height: 800,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildAboutTab(
                            context,
                            isMobile,
                            isDarkMode,
                            hospital,
                          ),
                          _buildDoctorsTab(
                            context,
                            isMobile,
                            isDarkMode,
                            hospital,
                          ),
                          _buildServicesTab(
                            context,
                            isMobile,
                            isDarkMode,
                            hospital,
                          ),
                          _buildReviewsTab(
                            context,
                            isMobile,
                            isDarkMode,
                            hospital,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(context, isDarkMode, hospital),
        );
      },
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    bool isDarkMode,
    HospitalModel hospital,
  ) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            hospital.coverPhoto != null && hospital.coverPhoto!.isNotEmpty
                ? Image.network(
                    hospital.coverPhoto!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).primaryColor,
                              Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: 0.7),
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
                      );
                    },
                  )
                : Container(
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
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    HospitalModel hospital,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hospital.displayName,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              hospital.type ?? "",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    hospital.rating != null
                        ? hospital.rating!.toStringAsFixed(1)
                        : "No rating",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    " (${hospital.totalReviews ?? 0} reviews)",
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.pin_drop,
                size: 18,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  [
                    hospital.address,
                    hospital.city,
                    hospital.state,
                  ].where((e) => e != null && e.isNotEmpty).join(", "),
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
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    HospitalModel hospital,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            context,
            Icons.access_time,
            hospital.is24x7! ? "24/7 Open" : "Operating",
            hospital.is24x7! ? "Always Open" : "Check Hours",
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTab(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    HospitalModel hospital,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, "About Hospital"),
          const SizedBox(height: 12),
          Text(
            hospital.description ?? "No description available",
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(context, "Facilities & Amenities"),
          const SizedBox(height: 12),
          _buildFacilitiesGrid(context, isDarkMode, hospital),
          const SizedBox(height: 24),
          _buildSectionTitle(context, "Operating Hours"),
          const SizedBox(height: 12),
          _buildOperatingHours(context, isDarkMode, hospital),
          const SizedBox(height: 24),
          _buildSectionTitle(context, "Contact Information"),
          const SizedBox(height: 12),
          _buildContactInfo(context, isDarkMode, hospital),
          const SizedBox(height: 24),
          _buildSectionTitle(context, "Photo Gallery"),
          const SizedBox(height: 12),
          _buildGallery(context, isDarkMode, hospital),
        ],
      ),
    );
  }

  Widget _buildDoctorsTab(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    HospitalModel hospital,
  ) {
    return Consumer<DoctorProvider>(
      builder: (context, doctorProvider, child) {
        if (doctorProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final doctors = doctorProvider.doctors;

        if (doctors.isEmpty) {
          return const Center(child: Text("No doctors available"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            final doctor = doctors[index];

            return Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(doctor.name),
                subtitle: Text(doctor.specialization ?? ""),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to doctor details
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildServicesTab(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    HospitalModel hospital,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(context, "Departments"),
          const SizedBox(height: 12),
          _buildDepartmentsList(context, isDarkMode, hospital),
          const SizedBox(height: 24),
          _buildSectionTitle(context, "Medical Services"),
          const SizedBox(height: 12),
          _buildServicesList(context, isDarkMode, hospital),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    HospitalModel hospital,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverallRating(context, isDarkMode, hospital),
          const SizedBox(height: 24),
          _buildSectionTitle(context, "Patient Reviews"),
          const SizedBox(height: 12),
          Center(
            child: Text(
              "No reviews available yet",
              style: TextStyle(color: Colors.grey[600]),
            ),
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

  Widget _buildFacilitiesGrid(
    BuildContext context,
    bool isDarkMode,
    HospitalModel hospital,
  ) {
    final facilities = hospital.facilities ?? [];

    if (facilities.isEmpty) {
      return Center(
        child: Text(
          "No facilities information available",
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

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
                Icons.check_circle,
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                facility,
                style: const TextStyle(fontSize: 12),
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

  Widget _buildOperatingHours(
    BuildContext context,
    bool isDarkMode,
    HospitalModel hospital,
  ) {
    if (hospital.is24x7!) {
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
                    "This hospital operates around the clock",
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

    final operatingHours = hospital.operatingHours;
    if (operatingHours == null || operatingHours.isEmpty) {
      return Text(
        "Operating hours not available",
        style: TextStyle(color: Colors.grey[600]),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: operatingHours.entries.map((entry) {
          final day = entry.key;
          final hours = entry.value as Map<String, dynamic>;
          final isOpen = hours['isOpen'] ?? false;
          final start = hours['start'] ?? '';
          final end = hours['end'] ?? '';

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(day, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(
                  isOpen ? "$start - $end" : "Closed",
                  style: TextStyle(
                    color: isOpen
                        ? (isDarkMode ? Colors.grey[400] : Colors.grey[600])
                        : Colors.red,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContactInfo(
    BuildContext context,
    bool isDarkMode,
    HospitalModel hospital,
  ) {
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
          _buildContactTile(
            Icons.phone,
            "Phone",
            hospital.phoneNumber ?? "",
            Colors.green,
            isDarkMode,
          ),
          const SizedBox(height: 16),
          _buildContactTile(
            Icons.email,
            "Email",
            hospital.email ?? "",
            Colors.blue,
            isDarkMode,
          ),
          if (hospital.website != null && hospital.website!.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildContactTile(
              Icons.language,
              "Website",
              hospital.website!,
              Colors.purple,
              isDarkMode,
            ),
          ],
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

  Widget _buildGallery(
    BuildContext context,
    bool isDarkMode,
    HospitalModel hospital,
  ) {
    final images = hospital.hospitalImages ?? [];

    if (images.isEmpty) {
      return SizedBox(
        height: 120,
        child: Center(
          child: Text(
            "No images available",
            style: TextStyle(
              color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          final imageUrl = images[index];

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 160,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 40,
                        color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDepartmentsList(
    BuildContext context,
    bool isDarkMode,
    HospitalModel hospital,
  ) {
    final departments = hospital.departments ?? [];

    if (departments.isEmpty) {
      return Text(
        "No departments information available",
        style: TextStyle(color: Colors.grey[600]),
      );
    }

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
                Expanded(
                  child: Text(
                    dept,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildServicesList(
    BuildContext context,
    bool isDarkMode,
    HospitalModel hospital,
  ) {
    final facilities = hospital.facilities ?? [];

    if (facilities.isEmpty) {
      return Text(
        "No services information available",
        style: TextStyle(color: Colors.grey[600]),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: facilities.map((service) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
            ),
          ),
          child: Text(service, style: const TextStyle(fontSize: 13)),
        );
      }).toList(),
    );
  }

  Widget _buildOverallRating(
    BuildContext context,
    bool isDarkMode,
    HospitalModel hospital,
  ) {
    final double rating = hospital.rating ?? 0.0;
    final int totalReviews = hospital.totalReviews ?? 0;

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
              Text(
                rating > 0 ? rating.toStringAsFixed(1) : "No rating",
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < rating.floor()
                        ? Icons.star
                        : (index < rating
                              ? Icons.star_half
                              : Icons.star_border),
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Based on $totalReviews reviews",
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
          Text(stars, style: const TextStyle(fontSize: 12)),
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

  Widget _buildBottomBar(
    BuildContext context,
    bool isDarkMode,
    HospitalModel hospital,
  ) {
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
                onPressed: () {},
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookAppointmentScreen(
                        hospitalId: hospital.id!,
                        hospitalName: hospital.displayName,
                        hospitalAddress: hospital.address ?? "",
                      ),
                    ),
                  );
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
