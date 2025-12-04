import 'package:flutter/material.dart';
import 'api_request.dart'; // generateText функц энд

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> messages = [
    {"text": "Сайн уу? Таны ACE туслах байна. Таньд юугаар туслах уу?", "isUser": false},
  ];
  bool _loading = false;

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty || _loading) return;

    final userMessage = _controller.text.trim();

    setState(() {
      messages.add({"text": userMessage, "isUser": true});
      _loading = true;
    });

    _controller.clear();

    try {
      // Backend руу request явуулах
      final aiResponse = await generateText(
        "You are a career advisor for teenagers. Give friendly advice: $userMessage",
      );

      setState(() {
        messages.add({"text": aiResponse, "isUser": false});
      });
    } catch (e) {
      setState(() {
        messages.add({
          "text": "ACE-с зөвлөгөө авахад алдаа гарлаа.",
          "isUser": false,
        });
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFFA58BFF),
        title: const Text(
          "ACE AI Chatbot",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color:Colors.white ),
          onPressed: () => Navigator.pop(context), // Буцах функц
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg["isUser"]
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                    decoration: BoxDecoration(
                      color: msg["isUser"]
                          ? const Color(0xFFA58BFF)
                          : const Color.fromARGB(255, 187, 139, 255),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: msg["isUser"]
                            ? const Radius.circular(16)
                            : const Radius.circular(0),
                        bottomRight: msg["isUser"]
                            ? const Radius.circular(0)
                            : const Radius.circular(16),
                      ),
                    ),
                    child: Text(
                      msg["text"],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: CircularProgressIndicator(),
            ),
          _inputArea(),
        ],
      ),
    );
  }

  Widget _inputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Харилцан яриаг эхлүүлэх...",
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _sendMessage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFA58BFF),
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(14),
            ),
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
