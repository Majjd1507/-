import 'package:flutter/material.dart';
import 'package:ai_psychologist/features/chat/widgets/message_bubble.dart';
import 'package:ai_psychologist/features/chat/widgets/chat_input_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  Future<void> _sendMessage(String message) async {
    setState(() {
      _messages.insert(0, {'message': message, 'isMe': true});
      _isTyping = true;
    });

    // Replace with your backend URL
    final url = Uri.parse('http://localhost:3000/api/chat');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _messages.insert(0, {'message': responseData['reply'], 'isMe': false});
        });
      } else {
        // Handle error
        setState(() {
          _messages.insert(0, {'message': 'Error: Could not get reply.', 'isMe': false});
        });
      }
    } catch (error) {
      setState(() {
        _messages.insert(0, {'message': 'Error: Could not connect to server.', 'isMe': false});
      });
    } finally {
      setState(() {
        _isTyping = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мира'),
        backgroundColor: Colors.blue.shade300,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (ctx, index) => MessageBubble(
                message: _messages[index]['message'],
                isMe: _messages[index]['isMe'],
              ),
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    SizedBox(width: 15),
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 10),
                    Text("Мира печатает..."),
                  ],
                ),
              ),
            ),
          ChatInputField(onSendMessage: _sendMessage),
        ],
      ),
    );
  }
}
