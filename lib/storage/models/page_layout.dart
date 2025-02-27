class PageLayout {
  final List images;
  final int width;
  final int height;

  PageLayout({required this.images, required this.height, required this.width});

  static PageLayout fromJson(Map<String, dynamic> json) {
    if (json["images"] is! List ||
        json["width"] is! int ||
        json["height"] is! int) {
      throw Exception("Some arguments are not presented");
    }
    return PageLayout(
        images: json["images"], width: json["width"], height: json["height"]);
  }

  Map<String, Object> toJson() {
    return {"images": images, "width": width, "height": height};
  }
}
