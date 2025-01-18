// ignore_for_file: non_constant_identifier_names

import 'package:testline_app/models/practice_material_model.dart';

class ReadingMaterial {
  final int? id;
  final String? keywords;
  final String? content;
  final String? created_at;
  final String? updated_at;
  final List? content_sections;
  final PracticeMaterial? practice_material;

  ReadingMaterial({
    this.id,
    this.keywords,
    this.content,
    this.created_at,
    this.updated_at,
    this.content_sections,
    this.practice_material,
  });

  factory ReadingMaterial.fromJson(Map<String, dynamic> json) {
    return ReadingMaterial(
      id: json['id'],
      keywords: json['keywords'],
      content: json['content'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
      content_sections: json['content_sections'],
      practice_material: json['practice_material'] != null
          ? PracticeMaterial.fromJson(json['practice_material'])
          : null,
    );
  }
}
