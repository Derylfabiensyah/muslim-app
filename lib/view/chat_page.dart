import 'package:flutter/material.dart';
import 'package:muslim_app/model/chat_massage_model.dart';
import 'package:muslim_app/viewmodel/chat_view_model.dart';
import 'package:provider/provider.dart';


class ChatPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final bool hideAppBar;

  ChatPage({super.key, this.hideAppBar = false});

  // Helper function agar Logika kirim pesan tidak duplikat
  void _sendAction(ChatViewModel viewModel) {
    if (_controller.text.trim().isNotEmpty) {
      viewModel.sendMessage(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ChatViewModel>();

    Widget buildMessageBubble(ChatMessage msg) {
      final bubbleColor = msg.isUser ? const Color(0xFFCCDAD4) : const Color(0xFFE8F5EA);
      final textColor = msg.isUser ? Colors.black87 : const Color(0xFF1B3B26);
      final alignment = msg.isUser ? Alignment.centerRight : Alignment.centerLeft;
      final borderRadius = BorderRadius.only(
        topLeft: const Radius.circular(18),
        topRight: const Radius.circular(18),
        bottomLeft: Radius.circular(msg.isUser ? 18 : 6),
        bottomRight: Radius.circular(msg.isUser ? 6 : 18),
      );

      return Align(
        alignment: alignment,
        child: Column(
          crossAxisAlignment:
              msg.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: borderRadius,
                border: Border.all(
                  color: msg.isUser ? const Color(0xFFB3C7BF) : const Color(0xFFD8E8D7),
                ),
              ),
              child: Text(
                msg.text,
                style: TextStyle(color: textColor, fontSize: 15, height: 1.5),
              ),
            ),
            Text(
              '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      );
    }

    final chatBody = Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5EA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.smart_toy, color: Color(0xFF546B41), size: 24),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Muslim AI',
                      style: TextStyle(
                        color: Color(0xFF546B41),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Obrolan AI ringan dan praktis untuk tiap hari.',
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                  ],
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F7F2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.keyboard_arrow_down, color: Color(0xFF546B41), size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: const Color(0xFFF6FBF6),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: viewModel.messages.length,
              itemBuilder: (context, index) {
                final msg = viewModel.messages[index];
                return buildMessageBubble(msg);
              },
            ),
          ),
        ),
        if (viewModel.isLoading)
          const LinearProgressIndicator(
            minHeight: 3,
            color: Color(0xFF546B41),
          ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FBF7),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.03),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Icon(Icons.chat_bubble_outline, color: Color(0xFF546B41)),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendAction(viewModel),
                          decoration: const InputDecoration(
                            hintText: 'Ketik pesan untuk Muslim AI...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 48,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF546B41),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  icon: const Icon(Icons.arrow_forward, size: 18),
                  label: const Text('Kirim'),
                  onPressed: () => _sendAction(viewModel),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    return SafeArea(
      child: hideAppBar
          ? chatBody
          : Scaffold(
              backgroundColor: Colors.white,
              body: chatBody,
            ),
    );
  }
}
