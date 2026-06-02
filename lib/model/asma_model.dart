class AsmaModel {
  final int id;
  final String arab;
  final String latin;
  final String arti; // Arti dalam bahasa Indonesia

  AsmaModel({
    required this.id,
    required this.arab,
    required this.latin,
    required this.arti,
  });

  factory AsmaModel.fromJson(Map<String, dynamic> json) {
    return AsmaModel(
      id: json['urutan'] ?? 0,
      arab: json['arab'] ?? '',
      latin: json['latin'] ?? '',
      arti: json['arti'] ?? '',
    );
  }
}