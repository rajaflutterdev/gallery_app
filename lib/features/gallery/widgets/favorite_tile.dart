import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/models/gallery_image.dart';

class FavoriteTile extends StatelessWidget {
  const FavoriteTile({
    required this.image,
    required this.onTap,
    required this.onRemove,
  });

  final GalleryImage image;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Material(
    borderRadius: BorderRadius.circular(18),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: image.urls!.small.toString(),
            fit: BoxFit.cover,
            placeholder: (_, _) =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2,color:  Color(0xfff84b81),)),
            errorWidget: (_, _, _) => const Icon(Icons.broken_image),
          ),
          Positioned(
            right: 4,
            top: 4,
            child: IconButton.filledTonal(
              onPressed: onRemove,
              icon: const Icon(Icons.favorite, color: Colors.pink),
            ),
          ),
        ],
      ),
    ),
  );
}