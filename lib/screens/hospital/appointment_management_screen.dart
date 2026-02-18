import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect/models/appointment_model.dart';
import 'package:provider/provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/authentication_provider.dart';

class AppointmentManagementScreen extends StatefulWidget {
  const AppointmentManagementScreen({super.key});

  @override
  State<AppointmentManagementScreen> createState() =>
      _AppointmentManagementScreenState();
}

class _AppointmentManagementScreenState
    extends State<AppointmentManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = "All";
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAppointments();
    });
  }

  void _loadAppointments() {
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    final appointmentProvider = Provider.of<AppointmentProvider>(
      context,
      listen: false,
    );
    final hospitalId = authProvider.hospital?.id;

    if (hospitalId != null) {
      appointmentProvider.loadAppointmentsByHospital(hospitalId);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
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
          "Appointment Management",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context, isDarkMode);
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              _showDatePickerDialog(context, isDarkMode);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_isSearching ? 110 : 50),
          child: Column(
            children: [
              if (_isSearching) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Search by patient name, ID, or doctor...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: isDarkMode
                          ? Colors.grey[850]
                          : Colors.grey[100],
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
                      setState(() {});
                    },
                  ),
                ),
              ],
              Container(
                color: isDarkMode ? Colors.grey[900] : Colors.white,
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: Theme.of(context).primaryColor,
                  indicatorWeight: 3,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: isDarkMode
                      ? Colors.grey[400]
                      : Colors.grey[600],
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  tabs: const [
                    Tab(text: "All"),
                    Tab(text: "Upcoming"),
                    Tab(text: "Completed"),
                    Tab(text: "Cancelled"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading appointments',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.error!,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _loadAppointments,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              _buildSummaryCards(context, isMobile, isDarkMode, provider),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _loadAppointments();
                  },
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAllTab(
                        context,
                        isMobile,
                        isDarkMode,
                        provider.appointments,
                      ),
                      _buildUpcomingTab(
                        context,
                        isMobile,
                        isDarkMode,
                        provider.upcomingAppointments,
                      ),
                      _buildCompletedTab(
                        context,
                        isMobile,
                        isDarkMode,
                        provider.pastAppointments,
                      ),
                      _buildCancelledTab(
                        context,
                        isMobile,
                        isDarkMode,
                        provider.cancelledAppointments,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showAddAppointmentDialog(context, isDarkMode);
        },
        icon: const Icon(Icons.add),
        label: const Text("New Appointment"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildSummaryCards(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    AppointmentProvider provider,
  ) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[900] : Colors.grey[50],
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              context,
              "Today",
              provider.todayAppointments.length.toString(),
              Icons.today,
              Colors.blue,
              isDarkMode,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              context,
              "Pending",
              provider.pendingCount.toString(),
              Icons.schedule,
              Colors.orange,
              isDarkMode,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              context,
              "Confirmed",
              provider.confirmedCount.toString(),
              Icons.check_circle,
              Colors.green,
              isDarkMode,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
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
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
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

  Widget _buildAllTab(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    List<AppointmentModel> appointments,
  ) {
    final filteredAppointments = _filterAppointments(appointments);

    if (filteredAppointments.isEmpty) {
      return _buildEmptyState(
        context,
        Icons.calendar_today_outlined,
        "No Appointments",
        "All appointments will appear here",
        isDarkMode,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildAppointmentCard(
            context,
            filteredAppointments[index],
            isMobile,
            isDarkMode,
          ),
        );
      },
    );
  }

  Widget _buildUpcomingTab(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    List<AppointmentModel> appointments,
  ) {
    final filteredAppointments = _filterAppointments(appointments);

    if (filteredAppointments.isEmpty) {
      return _buildEmptyState(
        context,
        Icons.upcoming_outlined,
        "No Upcoming Appointments",
        "Upcoming appointments will appear here",
        isDarkMode,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildAppointmentCard(
            context,
            filteredAppointments[index],
            isMobile,
            isDarkMode,
          ),
        );
      },
    );
  }

  Widget _buildCompletedTab(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    List<AppointmentModel> appointments,
  ) {
    final filteredAppointments = _filterAppointments(appointments);

    if (filteredAppointments.isEmpty) {
      return _buildEmptyState(
        context,
        Icons.check_circle_outline,
        "No Completed Appointments",
        "Completed appointments will appear here",
        isDarkMode,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildAppointmentCard(
            context,
            filteredAppointments[index],
            isMobile,
            isDarkMode,
          ),
        );
      },
    );
  }

  Widget _buildCancelledTab(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    List<AppointmentModel> appointments,
  ) {
    final filteredAppointments = _filterAppointments(appointments);

    if (filteredAppointments.isEmpty) {
      return _buildEmptyState(
        context,
        Icons.cancel_outlined,
        "No Cancelled Appointments",
        "Cancelled appointments will appear here",
        isDarkMode,
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildAppointmentCard(
            context,
            filteredAppointments[index],
            isMobile,
            isDarkMode,
          ),
        );
      },
    );
  }

  List<AppointmentModel> _filterAppointments(
    List<AppointmentModel> appointments,
  ) {
    if (_searchController.text.isEmpty) {
      return appointments;
    }

    final query = _searchController.text.toLowerCase();
    return appointments.where((apt) {
      return (apt.patientName?.toLowerCase().contains(query) ?? false) ||
          apt.doctorName.toLowerCase().contains(query) ||
          apt.id.toLowerCase().contains(query);
    }).toList();
  }

  Widget _buildAppointmentCard(
    BuildContext context,
    AppointmentModel appointment,
    bool isMobile,
    bool isDarkMode,
  ) {
    final formattedDate = DateFormat(
      'MMM d, yyyy',
    ).format(appointment.appointmentDate);

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header Row
                Row(
                  children: [
                    // Appointment ID
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '#${appointment.id.substring(appointment.id.length - 6)}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Type Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color:
                            appointment.appointmentType.toLowerCase().contains(
                              'video',
                            )
                            ? Colors.purple.withValues(alpha: 0.1)
                            : Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            appointment.appointmentType.toLowerCase().contains(
                                  'video',
                                )
                                ? Icons.videocam
                                : Icons.local_hospital,
                            size: 12,
                            color:
                                appointment.appointmentType
                                    .toLowerCase()
                                    .contains('video')
                                ? Colors.purple
                                : Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            appointment.appointmentType,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color:
                                  appointment.appointmentType
                                      .toLowerCase()
                                      .contains('video')
                                  ? Colors.purple
                                  : Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Status Badge
                    _buildStatusBadge(appointment.status, isDarkMode),
                  ],
                ),
                const SizedBox(height: 16),

                // Patient and Doctor Info
                Row(
                  children: [
                    // Patient Avatar
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  appointment.patientName ?? 'Patient',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (appointment.consultationFee != null)
                                Text(
                                  '₹${appointment.consultationFee}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.medical_services,
                                size: 14,
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  "Dr. ${appointment.doctorName} • ${appointment.specialization}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
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
                const SizedBox(height: 16),

                // Date and Time
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? Colors.grey[300]
                              : Colors.grey[700],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        appointment.appointmentTime,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? Colors.grey[300]
                              : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Divider(
            height: 1,
            color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: _buildActionButtons(context, appointment, isDarkMode),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(AppointmentStatus status, bool isDarkMode) {
    Color color;
    switch (status) {
      case AppointmentStatus.confirmed:
        color = Colors.green;
        break;
      case AppointmentStatus.pending:
        color = Colors.orange;
        break;
      case AppointmentStatus.completed:
        color = Colors.blue;
        break;
      case AppointmentStatus.cancelledByPatient:
      case AppointmentStatus.cancelledByHospital:
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.name[0].toUpperCase() + status.name.substring(1),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    AppointmentModel appointment,
    bool isDarkMode,
  ) {
    if (appointment.status == AppointmentStatus.completed) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: View details
              },
              icon: const Icon(Icons.visibility, size: 18),
              label: const Text("View Details"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                side: BorderSide(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: View prescription
              },
              icon: const Icon(Icons.description, size: 18),
              label: const Text("Prescription"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                side: BorderSide(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (appointment.isCancelled) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {
            _showCancellationDetails(context, appointment, isDarkMode);
          },
          icon: const Icon(Icons.info_outline, size: 18),
          label: const Text("View Details"),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.grey,
            side: BorderSide(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    } else {
      // Confirmed or Pending
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                _showRescheduleDialog(context, appointment, isDarkMode);
              },
              icon: const Icon(Icons.edit_calendar, size: 18),
              label: const Text("Reschedule"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
                side: BorderSide(color: Theme.of(context).primaryColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                _showConfirmDialog(context, appointment, isDarkMode);
              },
              icon: const Icon(Icons.check, size: 18),
              label: Text(
                appointment.status == AppointmentStatus.pending
                    ? "Confirm"
                    : "Complete",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () {
              _showCancelDialog(context, appointment, isDarkMode);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Icon(Icons.cancel, size: 18),
          ),
        ],
      );
    }
  }

  Widget _buildEmptyState(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool isDarkMode,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
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
                    "Filter Appointments",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildFilterOption(
                    context,
                    "All",
                    _selectedFilter == "All",
                    isDarkMode,
                    () {
                      setModalState(() {
                        _selectedFilter = "All";
                      });
                    },
                  ),
                  _buildFilterOption(
                    context,
                    "Today",
                    _selectedFilter == "Today",
                    isDarkMode,
                    () {
                      setModalState(() {
                        _selectedFilter = "Today";
                      });
                    },
                  ),
                  _buildFilterOption(
                    context,
                    "This Week",
                    _selectedFilter == "This Week",
                    isDarkMode,
                    () {
                      setModalState(() {
                        _selectedFilter = "This Week";
                      });
                    },
                  ),
                  _buildFilterOption(
                    context,
                    "This Month",
                    _selectedFilter == "This Month",
                    isDarkMode,
                    () {
                      setModalState(() {
                        _selectedFilter = "This Month";
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Apply Filters"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterOption(
    BuildContext context,
    String label,
    bool isSelected,
    bool isDarkMode,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
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

  void _showDatePickerDialog(BuildContext context, bool isDarkMode) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        // TODO: Filter by date
      });
    }
  }

  void _showAddAppointmentDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("New Appointment"),
          content: const Text("This will open the appointment booking form."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Navigate to appointment booking form
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: const Text("Continue"),
            ),
          ],
        );
      },
    );
  }

  void _showRescheduleDialog(
    BuildContext context,
    AppointmentModel appointment,
    bool isDarkMode,
  ) {
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
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.edit_calendar,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(child: Text("Reschedule")),
            ],
          ),
          content: Text(
            "Reschedule appointment for ${appointment.patientName ?? 'this patient'}?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Open reschedule form
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: const Text("Reschedule"),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    AppointmentModel appointment,
    bool isDarkMode,
  ) {
    final newStatus = appointment.status == AppointmentStatus.pending
        ? AppointmentStatus.confirmed
        : AppointmentStatus.completed;
    final action = newStatus == AppointmentStatus.confirmed
        ? "Confirm"
        : "Complete";

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
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.check_circle, color: Colors.green),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text("$action Appointment")),
            ],
          ),
          content: Text(
            "$action appointment for ${appointment.patientName ?? 'this patient'}?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final provider = Provider.of<AppointmentProvider>(
                  context,
                  listen: false,
                );

                final result = await provider.updateAppointmentStatus(
                  appointment.id,
                  newStatus,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        result['message'] ??
                            "Appointment ${action.toLowerCase()}ed",
                      ),
                      backgroundColor: result['success']
                          ? Colors.green
                          : Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text(action),
            ),
          ],
        );
      },
    );
  }

  void _showCancelDialog(
    BuildContext context,
    AppointmentModel appointment,
    bool isDarkMode,
  ) {
    final reasonController = TextEditingController();

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
                child: const Icon(Icons.cancel, color: Colors.red),
              ),
              const SizedBox(width: 16),
              const Expanded(child: Text("Cancel Appointment")),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are you sure you want to cancel the appointment for ${appointment.patientName ?? 'this patient'}?",
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  hintText: "Reason for cancellation",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No, Keep It"),
            ),
            ElevatedButton(
              onPressed: () async {
                final provider = Provider.of<AppointmentProvider>(
                  context,
                  listen: false,
                );

                final result = await provider.cancelAppointmentByHospital(
                  appointment.id,
                  reasonController.text.isEmpty
                      ? "Cancelled by hospital"
                      : reasonController.text,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        result['message'] ?? 'Appointment cancelled',
                      ),
                      backgroundColor: result['success']
                          ? Colors.green
                          : Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Yes, Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _showCancellationDetails(
    BuildContext context,
    AppointmentModel appointment,
    bool isDarkMode,
  ) {
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
                child: const Icon(Icons.info_outline, color: Colors.red),
              ),
              const SizedBox(width: 16),
              const Expanded(child: Text("Cancellation Details")),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Status: ${appointment.statusDisplayText}"),
              const SizedBox(height: 12),
              if (appointment.cancellationReason != null) ...[
                const Text(
                  "Reason:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(appointment.cancellationReason!),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }
}
