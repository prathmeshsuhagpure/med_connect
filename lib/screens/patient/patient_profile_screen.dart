import 'package:flutter/material.dart';
import 'package:med_connect/models/user/patient_model.dart';
import 'package:med_connect/screens/patient/edit_patient_profile_screen.dart';
import 'package:med_connect/widgets/btm_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../providers/authentication_provider.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (context, authProvider, child) {
        final patient = authProvider.patient;

        if (patient == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 650;
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(context, isMobile, isDarkMode, patient),
                  Padding(
                    padding: EdgeInsets.all(isMobile ? 16 : 24),
                    child: Column(
                      children: [
                        _buildQuickStats(context, isMobile, isDarkMode),
                        const SizedBox(height: 24),
                        _buildSectionCard(context, "Personal Information", [
                          _buildInfoTile(
                            context,
                            Icons.person_outline,
                            "Full Name",
                            patient.name,
                            isDarkMode,
                            onTap: () {},
                          ),
                          _buildInfoTile(
                            context,
                            Icons.email_outlined,
                            "Email",
                            patient.email,
                            isDarkMode,
                            onTap: () {},
                          ),
                          _buildInfoTile(
                            context,
                            Icons.phone_outlined,
                            "Phone Number",
                            patient.phoneNumber,
                            isDarkMode,
                            onTap: () {},
                          ),
                          _buildInfoTile(
                            context,
                            Icons.cake_outlined,
                            "Date of Birth",
                            patient.dateOfBirth ?? "",
                            isDarkMode,
                            onTap: () {},
                          ),
                          _buildInfoTile(
                            context,
                            Icons.person_outline,
                            "Gender",
                            patient.gender ?? "",
                            isDarkMode,
                            onTap: () {},
                          ),
                          _buildInfoTile(
                            context,
                            Icons.bloodtype_outlined,
                            "Blood Group",
                            patient.bloodGroup ?? "",
                            isDarkMode,
                            onTap: () {},
                          ),
                        ], isDarkMode),
                        const SizedBox(height: 16),

                        // Medical Information Section
                        _buildSectionCard(context, "Medical Information", [
                          _buildInfoTile(
                            context,
                            Icons.favorite_outline,
                            "Allergies",
                            patient.allergies ?? "",
                            isDarkMode,
                            onTap: () {},
                          ),
                          _buildInfoTile(
                            context,
                            Icons.medication_outlined,
                            "Current Medications",
                            patient.medications ?? "",
                            isDarkMode,
                            onTap: () {},
                          ),
                          _buildInfoTile(
                            context,
                            Icons.local_hospital_outlined,
                            "Medical Conditions",
                            patient.conditions ?? "",
                            isDarkMode,
                            onTap: () {},
                          ),
                        ], isDarkMode),
                        const SizedBox(height: 16),

                        // Account Settings Section
                        _buildSectionCard(context, "Account Settings", [
                          _buildMenuTile(
                            context,
                            Icons.family_restroom_outlined,
                            "Family Members",
                            "Manage family members",
                            isDarkMode,
                            onTap: () {},
                          ),
                          _buildMenuTile(
                            context,
                            Icons.location_on_outlined,
                            "Saved Addresses",
                            "Home, Work, Other",
                            isDarkMode,
                            onTap: () {},
                          ),
                          _buildMenuTile(
                            context,
                            Icons.credit_card_outlined,
                            "Payment Methods",
                            "Manage payment methods",
                            isDarkMode,
                            onTap: () {},
                          ),
                          _buildMenuTile(
                            context,
                            Icons.language_outlined,
                            "Language",
                            "English",
                            isDarkMode,
                            onTap: () {},
                          ),
                        ], isDarkMode),
                        const SizedBox(height: 16),

                        // App Settings Section
                        _buildSectionCard(context, "App Settings", [
                          _buildMenuTile(
                            context,
                            Icons.notifications_outlined,
                            "Notifications",
                            "Manage notifications",
                            isDarkMode,
                            onTap: () {},
                          ),
                          _buildMenuTile(
                            context,
                            Icons.security_outlined,
                            "Privacy & Security",
                            "Manage privacy settings",
                            isDarkMode,
                            onTap: () {},
                          ),
                          _buildMenuTile(
                            context,
                            Icons.dark_mode_outlined,
                            "Dark Mode",
                            isDarkMode ? "Enabled" : "Disabled",
                            isDarkMode,
                            trailing: Switch(
                              value: isDarkMode,
                              onChanged: (value) {},
                            ),
                          ),
                        ], isDarkMode),
                        const SizedBox(height: 16),

                        // Support Section
                        _buildSectionCard(context, "Support & About", [
                          _buildMenuTile(
                            context,
                            Icons.help_outline,
                            "Help & Support",
                            "FAQs, Contact us",
                            isDarkMode,
                            onTap: () {},
                          ),
                          _buildMenuTile(
                            context,
                            Icons.article_outlined,
                            "Terms & Conditions",
                            "Read terms and conditions",
                            isDarkMode,
                            onTap: () {},
                          ),
                          _buildMenuTile(
                            context,
                            Icons.privacy_tip_outlined,
                            "Privacy Policy",
                            "Read privacy policy",
                            isDarkMode,
                            onTap: () {},
                          ),
                          _buildMenuTile(
                            context,
                            Icons.info_outline,
                            "About App",
                            "Version 1.0.0",
                            isDarkMode,
                            onTap: () {},
                          ),
                        ], isDarkMode),
                        const SizedBox(height: 24),

                        // Logout Button
                        _buildLogoutButton(context, isMobile, isDarkMode),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
    PatientModel patient,
  ) {
    final userId = patient.id.toString();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => PatientShell()),
                    );
                  },
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              left: isMobile ? 16 : 24,
              right: isMobile ? 16 : 24,
              bottom: 32,
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: isMobile ? 100 : 120,
                      height: isMobile ? 100 : 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child:
                            patient.profilePicture != null &&
                                patient.profilePicture!.isNotEmpty
                            ? Image.network(
                                patient.profilePicture.toString(),
                                width: isMobile ? 100 : 120,
                                height: isMobile ? 100 : 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.person,
                                    size: isMobile ? 50 : 60,
                                    color: Theme.of(context).primaryColor,
                                  );
                                },
                              )
                            : Icon(
                                Icons.person,
                                size: isMobile ? 50 : 60,
                                color: Theme.of(context).primaryColor,
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Name
                Text(
                  patient.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),

                Text(
                  "Patient ID: ${userId.substring(0, userId.length >= 8 ? 8 : userId.length)}",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPatientProfileScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text("Edit Profile"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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

  Widget _buildQuickStats(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            "12",
            "Appointments",
            Icons.calendar_today,
            Colors.blue,
            isDarkMode,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            "8",
            "Reports",
            Icons.description,
            Colors.green,
            isDarkMode,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            "5",
            "Doctors",
            Icons.medical_services,
            Colors.orange,
            isDarkMode,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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

  Widget _buildSectionCard(
    BuildContext context,
    String title,
    List<Widget> children,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            height: 1,
            color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    bool isDarkMode, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey[800]
                    : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDarkMode
                    ? Colors.grey[400]
                    : Theme.of(context).primaryColor,
              ),
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
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
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

  Widget _buildMenuTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    bool isDarkMode, {
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey[800]
                    : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDarkMode
                    ? Colors.grey[400]
                    : Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
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

  Widget _buildLogoutButton(
    BuildContext context,
    bool isMobile,
    bool isDarkMode,
  ) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.5), width: 2),
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          _showLogoutDialog(context, isDarkMode, AuthenticationProvider());
        },
        icon: const Icon(Icons.logout),
        label: const Text(
          "Logout",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
          foregroundColor: Colors.red,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    bool isDarkMode,
    AuthenticationProvider authProvider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                child: const Icon(Icons.logout, color: Colors.red, size: 24),
              ),
              const SizedBox(width: 16),
              const Text("Logout"),
            ],
          ),
          content: const Text(
            "Are you sure you want to logout from your account?",
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
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                try {
                  await authProvider.logout();
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.pushReplacementNamed(context, '/login');
                } catch (e) {
                  setState(() {
                    isLoading = false;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
