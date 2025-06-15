import 'package:flutter/material.dart';
import '../../models/image_model.dart';
import '../../services/image_service.dart';

class ImagePage extends StatefulWidget {
  final String albumId;

  const ImagePage({super.key, required this.albumId});

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  final ImageService _imageService = ImageService();

  void _addImage() async {
    // implement file picker or camera here
    const imageUrl =
        "https://example.com/sample-image.jpg"; // replace with actual upload
    final newImage = ImageEntry(
      id: '',
      albumId: widget.albumId,
      imageUrl: imageUrl,
      uploadedAt: DateTime.now(),
    );

    try {
      await _imageService.addImage(newImage);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image uploaded successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading image: $e")),
      );
    }
  }

  void _deleteImage(String imageId) async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Image"),
        content: const Text("Are you sure you want to delete this image?"),
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
        await _imageService.deleteImage(imageId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image deleted successfully")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error deleting image: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Album Images"),
      ),
      body: StreamBuilder<List<ImageEntry>>(
        stream: _imageService.getImagesByAlbum(widget.albumId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error loading images"));
          }

          final images = snapshot.data ?? [];

          if (images.isEmpty) {
            return const Center(child: Text("No images in this album."));
          }

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: images.length,
            itemBuilder: (context, index) {
              final image = images[index];
              return Stack(
                children: [
                  Image.network(image.imageUrl, fit: BoxFit.cover),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteImage(image.id),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addImage,
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}
