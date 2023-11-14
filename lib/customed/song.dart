class Song {
  final int id;
  final String title;
  final String description;
  final String copyright;
  final String refrain;
  final List<String> paragraphes;

  const Song({
    required this.id,
    required this.title,
    required this.description,
    required this.copyright,
    required this.refrain,
    required this.paragraphes,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        copyright: json['copyright'],
        refrain: json['refrain'],
        paragraphes: json['paragraphes']);
  }
}
