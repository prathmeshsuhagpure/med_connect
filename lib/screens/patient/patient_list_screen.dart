import 'package:flutter/material.dart';
import 'package:med_connect/screens/patient/patient_detail_screen.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Patients",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _buildSearchBar(isDarkMode),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 8, // dummy data count
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                return _buildPatientCard(isDarkMode);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search patient name or phone",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPatientCard(bool isDarkMode) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PatientDetailScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(18),
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
            _buildStatusBadge(),
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
          "Rahul Sharma",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              Icons.phone,
              size: 14,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            const Text("+91 98765 43210", style: TextStyle(fontSize: 13)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 14,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            const SizedBox(width: 6),
            const Text(
              "Last visit: 12 Aug 2025",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "Active",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.green,
        ),
      ),
    );
  }
}
