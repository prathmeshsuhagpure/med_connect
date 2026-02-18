import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:med_connect/providers/hospital_provider.dart';
import '../../models/user/hospital_model.dart';
import '../appointments/book_appointment_screen.dart';
import 'hospital_detail_screen.dart';

class HospitalListScreen extends StatefulWidget {
  const HospitalListScreen({super.key});

  @override
  State<HospitalListScreen> createState() => _HospitalListScreenState();
}

class _HospitalListScreenState extends State<HospitalListScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  String _selectedFilter = "All";
  String _selectedSort = "Rating";
  bool _isMapView = false;
  final Set<String> _favorites = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHospitals();
    });
  }

  void _loadHospitals() async {
    final hospitalProvider = context.read<HospitalProvider>();
    await hospitalProvider.loadHospitals(limit: 50);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<HospitalModel> _getFilteredHospitals(HospitalProvider provider) {
    List<HospitalModel> hospitals = provider.hospitals;

    // Apply search
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      hospitals = hospitals.where((hospital) {
        return hospital.name.toLowerCase().contains(query) ||
            hospital.displayName.toLowerCase().contains(query) ||
            (hospital.city?.toLowerCase().contains(query) ?? false) ||
            (hospital.state?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply filters
    switch (_selectedFilter) {
      case "Emergency":
        hospitals = hospitals.where((h) => h.ambulanceService == true).toList();
        break;
      case "24/7":
        hospitals = hospitals.where((h) => h.is24x7 == true).toList();
        break;
      case "Verified":
        hospitals = hospitals.where((h) => h.isVerified == true).toList();
        break;
      case "Top Rated":
        hospitals = hospitals.where((h) => (h.rating ?? 0) >= 4.0).toList();
        break;
      case "Favorites":
        hospitals = hospitals.where((h) => _favorites.contains(h.id)).toList();
        break;
      default:
        // "All" - no additional filter
        break;
    }

    // Apply sorting
    switch (_selectedSort) {
      case "Rating":
        hospitals.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
        break;
      case "Name":
        hospitals.sort((a, b) => a.name.compareTo(b.name));
        break;
      case "Reviews":
        hospitals.sort(
          (a, b) => (b.totalReviews ?? 0).compareTo(a.totalReviews ?? 0),
        );
        break;
      // "Distance" would require location data
    }

    return hospitals;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 650;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Find Hospitals",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isMapView ? Icons.list : Icons.map),
            onPressed: () {
              setState(() {
                _isMapView = !_isMapView;
              });
            },
            tooltip: _isMapView ? "List View" : "Map View",
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context, isDarkMode);
            },
            tooltip: "Filter",
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
              onTap: (index) {
                setState(() {
                  if (index == 0) {
                    _selectedFilter = "All";
                  } else if (index == 1) {
                    // TODO: Load nearby hospitals when location is available
                    _selectedFilter = "All";
                  } else if (index == 2) {
                    _selectedFilter = "Favorites";
                  }
                });
              },
              tabs: const [
                Tab(text: "All"),
                Tab(text: "Nearby"),
                Tab(text: "Favorites"),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<HospitalProvider>(
        builder: (context, hospitalProvider, child) {
          if (hospitalProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              // Search and Quick Filters
              _buildSearchAndFilters(isDarkMode),

              // Content
              Expanded(
                child: _isMapView
                    ? _buildMapView(isDarkMode)
                    : _buildHospitalList(
                        context,
                        isMobile,
                        isDarkMode,
                        hospitalProvider,
                      ),
              ),
            ],
          );
        },
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
              hintText: "Search hospital, clinic, or location...",
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

        // Quick Filters
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildQuickFilterChip("All", Icons.grid_view, isDarkMode),
              const SizedBox(width: 8),
              _buildQuickFilterChip("Emergency", Icons.emergency, isDarkMode),
              const SizedBox(width: 8),
              _buildQuickFilterChip("24/7", Icons.access_time, isDarkMode),
              const SizedBox(width: 8),
              _buildQuickFilterChip("Verified", Icons.verified, isDarkMode),
              const SizedBox(width: 8),
              _buildQuickFilterChip("Top Rated", Icons.star, isDarkMode),
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
          // Update tab controller if needed
          if (_selectedFilter == "Favorites") {
            _tabController.animateTo(2);
          } else if (_selectedFilter == "All") {
            _tabController.animateTo(0);
          }
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

  Widget _buildHospitalList(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    HospitalProvider hospitalProvider,
  ) {
    final hospitals = _getFilteredHospitals(hospitalProvider);

    if (hospitals.isEmpty) {
      return _buildEmptyState(context, _selectedFilter, isDarkMode);
    }

    return RefreshIndicator(
      onRefresh: () async {
        await hospitalProvider.loadHospitals();
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: hospitals.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _buildHospitalCard(context, hospitals[index], isDarkMode);
        },
      ),
    );
  }

  Widget _buildHospitalCard(
    BuildContext context,
    HospitalModel hospital,
    bool isDarkMode,
  ) {
    final isFavorite = _favorites.contains(hospital.id);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HospitalDetailsScreen(hospitalId: hospital.id!),
          ),
        );
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHospitalHeader(hospital, isFavorite, isDarkMode),
            const SizedBox(height: 12),
            _buildHospitalInfo(hospital, isDarkMode),
            const SizedBox(height: 14),
            _buildSpecialties(hospital, isDarkMode),
            const SizedBox(height: 16),
            _buildActionButtons(hospital, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildHospitalHeader(
    HospitalModel hospital,
    bool isFavorite,
    bool isDarkMode,
  ) {
    return Row(
      children: [
        // Hospital Icon/Logo
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: hospital.logo != null && hospital.logo!.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    hospital.logo!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.local_hospital,
                        color: Theme.of(context).primaryColor,
                        size: 32,
                      );
                    },
                  ),
                )
              : Icon(
                  Icons.local_hospital,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
        ),
        const SizedBox(width: 14),

        // Hospital Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hospital.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    "${(hospital.rating ?? 0).toStringAsFixed(1)} (${hospital.totalReviews ?? 0} reviews)",
                    style: const TextStyle(fontSize: 13),
                  ),
                  if (hospital.isVerified == true) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.verified, color: Colors.blue, size: 16),
                  ],
                ],
              ),
            ],
          ),
        ),

        // Favorite Button
        IconButton(
          onPressed: () {
            setState(() {
              if (isFavorite) {
                _favorites.remove(hospital.id);
              } else {
                _favorites.add(hospital.id!);
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

  Widget _buildHospitalInfo(HospitalModel hospital, bool isDarkMode) {
    return Column(
      children: [
        // Location
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 18,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                "${hospital.address ?? 'N/A'}, ${hospital.city ?? 'N/A'}, ${hospital.state ?? 'N/A'}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Type and Additional Info
        Row(
          children: [
            _buildInfoChip(
              hospital.type ?? "Hospital",
              Theme.of(context).primaryColor,
              Icons.business,
            ),
            const SizedBox(width: 8),
            if (hospital.ambulanceService == true)
              _buildInfoChip("Emergency", Colors.red, Icons.emergency),
            if (hospital.is24x7 == true) ...[
              const SizedBox(width: 8),
              _buildInfoChip("24/7", Colors.blue, Icons.watch_later),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildInfoChip(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
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

  Widget _buildSpecialties(HospitalModel hospital, bool isDarkMode) {
    final departments = hospital.departments ?? [];

    if (departments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: departments.take(4).map((dept) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.grey[800]
                : Theme.of(context).primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            dept,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDarkMode
                  ? Colors.grey[400]
                  : Theme.of(context).primaryColor,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(HospitalModel hospital, bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.phone, size: 18),
            label: const Text("Call"),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
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
            icon: const Icon(Icons.calendar_today, size: 18),
            label: const Text("Book Appointment"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMapView(bool isDarkMode) {
    return Container(
      color: isDarkMode ? Colors.grey[850] : Colors.grey[200],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map,
              size: 80,
              color: isDarkMode ? Colors.grey[700] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "Map View",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Coming Soon",
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    String filter,
    bool isDarkMode,
  ) {
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
                    : Icons.local_hospital_outlined,
                size: 80,
                color: isDarkMode
                    ? Colors.grey[600]
                    : Theme.of(context).primaryColor.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              filter == "Favorites" ? "No Favorites Yet" : "No Hospitals Found",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              filter == "Favorites"
                  ? "Add hospitals to your favorites for quick access"
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
                    children: ["Rating", "Name", "Reviews"].map((sort) {
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
                        "Emergency",
                        Icons.emergency,
                        setModalState,
                      ),
                      _buildFilterChipModal(
                        "24/7",
                        Icons.watch_later,
                        setModalState,
                      ),
                      _buildFilterChipModal(
                        "Verified",
                        Icons.verified,
                        setModalState,
                      ),
                      _buildFilterChipModal(
                        "Top Rated",
                        Icons.star,
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
