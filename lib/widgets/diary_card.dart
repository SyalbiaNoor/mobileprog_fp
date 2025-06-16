import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/diary_model.dart';
import '../services/diary_service.dart';
import '../screens/diary/diary_form_screen.dart';

class DiaryCard extends StatelessWidget {
  final DiaryEntry entry;
  final DiaryService _diaryService = DiaryService();

  DiaryCard({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(
          entry.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.content.length > 100
                  ? "${entry.content.substring(0, 100)}..."
                  : entry.content,
            ),
            const SizedBox(height: 4),
            Text(
              "Author: ${entry.userId}",
              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        trailing: entry.userId == currentUser?.uid
            ? PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DiaryFormScreen(entry: entry),
                      ),
                    );
                  } else if (value == 'delete') {
                    _diaryService.deleteEntry(entry.id).then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Entry deleted")),
                      );
                    }).catchError((e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $e")),
                      );
                    });
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              )
            : null,
      ),
    );
  }
}
