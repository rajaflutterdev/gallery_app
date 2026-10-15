import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gal/gal.dart';
import '../../../core/constant/string_values.dart';
import '../bloc/gallery_bloc.dart';
import '../bloc/gallery_event.dart';
import '../bloc/gallery_state.dart';
import '../data/models/gallery_image.dart';

class ImageDetailScreen extends StatefulWidget {
  const ImageDetailScreen({super.key, required this.image});

  final GalleryImage image;

  @override
  State<ImageDetailScreen> createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  bool downloadingImage = false;

  Future<void> downloadImage() async {
    setState(() => downloadingImage = true);
    try {
      final url = widget.image.urls!.small.toString();
      final response = await Dio().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) throw Exception(emptyImg);
      await Gal.putImageBytes(
        Uint8List.fromList(bytes),
        name: 'pixel_${widget.image.id}',
      );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(saveImgFromGallery)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$notSaveImg $e')));
      }
    } finally {
      if (mounted) setState(() => downloadingImage = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.image;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff84b81),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
        title: Text(
          photoDetails,
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        actions: [
          BlocBuilder<GalleryBloc, GalleryState>(
            builder: (context, state) {
              final favorite = state.favorites.any((e) => e.id == image.id);
              print("favorite value is :::$favorite");
              return IconButton(
                tooltip: favorite ? removeFav : addFav,
                onPressed: () =>
                    context.read<GalleryBloc>().add(FavoriteToggled(image)),
                icon: Icon(
                  favorite ? Icons.favorite : Icons.favorite_border,
                  color: favorite ? Colors.pink : Colors.white,
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Hero(
              tag: 'image-${image.id}',
              child: AspectRatio(
                aspectRatio: 0.85,
                child: CachedNetworkImage(
                  imageUrl: image.urls!.small.toString(),
                  fit: BoxFit.cover,
                  placeholder: (_, _) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2,color:  Color(0xfff84b81)),
                  ),
                  errorWidget: (_, _, _) =>
                      const Center(child: Icon(Icons.broken_image, size: 48)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            '$name : ${widget.image.sponsorship?.sponsor?.name?.isNotEmpty == true ? widget.image.sponsorship!.sponsor!.name! : "Unknown"}',
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),

          const SizedBox(height: 15),

          Text(
            '$bio :',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),

          const SizedBox(height: 5),

          Text(
            widget.image.sponsorship?.sponsor?.bio?.isNotEmpty == true
                ? widget.image.sponsorship!.sponsor!.bio!
                : bioNotAvailable,
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 15),

          Text(
            '$description :',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),

          const SizedBox(height: 5),

          Text(
            widget.image.description?.isNotEmpty == true
                ? widget.image.description!
                : descriptionNotAvailable,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar:  Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 52,
          child: FilledButton.icon(
            onPressed: downloadingImage ? null : downloadImage,
            icon: downloadingImage
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2,color:  Color(0xfff84b81)),
            )
                : const Icon(Icons.download_rounded),
            label: Text(downloadingImage ? saveImg : downloadImg),
          ),
        ),
      ),
    );
  }
}
