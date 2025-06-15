import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/album_service.dart';
import '../../models/album_model.dart';
import 'album_form_screen.dart';
import '../images/image_page.dart'; // import the ImagePage

class AlbumPage extends StatefulWidget {
  const AlbumPage({super.key});

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  final AlbumService _albumService = AlbumService();
  final userId = FirebaseAuth.instance.currentUser?.uid;

  void _deleteAlbum(String albumId) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Album"),
        content: const Text("Are you sure you want to delete this album?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      try {
        await _albumService.deleteAlbum(albumId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Album deleted successfully")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error deleting album: $e")),
        );
      }
    }
  }

  void _editAlbum(Album album) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AlbumFormScreen(album: album)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Center(child: Text("User not logged in"));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Albums"),
      ),
      body: StreamBuilder<List<Album>>(
        stream: _albumService.getUserAlbums(userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading albums"));
          }

          final albums = snapshot.data ?? [];

          if (albums.isEmpty) {
            return const Center(child: Text("No albums yet."));
          }

          return ListView.builder(
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final album = albums[index];
              return ListTile(
                title: Text(album.title),
                onTap: () {
                  // Navigate to the ImagePage for the selected album
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImagePage(albumId: album.id),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editAlbum(album),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteAlbum(album.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AlbumFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
