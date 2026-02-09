import 'package:flutter/material.dart';
import 'dart:async';

class InstantOPDScreen extends StatefulWidget {
  const InstantOPDScreen({super.key});

  @override
  State<InstantOPDScreen> createState() => _InstantOPDScreenState();
}

class _InstantOPDScreenState extends State<InstantOPDScreen> {
  bool _hasActiveToken = false;
  int _tokenNumber = 0;
  int _queuePosition = 0;
  int _estimatedWaitTime = 0;
  String _selectedSpecialization = "";
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
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
          "Instant OPD",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            _buildHeaderCard(context, isDarkMode),
            const SizedBox(height: 24),

            // Active Token or Selection
            if (_hasActiveToken)
              _buildActiveTokenSection(context, isDarkMode)
            else
              _buildSelectionSection(context, isMobile, isDarkMode),

            const SizedBox(height: 24),

            // Available Doctors
            _buildSectionTitle(context, "Available Now", Icons.access_time),
            const SizedBox(height: 12),
            _buildAvailableDoctors(context, isDarkMode),

            const SizedBox(height: 24),

            // How it Works
            _buildSectionTitle(context, "How It Works", Icons.info_outline),
            const SizedBox(height: 12),
            _buildHowItWorks(context, isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.flash_on,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Walk-in Consultation",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Get instant OPD token",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _buildInfoChip("No Appointment", Icons.event_busy),
              const SizedBox(width: 12),
              _buildInfoChip("Quick Token", Icons.confirmation_number),
              const SizedBox(width: 12),
              _buildInfoChip("Real-time Queue", Icons.queue),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTokenSection(BuildContext context, bool isDarkMode) {
    return Column(
      children: [
        // Token Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(20),
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
              Row(
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
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Token",
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "OPD-${_tokenNumber.toString().padLeft(3, '0')}",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Active",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Queue Position",
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "$_queuePosition",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "in queue",
                            style: TextStyle(
                              fontSize: 11,
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 60,
                      color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Est. Wait Time",
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "$_estimatedWaitTime",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "minutes",
                            style: TextStyle(
                              fontSize: 11,
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Please reach the hospital within the estimated time",
                style: TextStyle(
                  fontSize: 13,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Actions
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _showCancelDialog(context, isDarkMode);
                },
                icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                label: const Text(
                  "Cancel Token",
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to queue status
                },
                icon: const Icon(Icons.refresh),
                label: const Text("Refresh Status"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSelectionSection(
      BuildContext context, bool isMobile, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, "Select Specialization", Icons.local_hospital),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isMobile ? 2 : 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.1,
          children: [
            _buildSpecializationCard(
              "General Medicine",
              Icons.medical_services,
              Colors.blue,
              "5 doctors available",
              isDarkMode,
            ),
            _buildSpecializationCard(
              "Cardiology",
              Icons.favorite,
              Colors.red,
              "3 doctors available",
              isDarkMode,
            ),
            _buildSpecializationCard(
              "Orthopedic",
              Icons.accessibility_new,
              Colors.green,
              "4 doctors available",
              isDarkMode,
            ),
            _buildSpecializationCard(
              "Pediatrics",
              Icons.child_care,
              Colors.orange,
              "6 doctors available",
              isDarkMode,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecializationCard(
      String title,
      IconData icon,
      Color color,
      String availability,
      bool isDarkMode,
      ) {
    final isSelected = _selectedSpecialization == title;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedSpecialization = title;
        });
        _showConfirmationDialog(context, title, isDarkMode);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.1)
              : (isDarkMode ? Colors.grey[850] : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? color
                : (isDarkMode ? Colors.grey[700]! : Colors.grey[200]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? color : null,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              availability,
              style: TextStyle(
                fontSize: 11,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).primaryColor),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableDoctors(BuildContext context, bool isDarkMode) {
    final doctors = [
      {
        "name": "Dr. Sarah Johnson",
        "specialization": "General Medicine",
        "queue": 3,
        "wait": 15,
        "color": Colors.blue,
      },
      {
        "name": "Dr. Michael Brown",
        "specialization": "Cardiology",
        "queue": 5,
        "wait": 25,
        "color": Colors.red,
      },
      {
        "name": "Dr. Emily Davis",
        "specialization": "Pediatrics",
        "queue": 2,
        "wait": 10,
        "color": Colors.orange,
      },
    ];

    return Column(
      children: doctors.map((doctor) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (doctor["color"] as Color).withValues(alpha: 0.1),
                    border: Border.all(
                      color: doctor["color"] as Color,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    color: doctor["color"] as Color,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor["name"] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doctor["specialization"] as String,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            size: 14,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${doctor["queue"]} in queue",
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "~${doctor["wait"]} min wait",
                            style: TextStyle(
                              fontSize: 12,
                              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedSpecialization = doctor["specialization"] as String;
                    });
                    _showConfirmationDialog(
                        context, doctor["specialization"] as String, isDarkMode);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Get Token"),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHowItWorks(BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          _buildStep(1, "Select Specialization", "Choose the department you need", isDarkMode),
          const SizedBox(height: 16),
          _buildStep(2, "Get Instant Token", "Receive your queue number immediately", isDarkMode),
          const SizedBox(height: 16),
          _buildStep(3, "Visit Hospital", "Arrive within estimated time for consultation", isDarkMode),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String title, String description, bool isDarkMode) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              "$number",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showConfirmationDialog(BuildContext context, String specialization, bool isDarkMode) {
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
                  Icons.confirmation_number,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(child: Text("Get Token")),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You are requesting an instant OPD token for:",
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.local_hospital,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      specialization,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "You'll receive a token number and estimated wait time.",
                style: TextStyle(
                  fontSize: 13,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _generateToken();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  void _showCancelDialog(BuildContext context, bool isDarkMode) {
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
              const Expanded(child: Text("Cancel Token")),
            ],
          ),
          content: const Text(
            "Are you sure you want to cancel your OPD token? You'll need to generate a new token to join the queue again.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No, Keep It"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _hasActiveToken = false;
                  _tokenNumber = 0;
                  _queuePosition = 0;
                  _estimatedWaitTime = 0;
                  _timer?.cancel();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text("Token cancelled successfully"),
                      ],
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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

  void _generateToken() {
    setState(() {
      _hasActiveToken = true;
      _tokenNumber = 127; // Simulated token number
      _queuePosition = 8;
      _estimatedWaitTime = 40;
    });

    // Simulate queue updates
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (_queuePosition > 0 && mounted) {
        setState(() {
          _queuePosition--;
          _estimatedWaitTime = _queuePosition * 5;
        });
      } else {
        timer.cancel();
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              "Token OPD-${_tokenNumber.toString().padLeft(3, '0')} generated!",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}