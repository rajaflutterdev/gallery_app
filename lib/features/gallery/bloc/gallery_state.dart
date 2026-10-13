import '../data/models/gallery_image.dart';

enum GalleryStatus { initial, loading, success, failure }

class GalleryState {
  const GalleryState({
    this.status = GalleryStatus.initial,
    this.images = const [],
    this.favorites = const [],
    this.page = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.query = '',
    this.errorMessage,
  });

  final GalleryStatus status;
  final List<GalleryImage> images;
  final List<GalleryImage> favorites;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final String query;
  final String? errorMessage;

  GalleryState copyWith({
    GalleryStatus? status,
    List<GalleryImage>? images,
    List<GalleryImage>? favorites,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
    String? query,
    String? errorMessage,
    bool clearError = false,
  }) => GalleryState(
    status: status ?? this.status,
    images: images ?? this.images,
    favorites: favorites ?? this.favorites,
    page: page ?? this.page,
    hasMore: hasMore ?? this.hasMore,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    query: query ?? this.query,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
  );
}
