import 'package:flutter/material.dart';

class HospitalSettingsScreen extends StatefulWidget {
  const HospitalSettingsScreen({super.key});

  @override
  State<HospitalSettingsScreen> createState() => _HospitalSettingsScreenState();
}

class _HospitalSettingsScreenState extends State<HospitalSettingsScreen> {
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _appointmentReminders = true;
  bool _marketingEmails = false;
  bool _twoFactorAuth = false;
  bool _fingerprintAuth = true;
  bool _autoBackup = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 650;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Settings
              _buildSectionTitle(context, "Account Settings"),
              const SizedBox(height: 12),
              _buildAccountSettings(context, isDarkMode),
              const SizedBox(height: 24),

              // Notification Settings
              _buildSectionTitle(context, "Notifications"),
              const SizedBox(height: 12),
              _buildNotificationSettings(context, isDarkMode),
              const SizedBox(height: 24),

              // Preferences
              _buildSectionTitle(context, "Preferences"),
              const SizedBox(height: 12),
              _buildPreferences(context, isDarkMode),
              const SizedBox(height: 24),

              // Security & Privacy
              _buildSectionTitle(context, "Security & Privacy"),
              const SizedBox(height: 12),
              _buildSecuritySettings(context, isDarkMode),
              const SizedBox(height: 24),

              // Hospital Management
              _buildSectionTitle(context, "Hospital Management"),
              const SizedBox(height: 12),
              _buildManagementSettings(context, isDarkMode),
              const SizedBox(height: 24),

              // Data & Storage
              _buildSectionTitle(context, "Data & Storage"),
              const SizedBox(height: 12),
              _buildDataSettings(context, isDarkMode),
              const SizedBox(height: 24),

              // Support & About
              _buildSectionTitle(context, "Support & About"),
              const SizedBox(height: 12),
              _buildSupportSettings(context, isDarkMode),
              const SizedBox(height: 24),

