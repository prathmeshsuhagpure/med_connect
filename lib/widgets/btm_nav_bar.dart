import 'package:flutter/material.dart';
import 'package:med_connect/screens/hospital/hospital_list_screen.dart';
import 'package:med_connect/screens/patient/patient_appointment_screen.dart';
import 'package:med_connect/screens/patient/patient_home_screen.dart';
import 'package:med_connect/screens/patient/patient_profile_screen.dart';
import '../theme/theme.dart';

class BottomNavBar extends StatefulWidget {
  final bool isDarkMode;

  const BottomNavBar({super.key, required this.isDarkMode});

  @override
  BottomNavBarState createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const PatientHomeScreen(),
    const PatientAppointmentsScreen(),
    const HospitalListScreen(),
    const PatientProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          return;
        }
        if (_selectedIndex != 0) {
          setState(() {
            _selectedIndex = 0;
          });
        }
      },
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, -2),
                blurRadius: 20,
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: widget.isDarkMode
                ? DarkThemeColors.white
                : Theme.of(context).primaryColor,
            unselectedItemColor: widget.isDarkMode
                ? Colors.grey[700]
                : Colors.grey[600],
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined),
                activeIcon: Icon(Icons.calendar_today),
                label: 'Appointments',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_hospital_outlined),
                activeIcon: Icon(Icons.local_hospital),
                label: 'Hospitals',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PatientShell extends StatelessWidget {
  const PatientShell({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BottomNavBar(isDarkMode: isDarkMode);
  }
}

