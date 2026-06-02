import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../model/doa_model.dart';

class DoaRepository {
  final String apiUrl = "https://muslim-api-three.vercel.app/v1/doa";

  Future<List<Doa>> fetchDoa() async {
    try {
      final response = await http
          .get(
            Uri.parse(apiUrl),
            headers: {
              'Accept': 'application/json',
            },
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Permintaan Doa timeout. Cek koneksi internet.');
            },
          );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        late final List data;

        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map<String, dynamic> && decoded['data'] is List) {
          data = decoded['data'] as List;
        } else {
          throw Exception('Format data Doa tidak sesuai');
        }

        return data.map((e) => Doa.fromJson(e as Map<String, dynamic>)).toList();
      } else {
        throw Exception("Gagal mengambil data: Status ${response.statusCode}");
      }
    } catch (e) {
      developer.log("Detail Error: $e");
      throw Exception("Gagal mengambil data doa. Periksa koneksi internet atau coba lagi nanti.");
    }
  }
}

