import 'package:flutter/material.dart';
import 'package:med_connect/models/user/doctor_model.dart';
import 'package:provider/provider.dart';

import '../../providers/doctor_provider.dart';
import 'doctor_detail_screen.dart';

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
  final Set<String> _favorites = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadDoctors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctors() async {
    final doctorProvider = context.read<DoctorProvider>();
    await doctorProvider.loadDoctors(null);
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
              unselectedLabelColor: isDarkMode
                  ? Colors.grey[400]
                  : Colors.grey[600],
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
              _buildQuickFilterChip(
                "Orthopedic",
                Icons.accessibility_new,
                isDarkMode,
              ),
              const SizedBox(width: 8),
              _buildQuickFilterChip("Pediatrics", Icons.child_care, isDarkMode),
              const SizedBox(width: 8),
              _buildQuickFilterChip("Neurology", Icons.psychology, isDarkMode),
              const SizedBox(width: 8),
              _buildQuickFilterChip(
                "Dentistry",
                Icons.sentiment_satisfied,
                isDarkMode,
              ),
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
        children: [Icon(icon, size: 16), const SizedBox(width: 6), Text(label)],
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
    BuildContext context,
    String filter,
    bool isMobile,
    bool isDarkMode,
  ) {
    final doctorProvider = Provider.of<DoctorProvider>(context);
    final doctors = doctorProvider.doctors;

    if (doctorProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (doctorProvider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              doctorProvider.errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadDoctors,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (doctors.isEmpty) {
      return const Center(child: Text("No doctors found"));
    }

    return RefreshIndicator(
      onRefresh: () async {
        await _loadDoctors();
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
    BuildContext context,
    DoctorModel doctor,
    bool isDarkMode,
  ) {
    final isFavorite = _favorites.contains(doctor.id);

    return Container(
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
    );
  }

  Widget _buildDoctorAvatar(DoctorModel doctor, bool isDarkMode) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Icon(Icons.person, color: Colors.green, size: 40),
    );
  }

  Widget _buildDoctorHeader(
    DoctorModel doctor,
    bool isFavorite,
    bool isDarkMode,
  ) {
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
                doctor.specialization ?? "",
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
            /*setState(() {
              if (isFavorite) {
                _favorites.remove(doctor.id);
              } else {
                _favorites.add(doctor.id);
              }
            });*/
          },
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorInfo(DoctorModel doctor, bool isDarkMode) {
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
                doctor.hospitalAffiliation ?? "",
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
              doctor.qualification ?? "",
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

  Widget _buildDoctorStats(DoctorModel doctor, bool isDarkMode) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: [
        _buildStatChip(
          Icons.star,
          doctor.rating?.toString() ?? "0.0",
          Colors.amber,
          isDarkMode,
        ),
        _buildStatChip(
          Icons.people,
          "${doctor.consultationFee}+ patients",
          Colors.blue,
          isDarkMode,
        ),
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
    IconData icon,
    String label,
    Color color,
    bool isDarkMode,
  ) {
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

  Widget _buildActionButtons(DoctorModel doctor, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorDetailScreen(doctorId: doctor.id),
                ),
              );
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
                    children: ["Rating", "Experience", "Price", "Name"].map((
                      sort,
                    ) {
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
                        selectedColor: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.2),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : (isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600]),
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
                      _buildFilterChipModal(
                        "Available Now",
                        Icons.check_circle,
                        setModalState,
                      ),
                      _buildFilterChipModal(
                        "Top Rated",
                        Icons.star,
                        setModalState,
                      ),
                      _buildFilterChipModal(
                        "Verified",
                        Icons.verified,
                        setModalState,
                      ),
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
    String label,
    IconData icon,
    StateSetter setModalState,
  ) {
    final isSelected = _selectedFilter == label;
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 16), const SizedBox(width: 6), Text(label)],
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
}
