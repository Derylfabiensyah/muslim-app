import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService(String apiKey)
      : _model = GenerativeModel(
          model:
              'gemini-3-flash-preview', // Gunakan -latest untuk menghindari 404
          apiKey: apiKey,
          systemInstruction: Content.system(
            "Anda adalah asisten khusus untuk Muslim App."
            "Anda hanya boleh menjawab pertanyaan seputar topik islam,sejarah islam,doa,dan ibadah."
            "Jika pengguna bertanya di luar topik tersebut (seperti politik praktis,coding, atau hal umum lainnya),"
            "Jawablah dengan sopan bahwa anda hanya bisa membantu dalam hal agama islam."
          )
        );

  Future<String> getResponse(String prompt) async {
    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);
      return response.text ?? "Maaf, saya tidak bisa menjawab itu.";
    } catch (e) {
      return "Terjadi kesalahan: $e";
    }
  }
}