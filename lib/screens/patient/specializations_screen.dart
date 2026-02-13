import 'package:flutter/material.dart';
import 'package:med_connect/models/user/doctor_model.dart';
import 'package:med_connect/models/user/hospital_model.dart';
import 'package:med_connect/theme/theme.dart';

class Clinic {
  final String name;
  final String address;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final double distance;
  final String timing;
  final bool isOpen;

  Clinic({
    required this.name,
    required this.address,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.distance,
    required this.timing,
    required this.isOpen,
  });
}

class SpecializationListScreen extends StatefulWidget {
  final String specialization;
  final IconData icon;
  final Color color;

  const SpecializationListScreen({
    super.key,
    required this.specialization,
    required this.icon,
    required this.color,
  });

  @override
  State<SpecializationListScreen> createState() =>
      _SpecializationListScreenState();
}

class _SpecializationListScreenState extends State<SpecializationListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'All';
  String _sortBy = 'Recommended';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Sample data - replace with actual API data
  List<DoctorModel> _getDoctors() {
    return [
      DoctorModel(
        name: 'Sarah Anderson',
        hospitalAffiliation: 'City Heart Hospital',
        specialization: widget.specialization,
        rating: 4.8,
        totalReviews: 234,
        experience: "15",
        profilePicture: 'https://i.pravatar.cc/150?img=45',
        consultationFee: "500",
        availableHours: 'Available Today',
        isAvailable: true,
        id: '1',
        email: 'sarah.anderson@example.com',
        phoneNumber: "+1234567890",
      ),
      DoctorModel(
        name: 'Michael Roberts',
        hospitalAffiliation: 'Austin Medical Center',
        specialization: widget.specialization,
        rating: 4.9,
        totalReviews: 456,
        experience: "20",
        profilePicture: 'https://i.pravatar.cc/150?img=12',
        consultationFee: "750",
        availableHours: 'Tomorrow at 10 AM',
        isAvailable: false,
        id: '2',
        email: 'michael.roberts@example.com',
        phoneNumber: "+1234567891",
      ),
      DoctorModel(
        name: 'Emily Chen',
        hospitalAffiliation: 'Metro Health Clinic',
        specialization: widget.specialization,
        rating: 4.7,
        totalReviews: 189,
        experience: "12",
        profilePicture: 'https://i.pravatar.cc/150?img=47',
        consultationFee: "600",
        availableHours: 'Available Today',
        isAvailable: true,
        id: '3',
        email: 'emily.chen@example.com',
        phoneNumber: "+1234567892",
      ),
      DoctorModel(
        name: 'James Wilson',
        hospitalAffiliation: 'Central Hospital',
        specialization: widget.specialization,
        rating: 4.6,
        totalReviews: 167,
        experience: "18",
        profilePicture: 'https://i.pravatar.cc/150?img=33',
        consultationFee: "550",
        availableHours: 'Available Now',
        isAvailable: true,
        id: '4',
        email: 'james.wilson@example.com',
        phoneNumber: "+1234567893",
      ),
    ];
  }

  List<HospitalModel> _getHospitals() {
    return [
      HospitalModel(
        name: 'City Heart Hospital',
        address: '123 Medical Plaza, Downtown',
        rating: 4.5,
        totalReviews: 1234,
        coverPhoto:
        'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=400',
        distance: 2.5,
        facilities: ['ICU', 'Emergency', '24/7', 'Parking'],
        isOpen: true,
        id: '1',
        email: 'info@cityheart.com',
        phoneNumber: '+1234567890',
      ),
      HospitalModel(
        name: 'Austin Medical Center',
        address: '456 Health Street, Midtown',
        rating: 4.7,
        totalReviews: 2341,
        coverPhoto:
        'https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=400',
        distance: 3.8,
        facilities: ['ICU', 'Surgery', '24/7', 'Pharmacy'],
        isOpen: true,
        id: '2',
        email: 'info@austinmedical.com',
        phoneNumber: '+1234567891',
      ),
      HospitalModel(
        name: 'Metro Health Clinic',
        address: '789 Wellness Ave, Uptown',
        rating: 4.4,
        totalReviews: 987,
        coverPhoto:
        'https://images.unsplash.com/photo-1519494140681-8b17d830a3e9?w=400',
        distance: 1.2,
        facilities: ['Emergency', 'Lab', 'X-Ray'],
        isOpen: true,
        id: '3',
        email: 'info@metrohealth.com',
        phoneNumber: '+1234567892',
      ),
    ];
  }

  List<Clinic> _getClinics() {
    return [
      Clinic(
        name: 'Heart Care Clinic',
        address: '321 Care Lane, East Side',
        rating: 4.6,
        reviewCount: 456,
        imageUrl:
        'https://images.unsplash.com/photo-1631217868264-e5b90bb7e133?w=400',
        distance: 1.5,
        timing: '9 AM - 6 PM',
        isOpen: true,
      ),
      Clinic(
        name: 'Quick Care Center',
        address: '654 Quick Street, West End',
        rating: 4.3,
        reviewCount: 234,
        imageUrl:
        'https://images.unsplash.com/photo-1512678080530-7760d81faba6?w=400',
        distance: 2.1,
        timing: '8 AM - 8 PM',
        isOpen: true,
      ),
      Clinic(
        name: 'Family Health Clinic',
        address: '987 Family Road, South',
        rating: 4.5,
        reviewCount: 567,
        imageUrl:
        'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=400',
        distance: 0.8,
        timing: '10 AM - 7 PM',
        isOpen: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            _buildAppBar(context, isDark),

            // Header Banner
            _buildHeaderBanner(context, isDark),

            // Filter and Sort Bar
            _buildFilterBar(context, isDark),

            // Tab Bar
            _buildTabBar(context, isDark),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDoctorsList(context, isDark),
                  _buildHospitalsList(context, isDark),
                  _buildClinicsList(context, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: isDark
                  ? DarkThemeColors.buttonPrimary
                  : Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.specialization,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: isDark
                  ? DarkThemeColors.buttonPrimary
                  : Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
            style: IconButton.styleFrom(
              backgroundColor: isDark
                  ? DarkThemeColors.buttonPrimary
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBanner(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [widget.color, widget.color.withValues(alpha: 0.7)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: widget.color.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(widget.icon, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.specialization,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Find the best specialists near you',
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildBannerStat('142', 'Doctors'),
                    const SizedBox(width: 16),
                    _buildBannerStat('28', 'Hospitals'),
                    const SizedBox(width: 16),
                    _buildBannerStat('45', 'Clinics'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterBar(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    context,
                    isDark,
                    'All',
                    _selectedFilter == 'All',
                  ),
                  _buildFilterChip(
                    context,
                    isDark,
                    'Available Today',
                    _selectedFilter == 'Available Today',
                  ),
                  _buildFilterChip(
                    context,
                    isDark,
                    'Nearby',
                    _selectedFilter == 'Nearby',
                  ),
                  _buildFilterChip(
                    context,
                    isDark,
                    'Top Rated',
                    _selectedFilter == 'Top Rated',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          PopupMenuButton<String>(
            initialValue: _sortBy,
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'Recommended',
                child: Text('Recommended'),
              ),
              const PopupMenuItem(
                value: 'Rating',
                child: Text('Highest Rating'),
              ),
              const PopupMenuItem(
                value: 'Distance',
                child: Text('Nearest First'),
              ),
              const PopupMenuItem(value: 'Fee', child: Text('Lowest Fee')),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? DarkThemeColors.buttonPrimary : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.sort, size: 18),
                  SizedBox(width: 4),
                  Text(
                    'Sort',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      BuildContext context,
      bool isDark,
      String label,
      bool isSelected,
      ) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = label;
          });
        },
        backgroundColor: isDark ? DarkThemeColors.buttonPrimary : Colors.white,
        selectedColor: isDark
            ? DarkThemeColors.buttonPrimary
            : LightThemeColors.buttonPrimary,
        labelStyle: TextStyle(
          color: isSelected
              ? Colors.white
              : (isDark ? Colors.white : Colors.black87),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: isSelected
                ? Colors.transparent
                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? DarkThemeColors.buttonPrimary : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: isDark
              ? DarkThemeColors.buttonPrimary
              : LightThemeColors.buttonPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: isDark ? Colors.grey[400] : Colors.grey[600],
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        tabs: const [
          Tab(text: 'Doctors'),
          Tab(text: 'Hospitals'),
          Tab(text: 'Clinics'),
        ],
      ),
    );
  }

  Widget _buildDoctorsList(BuildContext context, bool isDark) {
    final doctors = _getDoctors();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        return _buildDoctorCard(context, isDark, doctors[index]);
      },
    );
  }

  Widget _buildDoctorCard(BuildContext context, bool isDark, DoctorModel doctor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? DarkThemeColors.buttonPrimary : Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: widget.color.withValues(alpha: 0.1),
                    child: ClipOval(
                      child: Image.network(
                        doctor.profilePicture ?? '',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            size: 35,
                            color: widget.color,
                          );
                        },
                      ),
                    ),
                  ),
                  if (doctor.isAvailable)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? DarkThemeColors.buttonPrimary
                                : Colors.white,
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
                        Expanded(
                          child: Text(
                            doctor.displayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(Icons.verified, size: 18, color: Colors.pink),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      doctor.hospitalAffiliation ?? 'Not specified',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
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
                            color: widget.color.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star, size: 14, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                '${doctor.rating ?? 0.0}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              Text(
                                ' (${doctor.totalReviews ?? 0})',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[800] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${doctor.experience ?? "0"} years exp',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: doctor.isAvailable
                              ? Colors.green
                              : Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          doctor.availableHours ?? 'Not available',
                          style: TextStyle(
                            fontSize: 12,
                            color: doctor.isAvailable
                                ? Colors.green
                                : Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '\$${doctor.consultationFee ?? "0"}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? DarkThemeColors.buttonPrimary
                                : LightThemeColors.buttonPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: const Text('Book'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark
                        ? DarkThemeColors.buttonPrimary
                        : LightThemeColors.buttonPrimary,
                    side: BorderSide(
                      color: isDark
                          ? DarkThemeColors.buttonPrimary
                          : LightThemeColors.buttonPrimary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.video_call, size: 16),
                  label: const Text('Video Call'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? DarkThemeColors.buttonPrimary
                        : LightThemeColors.buttonPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHospitalsList(BuildContext context, bool isDark) {
    final hospitals = _getHospitals();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: hospitals.length,
      itemBuilder: (context, index) {
        return _buildHospitalCard(context, isDark, hospitals[index]);
      },
    );
  }

  Widget _buildHospitalCard(
      BuildContext context,
      bool isDark,
      HospitalModel hospital,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? DarkThemeColors.buttonPrimary : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  hospital.profilePicture ?? '',
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 160,
                      color: isDark ? Colors.grey[800] : Colors.grey[200],
                      child: Icon(
                        Icons.local_hospital,
                        size: 50,
                        color: widget.color,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: hospital.isOpen ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    hospital.isOpen ? 'Open' : 'Closed',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${hospital.distance} km',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hospital.displayName,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        hospital.address ?? 'Address not available',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${hospital.rating ?? 0.0}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          Text(
                            ' (${hospital.totalReviews ?? 0})',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (hospital.facilities ?? []).map((facility) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        facility,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.directions, size: 16),
                        label: const Text('Directions'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark
                              ? DarkThemeColors.buttonPrimary
                              : LightThemeColors.buttonPrimary,
                          side: BorderSide(
                            color: isDark
                                ? DarkThemeColors.buttonPrimary
                                : LightThemeColors.buttonPrimary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.info_outline, size: 16),
                        label: const Text('View Details'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? DarkThemeColors.buttonPrimary
                              : LightThemeColors.buttonPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
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

  Widget _buildClinicsList(BuildContext context, bool isDark) {
    final clinics = _getClinics();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: clinics.length,
      itemBuilder: (context, index) {
        return _buildClinicCard(context, isDark, clinics[index]);
      },
    );
  }

  Widget _buildClinicCard(BuildContext context, bool isDark, Clinic clinic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? DarkThemeColors.buttonPrimary : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              clinic.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 80,
                  height: 80,
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                  child: Icon(
                    Icons.local_hospital,
                    size: 30,
                    color: widget.color,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        clinic.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: clinic.isOpen
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        clinic.isOpen ? 'Open' : 'Closed',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: clinic.isOpen ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        clinic.address,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${clinic.rating}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' (${clinic.reviewCount}) ',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                    Text(
                      '· ${clinic.distance} km',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      clinic.timing,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark
                              ? DarkThemeColors.buttonPrimary
                              : LightThemeColors.buttonPrimary,
                          side: BorderSide(
                            color: isDark
                                ? DarkThemeColors.buttonPrimary
                                : LightThemeColors.buttonPrimary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: const Text(
                          'Call',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? DarkThemeColors.buttonPrimary
                              : LightThemeColors.buttonPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: const Text(
                          'Visit',
                          style: TextStyle(fontSize: 13),
                        ),
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
}