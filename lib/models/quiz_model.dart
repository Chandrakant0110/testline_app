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

  Quiz({
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
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      description: json['description'],
      difficulty_level: json['difficulty_level'],
      topic: json['topic'],
      time: json['time'],
      is_published: json['is_published'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      duration: json['duration'],
      end_time: json['end_time'],
      negative_marks: json['negative_marks'],
      correct_answer_marks: json['correct_answer_marks'],
      shuffle: json['shuffle'],
      show_answers: json['show_answers'],
      lock_solutions: json['lock_solutions'],
      is_form: json['is_form'],
      show_mastery_option: json['show_mastery_option'],
      reading_material: json['reading_material'],
      quiz_type: json['quiz_type'],
      is_custom: json['is_custom'],
      banner_id: json['banner_id'],
      exam_id: json['exam_id'],
      show_unanswered: json['show_unanswered'],
      ends_at: json['ends_at'],
      lives: json['lives'],
      live_count: json['live_count'],
      coin_count: json['coin_count'],
      questions_count: json['questions_count'],
      daily_date: json['daily_date'],
      max_mistake_count: json['max_mistake_count'],
      reading_materials: json['reading_materials'],
      questions: json['questions'] != null
          ? List<Question>.from(
              json['questions'].map((x) => Question.fromJson(x)))
          : null,
      progress: json['progress'],
    );
  }
}
