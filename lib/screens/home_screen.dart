import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/diary_service.dart';
import '../../models/diary_model.dart';
import '../../widgets/diary_card.dart';
import '../../widgets/quote_widget.dart';
import 'diary/diary_form_screen.dart';
import 'videostory_screen.dart';
import 'auth/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    final DiaryService _diaryService = DiaryService();

    if (userId == null) {
      return const Center(child: Text('User not logged in'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
        actions: [
          IconButton(
            icon: const Icon(Icons.video_collection),
            tooltip: 'Video',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const VideoStoryScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Column(
        children: [
          const QuoteWidget(),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              "Latest entries",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<DiaryEntry>>(
              stream: _diaryService.getAllEntries(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final entries = snapshot.data ?? [];
                if (entries.isEmpty) {
                  return const Center(child: Text("No entries yet."));
                }

                return ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    return DiaryCard(entry: entries[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DiaryFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
