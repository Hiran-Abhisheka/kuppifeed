import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/welcome_screen.dart';
import 'screens/home_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables - works for both dev and release
  try {
    await dotenv.load();
    debugPrint('✓ .env file loaded successfully');
  } catch (e) {
    debugPrint('⚠ Warning: .env file not found - $e');
  }

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'];

  debugPrint('Supabase URL: ${supabaseUrl != null ? '✓ Found' : '✗ Missing'}');
  debugPrint('Supabase Key: ${supabaseKey != null ? '✓ Found' : '✗ Missing'}');

  if (supabaseUrl != null && supabaseKey != null) {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseKey,
      );
      debugPrint('✓ Supabase initialized successfully');
    } catch (e) {
      debugPrint('✗ Supabase initialization error: $e');
      rethrow;
    }
  } else {
    debugPrint('✗ ERROR: Missing Supabase credentials in .env file!');
  }

  runApp(const KuppiFeedApp());
}

class KuppiFeedApp extends StatelessWidget {
  const KuppiFeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KuppiFeed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF6C63FF),
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF6C63FF),
          secondary: const Color(0xFFB2A4FF),
          surface: const Color(0xFFE0E0E0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: const Color(0xFF6C63FF),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      home: const WelcomeScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/upload': (context) => const UploadScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
