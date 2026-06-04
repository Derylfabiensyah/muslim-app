import 'package:flutter/material.dart';
import 'package:muslim_app/view/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:muslim_app/config/env_config.dart';

import 'repository/shalat_repository.dart';
import 'viewmodel/shalat_view_model.dart';

import 'repository/doa_repository.dart';
import 'viewmodel/doa_viewmodel.dart';

import 'repository/quran_repository.dart';
import 'viewmodel/quran_viewmodel.dart';

import 'repository/detail_surat_repository.dart';
import 'viewmodel/detail_surat_viewmodel.dart';

import 'repository/asma_repository.dart';
import 'viewmodel/asma_viewmodel.dart';

import 'repository/dzikir_repository.dart';
import 'viewmodel/dzikir_viewmodel.dart';

// ✅ TAMBAHAN UNTUK GEMINI CHATBOT
import 'services/gemini_services.dart';
import 'viewmodel/chat_view_model.dart';
import 'viewmodel/catatan_ramadhan_viewmodel.dart';
import 'viewmodel/tasbih_viewmodel.dart';

void main() async {
  // Pastikan Flutter binding sudah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables dari .env
  try {
    await EnvConfig.load();
    EnvConfig.validate(); // Validasi semua required env variables
  } catch (e) {
    // Jika gagal load .env, tampilkan error
    runApp(ErrorApp(error: e.toString()));
    return;
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// SHALAT
        Provider(create: (_) => ShalatRepository()),
        ChangeNotifierProvider(
          create: (context) =>
              ShalatViewModel(context.read<ShalatRepository>()),
        ),

        /// DOA
        Provider(create: (_) => DoaRepository()),
        ChangeNotifierProvider(
          create: (context) => DoaViewModel(context.read<DoaRepository>()),
        ),

        /// QURAN
        Provider(create: (_) => SuratRepository()),
        ChangeNotifierProvider(
          create: (context) => QuranViewModel(context.read<SuratRepository>()),
        ),

        /// DETAIL SURAT
        Provider(create: (_) => DetailSuratRepository()),
        ChangeNotifierProvider(
          create: (context) =>
              DetailSuratViewModel(context.read<DetailSuratRepository>()),
        ),

        /// ASMAUL HUSNA
        Provider(create: (_) => AsmaRepository()),
        ChangeNotifierProvider(
          create: (context) => AsmaViewModel(context.read<AsmaRepository>()),
        ),

        /// DZIKIR
        Provider(create: (_) => DzikirRepository()),
        ChangeNotifierProvider(
          create: (context) =>
              DzikirViewModel(context.read<DzikirRepository>()),
        ),

        // GEMINI + CHAT VIEWMODEL
        Provider(
          create: (_) =>
              GeminiService(EnvConfig.geminiApiKey), // Ambil dari env
        ),
        ChangeNotifierProvider(
          create: (context) => ChatViewModel(context.read<GeminiService>()),
        ),

        // CATATAN RAMADHAN
        ChangeNotifierProvider(
          create: (_) => CatatanRamadhanViewModel(),
        ),

        // TASBIH
        ChangeNotifierProvider(
          create: (_) => TasbihViewModel(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

/// Widget untuk menampilkan error jika environment variables gagal dimuat
class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF546B41),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 80,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Konfigurasi Error',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    error,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Solusi:\n'
                  '1. Copy file .env.example menjadi .env\n'
                  '2. Isi GEMINI_API_KEY dengan API key Anda\n'
                  '3. Restart aplikasi',
                  style: TextStyle(
                    color: Color(0xFF99AD7A),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
