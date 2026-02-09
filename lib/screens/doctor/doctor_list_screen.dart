import 'package:flutter/material.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({super.key});

  @override
  State<DoctorListScreen> createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  String _selectedFilter = "All";
  String _selectedSort = "Rating";
  bool _isGridView = false;
  final Set<String> _favorites = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 650;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Find Doctors",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            tooltip: _isGridView ? "List View" : "Grid View",
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context, isDarkMode);
            },
            tooltip: "Filter & Sort",
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            color: isDarkMode ? Colors.grey[900] : Colors.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor:
              isDarkMode ? Colors.grey[400] : Colors.grey[600],
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: "All Doctors"),
                Tab(text: "Available"),
                Tab(text: "Favorites"),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Search and Quick Filters
          _buildSearchAndFilters(isDarkMode),

          // Doctor List/Grid
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDoctorList(context, "All", isMobile, isDarkMode),
                _buildDoctorList(context, "Available", isMobile, isDarkMode),
                _buildDoctorList(context, "Favorites", isMobile, isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(bool isDarkMode) {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: "Search by name, specialization, or hospital...",
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  setState(() {});
                },
              )
                  : null,
              filled: true,
              fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),

        // Specialization Quick Filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildQuickFilterChip("All", Icons.grid_view, isDarkMode),
              const SizedBox(width: 8),
              _buildQuickFilterChip("Cardiology", Icons.favorite, isDarkMode),
              const SizedBox(width: 8),
              _buildQuickFilterChip("Orthopedic", Icons.accessibility_new, isDarkMode),
              const SizedBox(width: 8),
              _buildQuickFilterChip("Pediatrics", Icons.child_care, isDarkMode),
              const SizedBox(width: 8),
              _buildQuickFilterChip("Neurology", Icons.psychology, isDarkMode),
              const SizedBox(width: 8),
              _buildQuickFilterChip("Dentistry", Icons.sentiment_satisfied, isDarkMode),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildQuickFilterChip(String label, IconData icon, bool isDarkMode) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? label : "All";
        });
      },
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 13,
        color: isSelected
            ? Theme.of(context).primaryColor
            : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
      ),
    );
  }

  Widget _buildDoctorList(
      BuildContext context, String filter, bool isMobile, bool isDarkMode) {
    final doctors = _getDoctors(filter);

    if (doctors.isEmpty) {
      return _buildEmptyState(context, filter, isDarkMode);
    }

    if (_isGridView && !isMobile) {
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 2 : 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return _buildDoctorGridCard(context, doctors[index], isDarkMode);
        },
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Implement refresh logic
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: doctors.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _buildDoctorCard(context, doctors[index], isDarkMode);
        },
      ),
    );
  }

  Widget _buildDoctorCard(
      BuildContext context, _DoctorData doctor, bool isDarkMode) {
    final isFavorite = _favorites.contains(doctor.id);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        // TODO: Navigate to DoctorDetailsScreen
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDoctorAvatar(doctor, isDarkMode),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDoctorHeader(doctor, isFavorite, isDarkMode),
                  const SizedBox(height: 8),
                  _buildDoctorInfo(doctor, isDarkMode),
                  const SizedBox(height: 12),
                  _buildDoctorStats(doctor, isDarkMode),
                  const SizedBox(height: 12),
                  _buildActionButtons(doctor, isDarkMode),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorGridCard(
      BuildContext context, _DoctorData doctor, bool isDarkMode) {
    final isFavorite = _favorites.contains(doctor.id);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        // TODO: Navigate to DoctorDetailsScreen
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
          ),
        ),
        child: Column(
          children: [
            // Avatar with favorite button
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: doctor.color.withValues(alpha: 0.1),
                    border: Border.all(
                      color: doctor.color,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    color: doctor.color,
                    size: 40,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (isFavorite) {
                          _favorites.remove(doctor.id);
                        } else {
                          _favorites.add(doctor.id);
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[850] : Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Doctor Name
            Text(
              doctor.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Specialization
            Text(
              doctor.specialization,
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  "${doctor.rating}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  " (${doctor.reviews})",
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Availability
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: doctor.isAvailable
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                doctor.isAvailable ? "Available" : "Busy",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: doctor.isAvailable ? Colors.green : Colors.red,
                ),
              ),
            ),
            const Spacer(),

            // Book Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to booking
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Book",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorAvatar(_DoctorData doctor, bool isDarkMode) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: doctor.color.withValues(alpha: 0.1),
        border: Border.all(
          color: doctor.color,
          width: 2,
        ),
      ),
      child: Icon(
        Icons.person,
        color: doctor.color,
        size: 40,
      ),
    );
  }

  Widget _buildDoctorHeader(
      _DoctorData doctor, bool isFavorite, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                doctor.specialization,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              if (isFavorite) {
                _favorites.remove(doctor.id);
              } else {
                _favorites.add(doctor.id);
              }
            });
          },
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorInfo(_DoctorData doctor, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.business,
              size: 16,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                doctor.hospital,
                style: TextStyle(
                  fontSize: 13,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
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
            Icon(
              Icons.school,
              size: 16,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            Text(
              doctor.qualification,
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDoctorStats(_DoctorData doctor, bool isDarkMode) {
    return Row(
      children: [
        _buildStatChip(
          Icons.star,
          "${doctor.rating}",
          Colors.amber,
          isDarkMode,
        ),
        const SizedBox(width: 8),
        _buildStatChip(
          Icons.people,
          "${doctor.patients}+ patients",
          Colors.blue,
          isDarkMode,
        ),
        const SizedBox(width: 8),
        _buildStatChip(
          Icons.timeline,
          "${doctor.experience} years",
          Colors.green,
          isDarkMode,
        ),
      ],
    );
  }

  Widget _buildStatChip(
      IconData icon, String label, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(_DoctorData doctor, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: View profile
            },
            icon: const Icon(Icons.visibility, size: 18),
            label: const Text("View Profile"),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Book appointment
            },
            icon: const Icon(Icons.calendar_today, size: 18),
            label: const Text("Book"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, String filter, bool isDarkMode) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey[800]
                    : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                filter == "Favorites"
                    ? Icons.favorite_border
                    : Icons.medical_services_outlined,
                size: 80,
                color: isDarkMode
                    ? Colors.grey[600]
                    : Theme.of(context).primaryColor.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              filter == "Favorites"
                  ? "No Favorite Doctors"
                  : "No Doctors Found",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              filter == "Favorites"
                  ? "Add doctors to your favorites for quick access"
                  : "Try adjusting your search or filters",
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Filter & Sort",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sort Section
                  Text(
                    "Sort By",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ["Rating", "Experience", "Price", "Name"].map((sort) {
                      final isSelected = _selectedSort == sort;
                      return ChoiceChip(
                        label: Text(sort),
                        selected: isSelected,
                        onSelected: (selected) {
                          setModalState(() {
                            _selectedSort = sort;
                          });
                          setState(() {
                            _selectedSort = sort;
                          });
                        },
                        selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Filter Section
                  Text(
                    "Filters",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFilterChipModal("Available Now", Icons.check_circle, setModalState),
                      _buildFilterChipModal("Top Rated", Icons.star, setModalState),
                      _buildFilterChipModal("Verified", Icons.verified, setModalState),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _selectedFilter = "All";
                              _selectedSort = "Rating";
                            });
                            Navigator.pop(context);
                          },
                          child: const Text("Reset"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: const Text("Apply"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChipModal(
      String label, IconData icon, StateSetter setModalState) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setModalState(() {
          _selectedFilter = selected ? label : "All";
        });
        setState(() {
          _selectedFilter = selected ? label : "All";
        });
      },
      selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
      checkmarkColor: Theme.of(context).primaryColor,
    );
  }

  List<_DoctorData> _getDoctors(String filter) {
    final allDoctors = [
      _DoctorData(
        id: "1",
        name: "Dr. Sarah Johnson",
        specialization: "Cardiologist",
        hospital: "City General Hospital",
        qualification: "MBBS, MD",
        experience: 15,
        rating: 4.9,
        reviews: 234,
        patients: 500,
        fee: 150,
        isAvailable: true,
        color: Colors.blue,
      ),
      _DoctorData(
        id: "2",
        name: "Dr. Michael Brown",
        specialization: "Orthopedic Surgeon",
        hospital: "Apollo Clinic",
        qualification: "MBBS, MS",
        experience: 12,
        rating: 4.8,
        reviews: 189,
        patients: 450,
        fee: 180,
        isAvailable: true,
        color: Colors.green,
      ),
      _DoctorData(
        id: "3",
        name: "Dr. Emily Davis",
        specialization: "Pediatrician",
        hospital: "Sunshine Medical Center",
        qualification: "MBBS, DCH",
        experience: 10,
        rating: 4.7,
        reviews: 156,
        patients: 600,
        fee: 120,
        isAvailable: false,
        color: Colors.orange,
      ),
      _DoctorData(
        id: "4",
        name: "Dr. Robert Wilson",
        specialization: "Neurologist",
        hospital: "Max Healthcare",
        qualification: "MBBS, DM",
        experience: 20,
        rating: 4.9,
        reviews: 298,
        patients: 800,
        fee: 200,
        isAvailable: true,
        color: Colors.purple,
      ),
      _DoctorData(
        id: "5",
        name: "Dr. Jennifer Lee",
        specialization: "Dermatologist",
        hospital: "City General Hospital",
        qualification: "MBBS, MD",
        experience: 8,
        rating: 4.6,
        reviews: 142,
        patients: 350,
        fee: 100,
        isAvailable: true,
        color: Colors.pink,
      ),
      _DoctorData(
        id: "6",
        name: "Dr. David Martinez",
        specialization: "Dentist",
        hospital: "Care & Cure Clinic",
        qualification: "BDS, MDS",
        experience: 14,
        rating: 4.8,
        reviews: 201,
        patients: 550,
        fee: 80,
        isAvailable: false,
        color: Colors.teal,
      ),
      _DoctorData(
        id: "7",
        name: "Dr. Amanda Taylor",
        specialization: "Gynecologist",
        hospital: "Apollo Clinic",
        qualification: "MBBS, MS",
        experience: 16,
        rating: 4.9,
        reviews: 267,
        patients: 700,
        fee: 140,
        isAvailable: true,
        color: Colors.indigo,
      ),
      _DoctorData(
        id: "8",
        name: "Dr. James Anderson",
        specialization: "General Physician",
        hospital: "HealthFirst Hospital",
        qualification: "MBBS",
        experience: 18,
        rating: 4.7,
        reviews: 324,
        patients: 900,
        fee: 60,
        isAvailable: true,
        color: Colors.cyan,
      ),
    ];

    if (filter == "Favorites") {
      return allDoctors.where((d) => _favorites.contains(d.id)).toList();
    } else if (filter == "Available") {
      return allDoctors.where((d) => d.isAvailable).toList();
    }
    return allDoctors;
  }
}

// Helper class
class _DoctorData {
  final String id;
  final String name;
  final String specialization;
  final String hospital;
  final String qualification;
  final int experience;
  final double rating;
  final int reviews;
  final int patients;
  final int fee;
  final bool isAvailable;
  final Color color;

  _DoctorData({
    required this.id,
    required this.name,
    required this.specialization,
    required this.hospital,
    required this.qualification,
    required this.experience,
    required this.rating,
    required this.reviews,
    required this.patients,
    required this.fee,
    required this.isAvailable,
    required this.color,
  });
}