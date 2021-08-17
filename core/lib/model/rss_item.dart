class RSSItem {
  RSSItem(
      {required this.id,
        required this.feedUrl,
        required this.feedTitle,
        required this.title,
        required this.description,
        required this.url,
        required this.displayTime,
        this.categories = const [],
        this.author,
        this.keywords = const [],
        this.feedThumbnail});

  final String id;
  final String title;
  final String feedTitle;
  final String? feedThumbnail;
  final String? author;
  final List<String> categories;
  final DateTime displayTime;
  final String description;

  // uid;
  final String feedUrl;

  final String url;
  final List<String> keywords;
}