              // Danger Zone
              _buildSectionTitle(context, "Danger Zone"),
              const SizedBox(height: 12),
              _buildDangerZone(context, isDarkMode),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAccountSettings(BuildContext context, bool isDarkMode) {
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
          _buildSettingTile(
            context,
            Icons.business,
            "Hospital Information",
            "Update hospital details",
            Colors.blue,
            isDarkMode,
            onTap: () {
              // TODO: Navigate to edit hospital info
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.person,
            "Admin Profile",
            "Manage admin account",
            Colors.green,
            isDarkMode,
            onTap: () {
              // TODO: Navigate to admin profile
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.lock,
            "Change Password",
            "Update your password",
            Colors.orange,
            isDarkMode,
            onTap: () {
              _showChangePasswordDialog(context, isDarkMode);
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.email,
            "Email Address",
            "admin@citygeneralhospital.com",
            Colors.purple,
            isDarkMode,
            onTap: () {
              // TODO: Change email
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(BuildContext context, bool isDarkMode) {
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
          _buildSwitchTile(
            context,
            Icons.email_outlined,
            "Email Notifications",
            "Receive notifications via email",
            Colors.blue,
            isDarkMode,
            _emailNotifications,
                (value) {
              setState(() {
                _emailNotifications = value;
              });
            },
          ),
          _buildDivider(isDarkMode),
          _buildSwitchTile(
            context,
            Icons.sms_outlined,
            "SMS Notifications",
            "Receive notifications via SMS",
            Colors.green,
            isDarkMode,
            _smsNotifications,
                (value) {
              setState(() {
                _smsNotifications = value;
              });
            },
          ),
          _buildDivider(isDarkMode),
          _buildSwitchTile(
            context,
            Icons.notifications_active,
            "Appointment Reminders",
            "Get reminded about appointments",
            Colors.orange,
            isDarkMode,
            _appointmentReminders,
                (value) {
              setState(() {
                _appointmentReminders = value;
              });
            },
          ),
          _buildDivider(isDarkMode),
          _buildSwitchTile(
            context,
            Icons.campaign,
            "Marketing Emails",
            "Receive promotional content",
            Colors.purple,
            isDarkMode,
            _marketingEmails,
                (value) {
              setState(() {
                _marketingEmails = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPreferences(BuildContext context, bool isDarkMode) {
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
          _buildSwitchTile(
            context,
            Icons.dark_mode,
            "Dark Mode",
            "Switch to dark theme",
            Colors.indigo,
            isDarkMode,
            _darkMode,
                (value) {
              setState(() {
                _darkMode = value;
              });
              // TODO: Implement theme toggle
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.language,
            "Language",
            "English",
            Colors.blue,
            isDarkMode,
            onTap: () {
              _showLanguageDialog(context, isDarkMode);
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.access_time,
            "Time Zone",
            "GMT-5 (Eastern Time)",
            Colors.green,
            isDarkMode,
            onTap: () {
              // TODO: Change timezone
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.calendar_today,
            "Date Format",
            "MM/DD/YYYY",
            Colors.orange,
            isDarkMode,
            onTap: () {
              // TODO: Change date format
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySettings(BuildContext context, bool isDarkMode) {
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
          _buildSwitchTile(
            context,
            Icons.verified_user,
            "Two-Factor Authentication",
            "Add extra security to your account",
            Colors.red,
            isDarkMode,
            _twoFactorAuth,
                (value) {
              setState(() {
                _twoFactorAuth = value;
              });
              if (value) {
                _show2FADialog(context, isDarkMode);
              }
            },
          ),
          _buildDivider(isDarkMode),
          _buildSwitchTile(
            context,
            Icons.fingerprint,
            "Fingerprint Authentication",
            "Use fingerprint to login",
            Colors.blue,
            isDarkMode,
            _fingerprintAuth,
                (value) {
              setState(() {
                _fingerprintAuth = value;
              });
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.devices,
            "Active Sessions",
            "Manage your active devices",
            Colors.purple,
            isDarkMode,
            onTap: () {
              _showActiveSessionsDialog(context, isDarkMode);
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.history,
            "Login History",
            "View recent login activity",
            Colors.orange,
            isDarkMode,
            onTap: () {
              // TODO: Show login history
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.shield,
            "Privacy Policy",
            "Read our privacy policy",
            Colors.green,
            isDarkMode,
            onTap: () {
              // TODO: Show privacy policy
            },
          ),
        ],
      ),
    );
  }

  Widget _buildManagementSettings(BuildContext context, bool isDarkMode) {
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
          _buildSettingTile(
            context,
            Icons.medical_services,
            "Doctor Management",
            "Manage doctors and staff",
            Colors.blue,
            isDarkMode,
            onTap: () {
              // TODO: Navigate to doctor management
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.business_center,
            "Department Settings",
            "Configure departments",
            Colors.green,
            isDarkMode,
            onTap: () {
              // TODO: Navigate to department settings
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.schedule,
            "Operating Hours",
            "Set hospital working hours",
            Colors.orange,
            isDarkMode,
            onTap: () {
              // TODO: Navigate to operating hours
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.payment,
            "Payment Settings",
            "Configure payment methods",
            Colors.purple,
            isDarkMode,
            onTap: () {
              // TODO: Navigate to payment settings
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.attach_money,
            "Billing & Invoices",
            "Manage billing information",
            Colors.teal,
            isDarkMode,
            onTap: () {
              // TODO: Navigate to billing
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDataSettings(BuildContext context, bool isDarkMode) {
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
          _buildSwitchTile(
            context,
            Icons.backup,
            "Auto Backup",
            "Automatically backup data daily",
            Colors.blue,
            isDarkMode,
            _autoBackup,
                (value) {
              setState(() {
                _autoBackup = value;
              });
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.cloud_upload,
            "Backup Now",
            "Manually backup your data",
            Colors.green,
            isDarkMode,
            onTap: () {
              _showBackupDialog(context, isDarkMode);
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.cloud_download,
            "Restore Data",
            "Restore from previous backup",
            Colors.orange,
            isDarkMode,
            onTap: () {
              _showRestoreDialog(context, isDarkMode);
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.file_download,
            "Export Data",
            "Download all hospital data",
            Colors.purple,
            isDarkMode,
            onTap: () {
              _showExportDialog(context, isDarkMode);
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.storage,
            "Storage Usage",
            "2.3 GB of 10 GB used",
            Colors.indigo,
            isDarkMode,
            onTap: () {
              // TODO: Show storage details
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSettings(BuildContext context, bool isDarkMode) {
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
          _buildSettingTile(
            context,
            Icons.help_outline,
            "Help Center",
            "Get help and support",
            Colors.blue,
            isDarkMode,
            onTap: () {
              // TODO: Navigate to help center
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.chat_bubble_outline,
            "Contact Support",
            "Chat with our support team",
            Colors.green,
            isDarkMode,
            onTap: () {
              // TODO: Open support chat
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.feedback_outlined,
            "Send Feedback",
            "Share your suggestions",
            Colors.orange,
            isDarkMode,
            onTap: () {
              // TODO: Open feedback form
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.article_outlined,
            "Terms & Conditions",
            "Read our terms of service",
            Colors.purple,
            isDarkMode,
            onTap: () {
              // TODO: Show terms
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.info_outline,
            "About",
            "Version 1.0.0",
            Colors.indigo,
            isDarkMode,
            onTap: () {
              _showAboutDialog(context, isDarkMode);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZone(BuildContext context, bool isDarkMode) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          _buildSettingTile(
            context,
            Icons.delete_forever,
            "Delete All Data",
            "Permanently delete all hospital data",
            Colors.red,
            isDarkMode,
            onTap: () {
              _showDeleteDataDialog(context, isDarkMode);
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.cancel,
            "Deactivate Account",
            "Temporarily deactivate hospital account",
            Colors.orange,
            isDarkMode,
            onTap: () {
              _showDeactivateDialog(context, isDarkMode);
            },
          ),
          _buildDivider(isDarkMode),
          _buildSettingTile(
            context,
            Icons.logout,
            "Logout",
            "Sign out from all devices",
            Colors.red,
            isDarkMode,
            onTap: () {
              _showLogoutDialog(context, isDarkMode);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle,
      Color color,
      bool isDarkMode, {
        VoidCallback? onTap,
      }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
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

  Widget _buildSwitchTile(
      BuildContext context,
      IconData icon,
      String title,
      String subtitle,
      Color color,
      bool isDarkMode,
      bool value,
      ValueChanged<bool> onChanged,
      ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: color,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      height: 1,
      color: isDarkMode ? Colors.grey[700] : Colors.grey[200],
    );
  }

  // Dialog methods
  void _showChangePasswordDialog(BuildContext context, bool isDarkMode) {
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
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.lock, color: Colors.orange),
              ),
              const SizedBox(width: 16),
              const Text("Change Password"),
            ],
          ),
          content: const Text(
            "This will open the change password form.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Navigate to change password form
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text("Continue"),
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context, bool isDarkMode) {
    final languages = ["English", "Spanish", "French", "German", "Chinese"];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Select Language"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: languages
                .map((lang) => RadioListTile(
              title: Text(lang),
              value: lang,
              groupValue: "English",
              onChanged: (value) {
                Navigator.pop(context);
              },
            ))
                .toList(),
          ),
        );
      },
    );
  }

  void _show2FADialog(BuildContext context, bool isDarkMode) {
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
                child: const Icon(Icons.verified_user, color: Colors.red),
              ),
              const SizedBox(width: 16),
              const Expanded(child: Text("Enable 2FA")),
            ],
          ),
          content: const Text(
            "Two-factor authentication adds an extra layer of security to your account. You'll need to verify your identity with a code sent to your phone.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _twoFactorAuth = false;
                });
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Setup 2FA
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Setup"),
            ),
          ],
        );
      },
    );
  }

  void _showActiveSessionsDialog(BuildContext context, bool isDarkMode) {
    final sessions = [
      {"device": "iPhone 13 Pro", "location": "New York, USA", "time": "Active now"},
      {"device": "MacBook Pro", "location": "New York, USA", "time": "2 hours ago"},
      {"device": "iPad Air", "location": "New York, USA", "time": "Yesterday"},
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Active Sessions"),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: sessions.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final session = sessions[index];
                return ListTile(
                  leading: const Icon(Icons.devices),
                  title: Text(session["device"]!),
                  subtitle: Text("${session["location"]} • ${session["time"]}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.logout, color: Colors.red),
                    onPressed: () {
                      // TODO: End session
                    },
                  ),
                );
              },
            ),
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

  void _showBackupDialog(BuildContext context, bool isDarkMode) {
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
                child: const Icon(Icons.cloud_upload, color: Colors.green),
              ),
              const SizedBox(width: 16),
              const Text("Backup Data"),
            ],
          ),
          content: const Text(
            "This will create a backup of all your hospital data. The backup will be stored securely in the cloud.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Initiate backup
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Backup started..."),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text("Backup"),
            ),
          ],
        );
      },
    );
  }

  void _showRestoreDialog(BuildContext context, bool isDarkMode) {
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
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.cloud_download, color: Colors.orange),
              ),
              const SizedBox(width: 16),
              const Text("Restore Data"),
            ],
          ),
          content: const Text(
            "Warning: This will replace all current data with the backup. This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Initiate restore
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text("Restore"),
            ),
          ],
        );
      },
    );
  }

  void _showExportDialog(BuildContext context, bool isDarkMode) {
    final formats = ["CSV", "Excel", "PDF", "JSON"];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Export Data"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Select export format:"),
              const SizedBox(height: 16),
              ...formats.map((format) => RadioListTile(
                title: Text(format),
                value: format,
                groupValue: "CSV",
                onChanged: (value) {
                  Navigator.pop(context);
                  // TODO: Export in selected format
                },
              )),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDataDialog(BuildContext context, bool isDarkMode) {
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
                child: const Icon(Icons.delete_forever, color: Colors.red),
              ),
              const SizedBox(width: 16),
              const Expanded(child: Text("Delete All Data")),
            ],
          ),
          content: const Text(
            "WARNING: This will permanently delete all hospital data including appointments, patients, and records. This action CANNOT be undone!",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Delete all data
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Delete Everything"),
            ),
          ],
        );
      },
    );
  }

  void _showDeactivateDialog(BuildContext context, bool isDarkMode) {
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
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.cancel, color: Colors.orange),
              ),
              const SizedBox(width: 16),
              const Text("Deactivate Account"),
            ],
          ),
          content: const Text(
            "Your account will be temporarily deactivated. You can reactivate it anytime by logging in again.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Deactivate account
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              child: const Text("Deactivate"),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, bool isDarkMode) {
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
                child: const Icon(Icons.logout, color: Colors.red),
              ),
              const SizedBox(width: 16),
              const Text("Logout"),
            ],
          ),
          content: const Text(
            "Are you sure you want to logout from all devices?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context, bool isDarkMode) {
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
              Icon(
                Icons.local_hospital,
                color: Theme.of(context).primaryColor,
                size: 32,
              ),
              const SizedBox(width: 16),
              const Text("About"),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "MedConnect",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Version 1.0.0",
                style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Hospital Appointment Booking & Management System",
              ),
              const SizedBox(height: 16),
              const Text(
                "© 2026 MedConnect. All rights reserved.",
                style: TextStyle(fontSize: 12),
              ),
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