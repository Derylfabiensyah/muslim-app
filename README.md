# Muslim App

Aplikasi mobile untuk membantu ibadah sehari-hari umat Muslim, dibangun dengan Flutter.

## ✨ Fitur

- 📖 **Al-Quran Digital** - Baca Al-Quran lengkap dengan terjemahan
- 🤲 **Doa-doa** - Kumpulan doa harian
- 📿 **Tasbih Digital** - Counter tasbih praktis
- 🕌 **Jadwal Shalat** - Waktu shalat akurat berdasarkan lokasi
- 🧭 **Kiblat Finder** - Penunjuk arah kiblat
- ✨ **Asmaul Husna** - 99 nama Allah
- 📝 **Dzikir** - Panduan dzikir lengkap
- 📓 **Catatan Ramadhan** - Jurnal ibadah bulan Ramadhan
- 🤖 **AI Chat Assistant** - Asisten AI khusus topik Islam (powered by Gemini)

## 🚀 Quick Start

### 1. Prerequisites

- Flutter SDK (>=3.0.0)
- Android Studio / VS Code
- Android Emulator atau Physical Device

### 2. Clone & Setup

```bash
# Clone repository
git clone <repository-url>
cd muslim_app

# Install dependencies
flutter pub get
```

### 3. Setup API Keys

```bash
# Copy template environment file
copy .env.example .env
```

Edit file `.env` dan isi dengan API key Anda:

```env
GEMINI_API_KEY=your_gemini_api_key_here
```

**Cara mendapatkan Gemini API Key:**
1. Buka https://makersuite.google.com/app/apikey
2. Login dengan Google Account
3. Klik "Create API Key"
4. Copy dan paste ke file `.env`

### 4. Run App

```bash
flutter run
```

## 📁 Struktur Project

```
lib/
├── config/           # Configuration & environment variables
├── model/            # Data models
├── repository/       # Data layer & API calls
├── services/         # External services (Gemini AI)
├── view/             # UI pages
├── viewmodel/        # Business logic (MVVM)
└── main.dart         # App entry point
```

## 🏗️ Arsitektur

Project ini menggunakan **MVVM (Model-View-ViewModel)** pattern dengan **Provider** untuk state management.

## 🔒 Security

⚠️ **PENTING**: Jangan commit file `.env` yang berisi API key!

File sensitif sudah diamankan di `.gitignore`:
- `.env` (API keys)
- `google-services.json`
- `firebase_options.dart`
- File konfigurasi sensitif lainnya

Baca [SECURITY.md](SECURITY.md) untuk detail lengkap.

## 🛠️ Build

### Debug APK
```bash
flutter build apk --debug
```

### Release APK
```bash
flutter build apk --release
```

### App Bundle (untuk Google Play)
```bash
flutter build appbundle --release
```

## 📱 Minimum Requirements

- Android 5.0 (API Level 21) atau lebih tinggi
- Internet connection untuk fitur AI Chat dan API data

## 🧪 Testing

```bash
flutter test
```

## 📚 Dependencies

- **provider** - State management
- **http** - HTTP requests
- **google_generative_ai** - Gemini AI integration
- **flutter_dotenv** - Environment variables management
- **flutter_launcher_icons** - App icon generator

## 📄 Documentation

- [SECURITY.md](SECURITY.md) - Security guidelines & API key management
- [IMPLEMENTASI_LOGO.md](IMPLEMENTASI_LOGO.md) - Logo integration guide
- [LOGO_SETUP.md](LOGO_SETUP.md) - Logo customization guide

## 🤝 Contributing

Silakan buat Pull Request atau Issue untuk kontribusi dan pelaporan bug.

## 📝 License

Copyright © 2026

## 🙏 Credits

- API Al-Quran, Doa, Jadwal Shalat dari berbagai sumber
- Gemini AI by Google
- Flutter Framework by Google

