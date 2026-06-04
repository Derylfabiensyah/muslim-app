import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/quran_model.dart';
import '../model/quran_quote.dart';

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

class QuranQuoteRepository {
  final String baseUrl = "https://api.myquran.com/v3/quran/random";

  Future<QuranQuote> fetchRandomQuote() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final json = jsonDecode(utf8.decode(response.bodyBytes));
      if (json['status'] == true) {
        return QuranQuote.fromJson(json);
      } else {
        throw Exception("Gagal mendapatkan status sukses dari API");
      }
    } else {
      throw Exception("Gagal memuat kutipan Al-Quran");
    }
  }
}

