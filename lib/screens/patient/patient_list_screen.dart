import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:med_connect/models/user/patient_model.dart';
import 'package:med_connect/providers/patient_provider.dart';
import 'package:med_connect/providers/authentication_provider.dart';
import 'package:med_connect/screens/patient/patient_detail_screen.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  String _searchQuery = '';
  String _selectedSort = 'Name';
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPatients();
    });
  }

  void _loadPatients() {
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    final patientProvider = Provider.of<PatientProvider>(context, listen: false);

    final hospitalId = authProvider.hospital?.id;

    if (hospitalId != null) {
      patientProvider.fetchPatientsByHospital(hospitalId);
    } else {
      patientProvider.fetchAllPatients();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // ✅ Get filtered patients based on search and sort
  List<PatientModel> _getFilteredPatients(PatientProvider provider) {
    var patients = _searchQuery.isEmpty
        ? provider.patients
        : provider.searchPatients(_searchQuery);

    return provider.sortPatients(patients, _selectedSort);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Patients",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortSheet(context, isDarkMode),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: _buildTabBar(isDarkMode),
        ),
      ),
      // ✅ Use Consumer for reactive UI
      body: Consumer<PatientProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return _buildErrorState(provider.error!, isDarkMode);
          }

          final filteredPatients = _getFilteredPatients(provider);

          return Column(
            children: [
              _buildSearchBar(isDarkMode),
              _buildStatsCards(isDarkMode, provider),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPatientList(filteredPatients, isDarkMode, provider),
                    _buildPatientList(
                      provider.sortPatients(
                        _searchQuery.isEmpty
                            ? provider.activePatients
                            : provider.searchPatients(_searchQuery).where((p) => p.isActive ?? false).toList(),
                        _selectedSort,
                      ),
                      isDarkMode,
                      provider,
                    ),
                    _buildPatientList(
                      provider.sortPatients(
                        _searchQuery.isEmpty
                            ? provider.inactivePatients
                            : provider.searchPatients(_searchQuery).where((p) => !(p.isActive ?? true)).toList(),
                        _selectedSort,
                      ),
                      isDarkMode,
                      provider,
                    ),
                    _buildPatientList(
                      provider.sortPatients(
                        _searchQuery.isEmpty
                            ? provider.criticalPatients
                            : [],
                        _selectedSort,
                      ),
                      isDarkMode,
                      provider,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabBar(bool isDarkMode) {
    return Container(
      color: isDarkMode ? Colors.grey[900] : Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: Theme.of(context).primaryColor,
        indicatorWeight: 3,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: "All"),
          Tab(text: "Active"),
          Tab(text: "Inactive"),
          Tab(text: "Critical"),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search patients by name, email, or phone...",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
              });
            },
          )
              : null,
          filled: true,
          fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  // ✅ Real stats from provider
  Widget _buildStatsCards(bool isDarkMode, PatientProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              "Total",
              provider.totalPatients.toString(),
              Icons.people,
              Colors.blue,
              isDarkMode,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              "Active",
              provider.activeCount.toString(),
              Icons.check_circle,
              Colors.green,
              isDarkMode,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              "Inactive",
              provider.inactiveCount.toString(),
              Icons.circle_outlined,
              Colors.grey,
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientList(
      List<PatientModel> patients,
      bool isDarkMode,
      PatientProvider provider,
      ) {
    if (patients.isEmpty) {
      return _buildEmptyState(
        isDarkMode,
        _searchQuery.isNotEmpty
            ? "No patients found"
            : "No patients yet",
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadPatients();
      },
      child: _isGridView
          ? _buildGridView(patients, isDarkMode)
          : _buildListView(patients, isDarkMode),
    );
  }

  Widget _buildListView(List<PatientModel> patients, bool isDarkMode) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: patients.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildPatientCard(
            context,
            patients[index],
            isDarkMode,
          ),
        );
      },
    );
  }

  Widget _buildGridView(List<PatientModel> patients, bool isDarkMode) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: patients.length,
      itemBuilder: (context, index) {
        return _buildPatientGridCard(
          context,
          patients[index],
          isDarkMode,
        );
      },
    );
  }

  // ✅ Patient card with real PatientModel data
  Widget _buildPatientCard(
      BuildContext context,
      PatientModel patient,
      bool isDarkMode,
      ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientDetailScreen(patient: patient),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
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
            // Avatar
            CircleAvatar(
              radius: 30,
              backgroundImage: patient.profilePicture != null &&
                  patient.profilePicture!.isNotEmpty
                  ? NetworkImage(patient.profilePicture!)
                  : null,
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              child: patient.profilePicture == null ||
                  patient.profilePicture!.isEmpty
                  ? Icon(
                Icons.person,
                size: 30,
                color: Theme.of(context).primaryColor,
              )
                  : null,
            ),
            const SizedBox(width: 16),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    patient.email ?? "",
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (patient.phoneNumber != null &&
                      patient.phoneNumber!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 14,
                          color:
                          isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          patient.phoneNumber!,
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Status badge
                      _buildStatusBadge(
                        patient.isActive ?? false ? 'Active' : 'Inactive',
                        patient.isActive ?? false,
                        isDarkMode,
                      ),
                      const SizedBox(width: 8),
                      // Gender badge
                      if (patient.gender != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.purple.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            patient.gender!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.purple,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow icon
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Grid card for grid view
  Widget _buildPatientGridCard(
      BuildContext context,
      PatientModel patient,
      bool isDarkMode,
      ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PatientDetailScreen(patient: patient),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 35,
              backgroundImage: patient.profilePicture != null &&
                  patient.profilePicture!.isNotEmpty
                  ? NetworkImage(patient.profilePicture!)
                  : null,
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              child: patient.profilePicture == null ||
                  patient.profilePicture!.isEmpty
                  ? Icon(
                Icons.person,
                size: 35,
                color: Theme.of(context).primaryColor,
              )
                  : null,
            ),
            const SizedBox(height: 12),

            // Name
            Text(
              patient.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Email
            Text(
              patient.email ?? "",
              style: TextStyle(
                fontSize: 11,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Status badge
            _buildStatusBadge(
              patient.isActive ?? false ? 'Active' : 'Inactive',
              patient.isActive ?? false,
              isDarkMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String text, bool isActive, bool isDarkMode) {
    final color = isActive ? Colors.green : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.circle_outlined,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
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

  Widget _buildEmptyState(bool isDarkMode, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? "Try a different search term"
                : "Patients will appear here",
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "Error Loading Patients",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _loadPatients,
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showSortSheet(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Sort By",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...['Name', 'Recent', 'Age'].map(
                  (sort) => RadioListTile<String>(
                title: Text(sort),
                value: sort,
                groupValue: _selectedSort,
                onChanged: (value) {
                  setState(() {
                    _selectedSort = value!;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}