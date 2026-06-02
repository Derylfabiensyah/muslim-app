import 'package:flutter/material.dart';
import '../model/catatan_ramadhan_model.dart';

class CatatanRamadhanViewModel extends ChangeNotifier {
  final List<ShalatReport> _shalatReports = [
    ShalatReport(date: DateTime.now().toIso8601String().split('T')[0]),
  ];

  final List<CeramahEntry> _ceramahEntries = [];
  final List<InfaqEntry> _infaqEntries = [];

  List<ShalatReport> get shalatReports => _shalatReports;
  List<CeramahEntry> get ceramahEntries => _ceramahEntries;
  List<InfaqEntry> get infaqEntries => _infaqEntries;

  void saveData() {
    notifyListeners();
  }

  void updateShalat(String date, String prayer, bool value) {
    final report = _getOrCreateShalat(date);
    switch (prayer) {
      case 'subuh':
        report.subuh = value;
        break;
      case 'dzuhur':
        report.dzuhur = value;
        break;
      case 'ashar':
        report.ashar = value;
        break;
      case 'maghrib':
        report.maghrib = value;
        break;
      case 'isya':
        report.isya = value;
        break;
    }
    notifyListeners();
  }

  ShalatReport _getOrCreateShalat(String date) {
    try {
      return _shalatReports.firstWhere((r) => r.date == date);
    } catch (_) {
      final r = ShalatReport(date: date);
      _shalatReports.add(r);
      return r;
    }
  }

  void addCeramah(String judul, String penceramah, String ringkasan) {
    _ceramahEntries.insert(
      0,
      CeramahEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now().toIso8601String().split('T')[0],
        judul: judul,
        penceramah: penceramah,
        ringkasanMateri: ringkasan,
      ),
    );
    notifyListeners();
  }

  void deleteCeramah(String id) {
    _ceramahEntries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void addInfaq(double nominal, String keterangan) {
    _infaqEntries.insert(
      0,
      InfaqEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now().toIso8601String().split('T')[0],
        nominal: nominal,
        keterangan: keterangan,
      ),
    );
    notifyListeners();
  }

  void deleteInfaq(String id) {
    _infaqEntries.removeWhere((e) => e.id == id);
    notifyListeners();
  }
}
