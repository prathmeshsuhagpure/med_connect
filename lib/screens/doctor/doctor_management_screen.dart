import 'package:flutter/material.dart';
import 'package:med_connect/screens/doctor/add_doctor_screen.dart';
import 'package:provider/provider.dart';
import '../../models/user/doctor_model.dart';
import '../../providers/doctor_provider.dart';

class DoctorManagementScreen extends StatefulWidget {
  final String? hospitalId;
  final String? hospitalAffiliation;


  const DoctorManagementScreen(
      {super.key, this.hospitalId,  this.hospitalAffiliation});

  @override
  State<DoctorManagementScreen> createState() => _DoctorManagementScreenState();
}

class _DoctorManagementScreenState extends State<DoctorManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDoctors();
    });
  }

  void _loadDoctors() async {
    final doctorProvider = context.read<DoctorProvider>();

    if (widget.hospitalId != null) {
      await doctorProvider.loadDoctorsByHospital(widget.hospitalId!, null);
    } else {
      await doctorProvider.loadDoctors(null);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<DoctorModel> _getDisplayedDoctors(DoctorProvider provider) {
    List<DoctorModel> doctors = provider.doctors;

    // Apply availability filter
    if (_selectedFilter == "Available") {
      doctors = doctors.where((d) => d.isAvailable).toList();
    } else if (_selectedFilter == "Unavailable") {
      doctors = doctors.where((d) => !d.isAvailable).toList();
    }

    // Apply search
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      doctors = doctors.where((doctor) {
        return doctor.name.toLowerCase().contains(query) ||
            (doctor.specialization?.toLowerCase().contains(query) ?? false) ||
            (doctor.department?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    return doctors;
  }

  int _getTotalDoctors(DoctorProvider provider) {
    return provider.doctors.length;
  }

  int _getAvailableDoctors(DoctorProvider provider) {
    return provider.doctors
        .where((d) => d.isAvailable)
        .length;
  }

  int _getUnavailableDoctors(DoctorProvider provider) {
    return _getTotalDoctors(provider) - _getAvailableDoctors(provider);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final isMobile = screenWidth < 650;
    final isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.hospitalId != null ? "Hospital Doctors" : "Doctor Management",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddDoctorScreen(
                      hospitalId: widget.hospitalId, hospitalAffiliation: widget.hospitalAffiliation),
            ),
          ).then((_) => _loadDoctors());
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Doctor"),
        backgroundColor: Theme
            .of(context)
            .primaryColor,
      ),
      body: Consumer<DoctorProvider>(
        builder: (context, doctorProvider, child) {
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

          return Column(
            children: [
              _buildStatisticsSection(
                context,
                isMobile,
                isDarkMode,
                doctorProvider,
              ),
              const SizedBox(height: 8),
              _buildSearchBar(isDarkMode),
              const SizedBox(height: 8),
              Expanded(
                child: _buildDoctorList(
                  context,
                  isMobile,
                  isDarkMode,
                  doctorProvider,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatisticsSection(BuildContext context,
      bool isMobile,
      bool isDarkMode,
      DoctorProvider provider,) {
    final totalDoctors = _getTotalDoctors(provider);
    final availableDoctors = _getAvailableDoctors(provider);
    final unavailableDoctors = _getUnavailableDoctors(provider);

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              "Total Doctors",
              totalDoctors.toString(),
              Icons.people,
              Colors.blue,
              isDarkMode,
              isSelected: _selectedFilter == "All",
              onTap: () {
                setState(() => _selectedFilter = "All");
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              "Available",
              availableDoctors.toString(),
              Icons.check_circle,
              Colors.green,
              isDarkMode,
              isSelected: _selectedFilter == "Available",
              onTap: () {
                setState(() => _selectedFilter = "Available");
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              context,
              "Unavailable",
              unavailableDoctors.toString(),
              Icons.event_busy,
              Colors.orange,
              isDarkMode,
              isSelected: _selectedFilter == "Unavailable",
              onTap: () {
                setState(() => _selectedFilter = "Unavailable");
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context,
      String label,
      String value,
      IconData icon,
      Color color,
      bool isDarkMode, {
        bool isSelected = false,
        VoidCallback? onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : (isDarkMode ? Colors.grey[850] : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? color
                : (isDarkMode ? Colors.grey[700]! : Colors.grey[200]!),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (!isDarkMode && !isSelected)
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() {}),
        decoration: InputDecoration(
          hintText: "Search doctors...",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchController.clear();
              });
            },
          )
              : null,
          filled: true,
          fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme
                  .of(context)
                  .primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorList(BuildContext context,
      bool isMobile,
      bool isDarkMode,
      DoctorProvider provider,) {
    final displayedDoctors = _getDisplayedDoctors(provider);

    if (displayedDoctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 80,
              color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty
                  ? "No doctors found"
                  : "No doctors available",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: displayedDoctors.length,
      itemBuilder: (context, index) {
        final doctor = displayedDoctors[index];
        return _buildDoctorCard(context, doctor, isMobile, isDarkMode);
      },
    );
  }

  Widget _buildDoctorCard(BuildContext context,
      DoctorModel doctor,
      bool isMobile,
      bool isDarkMode,) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: isDarkMode ? 2 : 1,
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      child: InkWell(
        onTap: () => _showDoctorDetails(context, doctor, isDarkMode),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildDoctorAvatar(doctor, isDarkMode),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            doctor.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors
                                  .grey[800],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: doctor.isAvailable
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            doctor.isAvailable ? "Available" : "Unavailable",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: doctor.isAvailable
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.medical_services,
                          size: 14,
                          color: isDarkMode ? Colors.grey[500] : Colors
                              .grey[500],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            doctor.specialization ?? "N/A",
                            style: TextStyle(
                              fontSize: 13,
                              color: isDarkMode ? Colors.grey[400] : Colors
                                  .grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.business,
                          size: 14,
                          color: isDarkMode ? Colors.grey[500] : Colors
                              .grey[500],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            doctor.department ?? "N/A",
                            style: TextStyle(
                              fontSize: 13,
                              color: isDarkMode ? Colors.grey[400] : Colors
                                  .grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: isDarkMode ? Colors.grey[850] : Colors.white,
                onSelected: (value) async {
                  if (value == 'toggle') {
                    await _toggleDoctorStatus(doctor);
                  } else if (value == 'delete') {
                    _showDeleteConfirmation(context, doctor, isDarkMode);
                  }
                },
                itemBuilder: (context) =>
                [
                  PopupMenuItem(
                    value: 'toggle',
                    child: Row(
                      children: [
                        Icon(
                          doctor.isAvailable
                              ? Icons.event_busy
                              : Icons.check_circle,
                          size: 20,
                          color: doctor.isAvailable
                              ? Colors.orange
                              : Colors.green,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          doctor.isAvailable
                              ? "Mark Unavailable"
                              : "Mark Available",
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: const [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text("Delete"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorAvatar(DoctorModel doctor, bool isDarkMode) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: Colors.blue.withValues(alpha: 0.1),
      child: Text(
        doctor.name.isNotEmpty
            ? doctor.name[0].toUpperCase()
            : 'D',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  void _showDoctorDetails(BuildContext context,
      DoctorModel doctor,
      bool isDarkMode,) {
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
                  Center(child: _buildDoctorAvatar(doctor, isDarkMode)),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      doctor.name,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      doctor.specialization ?? "N/A",
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailRow(
                    Icons.business,
                    "Department",
                    doctor.department ?? "N/A",
                    isDarkMode,
                  ),
                  _buildDetailRow(
                    Icons.email,
                    "Email",
                    doctor.email ?? "N/A",
                    isDarkMode,
                  ),
                  _buildDetailRow(
                    Icons.phone,
                    "Phone",
                    doctor.phoneNumber ?? "N/A",
                    isDarkMode,
                  ),
                  _buildDetailRow(
                    Icons.school,
                    "Qualification",
                    doctor.qualification ?? "N/A",
                    isDarkMode,
                  ),
                  _buildDetailRow(
                    Icons.timeline,
                    "Experience",
                    "${doctor.experience ?? 0} years",
                    isDarkMode,
                  ),
                  _buildDetailRow(
                    Icons.attach_money,
                    "Consultation Fee",
                    "\$${doctor.consultationFee ?? 0}",
                    isDarkMode,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon,
      String label,
      String value,
      bool isDarkMode,) {
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

  Future<void> _toggleDoctorStatus(DoctorModel doctor) async {
    final doctorProvider = context.read<DoctorProvider>();

    // Create updated doctor model with toggled availability
    final updatedDoctor = DoctorModel(
      id: doctor.id,
      name: doctor.name,
      email: doctor.email,
      phoneNumber: doctor.phoneNumber,
      specialization: doctor.specialization,
      department: doctor.department,
      qualification: doctor.qualification,
      experience: doctor.experience,
      consultationFee: doctor.consultationFee,
      isAvailable: !doctor.isAvailable,
      createdAt: doctor.createdAt,
      updatedAt: DateTime.now(),
    );

    try {
      await doctorProvider.updateDoctor(doctor.id!, updatedDoctor, null);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${doctor.name} is now ${!doctor.isAvailable
                  ? 'Available'
                  : 'Unavailable'}",
            ),
            backgroundColor: !doctor.isAvailable ? Colors.green : Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to update doctor status"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  void _showDeleteConfirmation(BuildContext context,
      DoctorModel doctor,
      bool isDarkMode,) {
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
            "Are you sure you want to delete ${doctor
                .name}? This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                try {
                  await context.read<DoctorProvider>().deleteDoctor(
                      doctor.id!, null);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${doctor.name} deleted successfully"),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Failed to delete doctor"),
                        backgroundColor: Colors.red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}