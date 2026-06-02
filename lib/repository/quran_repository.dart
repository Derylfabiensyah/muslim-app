import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/quran_model.dart';

class SuratRepository {
  final String baseUrl = "https://equran.id/api/v2/surat";

  Future<List<Surat>> fetchSurat() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List data = json['data'];
      return data.map((e) => Surat.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil data surat");
    }
  }
}
