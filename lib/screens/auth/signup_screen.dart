import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../theme/theme.dart';
import 'login_screen.dart';

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

  // Hospital-specific controllers
  final _hospitalNameController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _addressController = TextEditingController();

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
    super.dispose();
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
                              "Create Account 🏥",
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
                                    onTap: () {
                                      setState(() {
                                        _selectedRole = UserRole.patient;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _RoleCard(
                                    icon: Icons.local_hospital_rounded,
                                    label: "Hospital",
                                    isSelected:
                                        _selectedRole == UserRole.hospital,
                                    isDarkMode: isDarkMode,
                                    onTap: () {
                                      setState(() {
                                        _selectedRole = UserRole.hospital;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Dynamic Form based on role
                            if (_selectedRole == UserRole.patient)
                              _buildPatientForm(isDarkMode)
                            else
                              _buildHospitalForm(isDarkMode),

                            const SizedBox(height: 20),

                            // Terms and Conditions
                            Row(
                              children: [
                                Checkbox(
                                  value: _acceptTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      _acceptTerms = value ?? false;
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _acceptTerms = !_acceptTerms;
                                      });
                                    },
                                    child: Text.rich(
                                      TextSpan(
                                        text: "I agree to the ",
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.grey[400]
                                              : Colors.grey[700],
                                          fontSize: isMobile ? 13 : 14,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: "Terms & Conditions",
                                            style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.green
                                                  : Theme.of(
                                                      context,
                                                    ).primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const TextSpan(text: " and "),
                                          TextSpan(
                                            text: "Privacy Policy",
                                            style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.green
                                                  : Theme.of(
                                                      context,
                                                    ).primaryColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: (!_isLoading)
                                    ? () async {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }

                                        setState(() {
                                          _isLoading = true;
                                        });

                                        try {
                                          final authProvider =
                                              Provider.of<AuthProvider>(
                                                context,
                                                listen: false,
                                              );

                                          final result = await authProvider
                                              .signup(
                                                name: _nameController.text
                                                    .trim(),
                                                email: _emailController.text
                                                    .trim(),
                                                phoneNumber:
                                                    _phoneController.text,
                                                password:
                                                    _passwordController.text,
                                                confirmPassword:
                                                    _confirmPasswordController
                                                        .text,
                                                hospitalName:
                                                    _hospitalNameController.text
                                                        .trim(),
                                                registrationNumber:
                                                    _registrationNumberController
                                                        .text,
                                                address: _addressController.text
                                                    .trim(),
                                                role: _selectedRole.name,
                                              );

                                          print("result: $result");
                                          if (!mounted) return;

                                          setState(() {
                                            _isLoading = false;
                                          });

                                          if (result == null ||
                                              result['success'] != true) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  result?['message'] ??
                                                      'Signup failed',
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                            return;
                                          }

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen(),
                                            ),
                                          );
                                        } catch (e) {
                                          if (!mounted) return;
                                          print("Signup error: $e");
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Error: ${e.toString()}",
                                              ),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        } finally {
                                          if (mounted) {
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          }
                                        }
                                      }
                                    : null,

                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                  disabledBackgroundColor: isDarkMode
                                      ? Colors.black38
                                      : Colors.grey[700],
                                ),
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(
                                    fontSize: isMobile ? 16 : 18,
                                    fontWeight: FontWeight.bold,
                                    color: _acceptTerms
                                        ? (isDarkMode
                                              ? Colors.green
                                              : Theme.of(context).primaryColor)
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Divider
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: isDarkMode
                                        ? Colors.grey[700]
                                        : Colors.grey[300],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    "OR",
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: isDarkMode
                                        ? Colors.grey[700]
                                        : Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Social Signup Buttons
                            if (!isMobile) ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: _SocialButton(
                                      icon: Icons.g_mobiledata_rounded,
                                      label: "Google",
                                      isDarkMode: isDarkMode,
                                      onPressed: () {},
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _SocialButton(
                                      icon: Icons.apple_rounded,
                                      label: "Apple",
                                      isDarkMode: isDarkMode,
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ] else ...[
                              _SocialButton(
                                icon: Icons.g_mobiledata_rounded,
                                label: "Sign up with Google",
                                isDarkMode: isDarkMode,
                                onPressed: () {},
                              ),
                              const SizedBox(height: 12),
                              _SocialButton(
                                icon: Icons.apple_rounded,
                                label: "Sign up with Apple",
                                isDarkMode: isDarkMode,
                                onPressed: () {},
                              ),
                            ],

                            const SizedBox(height: 24),

                            // Login Redirect
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[700],
                                    fontSize: isMobile ? 14 : 16,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: isMobile ? 14 : 16,
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

  Widget _buildPatientForm(bool isDarkMode) {
    return Column(
      children: [
        // Full Name
        TextFormField(
          controller: _nameController,
          decoration: _getInputDecoration(
            labelText: "Full Name",
            hintText: "Enter your full name",
            prefixIcon: const Icon(Icons.person_rounded),
            isDarkMode: isDarkMode,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
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
            labelText: "Email",
            hintText: "Enter your email",
            prefixIcon: const Icon(Icons.email_rounded),
            isDarkMode: isDarkMode,
          ),
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
              return 'Please enter your phone number';
            }
            if (value.length < 10) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
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
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
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
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
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

  Widget _buildHospitalForm(bool isDarkMode) {
    return Column(
      children: [
        // Hospital Name
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

        // Registration Number
        TextFormField(
          controller: _registrationNumberController,
          decoration: _getInputDecoration(
            labelText: "Registration Number",
            hintText: "Enter registration number",
            prefixIcon: const Icon(Icons.badge_rounded),
            isDarkMode: isDarkMode,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter registration number';
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
            labelText: "Official Email",
            hintText: "Enter hospital email",
            prefixIcon: const Icon(Icons.email_rounded),
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
            labelText: "Contact Number",
            hintText: "Enter hospital contact number",
            prefixIcon: const Icon(Icons.phone_rounded),
            isDarkMode: isDarkMode,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter contact number';
            }
            return null;
          },
        ),

        const SizedBox(height: 20),

        // Address
        TextFormField(
          controller: _addressController,
          maxLines: 3,
          decoration: _getInputDecoration(
            labelText: "Address",
            hintText: "Enter hospital address",
            prefixIcon: const Icon(Icons.location_on_rounded),
            alignLabelWithHint: true,
            isDarkMode: isDarkMode,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter address';
            }
            return null;
          },
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
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
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
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
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

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDarkMode;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.isDarkMode,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
        ),
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
