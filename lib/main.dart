import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:med_connect/providers/appointment_provider.dart';
import 'package:med_connect/providers/authentication_provider.dart';
import 'package:med_connect/providers/doctor_provider.dart';
import 'package:med_connect/providers/hospital_provider.dart';
import 'package:med_connect/providers/patient_provider.dart';
import 'package:med_connect/screens/auth/login_screen.dart';
import 'package:med_connect/screens/splash_screen.dart';
import 'package:med_connect/services/api_service.dart';
import 'package:med_connect/services/notification_service.dart';
import 'package:med_connect/services/payment_service.dart';
import 'package:med_connect/theme/theme.dart';
import 'package:med_connect/widgets/btm_nav_bar.dart';
import 'package:med_connect/widgets/hospital_btm_nav_bar.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message: ${message.notification?.title}");
}
final notificationService = NotificationService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await NotificationService().initialize();
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
        Provider<PaymentService>(
          create: (context) =>
              PaymentService(context.read<ApiService>()),
        ),
        // Independent providers
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => DoctorProvider()),
        ChangeNotifierProvider(create: (_) => HospitalProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Med-Connect',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
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
