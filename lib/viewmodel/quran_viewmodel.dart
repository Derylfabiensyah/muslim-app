import 'package:flutter/material.dart';
import '../model/quran_model.dart';
import '../repository/quran_repository.dart';

class QuranViewModel extends ChangeNotifier {
  final SuratRepository repository;

  QuranViewModel(this.repository);

  List<Surat> suratList = [];
  bool isLoading = false;
  String? error;

  Future<void> getSurat() async {
    isLoading = true;
    notifyListeners();

    try {
      suratList = await repository.fetchSurat();
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
