import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Configuration class untuk mengelola environment variables
/// File ini membaca dari .env yang sudah di-gitignore
class EnvConfig {
  /// Load environment variables dari file .env
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      throw Exception(
        'Gagal load .env file. Pastikan file .env sudah ada dan berisi GEMINI_API_KEY. '
        'Copy dari .env.example jika belum ada. Error: $e',
      );
    }
  }

  /// Gemini AI API Key
  static String get geminiApiKey {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'GEMINI_API_KEY tidak ditemukan di .env file. '
        'Pastikan sudah menambahkan GEMINI_API_KEY=your_key di file .env',
      );
    }
    return apiKey;
  }

  /// Helper untuk mendapatkan env variable dengan default value
  static String get(String key, {String defaultValue = ''}) {
    return dotenv.env[key] ?? defaultValue;
  }

  /// Check apakah env variable ada
  static bool has(String key) {
    return dotenv.env.containsKey(key);
  }

  /// Validasi semua required env variables
  static void validate() {
    final requiredKeys = ['GEMINI_API_KEY'];
    final missing = <String>[];

    for (final key in requiredKeys) {
      if (!has(key) || dotenv.env[key]!.isEmpty) {
        missing.add(key);
      }
    }

    if (missing.isNotEmpty) {
      throw Exception(
        'Environment variables berikut belum diset: ${missing.join(", ")}\n'
        'Silakan tambahkan di file .env',
      );
    }
  }
}
