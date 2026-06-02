import 'package:flutter/material.dart';
import '../model/dzikir_model.dart';
import '../repository/dzikir_repository.dart';

class DzikirViewModel extends ChangeNotifier {
  final DzikirRepository repository;

  DzikirViewModel(this.repository);

  List<DzikirModel> dzikirList = [];
  bool isLoading = false;
  String? error;

  Future<void> getDzikir() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      dzikirList = await repository.getDzikir();
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
