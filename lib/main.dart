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

  String supabaseUrl = '';
  String supabaseKey = '';

  // Try to load environment variables
  try {
    // In debug: load from root, in release: load from assets
    await dotenv.load(fileName: '.env');
    debugPrint('✓ .env loaded from root');
    supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
    supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  } catch (e) {
    debugPrint('⚠ Could not load .env: $e');
    // Try fallback for release APK
    try {
      final envContent = await rootBundle.loadString('assets/.env');
      // Parse manually
      for (final line in envContent.split('\n')) {
        if (line.isEmpty || line.startsWith('#')) continue;
        final parts = line.split('=');
        if (parts.length == 2) {
          final key = parts[0].trim();
          final value = parts[1].trim();
          if (key == 'SUPABASE_URL') supabaseUrl = value;
          if (key == 'SUPABASE_ANON_KEY') supabaseKey = value;
        }
      }
      debugPrint('✓ Loaded from assets/.env');
    } catch (e2) {
      debugPrint('✗ Both .env loads failed: $e2');
    }
  }

  debugPrint('═════════════════════════════════════');
  debugPrint('Supabase URL: ${supabaseUrl.isEmpty ? 'NOT FOUND' : 'FOUND'}');
  debugPrint('Supabase Key: ${supabaseKey.isEmpty ? 'NOT FOUND' : 'FOUND'}');
  debugPrint('═════════════════════════════════════');

  // Initialize Supabase with loaded credentials
  if (supabaseUrl.isNotEmpty && supabaseKey.isNotEmpty) {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseKey,
      );
      debugPrint('✓ Supabase initialized successfully');
    } catch (e) {
      debugPrint('✗ Supabase initialization failed: $e');
    }
  } else {
    debugPrint('✗ Supabase credentials missing - login will not work');
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
