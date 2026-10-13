import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/favorites_repository.dart';
import '../data/repository/image_api_service.dart';
import 'gallery_event.dart';
import 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  GalleryBloc({required this.imageApiService, required this.favorites})
    : super(const GalleryState()) {
    on<GalleryStarted>(onStarted);
    on<GalleryRefreshed>(onRefresh);
    on<GallerySearchChanged>(onSearch);
    on<FavoriteToggled>(onFavoriteToggled);
    on<FavoritesReloaded>(onFavoritesReloaded);
    on<GalleryNextPageRequested>(onNextPage);
  }

  final ImageApiService imageApiService;
  final FavoritesRepository favorites;
  static const pageSize = 30;

  ///search

  Future<void> onStarted(
    GalleryStarted event,
    Emitter<GalleryState> emit,
  ) async {
    emit(state.copyWith(status: GalleryStatus.loading, clearError: true));
    await loadFavorites(emit);
    await loadFirstPage(emit, state.query);
  }

  Future<void> loadFirstPage(Emitter<GalleryState> emit, String query) async {
    emit(
      state.copyWith(
        status: GalleryStatus.loading,
        images: [],
        page: 1,
        hasMore: true,
        isLoadingMore: false,
        query: query,
        clearError: true,
      ),
    );
    try {
      final images = await imageApiService.fetchImages(
        page: 1,
        query: query,
        perPage: pageSize,
      );
      print("imgae usgfsfufebfebfe----${images.length.toString()}");
      emit(
        state.copyWith(
          status: GalleryStatus.success,
          images: images,
          page: 1,
          hasMore: images.length == pageSize,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GalleryStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> onRefresh(
    GalleryRefreshed event,
    Emitter<GalleryState> emit,
  ) async {
    await loadFirstPage(emit, state.query);
  }

  Future<void> onSearch(
    GallerySearchChanged event,
    Emitter<GalleryState> emit,
  ) async {
    try {
      final images = await imageApiService.searchImages(
        page: 1,
        query: event.query,
        perPage: pageSize,
      );
      print("Query State value is ----${event.query}");
      print("image -----urllllllllll${images.first.urls!.small.toString()}");
      emit(
        state.copyWith(
          status: GalleryStatus.success,
          images: images,
          page: 1,
          hasMore: images.length == pageSize,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: GalleryStatus.failure,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> onFavoriteToggled(
    FavoriteToggled event,
    Emitter<GalleryState> emit,
  ) async {
    await favorites.toggle(event.image);
    await loadFavorites(emit);
  }

  Future<void> onFavoritesReloaded(
    FavoritesReloaded event,
    Emitter<GalleryState> emit,
  ) => loadFavorites(emit);

  Future<void> loadFavorites(Emitter<GalleryState> emit) async {
    emit(state.copyWith(favorites: await favorites.getFavorites()));
  }

  Future<void> onNextPage(
    GalleryNextPageRequested event,
    Emitter<GalleryState> emit,
  ) async {
    if (state.status != GalleryStatus.success ||
        state.isLoadingMore ||
        !state.hasMore)
      return;
    emit(state.copyWith(isLoadingMore: true));
    try {
      final nextPage = state.page + 1;
      final images = await imageApiService.fetchImages(
        page: nextPage,
        query: state.query,
        perPage: pageSize,
      );
      final ids = state.images.map((e) => e.id).toSet();
      final unique = images.where((e) => !ids.contains(e.id)).toList();
      emit(
        state.copyWith(
          images: [...state.images, ...unique],
          page: nextPage,
          hasMore: images.length == pageSize,
          isLoadingMore: false,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoadingMore: false,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
