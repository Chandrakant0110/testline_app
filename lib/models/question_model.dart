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

  Question(
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
  );
}
