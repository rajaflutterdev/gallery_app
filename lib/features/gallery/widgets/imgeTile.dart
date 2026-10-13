import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/models/gallery_image.dart';

class ImageTile extends StatelessWidget {
  const ImageTile({
    super.key,
    required this.image,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
  });

  final GalleryImage image;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'image-${image.id}',
            child: CachedNetworkImage(
              imageUrl: image.urls!.small.toString(),
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(
                color: Colors.black12,
                child: const Center(
                  child: CircularProgressIndicator(strokeWidth: 2,color:  Color(0xfff84b81)),
                ),
              ),
              errorWidget: (_, _, _) =>
                  const Center(child: Icon(Icons.broken_image_outlined)),
            ),
          ),

          Positioned(
            right: 5,
            top: 5,
            child: Material(
              borderRadius: BorderRadius.circular(100),
              elevation: 5,
              color: Colors.transparent,
              child: IconButton.filledTonal(
                visualDensity: VisualDensity.standard,
                color: Colors.red,
                onPressed: onFavorite,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.pink : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
