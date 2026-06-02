import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../model/dzikir_model.dart';

class DzikirRepository {
  final String apiUrl = 'https://muslim-api-three.vercel.app/v1/dzikir';

  Future<List<DzikirModel>> getDzikir() async {
    try {
      final response = await http
          .get(Uri.parse(apiUrl))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Permintaan dzikir timeout. Cek koneksi internet.'),
          );

      if (response.statusCode != 200) {
        throw Exception('Gagal memuat data dzikir. Status: ${response.statusCode}');
      }

      final decoded = json.decode(response.body);
      late final List data;

      if (decoded is Map<String, dynamic> && decoded['data'] is List) {
        data = decoded['data'] as List;
      } else if (decoded is List) {
        data = decoded;
      } else {
        throw Exception('Format data dzikir tidak sesuai');
      }

      return data.map((e) => DzikirModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      developer.log('Detail Error Dzikir: $e');
      rethrow;
    }
  }
}
