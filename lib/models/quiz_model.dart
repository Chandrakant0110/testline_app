import 'question_model.dart';

class Quiz {
  final int? id;
  final String? name;
  final String? title;
  final String? description;
  final String? difficulty_level;
  final String? topic;
  final String? time;
  final bool? is_published;
  final String? created_at;
  final String? updated_at;
  final int? duration;
  final String? end_time;
  final String? negative_marks;
  final String? correct_answer_marks;
  final bool? shuffle;
  final bool? show_answers;
  final bool? lock_solutions;
  final bool? is_form;
  final bool? show_mastery_option;
  final String? reading_material;
  final String? quiz_type;
  final bool? is_custom;
  final String? banner_id;
  final String? exam_id;
  final bool? show_unanswered;
  final String? ends_at;
  final String? lives;
  final String? live_count;
  final int? coin_count;
  final int? questions_count;
  final String? daily_date;
  final int? max_mistake_count;
  final List? reading_materials;
  final List<Question>? questions;
  final int? progress;

  Quiz(
    this.id,
    this.name,
    this.title,
    this.description,
    this.difficulty_level,
    this.topic,
    this.time,
    this.is_published,
    this.created_at,
    this.updated_at,
    this.duration,
    this.end_time,
    this.negative_marks,
    this.correct_answer_marks,
    this.shuffle,
    this.show_answers,
    this.lock_solutions,
    this.is_form,
    this.show_mastery_option,
    this.reading_material,
    this.quiz_type,
    this.is_custom,
    this.banner_id,
    this.exam_id,
    this.show_unanswered,
    this.ends_at,
    this.lives,
    this.live_count,
    this.coin_count,
    this.questions_count,
    this.daily_date,
    this.max_mistake_count,
    this.reading_materials,
    this.questions,
    this.progress,
  );
}
