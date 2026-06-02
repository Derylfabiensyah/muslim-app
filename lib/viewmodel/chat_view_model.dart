import 'package:flutter/material.dart';
import 'package:muslim_app/model/chat_massage_model.dart';  // ← ubah ke chat_massage_model
import 'package:muslim_app/services/gemini_services.dart';

class ChatViewModel extends ChangeNotifier {
  final GeminiService _geminiService;
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  ChatViewModel(this._geminiService);

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Tambah pesan user
    _messages.add(ChatMessage(text: text, isUser: true, timestamp: DateTime.now()));
    _isLoading = true;
    notifyListeners();

    // Ambil respon dari AI
    final response = await _geminiService.getResponse(text);

    // Tambah pesan AI
    _messages.add(ChatMessage(text: response, isUser: false, timestamp: DateTime.now()));
    _isLoading = false;
    notifyListeners();
  }
}