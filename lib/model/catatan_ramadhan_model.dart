class ShalatReport {
  final String date;
  bool subuh;
  bool dzuhur;
  bool ashar;
  bool maghrib;
  bool isya;

  ShalatReport({
    required this.date,
    this.subuh = false,
    this.dzuhur = false,
    this.ashar = false,
    this.maghrib = false,
    this.isya = false,
  });
}

class CeramahEntry {
  final String id;
  final String date;
  String judul;
  String penceramah;
  String ringkasanMateri;

  CeramahEntry({
    required this.id,
    required this.date,
    this.judul = '',
    this.penceramah = '',
    this.ringkasanMateri = '',
  });
}

class InfaqEntry {
  final String id;
  final String date;
  double nominal;
  String keterangan;

  InfaqEntry({
    required this.id,
    required this.date,
    this.nominal = 0,
    this.keterangan = '',
  });
}
