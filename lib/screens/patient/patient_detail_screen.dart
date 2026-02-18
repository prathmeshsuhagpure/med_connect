import 'package:flutter/material.dart';
import 'package:med_connect/models/user/patient_model.dart';

class PatientDetailScreen extends StatefulWidget {
  final PatientModel? patient;
  const PatientDetailScreen({super.key, this.patient});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : const Color(0xFFFAFAF8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FadeTransition(
            opacity: _fadeController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isDarkMode),
                const SizedBox(height: 24),
                _buildStatusBanner(isDarkMode),
                const SizedBox(height: 24),
                _buildMainContent(isDarkMode),
                const SizedBox(height: 24),
                _buildBottomGrid(isDarkMode),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    final textColor = isDarkMode ? Colors.white : const Color(0xFF1A1C1E);
    final subtitleColor = isDarkMode
        ? Colors.grey[400]
        : const Color(0xFF625B71);
    final surfaceColor = isDarkMode ? Colors.grey[900] : Colors.white;

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, -0.1), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: _slideController,
              curve: Curves.easeOutCubic,
            ),
          ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 650;

            return isMobile
                ? _buildMobileLayout(isDarkMode, textColor, subtitleColor)
                : _buildDesktopLayout(isDarkMode, textColor, subtitleColor);
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
      bool isDarkMode,
      Color textColor,
      Color? subtitleColor,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Section: Avatar and Name
        Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Sarah Chen',
                    overflow: TextOverflow.ellipsis, // Prevents long name overflow
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildStatusBadge('Active Patient', Colors.green),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Bottom Section: Info and Actions
        // We use Wrap instead of Row here to ensure that if the buttons
        // are too wide for the phone, they drop to the next line safely.
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 12, // Horizontal space between info and buttons
          runSpacing: 16, // Vertical space if they wrap
          children: [
            // Constrain the text block so it doesn't push the buttons
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Female • 34 years',
                  style: TextStyle(color: subtitleColor, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'MRN: 987654321',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            // Action buttons now have room to exist
            _buildActionButtons(isDarkMode),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(
    bool isDarkMode,
    Color textColor,
    Color? subtitleColor,
  ) {
    return Row(
      children: [
        _buildAvatar(),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Sarah Chen',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildStatusBadge('Active', Colors.green),
                ],
              ),
              const SizedBox(height: 8),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 15,
                  color: subtitleColor,
                  fontWeight: FontWeight.w400,
                ),
                child: Row(
                  children: [
                    const Text('Female'),
                    _buildDotSeparator(isDarkMode),
                    const Text('34 years old'),
                    _buildDotSeparator(isDarkMode),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? Colors.blueAccent.withValues(alpha: 0.2)
                            : Colors.blue[50],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'MRN: 987654321',
                        style: TextStyle(
                          color: isDarkMode
                              ? Colors.blue[200]
                              : Colors.blue[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buildActionButtons(isDarkMode),
      ],
    );
  }

  // Helper for the "Dot" separator
  Widget _buildDotSeparator(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Icon(
        Icons.circle,
        size: 4,
        color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
      ),
    );
  }

  // Helper for Status Tags
  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00B4A0), Color(0xFF0A2540)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'SC',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(bool isDarkMode) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildButton(
          '📋 Records',
          isPrimary: false,
          onTap: () {},
          isDarkMode: isDarkMode,
        ),
        const SizedBox(width: 12),
        _buildButton(
          '📅 Schedule',
          isPrimary: true,
          onTap: () {},
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }

  Widget _buildButton(
    String label, {
    required bool isPrimary,
    required VoidCallback onTap,
    required bool isDarkMode,
  }) {
    return Material(
      color: isPrimary
          ? Theme.of(context).primaryColor
          : (isDarkMode ? Colors.grey[850] : Colors.white),
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isPrimary
                ? null
                : Border.all(
                    color: isDarkMode
                        ? Colors.grey[700]!
                        : const Color(0xFFE8E8E6),
                    width: 1.5,
                  ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isPrimary
                  ? Colors.white
                  : (isDarkMode ? Colors.grey[300] : const Color(0xFF1A1A1A)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBanner(bool isDarkMode) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-30 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.orange.withValues(alpha: 0.1)
                    : const Color(0xFFFFF9F0),
                borderRadius: BorderRadius.circular(12),
                border: Border(
                  left: BorderSide(
                    color: isDarkMode ? Colors.orange : const Color(0xFFFFB84D),
                    width: 4,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.orange.withValues(alpha: 0.2)
                          : const Color(0xFFFFB84D),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text('⚠️', style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upcoming Appointment',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Annual physical examination scheduled for Feb 15, 2026 at 10:00 AM with Dr. Martinez',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : const Color(0xFF6B6B6B),
                          ),
                        ),
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

  Widget _buildMainContent(bool isDarkMode) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildVitalSigns(isDarkMode),
                    const SizedBox(height: 24),
                    _buildMedicalHistory(isDarkMode),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(child: _buildQuickInfo(isDarkMode)),
            ],
          );
        } else {
          return Column(
            children: [
              _buildVitalSigns(isDarkMode),
              const SizedBox(height: 24),
              _buildQuickInfo(isDarkMode),
              const SizedBox(height: 24),
              _buildMedicalHistory(isDarkMode),
            ],
          );
        }
      },
    );
  }

  Widget _buildVitalSigns(bool isDarkMode) {
    return _buildCard(
      title: 'Vital Signs',
      action: 'Update →',
      isDarkMode: isDarkMode,
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.4,
        children: [
          _buildVitalItem('Blood Pressure', '118/76', 'Normal', 0, isDarkMode),
          _buildVitalItem('Heart Rate', '72', 'Normal', 1, isDarkMode),
          _buildVitalItem('Temperature', '98.6°F', 'Normal', 2, isDarkMode),
          _buildVitalItem('Oxygen Sat.', '98%', 'Normal', 3, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildVitalItem(
    String label,
    String value,
    String status,
    int index,
    bool isDarkMode,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: 0.9 + (0.1 * animValue),
          child: Opacity(
            opacity: animValue,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : const Color(0xFFFAFAF8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDarkMode
                      ? Colors.grey[700]!
                      : const Color(0xFFE8E8E6),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      color: isDarkMode
                          ? Colors.grey[400]
                          : const Color(0xFF6B6B6B),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? Colors.white
                          : const Color(0xFF0A2540),
                      height: 1,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF00B4A0),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF00B4A0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMedicalHistory(bool isDarkMode) {
    return _buildCard(
      title: 'Recent Medical History',
      action: 'View All →',
      isDarkMode: isDarkMode,
      child: Column(
        children: [
          _buildTimelineItem(
            'Jan 15, 2026',
            'Annual Wellness Visit',
            'Routine checkup, all vital signs normal. Bloodwork ordered.',
            0,
            isDarkMode,
          ),
          _buildTimelineItem(
            'Oct 8, 2025',
            'Flu Vaccination',
            'Administered seasonal influenza vaccine. No adverse reactions.',
            1,
            isDarkMode,
          ),
          _buildTimelineItem(
            'Jun 22, 2025',
            'Follow-up Consultation',
            'Migraine management review. Medication adjusted.',
            2,
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    String date,
    String title,
    String description,
    int index,
    bool isDarkMode,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, animValue, child) {
        return Transform.translate(
          offset: Offset(-20 * (1 - animValue), 0),
          child: Opacity(
            opacity: animValue,
            child: Padding(
              padding: const EdgeInsets.only(left: 32, bottom: 24),
              child: Stack(
                children: [
                  Positioned(
                    left: -24,
                    top: 4,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF00B4A0),
                        border: Border.all(
                          color: isDarkMode ? Colors.grey[850]! : Colors.white,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                  if (index < 2)
                    Positioned(
                      left: -17,
                      top: 20,
                      bottom: -24,
                      child: Container(
                        width: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF00B4A0),
                              const Color(0xFF00B4A0).withValues(alpha: 0.2),
                            ],
                          ),
                        ),
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? Colors.grey[500]
                              : const Color(0xFF999999),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDarkMode
                              ? Colors.grey[400]
                              : const Color(0xFF6B6B6B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickInfo(bool isDarkMode) {
    return Column(
      children: [
        _buildCard(
          title: 'Patient Information',
          isDarkMode: isDarkMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoItem(
                'DATE OF BIRTH',
                'March 12, 1992',
                isLarge: true,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 20),
              _buildInfoItem(
                'BLOOD TYPE',
                'A+',
                isLarge: true,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 20),
              _buildInfoItem(
                'CONTACT',
                '(555) 123-4567\nsarah.chen@email.com',
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 20),
              _buildInfoItem(
                'ADDRESS',
                '742 Evergreen Terrace\nSpringfield, IL 62701',
                isDarkMode: isDarkMode,
              ),
              const SizedBox(height: 20),
              _buildInfoItem(
                'EMERGENCY CONTACT',
                'James Chen (Spouse)\n(555) 987-6543',
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildCard(
          title: 'Allergies',
          action: 'Edit →',
          isDarkMode: isDarkMode,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag('Penicillin', isWarning: true, isDarkMode: isDarkMode),
              _buildTag('Shellfish', isWarning: true, isDarkMode: isDarkMode),
              _buildTag('Latex', isWarning: true, isDarkMode: isDarkMode),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildCard(
          title: 'Conditions',
          action: 'Edit →',
          isDarkMode: isDarkMode,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTag('Migraine', isWarning: false, isDarkMode: isDarkMode),
              _buildTag(
                'Seasonal Allergies',
                isWarning: false,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    String label,
    String value, {
    bool isLarge = false,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDarkMode ? Colors.grey[500] : const Color(0xFF999999),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: isLarge ? 16 : 14,
            fontWeight: isLarge ? FontWeight.w600 : FontWeight.w500,
            color: isLarge
                ? (isDarkMode ? Colors.white : const Color(0xFF0A2540))
                : (isDarkMode ? Colors.grey[300] : const Color(0xFF1A1A1A)),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTag(
    String label, {
    required bool isWarning,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isWarning
            ? (isDarkMode
                  ? Colors.red.withValues(alpha: 0.2)
                  : const Color(0xFFFFF5F5))
            : (isDarkMode
                  ? Colors.blue.withValues(alpha: 0.2)
                  : const Color(0xFFF0F9FF)),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isWarning ? const Color(0xFFFF6B6B) : const Color(0xFF0284C7),
          width: 1.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isWarning ? const Color(0xFFFF6B6B) : const Color(0xFF0284C7),
        ),
      ),
    );
  }

  Widget _buildBottomGrid(bool isDarkMode) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildMedications(isDarkMode)),
              const SizedBox(width: 24),
              Expanded(child: _buildLabResults(isDarkMode)),
            ],
          );
        } else {
          return Column(
            children: [
              _buildMedications(isDarkMode),
              const SizedBox(height: 24),
              _buildLabResults(isDarkMode),
            ],
          );
        }
      },
    );
  }

  Widget _buildMedications(bool isDarkMode) {
    return _buildCard(
      title: 'Current Medications',
      action: 'Manage →',
      isDarkMode: isDarkMode,
      child: Column(
        children: [
          _buildMedicationItem(
            'Sumatriptan',
            '50mg',
            'As needed for migraine',
            'Active',
            0,
            isDarkMode,
          ),
          const SizedBox(height: 16),
          _buildMedicationItem(
            'Loratadine',
            '10mg',
            'Once daily',
            'Active',
            1,
            isDarkMode,
          ),
          const SizedBox(height: 16),
          _buildMedicationItem(
            'Multivitamin',
            'Daily supplement',
            '',
            'Active',
            2,
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationItem(
    String name,
    String dosage,
    String frequency,
    String status,
    int index,
    bool isDarkMode,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * animValue),
          child: Opacity(
            opacity: animValue,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : const Color(0xFFFAFAF8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDarkMode
                      ? Colors.grey[700]!
                      : const Color(0xFFE8E8E6),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF0A2540),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F9F7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF00B4A0),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        dosage,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDarkMode
                              ? Colors.grey[400]
                              : const Color(0xFF6B6B6B),
                        ),
                      ),
                      if (frequency.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : const Color(0xFF6B6B6B),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            frequency,
                            style: TextStyle(
                              fontSize: 13,
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : const Color(0xFF6B6B6B),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLabResults(bool isDarkMode) {
    return _buildCard(
      title: 'Recent Lab Results',
      action: 'View All →',
      isDarkMode: isDarkMode,
      child: Column(
        children: [
          _buildLabResultRow(
            'Glucose',
            '92',
            'mg/dL',
            '70-100',
            'Normal',
            isDarkMode,
          ),
          const SizedBox(height: 8),
          _buildLabResultRow(
            'Cholesterol',
            '185',
            'mg/dL',
            '<200',
            'Normal',
            isDarkMode,
          ),
          const SizedBox(height: 8),
          _buildLabResultRow(
            'Hemoglobin',
            '13.8',
            'g/dL',
            '12-16',
            'Normal',
            isDarkMode,
          ),
          const SizedBox(height: 8),
          _buildLabResultRow(
            'WBC',
            '7.2',
            'K/µL',
            '4-11',
            'Normal',
            isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildLabResultRow(
    String test,
    String value,
    String unit,
    String range,
    String status,
    bool isDarkMode,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : const Color(0xFFFAFAF8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              test,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : const Color(0xFF1A1A1A),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? Colors.white
                          : const Color(0xFF0A2540),
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode
                          ? Colors.grey[400]
                          : const Color(0xFF6B6B6B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Text(
              range,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.grey[400] : const Color(0xFF6B6B6B),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF00B4A0),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                status,
                style: const TextStyle(fontSize: 13, color: Color(0xFF00B4A0)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    String? action,
    required Widget child,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : const Color(0xFFE8E8E6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : const Color(0xFF0A2540),
                ),
              ),
              if (action != null)
                InkWell(
                  onTap: () {},
                  child: Text(
                    action,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF00B4A0),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
