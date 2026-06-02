import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../model/asma_model.dart';

class AsmaRepository {
  final String apiUrl = 'https://asmaul-husna-api.vercel.app/api/all';

  Future<List<AsmaModel>> getAsma() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['data'] != null && jsonData['data'] is List) {
          final List list = jsonData['data'];
          return list.map((e) => AsmaModel.fromJson(e as Map<String, dynamic>)).toList();
        } else {
          throw Exception('Format data tidak sesuai');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      // Ini akan membantu Anda melihat error asli di terminal VS Code/Chrome
      developer.log('Log Error Asli: $e');
      rethrow; // Melemparkan error agar ditangkap ViewModel
    }
  }
}