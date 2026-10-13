import '../data/models/gallery_image.dart';

abstract class GalleryEvent {
  const GalleryEvent();
}

class GalleryStarted extends GalleryEvent {
  const GalleryStarted();
}

class GalleryRefreshed extends GalleryEvent {
  const GalleryRefreshed();
}

class GallerySearchChanged extends GalleryEvent {
  const GallerySearchChanged(this.query);
  final String query;
}

class FavoriteToggled extends GalleryEvent {
  const FavoriteToggled(this.image);

  final GalleryImage image;
}

class FavoritesReloaded extends GalleryEvent {
  const FavoritesReloaded();
}

class GalleryNextPageRequested extends GalleryEvent {
  const GalleryNextPageRequested();
}
