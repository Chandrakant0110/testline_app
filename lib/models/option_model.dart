// ignore_for_file: non_constant_identifier_names

class Option {
  final int? id;
  final String? description;
  final int? question_id;
  final bool? is_correct;
  final String? created_at;
  final String? updated_at;
  final bool? unanswered;
  final String? photo_url;

  Option({
    this.id,
    this.description,
    this.question_id,
    this.is_correct,
    this.created_at,
    this.updated_at,
    this.unanswered,
    this.photo_url,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['id'],
      description: json['description'],
      question_id: json['question_id'],
      is_correct: json['is_correct'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      unanswered: json['unanswered'],
      photo_url: json['photo_url'],
    );
  }
  
}
