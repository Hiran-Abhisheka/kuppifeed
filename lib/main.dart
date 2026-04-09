import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // Load environment variables from assets using rootBundle (works in APK)
  try {
    final envContent = await rootBundle.loadString('.env');
    debugPrint('✓ .env file loaded from assets');
    
    // Parse .env file manually
    final lines = envContent.split('\n');
    for (final line in lines) {
      if (line.isNotEmpty && !line.startsWith('#')) {
        final parts = line.split('=');
        if (parts.length == 2) {
          dotenv.env[parts[0].trim()] = parts[1].trim();
        }
      }
    }
    debugPrint('✓ Environment variables parsed');
  } catch (e) {
    debugPrint('⚠ Could not load .env from assets: $e');
    debugPrint('Falling back to dotenv.load()...');
    try {
      await dotenv.load();
    } catch (e2) {
      debugPrint('⚠ Also failed: $e2');
    }
  }

  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'];

  debugPrint(
      'Supabase URL: ${supabaseUrl != null ? '✓ Found: $supabaseUrl' : '✗ Missing'}');
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
