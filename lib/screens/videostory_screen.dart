import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:video_player/video_player.dart';
import '../models/videostory_model.dart';
import '../services/videostory_service.dart';

class VideoStoryScreen extends StatefulWidget {
  const VideoStoryScreen({Key? key}) : super(key: key);

  @override
  State<VideoStoryScreen> createState() => _VideoStoryScreenState();
}

class _VideoStoryScreenState extends State<VideoStoryScreen> {
  final VideoStoryService _videoService = VideoStoryService();

  void _showAddDialog() {
    final _titleController = TextEditingController();
    final _urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Video Story'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(labelText: 'Video URL'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null &&
                  _titleController.text.isNotEmpty &&
                  _urlController.text.isNotEmpty) {
                final story = VideoStory(
                  id: '',
                  title: _titleController.text.trim(),
                  videoUrl: _urlController.text.trim(),
                  createdAt: DateTime.now(),
                  userId: user.uid,
                );
                await _videoService.addVideoStory(story);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showVideoPlayer(String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: VideoPlayerWidget(videoUrl: url),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Video Stories'),
      ),
      body: StreamBuilder<List<VideoStory>>(
        stream: _videoService.getAllVideoStories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final stories = snapshot.data ?? [];
          if (stories.isEmpty) {
            return const Center(child: Text('No video stories yet.'));
          }
          return ListView.builder(
            itemCount: stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              return ListTile(
                title: Text(story.title),
                subtitle: Text(story.videoUrl),
                onTap: () => _showVideoPlayer(story.videoUrl),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            alignment: Alignment.bottomCenter,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              VideoProgressIndicator(_controller, allowScrubbing: true),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }
}