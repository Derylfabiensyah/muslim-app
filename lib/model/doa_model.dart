class Doa {
  final String id;
  final String judul;
  final String arab;
  final String indo;
  final String source;

  Doa({
    required this.id,
    required this.judul,
    required this.arab,
    required this.indo,
    required this.source,
  });

  factory Doa.fromJson(Map<String, dynamic> json) {
    return Doa(
      id: json['id']?.toString() ?? json['judul']?.toString() ?? '',
      judul: json['judul']?.toString() ?? '',
      arab: json['arab']?.toString() ?? '',
      indo: json['indo']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
    );
  }
}
