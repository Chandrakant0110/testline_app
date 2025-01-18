class PracticeMaterial {
  final List? content;
  final List? keywords;

  PracticeMaterial({
    this.content,
    this.keywords,
  });

  factory PracticeMaterial.fromJson(Map<String, dynamic> json) {
    return PracticeMaterial(
      content: json['content'],
      keywords: json['keywords'],
    );
  }
}
