class GalleryImage {
  const GalleryImage({
    this.id,
    this.author,
    this.width,
    this.height,
    this.url,
    this.downloadUrl,
    this.description,
    this.urls,
    this.sponsorship,
  });

  final String? id;
  final String? author;
  final num? width;
  final num? height;
  final String? url;
  final String? downloadUrl;
  final String? description;
  final PhotoUrls? urls;
  final Sponsorship? sponsorship;

  factory GalleryImage.fromJson(Map<String, dynamic> json) => GalleryImage(
    id: json['id'],
    author: json['author'],
    width: json['width'],
    height: json['height'],
    url: json['url'],
    downloadUrl: json['download_url'],
    description: json['description'],
    urls: json['urls'] != null ? PhotoUrls.fromJson(Map<String, dynamic>.from(json['urls'])) : null,
    sponsorship: json['sponsorship'] != null ? Sponsorship.fromJson(Map<String, dynamic>.from(json['sponsorship'])) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'author': author,
    'width': width,
    'height': height,
    'url': url,
    'download_url': downloadUrl,
    'description': description,
    "urls": urls,
    "sponsorship": sponsorship?.toJson(),
  };

  factory GalleryImage.fromStoredJson(Map<String, dynamic> json) =>
      GalleryImage.fromJson(json);
}

class PhotoUrls {
  final String? raw;
  final String? full;
  final String? regular;
  final String? small;
  final String? thumb;
  final String? smallS3;

  const PhotoUrls({
    this.raw,
    this.full,
    this.regular,
    this.small,
    this.thumb,
    this.smallS3,
  });

  factory PhotoUrls.fromJson(Map<String, dynamic> json) {
    return PhotoUrls(
      raw: json['raw'] as String?,
      full: json['full'] as String?,
      regular: json['regular'] as String?,
      small: json['small'] as String?,
      thumb: json['thumb'] as String?,
      smallS3: json['small_s3'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'raw': raw,
      'full': full,
      'regular': regular,
      'small': small,
      'thumb': thumb,
      'small_s3': smallS3,
    };
  }
}

class Sponsorship {
  final Sponsor? sponsor;

  const Sponsorship({this.sponsor});

  factory Sponsorship.fromJson(Map<String, dynamic> json) {
    return Sponsorship(
      sponsor: json['sponsor'] != null
          ? Sponsor.fromJson(Map<String, dynamic>.from(json['sponsor']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'sponsor': sponsor?.toJson()};
  }
}

class Sponsor {
  final String? name;
  final String? bio;

  Sponsor({this.name, this.bio});

  factory Sponsor.fromJson(Map<String, dynamic> json) {
    return Sponsor(name: json['name'], bio: json['bio']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'bio': bio};
  }
}
