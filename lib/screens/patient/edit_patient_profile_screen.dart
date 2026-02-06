import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class EditPatientProfileScreen extends StatefulWidget {
  const EditPatientProfileScreen({super.key});

  @override
  State<EditPatientProfileScreen> createState() =>
      _EditPatientProfileScreenState();
}

class _EditPatientProfileScreenState extends State<EditPatientProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _emergencyNameController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _conditionsController = TextEditingController();

  // Dropdown values
  String _selectedGender = "Male";
  String _selectedBloodGroup = "O+";

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    _fullNameController.text = authProvider.user?.name ?? "";
    _emailController.text = authProvider.user?.email ?? "";
    _phoneController.text = authProvider.user?.id ?? "";
    _dobController.text = authProvider.user?.dateOfBirth ?? "";
    _heightController.text = authProvider.user?.height.toString() ?? "";
    _weightController.text = authProvider.user?.weight.toString() ?? "";
    _addressController.text = authProvider.user?.address ?? "";
    _emergencyNameController.text = authProvider.user?.emergencyName ?? "";
    _emergencyContactController.text = authProvider.user?.emergencyContact ?? "";
    _allergiesController.text = authProvider.user?.allergies ?? "";
    _medicationsController.text = authProvider.user?.medications ?? "";
    _conditionsController.text = authProvider.user?.conditions ?? "";
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    _emergencyNameController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    _conditionsController.dispose();
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
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _saveProfile();
              }
            },
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    "Save",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildProfilePictureSection(context, isDarkMode),
              const SizedBox(height: 24),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle(context, "Personal Information"),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _fullNameController,
                      label: "Full Name",
                      icon: Icons.person_outline,
                      isDarkMode: isDarkMode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      label: "Email Address",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      isDarkMode: isDarkMode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: "Phone Number",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      isDarkMode: isDarkMode,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildDateField(
                      controller: _dobController,
                      label: "Date of Birth",
                      icon: Icons.cake_outlined,
                      isDarkMode: isDarkMode,
                      context: context,
                    ),
                    const SizedBox(height: 16),
                    _buildGenderDropdown(isDarkMode),
                    const SizedBox(height: 16),
                    _buildBloodGroupDropdown(isDarkMode),
                    const SizedBox(height: 32),

                    // Physical Information
                    _buildSectionTitle(context, "Physical Information"),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _heightController,
                            label: "Height (cm)",
                            icon: Icons.height,
                            keyboardType: TextInputType.number,
                            isDarkMode: isDarkMode,
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
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Contact Information
                    _buildSectionTitle(context, "Contact Information"),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _addressController,
                      label: "Address",
                      icon: Icons.location_on_outlined,
                      maxLines: 3,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 32),

                    // Emergency Contact
                    _buildSectionTitle(context, "Emergency Contact"),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emergencyNameController,
                      label: "Emergency Contact Name",
                      icon: Icons.person_outline,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emergencyContactController,
                      label: "Emergency Contact Number",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 32),

                    // Medical Information
                    _buildSectionTitle(context, "Medical Information"),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _allergiesController,
                      label: "Allergies",
                      icon: Icons.warning_amber_outlined,
                      maxLines: 2,
                      isDarkMode: isDarkMode,
                      hintText: "E.g., Peanuts, Penicillin",
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _medicationsController,
                      label: "Current Medications",
                      icon: Icons.medication_outlined,
                      maxLines: 2,
                      isDarkMode: isDarkMode,
                      hintText: "E.g., Aspirin 100mg daily",
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _conditionsController,
                      label: "Medical Conditions",
                      icon: Icons.local_hospital_outlined,
                      maxLines: 2,
                      isDarkMode: isDarkMode,
                      hintText: "E.g., Diabetes, Hypertension",
                    ),
                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isSaving
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  _saveProfile();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          disabledBackgroundColor: Colors.grey[400],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isSaving
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                            : Text(
                                "Save Changes",
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.cyan
                                      : Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection(BuildContext context, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.grey[50],
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
          ),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 3,
                  ),
                ),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Theme.of(context).primaryColor,
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
                    padding: const EdgeInsets.all(12),
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
          const SizedBox(height: 16),
          Text(
            "Change Profile Picture",
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDarkMode,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isDarkMode,
    required BuildContext context,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime(1990, 1, 15),
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
          controller.text =
              "${_getMonth(picked.month)} ${picked.day}, ${picked.year}";
        }
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildGenderDropdown(bool isDarkMode) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedGender,
      decoration: InputDecoration(
        labelText: "Gender",
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      items: ['Male', 'Female', 'Other', 'Prefer not to say']
          .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedGender = value!;
        });
      },
    );
  }

  Widget _buildBloodGroupDropdown(bool isDarkMode) {
    return DropdownButtonFormField<String>(
      initialValue: _selectedBloodGroup,
      decoration: InputDecoration(
        labelText: "Blood Group",
        prefixIcon: const Icon(Icons.bloodtype_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
          .map(
            (bloodGroup) =>
                DropdownMenuItem(value: bloodGroup, child: Text(bloodGroup)),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedBloodGroup = value!;
        });
      },
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
                  "Change Profile Picture",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
                const SizedBox(height: 12),
                _buildImageOption(
                  context,
                  Icons.delete_outline,
                  "Remove Photo",
                  isDarkMode,
                  () {
                    Navigator.pop(context);
                    // TODO: Implement remove photo
                  },
                  isDelete: true,
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
    VoidCallback onTap, {
    bool isDelete = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDelete
                ? Colors.red.withValues(alpha: 0.3)
                : (isDarkMode ? Colors.grey[700]! : Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDelete
                    ? Colors.red.withValues(alpha: 0.1)
                    : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDelete ? Colors.red : Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDelete ? Colors.red : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() => _isSaving = true);

    try {
      final success = await authProvider.updateProfile({
        'name': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'dob': _dobController.text.trim(),
        'height': double.tryParse(_heightController.text.trim()),
        'weight': double.tryParse(_weightController.text.trim()),
        'address': _addressController.text.trim(),
        'emergencyName': _emergencyNameController.text.trim(),
        'emergencyContact': _emergencyContactController.text.trim(),
        'allergies': _allergiesController.text.trim(),
        'medications': _medicationsController.text.trim(),
        'conditions': _conditionsController.text.trim(),
        'gender': _selectedGender,
        'bloodGroup': _selectedBloodGroup,
      });

      if (!mounted) return;

      setState(() => _isSaving = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  "Profile updated successfully!",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );

        // Navigate back or replace with profile screen
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            // Option 1: Go back to previous screen
            Navigator.pop(context);

            // Option 2: Replace current screen with profile screen
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const PatientProfileScreen()),
            // );
          }
        });
      } else {
        print("Error1: ${authProvider.error}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    authProvider.error ?? 'Failed to update profile',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => _isSaving = false);

      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'An error occurred: ${e.toString()}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /*Future<void> _saveProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!mounted) return;

    setState(() => _isSaving = true);

    try {
      final success = await authProvider.updateProfile({
        'name': _fullNameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'dob': _dobController.text.trim(),
        'height': _heightController.text.trim(),
        'weight': _weightController.text.trim(),
        'address': _addressController.text.trim(),
        'emergencyName': _emergencyNameController.text.trim(),
        'emergencyContact': _emergencyContactController.text.trim(),
        'allergies': _allergiesController.text.trim(),
        'medications': _medicationsController.text.trim(),
        'conditions': _conditionsController.text.trim(),
        'gender': _selectedGender,
        'bloodGroup': _selectedBloodGroup,
      });

      if (!mounted) return;

      setState(() => _isSaving = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text(
                  "Profile updated successfully!",
                  style: TextStyle(color: Colors.white),
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

        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PatientProfileScreen()),
            );
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.error ?? 'Profile update failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }*/

  /*Future<void> _saveProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!mounted) return;
    setState(() {
      _isSaving = true;
    });

    try {
      await authProvider.updateProfile(
        _fullNameController.text,
        _emailController.text,
        _phoneController.text,
        _dobController.text,
        _heightController.text,
        _weightController.text,
        _addressController.text,
      );

      if (!mounted) return;
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text("Profile updated successfully!"),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) Navigator.pop(context);
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isSaving = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }*/

  String _getMonth(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
