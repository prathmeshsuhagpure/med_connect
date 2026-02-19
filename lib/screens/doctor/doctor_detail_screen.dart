import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoctorDetailScreen extends StatefulWidget {
  final String? doctorId;

  const DoctorDetailScreen({super.key, this.doctorId});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;

  // Sample Doctor Data
  final _doctor = _Doctor(
    id: "1",
    name: "Dr. Amit Sharma",
    specialization: "Cardiologist",
    qualification: "MBBS, MD (Cardiology)",
    experience: 15,
    rating: 4.8,
    totalReviews: 342,
    consultationFee: 800,
    hospital: "Apollo Hospital",
    address: "Sector 26, Noida, Delhi NCR",
    phone: "+91 98765 43210",
    email: "dr.amit.sharma@apollo.com",
    about:
    "Dr. Amit Sharma is a highly experienced cardiologist with over 15 years of practice. He specializes in interventional cardiology and has performed over 5000 successful procedures. He is known for his compassionate approach and dedication to patient care.",
    languages: ["English", "Hindi", "Punjabi"],
    awards: [
      "Best Cardiologist Award 2023",
      "Excellence in Healthcare 2022",
      "Padma Shri Nominee 2021",
    ],
    education: [
      "MBBS - AIIMS Delhi (2005)",
      "MD Cardiology - AIIMS Delhi (2008)",
      "Fellowship in Interventional Cardiology - Harvard Medical School (2010)",
    ],
    services: [
      "Heart Disease Treatment",
      "Angioplasty",
      "Pacemaker Implantation",
      "ECG & Echo",
      "Cardiac Rehabilitation",
    ],
    availability: _Availability(
      days: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"],
      startTime: "09:00 AM",
      endTime: "06:00 PM",
      slotDuration: 30,
    ),
    stats: _DoctorStats(
      totalPatients: 5420,
      totalAppointments: 8934,
      successRate: 98,
      waitingTime: 15,
    ),
  );

  final List<_Review> _reviews = [
    _Review(
      patientName: "Priya Patel",
      rating: 5.0,
      date: DateTime.now().subtract(const Duration(days: 2)),
      comment:
      "Excellent doctor! Very patient and explains everything clearly. Highly recommended.",
      helpful: 24,
    ),
    _Review(
      patientName: "Rajesh Kumar",
      rating: 4.5,
      date: DateTime.now().subtract(const Duration(days: 5)),
      comment:
      "Good experience. The doctor is very knowledgeable and caring.",
      helpful: 18,
    ),
    _Review(
      patientName: "Sneha Reddy",
      rating: 5.0,
      date: DateTime.now().subtract(const Duration(days: 8)),
      comment:
      "Dr. Sharma saved my father's life. Forever grateful for his expertise and care.",
      helpful: 42,
    ),
    _Review(
      patientName: "Vikram Singh",
      rating: 4.0,
      date: DateTime.now().subtract(const Duration(days: 12)),
      comment: "Professional and efficient. Wait time was a bit long though.",
      helpful: 12,
    ),
  ];

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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          _buildAppBar(isDarkMode),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildDoctorHeader(isDarkMode),
                _buildQuickStats(isDarkMode),
                _buildTabBar(isDarkMode),
                _buildTabContent(isDarkMode),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(isDarkMode),
    );
  }

  Widget _buildAppBar(bool isDarkMode) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : null,
          ),
          onPressed: () {
            setState(() {
              _isFavorite = !_isFavorite;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDoctorHeader(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.grey[850]!, Colors.grey[900]!]
              : [Colors.white, Colors.grey[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Avatar
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withValues(alpha: 0.2),
                      Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    ],
                  ),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDarkMode ? Colors.grey[850]! : Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Doctor Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _doctor.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    _doctor.specialization,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _doctor.qualification,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 18,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _doctor.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${_doctor.totalReviews} reviews)',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.work_outline,
                      size: 16,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_doctor.experience} years experience',
                      style: TextStyle(
                        fontSize: 13,
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

  Widget _buildQuickStats(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Patients',
              _doctor.stats.totalPatients.toString(),
              Icons.people,
              Colors.blue,
              isDarkMode,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Success',
              '${_doctor.stats.successRate}%',
              Icons.check_circle,
              Colors.green,
              isDarkMode,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Wait Time',
              '${_doctor.stats.waitingTime} min',
              Icons.access_time,
              Colors.orange,
              isDarkMode,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label,
      String value,
      IconData icon,
      Color color,
      bool isDarkMode,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.grey[850]!, Colors.grey[900]!]
              : [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : color.withValues(alpha: 0.2),
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
              color: isDarkMode ? Colors.white : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: isDarkMode ? Colors.grey[500] : Colors.grey[600],
        indicatorColor: Theme.of(context).primaryColor,
        indicatorWeight: 3,
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        tabs: const [
          Tab(text: 'About'),
          Tab(text: 'Reviews'),
          Tab(text: 'Availability'),
          Tab(text: 'Contact'),
        ],
      ),
    );
  }

  Widget _buildTabContent(bool isDarkMode) {
    return SizedBox(
      height: 500,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildAboutTab(isDarkMode),
          _buildReviewsTab(isDarkMode),
          _buildAvailabilityTab(isDarkMode),
          _buildContactTab(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildAboutTab(bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('About Doctor', isDarkMode),
          const SizedBox(height: 12),
          _buildInfoCard(
            _doctor.about,
            isDarkMode,
          ),
          const SizedBox(height: 24),

          _buildSectionTitle('Education', isDarkMode),
          const SizedBox(height: 12),
          ..._doctor.education.map((edu) => _buildListItem(
            edu,
            Icons.school,
            Colors.blue,
            isDarkMode,
          )),
          const SizedBox(height: 24),

          _buildSectionTitle('Services', isDarkMode),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _doctor.services
                .map((service) => _buildChip(service, isDarkMode))
                .toList(),
          ),
          const SizedBox(height: 24),

          _buildSectionTitle('Languages', isDarkMode),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _doctor.languages
                .map((lang) => _buildChip(lang, isDarkMode))
                .toList(),
          ),
          const SizedBox(height: 24),

          _buildSectionTitle('Awards & Recognition', isDarkMode),
          const SizedBox(height: 12),
          ..._doctor.awards.map((award) => _buildListItem(
            award,
            Icons.emoji_events,
            Colors.amber,
            isDarkMode,
          )),
        ],
      ),
    );
  }

  Widget _buildReviewsTab(bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [Colors.grey[850]!, Colors.grey[900]!]
                    : [
                  Colors.amber.withValues(alpha: 0.1),
                  Colors.amber.withValues(alpha: 0.05)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode
                    ? Colors.grey[700]!
                    : Colors.amber.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      _doctor.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                            (index) => Icon(
                          index < _doctor.rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_doctor.totalReviews} reviews',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 32),
                Expanded(
                  child: Column(
                    children: [
                      _buildRatingBar(5, 220, isDarkMode),
                      _buildRatingBar(4, 85, isDarkMode),
                      _buildRatingBar(3, 25, isDarkMode),
                      _buildRatingBar(2, 8, isDarkMode),
                      _buildRatingBar(1, 4, isDarkMode),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          _buildSectionTitle('Patient Reviews', isDarkMode),
          const SizedBox(height: 16),

          // Reviews List
          ..._reviews.map((review) => _buildReviewCard(review, isDarkMode)),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, int count, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$stars',
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 12, color: Colors.amber),
          const SizedBox(width: 8),
          Expanded(
            child: LinearProgressIndicator(
              value: count / _doctor.totalReviews,
              backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 11,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(_Review review, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(14),
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
                radius: 20,
                backgroundColor:
                Theme.of(context).primaryColor.withValues(alpha: 0.1),
                child: Text(
                  review.patientName[0],
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
                      review.patientName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('MMM d, yyyy').format(review.date),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    review.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.thumb_up_outlined,
                size: 16,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                'Helpful (${review.helpful})',
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityTab(bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Working Days', isDarkMode),
          const SizedBox(height: 12),
          _buildInfoCard(
            _doctor.availability.days.join(', '),
            isDarkMode,
          ),
          const SizedBox(height: 24),

          _buildSectionTitle('Working Hours', isDarkMode),
          const SizedBox(height: 12),
          _buildInfoCard(
            '${_doctor.availability.startTime} - ${_doctor.availability.endTime}',
            isDarkMode,
          ),
          const SizedBox(height: 24),

          _buildSectionTitle('Slot Duration', isDarkMode),
          const SizedBox(height: 12),
          _buildInfoCard(
            '${_doctor.availability.slotDuration} minutes per consultation',
            isDarkMode,
          ),
          const SizedBox(height: 24),

          _buildSectionTitle('Hospital Location', isDarkMode),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.local_hospital,
                        color: Colors.blue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _doctor.hospital,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _doctor.address,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Open map
                  },
                  icon: const Icon(Icons.directions, size: 18),
                  label: const Text('Get Directions'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTab(bool isDarkMode) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContactCard(
            'Phone',
            _doctor.phone,
            Icons.phone,
            Colors.green,
            isDarkMode,
            onTap: () {
              // TODO: Make phone call
            },
          ),
          const SizedBox(height: 16),
          _buildContactCard(
            'Email',
            _doctor.email,
            Icons.email,
            Colors.blue,
            isDarkMode,
            onTap: () {
              // TODO: Send email
            },
          ),
          const SizedBox(height: 16),
          _buildContactCard(
            'Hospital',
            _doctor.hospital,
            Icons.local_hospital,
            Colors.purple,
            isDarkMode,
            onTap: () {
              // TODO: View hospital details
            },
          ),
          const SizedBox(height: 16),
          _buildContactCard(
            'Address',
            _doctor.address,
            Icons.location_on,
            Colors.red,
            isDarkMode,
            onTap: () {
              // TODO: Open map
            },
          ),
          const SizedBox(height: 32),

          _buildSectionTitle('Quick Actions', isDarkMode),
          const SizedBox(height: 16),

          _buildActionButton(
            'Schedule Video Consultation',
            Icons.videocam,
            Colors.blue,
            isDarkMode,
            onTap: () {
              // TODO: Video consultation
            },
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            'Send Message',
            Icons.message,
            Colors.green,
            isDarkMode,
            onTap: () {
              // TODO: Send message
            },
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            'View Medical Records',
            Icons.description,
            Colors.orange,
            isDarkMode,
            onTap: () {
              // TODO: View records
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
      String label,
      String value,
      IconData icon,
      Color color,
      bool isDarkMode, {
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
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
              child: Icon(icon, color: color, size: 24),
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
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String label,
      IconData icon,
      Color color,
      bool isDarkMode, {
        required VoidCallback onTap,
      }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildInfoCard(String text, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildListItem(
      String text,
      IconData icon,
      Color color,
      bool isDarkMode,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.grey[800]
            : Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDarkMode
              ? Colors.grey[700]!
              : Theme.of(context).primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDarkMode
              ? Colors.grey[300]
              : Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildBottomBar(bool isDarkMode) {
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
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Consultation Fee',
                style: TextStyle(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₹${_doctor.consultationFee}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: Book appointment
                _showBookingDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Book Appointment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Book Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Doctor: ${_doctor.name}'),
            const SizedBox(height: 8),
            Text('Specialization: ${_doctor.specialization}'),
            const SizedBox(height: 8),
            Text('Fee: ₹${_doctor.consultationFee}'),
            const SizedBox(height: 16),
            const Text(
              'Would you like to proceed with booking?',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Navigate to booking screen
            },
            child: const Text('Proceed'),
          ),
        ],
      ),
    );
  }
}

// Data Models
class _Doctor {
  final String id;
  final String name;
  final String specialization;
  final String qualification;
  final int experience;
  final double rating;
  final int totalReviews;
  final int consultationFee;
  final String hospital;
  final String address;
  final String phone;
  final String email;
  final String about;
  final List<String> languages;
  final List<String> awards;
  final List<String> education;
  final List<String> services;
  final _Availability availability;
  final _DoctorStats stats;

  _Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.qualification,
    required this.experience,
    required this.rating,
    required this.totalReviews,
    required this.consultationFee,
    required this.hospital,
    required this.address,
    required this.phone,
    required this.email,
    required this.about,
    required this.languages,
    required this.awards,
    required this.education,
    required this.services,
    required this.availability,
    required this.stats,
  });
}

class _Availability {
  final List<String> days;
  final String startTime;
  final String endTime;
  final int slotDuration;

  _Availability({
    required this.days,
    required this.startTime,
    required this.endTime,
    required this.slotDuration,
  });
}

class _DoctorStats {
  final int totalPatients;
  final int totalAppointments;
  final int successRate;
  final int waitingTime;

  _DoctorStats({
    required this.totalPatients,
    required this.totalAppointments,
    required this.successRate,
    required this.waitingTime,
  });
}

class _Review {
  final String patientName;
  final double rating;
  final DateTime date;
  final String comment;
  final int helpful;

  _Review({
    required this.patientName,
    required this.rating,
    required this.date,
    required this.comment,
    required this.helpful,
  });
}