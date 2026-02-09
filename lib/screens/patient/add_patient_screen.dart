import 'package:flutter/material.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  // Personal Information Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();

  // Medical Information Controllers
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _conditionsController = TextEditingController();
  final _notesController = TextEditingController();

  // Emergency Contact Controllers
  final _emergencyNameController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _emergencyRelationController = TextEditingController();

  // Dropdown values
  String? _selectedGender;
  String? _selectedBloodType;
  DateTime? _dateOfBirth;

  final List<String> _genders = ["Male", "Female", "Other"];
  final List<String> _bloodTypes = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];

  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    _conditionsController.dispose();
    _notesController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationController.dispose();
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
          "Add New Patient",
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

              // Personal Information
              _buildSectionTitle(context, "Personal Information", Icons.person),
              const SizedBox(height: 16),
              _buildPersonalInfoSection(isDarkMode, isMobile),
              const SizedBox(height: 32),

              // Contact Information
              _buildSectionTitle(context, "Contact Information", Icons.contact_phone),
              const SizedBox(height: 16),
              _buildContactSection(isDarkMode, isMobile),
              const SizedBox(height: 32),

              // Medical Information
              _buildSectionTitle(context, "Medical Information", Icons.medical_services),
              const SizedBox(height: 16),
              _buildMedicalSection(isDarkMode, isMobile),
              const SizedBox(height: 32),

              // Emergency Contact
              _buildSectionTitle(context, "Emergency Contact", Icons.emergency),
              const SizedBox(height: 16),
              _buildEmergencyContactSection(isDarkMode),
              const SizedBox(height: 32),

              // Additional Notes
              _buildSectionTitle(context, "Additional Notes", Icons.note),
              const SizedBox(height: 16),
              _buildNotesSection(isDarkMode),
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
            "Upload Patient Photo",
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

  Widget _buildPersonalInfoSection(bool isDarkMode, bool isMobile) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _firstNameController,
                label: "First Name",
                icon: Icons.person_outline,
                isDarkMode: isDarkMode,
                validator: _requiredValidator,
                hint: "John",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _lastNameController,
                label: "Last Name",
                icon: Icons.person_outline,
                isDarkMode: isDarkMode,
                validator: _requiredValidator,
                hint: "Doe",
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
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
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDatePicker(
                context,
                "Date of Birth",
                _dateOfBirth,
                isDarkMode,
                    (date) {
                  setState(() => _dateOfBirth = date);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildDropdown(
          label: "Blood Type",
          value: _selectedBloodType,
          items: _bloodTypes,
          icon: Icons.bloodtype,
          isDarkMode: isDarkMode,
          onChanged: (value) {
            setState(() => _selectedBloodType = value);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select blood type";
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildContactSection(bool isDarkMode, bool isMobile) {
    return Column(
      children: [
        _buildTextField(
          controller: _emailController,
          label: "Email Address",
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          isDarkMode: isDarkMode,
          validator: _emailValidator,
          hint: "patient@example.com",
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
          label: "Street Address",
          icon: Icons.location_on_outlined,
          isDarkMode: isDarkMode,
          validator: _requiredValidator,
          hint: "123 Main Street",
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildTextField(
                controller: _cityController,
                label: "City",
                icon: Icons.location_city,
                isDarkMode: isDarkMode,
                validator: _requiredValidator,
                hint: "New York",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _stateController,
                label: "State",
                icon: Icons.map_outlined,
                isDarkMode: isDarkMode,
                validator: _requiredValidator,
                hint: "NY",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _zipController,
                label: "ZIP Code",
                icon: Icons.pin_outlined,
                keyboardType: TextInputType.number,
                isDarkMode: isDarkMode,
                validator: _requiredValidator,
                hint: "10001",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMedicalSection(bool isDarkMode, bool isMobile) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _heightController,
                label: "Height (cm)",
                icon: Icons.height,
                keyboardType: TextInputType.number,
                isDarkMode: isDarkMode,
                hint: "170",
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                controller: _weightController,
                label: "Weight (kg)",
                icon: Icons.monitor_weight_outlined,
                keyboardType: TextInputType.number,
                isDarkMode: isDarkMode,
                hint: "70",
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _allergiesController,
          label: "Allergies",
          icon: Icons.warning_amber_outlined,
          isDarkMode: isDarkMode,
          maxLines: 2,
          hint: "List any known allergies (e.g., Penicillin, Peanuts)",
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _medicationsController,
          label: "Current Medications",
          icon: Icons.medication_outlined,
          isDarkMode: isDarkMode,
          maxLines: 2,
          hint: "List current medications",
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _conditionsController,
          label: "Medical Conditions",
          icon: Icons.local_hospital_outlined,
          isDarkMode: isDarkMode,
          maxLines: 2,
          hint: "List any existing medical conditions",
        ),
      ],
    );
  }

  Widget _buildEmergencyContactSection(bool isDarkMode) {
    return Column(
      children: [
        _buildTextField(
          controller: _emergencyNameController,
          label: "Contact Name",
          icon: Icons.person_outline,
          isDarkMode: isDarkMode,
          validator: _requiredValidator,
          hint: "Jane Doe",
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emergencyPhoneController,
          label: "Contact Phone",
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          isDarkMode: isDarkMode,
          validator: _requiredValidator,
          hint: "+1 234 567 8900",
        ),
        const SizedBox(height: 16),
        _buildTextField(
          controller: _emergencyRelationController,
          label: "Relationship",
          icon: Icons.family_restroom,
          isDarkMode: isDarkMode,
          validator: _requiredValidator,
          hint: "Spouse, Parent, Sibling, etc.",
        ),
      ],
    );
  }

  Widget _buildNotesSection(bool isDarkMode) {
    return _buildTextField(
      controller: _notesController,
      label: "Additional Notes",
      icon: Icons.note_outlined,
      isDarkMode: isDarkMode,
      maxLines: 4,
      hint: "Any additional information about the patient",
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
      initialValue: value,
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

  Widget _buildDatePicker(
      BuildContext context,
      String label,
      DateTime? selectedDate,
      bool isDarkMode,
      Function(DateTime) onDateSelected,
      ) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
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
          onDateSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today),
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
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        child: Text(
          selectedDate != null
              ? "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"
              : "Select date",
          style: TextStyle(
            color: selectedDate != null
                ? (isDarkMode ? Colors.white : Colors.black87)
                : Colors.grey[600],
          ),
        ),
      ),
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
            Icon(Icons.person_add, size: 24),
            SizedBox(width: 12),
            Text(
              "Add Patient",
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

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Check date of birth
      if (_dateOfBirth == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 12),
                Text("Please select date of birth"),
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
                  "${_firstNameController.text} ${_lastNameController.text} added successfully!",
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
                // TODO: Navigate to patient details
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