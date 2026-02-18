import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:med_connect/models/appointment_model.dart';
import 'package:provider/provider.dart';
import '../../providers/appointment_provider.dart';
import '../../providers/authentication_provider.dart';

class PatientAppointmentsScreen extends StatefulWidget {
  const PatientAppointmentsScreen({super.key});

  @override
  State<PatientAppointmentsScreen> createState() =>
      PatientAppointmentsScreenState();
}

class PatientAppointmentsScreenState extends State<PatientAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAppointments();
    });
  }

  void _loadAppointments() {
    final authProvider =
    Provider.of<AuthenticationProvider>(context, listen: false);
    final appointmentProvider =
    Provider.of<AppointmentProvider>(context, listen: false);
    final patientId = authProvider.patient?.id;

    if (patientId != null) {
      appointmentProvider.loadAppointmentsByPatient(patientId);
    }
  }

  @override
  void dispose() {
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
          "My Appointments",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context, isDarkMode);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
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
                Tab(text: "Upcoming"),
                Tab(text: "Past"),
                Tab(text: "Cancelled"),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, appointmentProvider, child) {
          if (appointmentProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (appointmentProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 64, color: Colors.red.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading appointments',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    appointmentProvider.error!,
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
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

          return TabBarView(
            controller: _tabController,
            children: [
              _buildUpcomingTab(context, isMobile, isDarkMode,
                  appointmentProvider.upcomingAppointments),
              _buildPastTab(context, isMobile, isDarkMode,
                  appointmentProvider.pastAppointments),
              _buildCancelledTab(context, isMobile, isDarkMode,
                  appointmentProvider.cancelledAppointments),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUpcomingTab(
      BuildContext context,
      bool isMobile,
      bool isDarkMode,
      List<AppointmentModel> upcomingAppointments,
      ) {
    if (upcomingAppointments.isEmpty) {
      return _buildEmptyState(
        context,
        Icons.calendar_today_outlined,
        "No Upcoming Appointments",
        "Book your next appointment to get started",
        isDarkMode,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadAppointments();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        itemCount: upcomingAppointments.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildUpcomingAppointmentCard(
              context,
              upcomingAppointments[index],
              isMobile,
              isDarkMode,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPastTab(
      BuildContext context,
      bool isMobile,
      bool isDarkMode,
      List<AppointmentModel> pastAppointments,
      ) {
    if (pastAppointments.isEmpty) {
      return _buildEmptyState(
        context,
        Icons.history_outlined,
        "No Past Appointments",
        "Your completed appointments will appear here",
        isDarkMode,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadAppointments();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        itemCount: pastAppointments.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildPastAppointmentCard(
              context,
              pastAppointments[index],
              isMobile,
              isDarkMode,
            ),
          );
        },
      ),
    );
  }

  Widget _buildCancelledTab(
      BuildContext context,
      bool isMobile,
      bool isDarkMode,
      List<AppointmentModel> cancelledAppointments,
      ) {
    if (cancelledAppointments.isEmpty) {
      return _buildEmptyState(
        context,
        Icons.cancel_outlined,
        "No Cancelled Appointments",
        "Your cancelled appointments will appear here",
        isDarkMode,
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadAppointments();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        itemCount: cancelledAppointments.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildCancelledAppointmentCard(
              context,
              cancelledAppointments[index],
              isMobile,
              isDarkMode,
            ),
          );
        },
      ),
    );
  }

  Widget _buildUpcomingAppointmentCard(
      BuildContext context,
      AppointmentModel appointment,
      bool isMobile,
      bool isDarkMode,
      ) {
    // ✅ Format date nicely
    final formattedDate = DateFormat('MMM d, yyyy').format(appointment.appointmentDate);
    final isToday = DateFormat('yyyy-MM-dd').format(appointment.appointmentDate) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    final isTomorrow = DateFormat('yyyy-MM-dd').format(appointment.appointmentDate) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now().add(const Duration(days: 1)));

    String dateDisplay = formattedDate;
    if (isToday) dateDisplay = 'Today';
    if (isTomorrow) dateDisplay = 'Tomorrow';

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
                // Header with appointment type and status
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: appointment.appointmentType.toLowerCase().contains("video")
                            ? Colors.purple.withValues(alpha: 0.1)
                            : Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            appointment.appointmentType.toLowerCase().contains("video")
                                ? Icons.videocam
                                : Icons.local_hospital,
                            size: 14,
                            color: appointment.appointmentType.toLowerCase().contains("video")
                                ? Colors.purple
                                : Colors.blue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            appointment.appointmentType,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: appointment.appointmentType.toLowerCase().contains("video")
                                  ? Colors.purple
                                  : Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: appointment.status == AppointmentStatus.confirmed
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        appointment.statusDisplayText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: appointment.status == AppointmentStatus.confirmed
                              ? Colors.green
                              : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Doctor and Hospital Info
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).primaryColor,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment.doctorName,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appointment.specialization,
                            style: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 14,
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  appointment.hospitalName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                  ),
                                  overflow: TextOverflow.ellipsis,
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
                        dateDisplay,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
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
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
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
            child: Row(
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
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showCancelDialog(context, appointment, isDarkMode);
                    },
                    icon: const Icon(Icons.cancel, size: 18),
                    label: const Text("Cancel"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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

  Widget _buildPastAppointmentCard(
      BuildContext context,
      AppointmentModel appointment,
      bool isMobile,
      bool isDarkMode,
      ) {
    final formattedDate = DateFormat('MMM d, yyyy').format(appointment.appointmentDate);

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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header with completed badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 14,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        appointment.statusDisplayText,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Doctor and Hospital Info
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment.specialization,
                        style: TextStyle(
                          color:
                          isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              appointment.hospitalName,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
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

            // Action Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Navigate to book again or view details
                },
                icon: const Icon(Icons.replay, size: 18),
                label: const Text("Book Again"),
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
          ],
        ),
      ),
    );
  }

  Widget _buildCancelledAppointmentCard(
      BuildContext context,
      AppointmentModel appointment,
      bool isMobile,
      bool isDarkMode,
      ) {
    final formattedDate = DateFormat('MMM d, yyyy').format(appointment.appointmentDate);

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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with cancelled badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.cancel,
                        size: 14,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        appointment.statusDisplayText,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Doctor and Hospital Info
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment.specialization,
                        style: TextStyle(
                          color:
                          isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 14,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              appointment.hospitalName,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Cancellation reason if available
            if (appointment.cancellationReason != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        appointment.cancellationReason!,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                          isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),

            // Action Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  // TODO: Navigate to book new appointment
                },
                icon: const Icon(Icons.add_circle_outline, size: 18),
                label: const Text("Book New Appointment"),
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
          ],
        ),
      ),
    );
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
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Navigate to book appointment
              },
              icon: const Icon(Icons.add),
              label: const Text("Book Appointment"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                "Filter Appointments",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildFilterOption(context, "All Appointments", isDarkMode),
              _buildFilterOption(context, "Today", isDarkMode),
              _buildFilterOption(context, "This Week", isDarkMode),
              _buildFilterOption(context, "This Month", isDarkMode),
              _buildFilterOption(context, "Video Consultations", isDarkMode),
              _buildFilterOption(context, "In-Person", isDarkMode),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
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
  }

  Widget _buildFilterOption(
      BuildContext context, String label, bool isDarkMode) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              Icons.radio_button_unchecked,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
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
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text("Reschedule"),
            ],
          ),
          content: Text(
            "Would you like to reschedule your appointment with ${appointment.doctorName}?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Navigate to reschedule appointment
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Reschedule"),
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
                child: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              const Text("Cancel Appointment"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Are you sure you want to cancel your appointment with ${appointment.doctorName}?",
              ),
              const SizedBox(height: 16),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  hintText: "Reason for cancellation (optional)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Text(
                "Cancellation charges may apply.",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red[300],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "No, Keep It",
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final provider = Provider.of<AppointmentProvider>(context, listen: false);
                final result = await provider.cancelAppointmentByPatient(
                  appointment.id,
                  reasonController.text.isEmpty
                      ? "No reason provided"
                      : reasonController.text,
                );

                if (context.mounted) {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(result['message'] ?? 'Appointment cancelled'),
                      backgroundColor:
                      result['success'] ? Colors.green : Colors.red,
                    ),
                  );

                  if (result['success']) {
                    _loadAppointments();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Yes, Cancel"),
            ),
          ],
        );
      },
    );
  }
}