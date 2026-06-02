import 'package:flutter/material.dart';
import '../model/asma_model.dart';
import '../repository/asma_repository.dart';

class AsmaViewModel extends ChangeNotifier {
  final AsmaRepository repository;

  AsmaViewModel(this.repository);

  List<AsmaModel> asmaList = [];
  bool isLoading = false;
  String? error;

  Future<void> getAsma() async {
    // Optimasi: Jika data sudah ada, jangan ambil lagi (opsional)
    if (asmaList.isNotEmpty) return;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      asmaList = await repository.getAsma();
    } catch (e) {
      // Buat pesan error lebih bersih untuk dilihat user di layar
      error = "Gagal memuat data. Pastikan koneksi internet stabil.";
      print("Detail Error: $e"); // Tetap log error asli di console untuk debug
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi tambahan jika user ingin "Tarik untuk Segarkan" (Pull to Refresh)
  Future<void> refreshAsma() async {
    asmaList = []; // Kosongkan list dulu
    await getAsma();
  }
}