import 'package:testline_app/models/practice_material_model.dart';

class ReadingMaterial {
  final int? id;
  final String? keywords;
  final String? content;
  final String? created_at;
  final String? updated_at;
  final List? content_sections;
  final PracticeMaterial? practice_material;

  ReadingMaterial(
    this.id,
    this.keywords,
    this.content,
    this.created_at,
    this.updated_at,
    this.content_sections,
    this.practice_material,
  );
}
