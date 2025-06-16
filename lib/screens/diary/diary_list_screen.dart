import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/diary_model.dart';
import '../../services/diary_service.dart';
import '../../widgets/diary_card.dart';
import 'diary_form_screen.dart';

class DiaryListScreen extends StatefulWidget {
  const DiaryListScreen({Key? key}) : super(key: key);

  @override
  State<DiaryListScreen> createState() => _DiaryListScreenState();
}

class _DiaryListScreenState extends State<DiaryListScreen> {
  final DiaryService _diaryService = DiaryService();
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Center(child: Text("User not logged in"));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Diary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DiaryFormScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<DiaryEntry>>(
        stream: _diaryService.getUserEntries(userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading diary entries'));
          }

          final entries = snapshot.data ?? [];

          if (entries.isEmpty) {
            return const Center(child: Text('No entries yet.'));
          }

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return DiaryCard(entry: entry);
            },
          );
        },
      ),
    );
  }
}
