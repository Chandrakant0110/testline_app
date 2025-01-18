import 'option_model.dart';
import 'reading_material_model.dart';

class Question {
  final int? id;
  final String? description;
  final String? difficulty_level;
  final String? topic;
  final bool? is_published;
  final String? created_at;
  final String? updated_at;
  final String? detailed_solution;
  final String? type;
  final bool? is_mandatory;
  final bool? show_in_feed;
  final String? pyq_label;
  final int? topic_id;
  final int? reading_material_id;
  final String? fixed_at;
  final String? fix_summary;
  final String? created_by;
  final String? updated_by;
  final String? quiz_level;
  final String? question_from;
  final String? language;
  final String? photo_url;
  final String? photo_solution_url;
  final bool? is_saved;
  final String? tag;
  final List<Option>? options;
  final ReadingMaterial? reading_material;

  Question({
    this.id,
    this.description,
    this.difficulty_level,
    this.topic,
    this.is_published,
    this.created_at,
    this.updated_at,
    this.detailed_solution,
    this.type,
    this.is_mandatory,
    this.show_in_feed,
    this.pyq_label,
    this.topic_id,
    this.reading_material_id,
    this.fixed_at,
    this.fix_summary,
    this.created_by,
    this.updated_by,
    this.quiz_level,
    this.question_from,
    this.language,
    this.photo_url,
    this.photo_solution_url,
    this.is_saved,
    this.tag,
    this.options,
    this.reading_material,
  });

   factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      description: json['description'],
      difficulty_level: json['difficulty_level'],
      topic: json['topic'],
      is_published: json['is_published'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      detailed_solution: json['detailed_solution'],
      type: json['type'],
      is_mandatory: json['is_mandatory'],
      show_in_feed: json['show_in_feed'],
      pyq_label: json['pyq_label'],
      topic_id: json['topic_id'],
      reading_material_id: json['reading_material_id'],
      fixed_at: json['fixed_at'],
      fix_summary: json['fix_summary'],
      created_by: json['created_by'],
      updated_by: json['updated_by'],
      quiz_level: json['quiz_level'],
      question_from: json['question_from'],
      language: json['language'],
      photo_url: json['photo_url'],
      photo_solution_url: json['photo_solution_url'],
      is_saved: json['is_saved'],
      tag: json['tag'],
      options: json['options'] != null
          ? List<Option>.from(json['options'].map((x) => Option.fromJson(x)))
          : null,
      reading_material: json['reading_material'] != null
          ? ReadingMaterial.fromJson(json['reading_material'])
          : null,
    );
  }
}
