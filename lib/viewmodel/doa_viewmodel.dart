import 'package:flutter/material.dart';
import '../model/doa_model.dart';
import '../repository/doa_repository.dart';

class DoaViewModel extends ChangeNotifier {
  final DoaRepository repository;

  DoaViewModel(this.repository);

  List<Doa> doaList = [];
  bool isLoading = false;
  String? error;

  Future<void> getDoa() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      doaList = await repository.fetchDoa();
    } catch (e) {
      error = e.toString();
      doaList = [];
    }

    isLoading = false;
    notifyListeners();
  }
}
