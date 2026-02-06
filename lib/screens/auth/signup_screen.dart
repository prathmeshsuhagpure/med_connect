import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/authentication_provider.dart';
import '../../theme/theme.dart';
import 'login_screen.dart';

enum UserRole { patient, hospital, doctor }

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();

  // Hospital-specific controllers
  final _hospitalNameController = TextEditingController();
  final _registrationNumberController = TextEditingController();

  // Doctor-specific controllers
  final _specializationController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _licenseNumberController = TextEditingController();

  UserRole _selectedRole = UserRole.patient;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _hospitalNameController.dispose();
    _registrationNumberController.dispose();
    _addressController.dispose();
    _specializationController.dispose();
    _qualificationController.dispose();
    _licenseNumberController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept terms and conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    Map<String, dynamic>? result;

    try {
      switch (_selectedRole) {
        case UserRole.patient:
          result = await authProvider.signupPatient(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            confirmPassword: _confirmPasswordController.text.trim(),
            address: _addressController.text.trim().isEmpty
                ? null
                : _addressController.text.trim(),
          );
          break;

        case UserRole.hospital:
          result = await authProvider.signupHospital(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            confirmPassword: _confirmPasswordController.text.trim(),
            hospitalName: _hospitalNameController.text.trim(),
            registrationNumber: _registrationNumberController.text.trim(),
            address: _addressController.text.trim().isEmpty
                ? null
                : _addressController.text.trim(),
          );
          break;

        case UserRole.doctor:
          result = await authProvider.signupDoctor(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            phoneNumber: _phoneController.text.trim(),
            confirmPassword: _confirmPasswordController.text.trim(),
            specialization: _specializationController.text.trim(),
            qualification: _qualificationController.text.trim(),
            licenseNumber: _licenseNumberController.text.trim().isEmpty
                ? null
                : _licenseNumberController.text.trim(),
            address: _addressController.text.trim().isEmpty
                ? null
                : _addressController.text.trim(),
          );
          break;
      }

      if (!mounted) return;

      setState(() => _isLoading = false);

      if (result?['success'] == true) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Account created successfully!'),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate based on role
        if (authProvider.isPatient) {
          Navigator.pushReplacementNamed(context, '/patient_home');
        } else if (authProvider.isHospital) {
          Navigator.pushReplacementNamed(context, '/hospital_home');
        } else if (authProvider.isDoctor) {
          Navigator.pushReplacementNamed(context, '/doctor_home');
        }
      } else {
        // Show error message
        print("Error: ${result?['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result?['message'] ?? 'Signup failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      print("E: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  InputDecoration _getInputDecoration({
    required String labelText,
    required String hintText,
    required Icon prefixIcon,
    Widget? suffixIcon,
    bool alignLabelWithHint = false,
    required bool isDarkMode,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      alignLabelWithHint: alignLabelWithHint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[50],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 650;
    final isTablet = screenWidth >= 650 && screenWidth < 1100;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    Theme.of(context).scaffoldBackgroundColor,
                    Theme.of(context).scaffoldBackgroundColor,
                  ]
                : [
                    Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    Colors.white,
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : (isTablet ? 60 : 0),
                  vertical: 24,
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isMobile
                        ? double.infinity
                        : (isTablet ? 500 : 450),
                  ),
                  child: Card(
                    elevation: isMobile ? 0 : 8,
                    color: isDarkMode
                        ? Theme.of(context).cardColor
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isMobile ? 24 : 40),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo/Icon
                            Icon(
                              Icons.medical_services_rounded,
                              size: isMobile ? 60 : 70,
                              color: isDarkMode
                                  ? DarkThemeColors.white
                                  : Theme.of(context).primaryColor,
                            ),
                            const SizedBox(height: 20),

                            // Title
                            Text(
                              "Create Account",
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isMobile ? 26 : 30,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Join us for better healthcare management",
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                    fontSize: isMobile ? 14 : 16,
                                  ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 32),

                            // Role Selection
                            Text(
                              "Register as",
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode
                                        ? Colors.grey[300]
                                        : Colors.grey[700],
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _RoleCard(
                                    icon: Icons.person_rounded,
                                    label: "Patient",
                                    isSelected:
                                        _selectedRole == UserRole.patient,
                                    isDarkMode: isDarkMode,
                                    onTap: () => setState(
                                      () => _selectedRole = UserRole.patient,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _RoleCard(
                                    icon: Icons.local_hospital_rounded,
                                    label: "Hospital",
                                    isSelected:
                                        _selectedRole == UserRole.hospital,
                                    isDarkMode: isDarkMode,
                                    onTap: () => setState(
                                      () => _selectedRole = UserRole.hospital,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _RoleCard(
                                    icon: Icons.medical_services,
                                    label: "Doctor",
                                    isSelected:
                                        _selectedRole == UserRole.doctor,
                                    isDarkMode: isDarkMode,
                                    onTap: () => setState(
                                      () => _selectedRole = UserRole.doctor,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Common Fields
                            _buildCommonFields(isDarkMode),

                            // Role-specific fields
                            if (_selectedRole == UserRole.hospital) ...[
                              const SizedBox(height: 20),
                              _buildHospitalFields(isDarkMode),
                            ],

                            if (_selectedRole == UserRole.doctor) ...[
                              const SizedBox(height: 20),
                              _buildDoctorFields(isDarkMode),
                            ],

                            const SizedBox(height: 24),

                            // Terms and Conditions
                            Row(
                              children: [
                                Checkbox(
                                  value: _acceptTerms,
                                  onChanged: (value) {
                                    setState(
                                      () => _acceptTerms = value ?? false,
                                    );
                                  },
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(
                                        () => _acceptTerms = !_acceptTerms,
                                      );
                                    },
                                    child: Text(
                                      "I accept the terms and conditions",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Signup Button
                            SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: (_isLoading || !_acceptTerms)
                                    ? null
                                    : _handleSignup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDarkMode
                                      ? DarkThemeColors.buttonPrimary
                                      : LightThemeColors.buttonPrimary,
                                  disabledBackgroundColor: isDarkMode
                                      ? DarkThemeColors.buttonSecondary
                                      : LightThemeColors.buttonSecondary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        "Create Account",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: _acceptTerms
                                              ? (isDarkMode
                                                    ? Colors.black
                                                    : Colors.black)
                                              : (isDarkMode
                                                    ? DarkThemeColors.textDisabled
                                                    : LightThemeColors.textDisabled),
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Login link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? DarkThemeColors.textPrimary
                                        : LightThemeColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 5,),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                             LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: isDarkMode ? DarkThemeColors.buttonPrimary : LightThemeColors.buttonPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommonFields(bool isDarkMode) {
    final role = _selectedRole;
    return Column(
      children: [
        // Full Name
        TextFormField(
          controller: _nameController,
          decoration: _getInputDecoration(
            labelText: role == UserRole.hospital
                ? " Admin Full Name"
                : "Full Name",
            hintText: "Enter admin name",
            prefixIcon: const Icon(Icons.person_outline_rounded),
            isDarkMode: isDarkMode,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),

        const SizedBox(height: 20),

        // Email
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: _getInputDecoration(
            labelText: role == UserRole.hospital
                ? " Admin Email Address"
                : "Email Address",
            hintText: "Enter admin email",
            prefixIcon: const Icon(Icons.email_outlined),
            isDarkMode: isDarkMode,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter email';
            }
            if (!value.contains('@')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),

        const SizedBox(height: 20),

        // Phone
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: _getInputDecoration(
            labelText: "Phone Number",
            hintText: "Enter your phone number",
            prefixIcon: const Icon(Icons.phone_rounded),
            isDarkMode: isDarkMode,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter phone number';
            }
            return null;
          },
        ),

        const SizedBox(height: 20),

        // Address (Optional)
        TextFormField(
          controller: _addressController,
          maxLines: 2,
          decoration: _getInputDecoration(
            labelText: "Address (Optional)",
            hintText: "Enter your address",
            prefixIcon: const Icon(Icons.location_on_rounded),
            alignLabelWithHint: true,
            isDarkMode: isDarkMode,
          ),
        ),

        const SizedBox(height: 20),

        // Password
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: _getInputDecoration(
            labelText: "Password",
            hintText: "Create a password",
            prefixIcon: const Icon(Icons.lock_rounded),
            isDarkMode: isDarkMode,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
              ),
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),

        const SizedBox(height: 20),

        // Confirm Password
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          decoration: _getInputDecoration(
            labelText: "Confirm Password",
            hintText: "Re-enter your password",
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            isDarkMode: isDarkMode,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
              ),
              onPressed: () {
                setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                );
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildHospitalFields(bool isDarkMode) {
    return Column(
      children: [
        TextFormField(
          controller: _hospitalNameController,
          decoration: _getInputDecoration(
            labelText: "Hospital Name",
            hintText: "Enter hospital name",
            prefixIcon: const Icon(Icons.local_hospital_rounded),
            isDarkMode: isDarkMode,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter hospital name';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _registrationNumberController,
          decoration: _getInputDecoration(
            labelText: "Registration Number",
            hintText: "Enter registration number",
            prefixIcon: const Icon(Icons.numbers_rounded),
            isDarkMode: isDarkMode,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter registration number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDoctorFields(bool isDarkMode) {
    return Column(
      children: [
        TextFormField(
          controller: _specializationController,
          decoration: _getInputDecoration(
            labelText: "Specialization",
            hintText: "e.g., Cardiology, Neurology",
            prefixIcon: const Icon(Icons.medical_services_rounded),
            isDarkMode: isDarkMode,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter specialization';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _qualificationController,
          decoration: _getInputDecoration(
            labelText: "Qualification",
            hintText: "e.g., MBBS, MD",
            prefixIcon: const Icon(Icons.school_rounded),
            isDarkMode: isDarkMode,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter qualification';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _licenseNumberController,
          decoration: _getInputDecoration(
            labelText: "License Number (Optional)",
            hintText: "Enter medical license number",
            prefixIcon: const Icon(Icons.badge_rounded),
            isDarkMode: isDarkMode,
          ),
        ),
      ],
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isDarkMode;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDarkMode
                    ? DarkThemeColors.grey
                    : Theme.of(context).primaryColor)
              : (isDarkMode
                    ? AppTheme.darkTheme.primaryColor
                    : Colors.grey[100]),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDarkMode ? DarkThemeColors.white : Colors.black)
                : (isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : (isDarkMode ? Colors.grey[300] : Colors.grey[700]),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDarkMode ? Colors.grey[300] : Colors.grey[700]),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
