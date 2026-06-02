import 'dart:convert';
import 'package:http/http.dart' as http;

class DetailSuratRepository {
  Future<List<dynamic>> fetchDetailSurat(int nomor) async {
    final response =
        await http.get(Uri.parse("https://equran.id/api/v2/surat/$nomor"));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['data']['ayat'];
    } else {
      throw Exception("Gagal mengambil ayat");
    }
  }
}
