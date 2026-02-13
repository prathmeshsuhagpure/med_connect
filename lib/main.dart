import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:med_connect/providers/authentication_provider.dart';
import 'package:med_connect/providers/doctor_provider.dart';
import 'package:med_connect/providers/hospital_provider.dart';
import 'package:med_connect/screens/auth/login_screen.dart';
import 'package:med_connect/screens/splash_screen.dart';
import 'package:med_connect/services/api_service.dart';
import 'package:med_connect/theme/theme.dart';
import 'package:med_connect/widgets/btm_nav_bar.dart';
import 'package:med_connect/widgets/hospital_btm_nav_bar.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Base services
        Provider<ApiService>(create: (_) => ApiService()),
        // Independent providers
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => HospitalProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Med-Connect',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        initialRoute: '/',
        navigatorKey: navigatorKey,
        routes: {
          '/login': (context) => const LoginScreen(),
          '/patient_home': (context) => const PatientShell(),
          '/hospital_home': (context) => const HospitalShell(),
          //'/doctor_home': (context) => const HospitalShell(),
        },
        home: const SplashScreen(),
      ),
    );
  }
}
