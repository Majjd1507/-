import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История сессий'),
        backgroundColor: Colors.blue.shade300,
      ),
      body: ListView.builder(
        itemCount: 10, // Dummy data
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Сессия ${index + 1}'),
            subtitle: const Text('Нажмите, чтобы просмотреть'),
            onTap: () {
              // Navigate to chat history view
            },
          );
        },
      ),
    );
  }
}
