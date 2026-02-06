import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _checkAuthAndNavigate());
  }

  Future<void> _checkAuthAndNavigate() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await Future.delayed(const Duration(seconds: 2));

    try {
      final isLoggedIn = await authProvider.tryAutoLogin();
      if (!mounted) return;

      if (isLoggedIn && authProvider.user != null) {
        print("in if Block");
        final user = authProvider.user!;

        if (user.role.toLowerCase() == 'hospital') {
          Navigator.pushReplacementNamed(context, '/hospital_home');
        } else {
          Navigator.pushReplacementNamed(context, '/patient_home');
        }
      } else {
        print("in else block");
        await authProvider.forceLogout();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      print("in catch block");
      await authProvider.forceLogout();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.local_hospital, size: 80),
            SizedBox(height: 16),
            Text(
              'CityCare',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
