import 'package:flutter/material.dart';

class AppointmentManagementScreen extends StatefulWidget {
  const AppointmentManagementScreen({super.key});

  @override
  State<AppointmentManagementScreen> createState() =>
      _AppointmentManagementScreenState();
}

class _AppointmentManagementScreenState
    extends State<AppointmentManagementScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = "All";
  String _selectedDate = "Today";
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: "Search by patient name, ID, or doctor...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
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
                      // TODO: Implement search logic
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
                  unselectedLabelColor:
                  isDarkMode ? Colors.grey[400] : Colors.grey[600],
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
      body: Column(
        children: [
          // Summary Cards
          _buildSummaryCards(context, isMobile, isDarkMode),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllTab(context, isMobile, isDarkMode),
                _buildUpcomingTab(context, isMobile, isDarkMode),
                _buildCompletedTab(context, isMobile, isDarkMode),
                _buildCancelledTab(context, isMobile, isDarkMode),
              ],
            ),
          ),
        ],
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
      BuildContext context, bool isMobile, bool isDarkMode) {
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
              "24",
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
              "8",
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
              "16",
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

  Widget _buildAllTab(BuildContext context, bool isMobile, bool isDarkMode) {
    final appointments = _getAllAppointments();

    if (appointments.isEmpty) {
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
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildAppointmentCard(
            context,
            appointments[index],
            isMobile,
            isDarkMode,
          ),
        );
      },
    );
  }

  Widget _buildUpcomingTab(
      BuildContext context, bool isMobile, bool isDarkMode) {
    final appointments = _getAllAppointments()
        .where((apt) => apt.status == "Confirmed" || apt.status == "Pending")
        .toList();

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildAppointmentCard(
            context,
            appointments[index],
            isMobile,
            isDarkMode,
          ),
        );
      },
    );
  }

  Widget _buildCompletedTab(
      BuildContext context, bool isMobile, bool isDarkMode) {
    final appointments = _getAllAppointments()
        .where((apt) => apt.status == "Completed")
        .toList();

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildAppointmentCard(
            context,
            appointments[index],
            isMobile,
            isDarkMode,
          ),
        );
      },
    );
  }

  Widget _buildCancelledTab(
      BuildContext context, bool isMobile, bool isDarkMode) {
    final appointments = _getAllAppointments()
        .where((apt) => apt.status == "Cancelled")
        .toList();

    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildAppointmentCard(
            context,
            appointments[index],
            isMobile,
            isDarkMode,
          ),
        );
      },
    );
  }

  Widget _buildAppointmentCard(
      BuildContext context,
      _AppointmentData appointment,
      bool isMobile,
      bool isDarkMode,
      ) {
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
                        appointment.id,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
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
                        color: appointment.type == "Video Consultation"
                            ? Colors.purple.withValues(alpha: 0.1)
                            : Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            appointment.type == "Video Consultation"
                                ? Icons.videocam
                                : Icons.local_hospital,
                            size: 12,
                            color: appointment.type == "Video Consultation"
                                ? Colors.purple
                                : Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            appointment.type,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: appointment.type == "Video Consultation"
                                  ? Colors.purple
                                  : Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(appointment.status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        appointment.status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(appointment.status),
                        ),
                      ),
                    ),
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
                        color: appointment.patientColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.person,
                        color: appointment.patientColor,
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
                                  appointment.patientName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Text(
                                appointment.age,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
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

                // Date, Time, and Contact Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            appointment.date,
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
                            appointment.time,
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
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 16,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            appointment.phone,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Notes (if any)
                if (appointment.notes != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.note,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            appointment.notes!,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode
                                  ? Colors.grey[300]
                                  : Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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

  Widget _buildActionButtons(
      BuildContext context,
      _AppointmentData appointment,
      bool isDarkMode,
      ) {
    if (appointment.status == "Completed") {
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
    } else if (appointment.status == "Cancelled") {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {
            // TODO: View cancellation details
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
                side: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
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
              label: Text(appointment.status == "Pending" ? "Confirm" : "Complete"),
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
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey[800]
                    : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 80,
                color: isDarkMode
                    ? Colors.grey[600]
                    : Theme.of(context).primaryColor.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case "Confirmed":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Completed":
        return Colors.blue;
      case "Cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
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
                "Filter Appointments",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildFilterOption(context, "All Appointments", isDarkMode),
              _buildFilterOption(context, "In-Person Only", isDarkMode),
              _buildFilterOption(context, "Video Consultations", isDarkMode),
              _buildFilterOption(context, "Today", isDarkMode),
              _buildFilterOption(context, "This Week", isDarkMode),
              _buildFilterOption(context, "Emergency", isDarkMode),
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

  Widget _buildFilterOption(
      BuildContext context, String label, bool isDarkMode) {
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
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
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
        _selectedDate = "${picked.day}/${picked.month}/${picked.year}";
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
          content: const Text(
            "This will open the appointment booking form.",
          ),
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
      _AppointmentData appointment,
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
            "Reschedule appointment for ${appointment.patientName}?",
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
      _AppointmentData appointment,
      bool isDarkMode,
      ) {
    final action = appointment.status == "Pending" ? "Confirm" : "Complete";
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
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(child: Text("$action Appointment")),
            ],
          ),
          content: Text(
            "$action appointment for ${appointment.patientName}?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Update appointment status
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Appointment ${action.toLowerCase()}ed"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text(action),
            ),
          ],
        );
      },
    );
  }

  void _showCancelDialog(
      BuildContext context,
      _AppointmentData appointment,
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
                child: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(child: Text("Cancel Appointment")),
            ],
          ),
          content: Text(
            "Are you sure you want to cancel the appointment for ${appointment.patientName}?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No, Keep It"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Cancel appointment
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Appointment cancelled"),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Yes, Cancel"),
            ),
          ],
        );
      },
    );
  }

  List<_AppointmentData> _getAllAppointments() {
    return [
      _AppointmentData(
        id: "APT001",
        patientName: "Sarah Johnson",
        age: "28 yrs",
        doctorName: "Michael Brown",
        specialization: "Cardiologist",
        date: "Today, Feb 6",
        time: "09:00 AM",
        phone: "+1 234 567 8900",
        type: "In-Person",
        status: "Confirmed",
        patientColor: Colors.blue,
        notes: "First visit - Chest pain complaint",
      ),
      _AppointmentData(
        id: "APT002",
        patientName: "Robert Williams",
        age: "45 yrs",
        doctorName: "Emily Davis",
        specialization: "Orthopedic",
        date: "Today, Feb 6",
        time: "10:30 AM",
        phone: "+1 234 567 8901",
        type: "Video Consultation",
        status: "Pending",
        patientColor: Colors.green,
      ),
      _AppointmentData(
        id: "APT003",
        patientName: "Lisa Anderson",
        age: "52 yrs",
        doctorName: "Sarah Johnson",
        specialization: "Dermatologist",
        date: "Today, Feb 6",
        time: "02:00 PM",
        phone: "+1 234 567 8902",
        type: "In-Person",
        status: "Confirmed",
        patientColor: Colors.purple,
      ),
      _AppointmentData(
        id: "APT004",
        patientName: "David Martinez",
        age: "38 yrs",
        doctorName: "James Wilson",
        specialization: "General Physician",
        date: "Feb 5, 2026",
        time: "03:30 PM",
        phone: "+1 234 567 8903",
        type: "In-Person",
        status: "Completed",
        patientColor: Colors.teal,
      ),
      _AppointmentData(
        id: "APT005",
        patientName: "Emma Thompson",
        age: "31 yrs",
        doctorName: "Robert Lee",
        specialization: "Neurologist",
        date: "Feb 4, 2026",
        time: "11:00 AM",
        phone: "+1 234 567 8904",
        type: "Video Consultation",
        status: "Cancelled",
        patientColor: Colors.red,
        notes: "Cancelled by patient - Personal emergency",
      ),
    ];
  }
}

// Helper class
class _AppointmentData {
  final String id;
  final String patientName;
  final String age;
  final String doctorName;
  final String specialization;
  final String date;
  final String time;
  final String phone;
  final String type;
  final String status;
  final Color patientColor;
  final String? notes;

  _AppointmentData({
    required this.id,
    required this.patientName,
    required this.age,
    required this.doctorName,
    required this.specialization,
    required this.date,
    required this.time,
    required this.phone,
    required this.type,
    required this.status,
    required this.patientColor,
    this.notes,
  });
}