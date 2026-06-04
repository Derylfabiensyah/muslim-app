import 'package:flutter/material.dart';

class TasbihItem {
  final String arabic;
  final String latin;
  final String meaning;
  final int targetCount;

  const TasbihItem({
    required this.arabic,
    required this.latin,
    required this.meaning,
    required this.targetCount,
  });
}

class TasbihViewModel extends ChangeNotifier {
  // Daftar tasbih/dzikir yang bisa dipilih
  final List<TasbihItem> tasbihList = const [
    TasbihItem(
      arabic: 'سُبْحَانَ اللَّهِ',
      latin: 'Subhanallah',
      meaning: 'Maha Suci Allah',
      targetCount: 33,
    ),
    TasbihItem(
      arabic: 'الْحَمْدُ لِلَّهِ',
      latin: 'Alhamdulillah',
      meaning: 'Segala Puji Bagi Allah',
      targetCount: 33,
    ),
    TasbihItem(
      arabic: 'اللَّهُ أَكْبَرُ',
      latin: 'Allahu Akbar',
      meaning: 'Allah Maha Besar',
      targetCount: 33,
    ),
    TasbihItem(
      arabic: 'لَا إِلٰهَ إِلَّا اللَّهُ',
      latin: 'La ilaha illallah',
      meaning: 'Tiada Tuhan Selain Allah',
      targetCount: 100,
    ),
    TasbihItem(
      arabic: 'أَسْتَغْفِرُ اللَّهَ',
      latin: 'Astaghfirullah',
      meaning: 'Aku Memohon Ampun Kepada Allah',
      targetCount: 100,
    ),
    TasbihItem(
      arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      latin: 'La haula wala quwwata illa billah',
      meaning: 'Tiada Daya dan Upaya Kecuali dari Allah',
      targetCount: 100,
    ),
    TasbihItem(
      arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      latin: 'Subhanallahi wa bihamdihi',
      meaning: 'Maha Suci Allah dan dengan Memuji-Nya',
      targetCount: 100,
    ),
  ];

  int _selectedIndex = 0;
  int _count = 0;
  int _totalCount = 0; // Total keseluruhan hitungan
  bool _hasReachedTarget = false;

  // Getters
  int get selectedIndex => _selectedIndex;
  int get count => _count;
  int get totalCount => _totalCount;
  bool get hasReachedTarget => _hasReachedTarget;
  TasbihItem get currentTasbih => tasbihList[_selectedIndex];
  double get progress => currentTasbih.targetCount > 0
      ? (_count / currentTasbih.targetCount).clamp(0.0, 1.0)
      : 0.0;

  /// Menambah hitungan tasbih
  void increment() {
    _count++;
    _totalCount++;
    if (_count >= currentTasbih.targetCount && !_hasReachedTarget) {
      _hasReachedTarget = true;
    }
    notifyListeners();
  }

  /// Memilih tasbih yang berbeda
  void selectTasbih(int index) {
    if (index >= 0 && index < tasbihList.length) {
      _selectedIndex = index;
      _count = 0;
      _hasReachedTarget = false;
      notifyListeners();
    }
  }

  /// Reset hitungan untuk tasbih yang sedang aktif
  void resetCount() {
    _count = 0;
    _hasReachedTarget = false;
    notifyListeners();
  }

  /// Reset total keseluruhan hitungan
  void resetTotal() {
    _totalCount = 0;
    notifyListeners();
  }

  /// Acknowledge target tercapai
  void acknowledgeTarget() {
    _hasReachedTarget = false;
    notifyListeners();
  }
}
