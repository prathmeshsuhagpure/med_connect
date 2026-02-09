import 'package:flutter/material.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({super.key});

  @override
  State<AddDoctorScreen> createState() => _AddDoctorScreenState();
}

class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _feeController = TextEditingController();
  final _bioController = TextEditingController();
  final _addressController = TextEditingController();
  final _licenseController = TextEditingController();

  // Dropdown values
  String? _selectedSpecialization;
  String? _selectedDepartment;
  String? _selectedGender;

  // Availability
  final Map<String, bool> _availability = {
    'Monday': true,
    'Tuesday': true,
    'Wednesday': true,
    'Thursday': true,
    'Friday': true,
    'Saturday': false,
    'Sunday': false,
  };

  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 0);

  // Lists
  final List<String> _specializations = [
    "Cardiology",
    "Orthopedic",
    "Dermatology",
    "Pediatrics",
    "Neurology",
    "ENT",
    "General Medicine",
    "Gynecology",
    "Dentistry",
    "Psychiatry",
  ];

  final List<String> _departments = [
    "General OPD",
    "Emergency",
    "ICU",
    "Surgery",
    "Radiology",
    "Laboratory",
  ];

  final List<String> _genders = ["Male", "Female", "Other"];

  bool _isActive = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _qualificationController.dispose();
    _experienceController.dispose();
    _feeController.dispose();
    _bioController.dispose();
    _addressController.dispose();
    _licenseController.dispose();
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
          "Add New Doctor",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture Section
              _buildProfilePictureSection(context, isDarkMode),
              const SizedBox(height: 32),

              // Basic Information
              _buildSectionTitle(context, "Basic Information", Icons.person),
              const SizedBox(height: 16),
              _buildBasicInfoSection(isDarkMode, isMobile),
              const SizedBox(height: 32),

              // Professional Details
              _buildSectionTitle(context, "Professional Details", Icons.work),
              const SizedBox(height: 16),
              _buildProfessionalSection(isDarkMode, isMobile),
              const SizedBox(height: 32),

              // Contact Information
              _buildSectionTitle(context, "Contact Information", Icons.contact_phone),
              const SizedBox(height: 16),
              _buildContactSection(isDarkMode),
              const SizedBox(height: 32),

              // Availability Schedule
              _buildSectionTitle(context, "Availability Schedule", Icons.calendar_today),
              const SizedBox(height: 16),
              _buildAvailabilitySection(isDarkMode),
              const SizedBox(height: 32),

              // Status
              _buildSectionTitle(context, "Status", Icons.toggle_on),
              const SizedBox(height: 16),
              _buildStatusSection(isDarkMode),
              const SizedBox(height: 40),

              // Submit Button
              _buildSubmitButton(isDarkMode),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection(BuildContext context, bool isDarkMode) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode
                      ? Colors.grey[800]
                      : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                ),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: isDarkMode
                      ? Colors.grey[600]
                      : Theme.of(context).primaryColor,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    _showImagePickerOptions(context, isDarkMode);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Upload Doctor Photo",
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 24,
          color: Theme.of(context).primaryColor,
        ),
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

  Widget _buildBasicInfoSection(bool isDarkMode, bool isMobile) {
    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          label: "Full Name",
          icon: Icons.person_outline,
          isDarkMode: isDarkMode,
          validator: _requiredValidator,
          hint: "Dr. John Smith",
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: "Gender",
          value: _selectedGender,
          items: _genders,
          icon: Icons.wc_outlined,
          isDarkMode: isDarkMode,
          onChanged: (value) {
            setState(() => _selectedGender = value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select gender";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _bioController,
          label: "Bio / About",
          icon: Icons.info_outline,
          isDarkMode: isDarkMode,
          maxLines: 3,
          hint: "Brief description about the doctor",
        ),
      ],
    );
  }

  Widget _buildProfessionalSection(bool isDarkMode, bool isMobile) {
    return Column(
      children: [
        _buildDropdown(
          label: "Specialization",
          value: _selectedSpecialization,
          items: _specializations,
          icon: Icons.local_hospital_outlined,
          isDarkMode: isDarkMode,
          onChanged: (value) {
            setState(() => _selectedSpecialization = value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select specialization";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: "Department",
          value: _selectedDepartment,
          items: _departments,
          icon: Icons.apartment_outlined,
          isDarkMode: isDarkMode,
          onChanged: (value) {
            setState(() => _selectedDepartment = value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select department";
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _qualificationController,
          label: "Qualification",
          icon: Icons.school_outlined,
          isDarkMode: isDarkMode,
          validator: _requiredValidator,
          hint: "MBBS, MD",
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _licenseController,
          label: "Medical License Number",
          icon: Icons.badge_outlined,
          isDarkMode: isDarkMode,
          validator: _requiredValidator,
          hint: "MED123456",
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _experienceController,
                label: "Experience (years)",
                icon: Icons.timeline_outlined,
                keyboardType: TextInputType.number,
                isDarkMode: isDarkMode,
                validator: _numberValidator,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _feeController,
                label: "Consultation Fee (\$)",
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                isDarkMode: isDarkMode,
                validator: _numberValidator,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactSection(bool isDarkMode) {
    return Column(
      children: [
        _buildTextField(
          controller: _emailController,
          label: "Email Address",
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          isDarkMode: isDarkMode,
          validator: _emailValidator,
          hint: "doctor@hospital.com",
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _phoneController,
          label: "Phone Number",
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          isDarkMode: isDarkMode,
          validator: _requiredValidator,
          hint: "+1 234 567 8900",
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _addressController,
          label: "Address",
          icon: Icons.location_on_outlined,
          isDarkMode: isDarkMode,
          maxLines: 2,
          hint: "Clinic/Hospital address",
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection(bool isDarkMode) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Working Days",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availability.keys.map((day) {
              final isSelected = _availability[day]!;
              return FilterChip(
                label: Text(day.substring(0, 3)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _availability[day] = selected;
                  });
                },
                selectedColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                checkmarkColor: Theme.of(context).primaryColor,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text(
            "Working Hours",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTimeSelector(
                  context,
                  "Start Time",
                  _startTime,
                  isDarkMode,
                      (time) {
                    setState(() => _startTime = time);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTimeSelector(
                  context,
                  "End Time",
                  _endTime,
                  isDarkMode,
                      (time) {
                    setState(() => _endTime = time);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(
      BuildContext context,
      String label,
      TimeOfDay time,
      bool isDarkMode,
      Function(TimeOfDay) onTimeSelected,
      ) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: time,
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
          onTimeSelected(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
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
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  time.format(context),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.grey[800],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isActive ? Icons.check_circle : Icons.cancel,
            color: _isActive ? Colors.green : Colors.red,
            size: 28,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isActive ? "Active" : "Inactive",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _isActive ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isActive
                      ? "Doctor will be available for appointments"
                      : "Doctor will not be available for appointments",
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isActive,
            onChanged: (value) {
              setState(() => _isActive = value);
            },
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDarkMode,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    String? hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required bool isDarkMode,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildSubmitButton(bool isDarkMode) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          disabledBackgroundColor: Colors.grey[400],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        child: _isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 24),
            SizedBox(width: 12),
            Text(
              "Add Doctor",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showImagePickerOptions(BuildContext context, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Choose Profile Picture",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                _buildImageOption(
                  context,
                  Icons.camera_alt,
                  "Take Photo",
                  isDarkMode,
                      () {
                    Navigator.pop(context);
                    // TODO: Implement camera
                  },
                ),
                const SizedBox(height: 12),
                _buildImageOption(
                  context,
                  Icons.photo_library,
                  "Choose from Gallery",
                  isDarkMode,
                      () {
                    Navigator.pop(context);
                    // TODO: Implement gallery picker
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageOption(
      BuildContext context,
      IconData icon,
      String label,
      bool isDarkMode,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Validators
  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    if (!value.contains('@') || !value.contains('.')) {
      return "Enter a valid email address";
    }
    return null;
  }

  String? _numberValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "This field is required";
    }
    if (int.tryParse(value) == null) {
      return "Enter a valid number";
    }
    return null;
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Check if at least one day is selected
      if (!_availability.values.any((isSelected) => isSelected)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Text("Please select at least one working day"),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() => _isLoading = false);

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  "Dr. ${_nameController.text} added successfully!",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            action: SnackBarAction(
              label: "View",
              textColor: Colors.white,
              onPressed: () {
                // TODO: Navigate to doctor details
              },
            ),
          ),
        );

        // Navigate back
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      }
    }
  }
}