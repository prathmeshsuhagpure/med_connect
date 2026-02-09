import 'package:flutter/material.dart';

class RecentPatientsScreen extends StatelessWidget {
  const RecentPatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recent Patients",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 8, // dummy data
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _buildRecentPatientCard(isDarkMode);
        },
      ),
    );
  }

  Widget _buildRecentPatientCard(bool isDarkMode) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        // TODO: Navigate to Patient Detail Screen
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(16),
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
            _buildAvatar(),
            const SizedBox(width: 14),
            Expanded(child: _buildPatientInfo(isDarkMode)),
            _buildTimeInfo(isDarkMode),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 26,
      backgroundColor: Colors.blue.withValues(alpha: 0.1),
      child: const Icon(Icons.person, color: Colors.blue, size: 28),
    );
  }

  Widget _buildPatientInfo(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Anita Verma",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Text(
          "Fever & body pain",
          style: TextStyle(
            fontSize: 13,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: 14,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            const Text("Dr. Amit Verma", style: TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeInfo(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "10:45 AM",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            "Completed",
            style: TextStyle(
              fontSize: 11,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
