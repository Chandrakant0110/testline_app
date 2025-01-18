class Option {
  final int? id;
  final String? description;
  final int? question_id;
  final bool? is_correct;
  final String? created_at;
  final String? updated_at;
  final bool? unanswered;
  final String? photo_url;

  Option(
    this.id,
    this.description,
    this.question_id,
    this.is_correct,
    this.created_at,
    this.updated_at,
    this.unanswered,
    this.photo_url,
  );
}
