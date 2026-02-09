import 'package:flutter/material.dart';
import 'package:med_connect/screens/hospital/hospital_dashboard_screen.dart';
import 'package:med_connect/screens/hospital/hospital_profile_screen.dart';
import 'package:med_connect/screens/patient/patient_list_screen.dart';
import '../screens/hospital/appointment_management_screen.dart';
import '../theme/theme.dart';

class HospitalBtmNavBar extends StatefulWidget {
  final bool isDarkMode;

  const HospitalBtmNavBar({super.key, required this.isDarkMode});

  @override
  HospitalBtmNavBarState createState() => HospitalBtmNavBarState();
}

class HospitalBtmNavBarState extends State<HospitalBtmNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HospitalDashboardScreen(),
    const AppointmentManagementScreen(),
    const PatientListScreen(),
    const HospitalProfileScreen(),
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
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined),
                activeIcon: Icon(Icons.calendar_today),
                label: 'Appointments',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people),
                label: 'Patients',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_hospital_outlined),
                activeIcon: Icon(Icons.local_hospital),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HospitalShell extends StatelessWidget {
  const HospitalShell({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return HospitalBtmNavBar(isDarkMode: isDarkMode);
  }
}

