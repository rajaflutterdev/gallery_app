import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/string_values.dart';
import '../bloc/gallery_bloc.dart';
import '../bloc/gallery_event.dart';
import '../bloc/gallery_state.dart';
import '../widgets/favorite_tile.dart';
import 'image_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Color(0xfff84b81),
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
      ),
      title: Text(
        favoritePhotos,
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
      ),
    ),
    body: BlocBuilder<GalleryBloc, GalleryState>(
      builder: (context, state) {
        if (state.favorites.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border, size: 58),
                  SizedBox(height: 12),
                  Text(
                    noFavoritesYet,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(favoriteSave, textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.78,
          ),
          itemCount: state.favorites.length,
          itemBuilder: (context, index) {
            final image = state.favorites[index];
            return FavoriteTile(
              image: image,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ImageDetailScreen(image: image),
                ),
              ),
              onRemove: () =>
                  context.read<GalleryBloc>().add(FavoriteToggled(image)),
            );
          },
        );
      },
    ),
  );
}
