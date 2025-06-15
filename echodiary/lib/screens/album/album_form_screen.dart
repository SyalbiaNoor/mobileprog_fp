import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/album_model.dart';
import '../../services/album_service.dart';

class AlbumFormScreen extends StatefulWidget {
  final Album? album;

  const AlbumFormScreen({super.key, this.album});

  @override
  State<AlbumFormScreen> createState() => _AlbumFormScreenState();
}

class _AlbumFormScreenState extends State<AlbumFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final AlbumService _albumService = AlbumService();

  @override
  void initState() {
    super.initState();
    if (widget.album != null) {
      _titleController.text = widget.album!.title;
    }
  }

  Future<void> _saveAlbum() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final isEditing = widget.album != null;

    final data = {
      'title': _titleController.text.trim(),
      'createdAt': DateTime.now(),
      'userId': user.uid,
      'photos': [], // empty list for new albums
    };

    try {
      if (isEditing) {
        await _albumService.updateAlbum(widget.album!.id, data);
      } else {
        final newAlbum = Album(
          id: '',
          title: data['title'] as String,
          userId: user.uid,
          createdAt: data['createdAt'] as DateTime,
          photos: [],
        );
        await _albumService.addAlbum(newAlbum);
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.album != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Album' : 'New Album'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await _saveAlbum();
                  }
                },
                child: Text(isEditing ? 'Update' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
