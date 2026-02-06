import 'package:flutter/material.dart';
import 'package:med_connect/screens/auth/signup_screen.dart';
import 'package:med_connect/theme/theme.dart';
import 'package:med_connect/widgets/btm_nav_bar.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum UserRole { patient, hospital }

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  UserRole _selectedRole = UserRole.patient;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 650;
    final isTablet = screenWidth >= 650 && screenWidth < 1100;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
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
                            Icon(
                              Icons.medical_services_rounded,
                              size: isMobile ? 60 : 80,
                              color: isDarkMode
                                  ? DarkThemeColors.white
                                  : Theme.of(context).primaryColor,
                            ),
                            const SizedBox(height: 24),

                            // Welcome Text
                            Text(
                              "Welcome Back 👋",
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isMobile ? 28 : 32,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Login to continue your healthcare journey",
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                    fontSize: isMobile ? 14 : 16,
                                  ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 40),

                            Text(
                              "Login as",
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

                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Email",
                                hintText: "Enter your email",
                                prefixIcon: const Icon(Icons.email_rounded),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: isDarkMode
                                    ? Colors.grey[850]
                                    : Colors.grey[50],
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

                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: "Password",
                                hintText: "Enter your password",
                                prefixIcon: const Icon(Icons.lock_rounded),
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: isDarkMode
                                    ? Colors.grey[850]
                                    : Colors.grey[50],
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
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
                                          final result = await authProvider
                                              .login(
                                                _emailController.text.trim(),
                                                _passwordController.text,
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
                                                      'Login failed',
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
                                                  PatientShell(),
                                            ),
                                          );
                                        } catch (e) {
                                          if (!mounted) return;
                                          print("Login error: $e");
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
                                ),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: isMobile ? 16 : 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

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

                            // Social Login Buttons
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
                                label: "Continue with Google",
                                isDarkMode: isDarkMode,
                                onPressed: () {},
                              ),
                              const SizedBox(height: 12),
                              _SocialButton(
                                icon: Icons.apple_rounded,
                                label: "Continue with Apple",
                                isDarkMode: isDarkMode,
                                onPressed: () {},
                              ),
                            ],

                            const SizedBox(height: 24),

                            // Signup Redirect
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[700],
                                    fontSize: isMobile ? 14 : 16,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const SignupScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Sign Up",
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
