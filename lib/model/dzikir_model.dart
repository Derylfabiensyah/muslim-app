class DzikirModel {
  final String? type;
  final String arab;
  final String indo;
  final String ulang;

  DzikirModel({
    this.type,
    required this.arab,
    required this.indo,
    required this.ulang,
  });

  factory DzikirModel.fromJson(Map<String, dynamic> json) {
    return DzikirModel(
      type: json['type']?.toString(),
      arab: json['arab'] ?? '',
      indo: json['indo'] ?? '',
      ulang: json['ulang']?.toString() ?? '',
    );
  }
}
