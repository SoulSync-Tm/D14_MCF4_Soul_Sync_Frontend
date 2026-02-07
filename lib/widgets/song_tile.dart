import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SongTile extends StatelessWidget {
  final String title;
  final String artist;
  final String imageUrl;
  final VoidCallback? onMorePressed;
  final VoidCallback? onTap;

  const SongTile({
    super.key,
    required this.title,
    required this.artist,
    required this.imageUrl,
    this.onMorePressed,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: onTap ?? () => context.push('/player'),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[700],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[700],
                ),
                child: const Icon(
                  Icons.music_note,
                  color: Colors.white54,
                  size: 24,
                ),
              );
            },
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        artist,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: IconButton(
        onPressed: onMorePressed ?? () {
          // TODO: Show options menu
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Song options coming soon!'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        icon: const Icon(
          Icons.more_vert,
          color: Colors.white70,
        ),
      ),
    );
  }
}