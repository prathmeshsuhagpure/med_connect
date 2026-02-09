import 'package:flutter/material.dart';

class DoctorManagementScreen extends StatefulWidget {
  const DoctorManagementScreen({super.key});

  @override
  State<DoctorManagementScreen> createState() => _DoctorManagementScreenState();
}

class _DoctorManagementScreenState extends State<DoctorManagementScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  String _selectedFilter = "All";
  String _selectedSort = "Name";
  bool _isGridView = false;

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
          "Doctor Management",
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
            tooltip: "Filter",
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              _showSortBottomSheet(context, isDarkMode);
            },
            tooltip: "Sort",
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
                Tab(text: "All"),
                Tab(text: "Active"),
                Tab(text: "Inactive"),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to AddDoctorScreen
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Doctor"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          // Statistics Cards
          _buildStatisticsSection(context, isMobile, isDarkMode),

          // Search Bar
          _buildSearchBar(isDarkMode),

          // Doctor List/Grid
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDoctorList(context, "All", isMobile, isDarkMode),
                _buildDoctorList(context, "Active", isMobile, isDarkMode),
                _buildDoctorList(context, "Inactive", isMobile, isDarkMode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection(
      BuildContext context, bool isMobile, bool isDarkMode) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              "Total Doctors",
              "24",
              Icons.people,
              Colors.blue,
              isDarkMode,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              "Active",
              "20",
              Icons.check_circle,
              Colors.green,
              isDarkMode,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              "On Leave",
              "4",
              Icons.event_busy,
              Colors.orange,
              isDarkMode,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      Color color,
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
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          // TODO: Implement search logic
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: "Search by name, specialization, or department...",
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
          childAspectRatio: 0.85,
        ),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return _buildDoctorGridCard(context, doctors[index], isDarkMode);
        },
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: doctors.length,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        return _buildDoctorCard(context, doctors[index], isDarkMode);
      },
    );
  }

  Widget _buildDoctorCard(
      BuildContext context, _DoctorData doctor, bool isDarkMode) {
    return InkWell(
      onTap: () {
        _showDoctorDetails(context, doctor, isDarkMode);
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(18),
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
          children: [
            _buildDoctorAvatar(doctor, isDarkMode),
            const SizedBox(width: 14),
            Expanded(child: _buildDoctorInfo(doctor, isDarkMode)),
            _buildDoctorActions(context, doctor, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorGridCard(
      BuildContext context, _DoctorData doctor, bool isDarkMode) {
    return InkWell(
      onTap: () {
        _showDoctorDetails(context, doctor, isDarkMode);
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
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
                size: 35,
              ),
            ),
            const SizedBox(height: 12),
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
            Text(
              doctor.specialization,
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: doctor.isActive
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                doctor.isActive ? "Active" : "Inactive",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: doctor.isActive ? Colors.green : Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  doctor.rating.toString(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorAvatar(_DoctorData doctor, bool isDarkMode) {
    return Container(
      width: 60,
      height: 60,
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
        size: 28,
      ),
    );
  }

  Widget _buildDoctorInfo(_DoctorData doctor, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          doctor.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "${doctor.specialization} • ${doctor.department}",
          style: TextStyle(
            fontSize: 13,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              Icons.circle,
              size: 10,
              color: doctor.isActive ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 6),
            Text(
              doctor.isActive ? "Active" : "Inactive",
              style: TextStyle(
                fontSize: 12,
                color: doctor.isActive ? Colors.green : Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.star, size: 14, color: Colors.amber),
            const SizedBox(width: 4),
            Text(
              doctor.rating.toString(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDoctorActions(
      BuildContext context, _DoctorData doctor, bool isDarkMode) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          // TODO: Navigate to EditDoctorScreen
        } else if (value == 'toggle') {
          _toggleDoctorStatus(doctor);
        } else if (value == 'view') {
          _showDoctorDetails(context, doctor, isDarkMode);
        } else if (value == 'schedule') {
          // TODO: View doctor schedule
        } else if (value == 'delete') {
          _showDeleteConfirmation(context, doctor, isDarkMode);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              Icon(Icons.visibility, size: 18),
              SizedBox(width: 12),
              Text("View Details"),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, size: 18),
              SizedBox(width: 12),
              Text("Edit"),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'schedule',
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 18),
              SizedBox(width: 12),
              Text("View Schedule"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'toggle',
          child: Row(
            children: [
              Icon(
                doctor.isActive
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(doctor.isActive ? "Deactivate" : "Activate"),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, size: 18, color: Colors.red),
              SizedBox(width: 12),
              Text("Delete", style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      icon: Icon(
        Icons.more_vert,
        color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
      ),
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
                Icons.people_outline,
                size: 80,
                color: isDarkMode
                    ? Colors.grey[600]
                    : Theme.of(context).primaryColor.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              filter == "All"
                  ? "No Doctors Found"
                  : "No $filter Doctors",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Add doctors to get started",
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to AddDoctorScreen
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Doctor"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Filter Doctors",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildFilterOption("All Doctors", isDarkMode),
              _buildFilterOption("Active Only", isDarkMode),
              _buildFilterOption("Inactive Only", isDarkMode),
              _buildFilterOption("By Specialization", isDarkMode),
              _buildFilterOption("By Department", isDarkMode),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
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
  }

  Widget _buildFilterOption(String label, bool isDarkMode) {
    final isSelected = _selectedFilter == label;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSortBottomSheet(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sort By",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildSortOption("Name", isDarkMode),
              _buildSortOption("Specialization", isDarkMode),
              _buildSortOption("Experience", isDarkMode),
              _buildSortOption("Rating", isDarkMode),
              _buildSortOption("Recently Added", isDarkMode),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String label, bool isDarkMode) {
    final isSelected = _selectedSort == label;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedSort = label;
        });
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDoctorDetails(
      BuildContext context, _DoctorData doctor, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: doctor.color.withValues(alpha: 0.1),
                        border: Border.all(color: doctor.color, width: 3),
                      ),
                      child: Icon(
                        Icons.person,
                        color: doctor.color,
                        size: 50,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      doctor.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      doctor.specialization,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow(Icons.business, "Department", doctor.department, isDarkMode),
                  _buildDetailRow(Icons.email, "Email", doctor.email, isDarkMode),
                  _buildDetailRow(Icons.phone, "Phone", doctor.phone, isDarkMode),
                  _buildDetailRow(Icons.school, "Qualification", doctor.qualification, isDarkMode),
                  _buildDetailRow(Icons.timeline, "Experience", "${doctor.experience} years", isDarkMode),
                  _buildDetailRow(Icons.attach_money, "Consultation Fee", "\$${doctor.fee}", isDarkMode),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            // TODO: Edit doctor
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            // TODO: View schedule
                          },
                          icon: const Icon(Icons.calendar_today),
                          label: const Text("Schedule"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
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

  Widget _buildDetailRow(IconData icon, String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
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
                    color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleDoctorStatus(_DoctorData doctor) {
    setState(() {
      doctor.isActive = !doctor.isActive;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${doctor.name} is now ${doctor.isActive ? 'active' : 'inactive'}",
        ),
        backgroundColor: doctor.isActive ? Colors.green : Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, _DoctorData doctor, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.delete, color: Colors.red),
              ),
              const SizedBox(width: 16),
              const Expanded(child: Text("Delete Doctor")),
            ],
          ),
          content: Text(
            "Are you sure you want to delete ${doctor.name}? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Delete doctor
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${doctor.name} deleted successfully"),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  List<_DoctorData> _getDoctors(String filter) {
    // Sample data
    final allDoctors = [
      _DoctorData(
        name: "Dr. Amit Verma",
        specialization: "Cardiologist",
        department: "OPD",
        email: "amit.verma@hospital.com",
        phone: "+1 234 567 8901",
        qualification: "MBBS, MD",
        experience: 15,
        fee: 150,
        rating: 4.8,
        isActive: true,
        color: Colors.blue,
      ),
      _DoctorData(
        name: "Dr. Priya Sharma",
        specialization: "Pediatrician",
        department: "OPD",
        email: "priya.sharma@hospital.com",
        phone: "+1 234 567 8902",
        qualification: "MBBS, DCH",
        experience: 12,
        fee: 120,
        rating: 4.9,
        isActive: true,
        color: Colors.green,
      ),
      _DoctorData(
        name: "Dr. Rajesh Kumar",
        specialization: "Orthopedic",
        department: "Surgery",
        email: "rajesh.kumar@hospital.com",
        phone: "+1 234 567 8903",
        qualification: "MBBS, MS",
        experience: 18,
        fee: 180,
        rating: 4.7,
        isActive: false,
        color: Colors.orange,
      ),
      _DoctorData(
        name: "Dr. Sneha Patel",
        specialization: "Dermatologist",
        department: "OPD",
        email: "sneha.patel@hospital.com",
        phone: "+1 234 567 8904",
        qualification: "MBBS, MD",
        experience: 10,
        fee: 100,
        rating: 4.6,
        isActive: true,
        color: Colors.purple,
      ),
      _DoctorData(
        name: "Dr. Vikram Singh",
        specialization: "Neurologist",
        department: "ICU",
        email: "vikram.singh@hospital.com",
        phone: "+1 234 567 8905",
        qualification: "MBBS, DM",
        experience: 20,
        fee: 200,
        rating: 4.9,
        isActive: true,
        color: Colors.teal,
      ),
      _DoctorData(
        name: "Dr. Anjali Desai",
        specialization: "Gynecologist",
        department: "OPD",
        email: "anjali.desai@hospital.com",
        phone: "+1 234 567 8906",
        qualification: "MBBS, MS",
        experience: 14,
        fee: 140,
        rating: 4.8,
        isActive: false,
        color: Colors.pink,
      ),
    ];

    if (filter == "Active") {
      return allDoctors.where((d) => d.isActive).toList();
    } else if (filter == "Inactive") {
      return allDoctors.where((d) => !d.isActive).toList();
    }
    return allDoctors;
  }
}

// Helper class
class _DoctorData {
  final String name;
  final String specialization;
  final String department;
  final String email;
  final String phone;
  final String qualification;
  final int experience;
  final int fee;
  final double rating;
  bool isActive;
  final Color color;

  _DoctorData({
    required this.name,
    required this.specialization,
    required this.department,
    required this.email,
    required this.phone,
    required this.qualification,
    required this.experience,
    required this.fee,
    required this.rating,
    required this.isActive,
    required this.color,
  });
}