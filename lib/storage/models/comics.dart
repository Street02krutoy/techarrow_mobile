class ComicsInfo {
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;

  ComicsInfo(
      {required this.title, required this.createdAt, required this.updatedAt});

  static ComicsInfo fromJson(Map<String, Object?> json) {
    if (json["title"] == null ||
        json["created_at"] == null ||
        json["updated_at"] == null) {
      throw Exception("Some arguments are not presented");
    }
    return ComicsInfo(
        title: json["title"].toString(),
        createdAt: DateTime.parse(json["created_at"].toString()),
        updatedAt: DateTime.parse(json["updated_at"].toString()));
  }

  Map<String, Object> toJson() {
    return {
      "title": title,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String()
    };
  }
}
