class QuranQuote {
  final String arab;
  final String translation;
  final String surahName;
  final int ayahNumber;

  QuranQuote({
    required this.arab,
    required this.translation,
    required this.surahName,
    required this.ayahNumber,
  });

  factory QuranQuote.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return QuranQuote(
      arab: data['arab'] ?? '',
      translation: data['translation'] ?? '',
      surahName: data['surah'] != null ? (data['surah']['name_latin'] ?? '') : '',
      ayahNumber: data['ayah_number'] ?? 0,
    );
  }
}
