# 🍲 KuppiFeed Flutter App

> A modern, modular Flutter mobile application for sharing and discovering recipes with a sleek UI and secure backend integration.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)
![License](https://img.shields.io/badge/license-MIT-green)

<p align="center">
   <img src="https://i.postimg.cc/L4tfBPkF/Whats-App-Image-2026-04-08-at-11-53-23-AM.jpg" alt="KuppiFeed Preview" width="400" />
</p>

---

## ✨ Features

- 🎨 **Modern UI Design** — Custom purple/blue theme with Poppins font family
- 🔐 **Secure Authentication** — Supabase authentication with secure credential management
- 📝 **Recipe Management** — Upload, view, and manage recipe posts
- 👤 **User Profiles** — Personalized user profiles with activity tracking
- 🔍 **Feed Navigation** — Browse recipes with intuitive bottom navigation
- 📱 **Responsive Design** — Optimized for all screen sizes
- 🛡️ **Security-First** — Environment variables for API key protection

---

## 📋 Prerequisites

Before you begin, ensure you have:

- **Flutter SDK** (3.0.0 or higher) — [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Dart SDK** (included with Flutter)
- **Git** — For version control
- **Supabase Account** — Free tier available at [supabase.com](https://supabase.com)
- **Code Editor** — VS Code, Android Studio, or IntelliJ IDEA

---

## 🚀 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/Hiran-Abhisheka/kuppifeeder.git
cd kuppifeeder
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Environment Variables

```bash
# Copy the template
cp .env.example .env

# Edit .env and add your Supabase credentials
```

**`.env` file format:**

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
```

### 4. Run the App

```bash
flutter run
```

---

## 📁 Project Structure

```
lib/
├── main.dart                    # App entry point, theme configuration
├── screens/
│   ├── welcome_screen.dart      # Onboarding/welcome screen
│   ├── login_screen.dart        # User login interface
│   ├── signup_screen.dart       # User registration
│   ├── home_screen.dart         # Main feed with bottom navigation
│   ├── upload_screen.dart       # Recipe upload interface
│   └── profile_screen.dart      # User profile and posted recipes
└── widgets/
    ├── post_card.dart           # Reusable recipe card component
    └── custom_input.dart        # Custom text field widget

assets/
└── Logo.png                     # App branding

android/, ios/, web/, windows/  # Platform-specific code
```

---

## 🏗️ Architecture

### Technology Stack

| Component        | Technology      | Version      |
| ---------------- | --------------- | ------------ |
| Frontend         | Flutter         | 3.x          |
| Language         | Dart            | 3.x          |
| Backend          | Supabase        | Latest       |
| Database         | PostgreSQL      | Via Supabase |
| Authentication   | Supabase Auth   | Latest       |
| State Management | StatefulWidget  | Native       |
| UI Framework     | Material Design | 3.0          |

### App Flow

```
Welcome Screen (Conditional)
    ↓
Login/Signup (if not authenticated)
    ↓
Home Screen (Main Feed)
├── Home Tab → View recipe feed
├── Search Tab → Discover recipes
├── Upload Tab → Create new recipes
└── Profile Tab → Manage account & posts
```

---

## 🔐 Security

### API Key Protection

- ✅ **Local Credentials** — Supabase keys stored in `.env` (never committed)
- ✅ **Environment Variables** — Loaded at runtime via `flutter_dotenv`
- ✅ **Gitignore Protection** — `.env` excluded from version control
- ✅ **Template Provided** — `.env.example` for safe collaboration

### Best Practices

1. **Never commit `.env`** to version control
2. **Regenerate** Supabase keys if accidentally exposed
3. **Use `.env.example`** to document required variables
4. **Rotate credentials** periodically in production

---

## 🛠️ Development

### Adding Dependencies

```bash
flutter pub add package_name
```

### Running Tests

```bash
flutter test
```

### Building for Release

**Android:**

```bash
flutter build apk --release
```

**iOS:**

```bash
flutter build ios --release
```

**Web:**

```bash
flutter build web
```

### Code Formatting

```bash
dart format lib/
```

### Linting

```bash
flutter analyze
```

---

## ⚙️ CI/CD Pipeline

### GitHub Actions Workflows

This project uses **GitHub Actions** for automated testing, building, and security scanning.

#### 1. **CI Workflow** (`ci.yml`)

Runs on every push to `main` or `develop` branches and on pull requests.

**Jobs:**

- ✅ **Analyze** — Dart code analysis and formatting check
- ✅ **Test** — Unit tests with coverage reporting
- ✅ **Build Android** — Automated APK build (release)
- ✅ **Build iOS** — Automated iOS build (no code sign)
- ✅ **Build Web** — Automated web build

**Artifacts Generated:**

- `kuppifeed-release.apk` — Android release build
- `kuppifeed-ios-release/` — iOS build directory
- `kuppifeed-web-release/` — Web build directory

#### 2. **Security Workflow** (`security.yml`)

Runs on push, pull requests, and weekly schedule.

**Jobs:**

- 🔍 **Dependency Scan** — Check for outdated packages
- 🚨 **Secret Detection** — Scan for exposed credentials (TruffleHog)

### Workflow Status Badges

Add these to your project board:

```markdown
![CI/CD](https://github.com/Hiran-Abhisheka/kuppifeeder/actions/workflows/ci.yml/badge.svg)
![Security](https://github.com/Hiran-Abhisheka/kuppifeeder/actions/workflows/security.yml/badge.svg)
```

### Local Pre-Commit Checks

Before pushing, run these locally to catch issues early:

```bash
# Analyze code
flutter analyze

# Format code
dart format lib/

# Run tests
flutter test

# Build for testing
flutter build apk --debug
```

---

## 📦 Dependencies

| Package            | Purpose                         |
| ------------------ | ------------------------------- |
| `supabase_flutter` | Backend & authentication        |
| `google_fonts`     | Custom typography (Poppins)     |
| `flutter_dotenv`   | Environment variable management |
| `image_picker`     | Gallery/camera integration      |
| `bcrypt`           | Password hashing                |

For complete dependency tree, see [pubspec.yaml](pubspec.yaml).

---

## 📖 Usage Guide

### First Time Setup

1. Create a Supabase account (free tier available)
2. Create a new project
3. Copy the project URL and anon key
4. Paste into `.env` file
5. Run `flutter pub get && flutter run`

### User Flow

**New User:**

- Tap "Sign Up" → Enter email & password → Create account

**Existing User:**

- Tap "Login" → Enter credentials → Access app

**Uploading Recipe:**

- Navigate to Upload tab → Fill recipe details → Submit

**Viewing Profile:**

- Navigate to Profile tab → View your posts and settings

---

## 🤝 Contributing

Contributions are welcome! Here's how to help:

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** changes (`git commit -m 'Add amazing feature'`)
4. **Push** to branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### Code Style Guidelines

- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable names
- Add comments for complex logic
- Keep functions focused and small

---

## 🐛 Troubleshooting

**"Failed to load environment variables"**

- Ensure `.env` file exists in project root
- Check file formatting (no extra spaces)

**"Supabase connection error"**

- Verify `SUPABASE_URL` and `SUPABASE_ANON_KEY` are correct
- Ensure internet connection is active
- Check Supabase project status

**"Flutter not found"**

- Add Flutter to PATH: [Installation Guide](https://docs.flutter.dev/get-started/install)
- Run `flutter doctor` to verify installation

---

## 📝 License

This project is licensed under the **MIT License** — see LICENSE file for details.

---

## 👨‍💻 Author

**Hiran Abhisheka**

- GitHub: [@Hiran-Abhisheka](https://github.com/Hiran-Abhisheka)
- Repository: [KuppiFeed](https://github.com/Hiran-Abhisheka/kuppifeeder)

---

## 💡 Support

- 📚 [Flutter Documentation](https://flutter.dev/docs)
- 🔧 [Supabase Documentation](https://supabase.com/docs)
- 🐛 [Report Issues](https://github.com/Hiran-Abhisheka/kuppifeeder/issues)

---

## 🎯 Roadmap

- [ ] Social features (likes, comments, follows)
- [ ] Recipe search & filtering
- [ ] Offline mode support
- [ ] Push notifications
- [ ] Recipe recommendations (ML-based)
- [ ] Multi-language support

---

**Made with ❤️ using Flutter**
