# KuppiFeed Flutter App

A modern, modular Flutter front-end for KuppiFeed, featuring:

- Custom theme with blue/purple palette, Poppins font, and high corner radius
- Modular widgets for post cards and custom inputs
- Welcome, Login, Home, Upload, and Profile screens
- Bottom navigation bar with Home, Search, Upload, and Profile
- Clean, minimalist UI
- Secure Supabase integration with environment variables

## Getting Started

1. Install Flutter: https://docs.flutter.dev/get-started/install
2. Run `flutter pub get` in the project root
3. Create a `.env` file by copying `.env.example` and add your Supabase credentials
4. Launch the app with `flutter run`

## File Structure

- `lib/main.dart` — Theme, routes, and app entry
- `lib/widgets/post_card.dart` — Reusable post card widget
- `lib/widgets/custom_input.dart` — Rounded text field widget
- `lib/screens/welcome_screen.dart` — Welcome screen
- `lib/screens/login_screen.dart` — Login screen
- `lib/screens/home_screen.dart` — Home feed and navigation
- `lib/screens/upload_screen.dart` — Upload notes screen
- `lib/screens/profile_screen.dart` — Profile and user posts

## Environment Setup

Create a `.env` file with:
```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

## Customization

- Replace placeholder data and icons as needed
- Update Supabase credentials in `.env` for your backend
