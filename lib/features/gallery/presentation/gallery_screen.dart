import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constant/string_values.dart';
import '../bloc/gallery_bloc.dart';
import '../bloc/gallery_event.dart';
import '../bloc/gallery_state.dart';
import '../widgets/errorView.dart';
import '../widgets/imgeTile.dart';
import 'image_detail_screen.dart';
import 'favorites_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      context.read<GalleryBloc>().add(const GalleryNextPageRequested());
    }
  }

  void _onSearchChanged(String value) {
    print("kdngkjdfgkjdfgkj dfkjgdfkjgin $value");
    if (mounted) context.read<GalleryBloc>().add(GallerySearchChanged(value));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff84b81),
        leading: Icon(Icons.arrow_back_rounded,size: 0,),
        title: Text(
          appName,
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<GalleryBloc, GalleryState>(
            buildWhen: (a, b) => a.favorites.length != b.favorites.length,
            builder: (context, state) => IconButton(
              tooltip: favorites,
              color: Colors.white,
              icon: Badge(
                label: Text('${state.favorites.length}'),
                child: const Icon(Icons.favorite_rounded, color: Colors.white),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<GalleryBloc>(),
                    child: const FavoritesScreen(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Material(
              elevation: 10,
              color: Colors.transparent,
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  print("sljbfkjdsbdbgbkdfbg");
                  _onSearchChanged(value);
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: searchPhotos,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      FocusScope.of(context).unfocus();
                      context.read<GalleryBloc>().add(const GalleryStarted());
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<GalleryBloc, GalleryState>(
              builder: (context, state) {
                if (state.status == GalleryStatus.loading &&
                    state.images.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2,color:  Color(0xfff84b81)),
                  );
                }
                if (state.status == GalleryStatus.failure &&
                    state.images.isEmpty) {
                  return ErrorView(
                    message: state.errorMessage ?? somethingWrong,
                    onRetry: () async {
                      context.read<GalleryBloc>().add(const GalleryRefreshed());
                      _searchController.clear();
                      FocusScope.of(context).unfocus();
                    },
                  );
                }
                if (state.images.isEmpty) {
                  return Center(child: Text(notFoundImg));
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<GalleryBloc>().add(const GalleryRefreshed());
                    _searchController.clear();
                    FocusScope.of(context).unfocus();
                  },
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(
                      left: 12,
                      top: 0,
                      right: 12,
                      bottom: 18,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.78,
                        ),
                    itemCount:
                        state.images.length + (state.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= state.images.length) {
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2,color:  Color(0xfff84b81)),
                        );
                      }
                      final image = state.images[index];
                      final isFavorite = state.favorites.any(
                        (e) => e.id == image.id,
                      );
                      return Material(
                        elevation: 10,
                        color: Colors.transparent,
                        child: ImageTile(
                          image: image,
                          isFavorite: isFavorite,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ImageDetailScreen(image: image),
                            ),
                          ),
                          onFavorite: () => context.read<GalleryBloc>().add(
                            FavoriteToggled(image),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
