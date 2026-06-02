import 'package:flutter/material.dart';
import '../repository/detail_surat_repository.dart';

class DetailSuratViewModel extends ChangeNotifier {
  final DetailSuratRepository repository;

  DetailSuratViewModel(this.repository);

  List ayatList = [];
  bool isLoading = false;
  String? error;

  Future<void> getDetailSurat(int nomor) async {
    isLoading = true;
    notifyListeners();

    try {
      ayatList = await repository.fetchDetailSurat(nomor);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
