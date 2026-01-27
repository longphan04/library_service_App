import '../../domain/entities/ai_book_source.dart';

class AIBookSourceModel {
  final String title;
  final String authors;
  final String category;
  final String identifier;
  final String publishYear;
  final String richtext;
  final double score;

  AIBookSourceModel({
    required this.title,
    required this.authors,
    required this.category,
    required this.identifier,
    required this.publishYear,
    required this.richtext,
    required this.score,
  });

  factory AIBookSourceModel.fromJson(Map<String, dynamic> json) {
    return AIBookSourceModel(
      title: json['title'] as String? ?? '',
      authors: json['authors'] as String? ?? '',
      category: json['category'] as String? ?? '',
      identifier: json['identifier'] as String? ?? '',
      publishYear: json['publish_year'] as String? ?? '',
      richtext: json['richtext'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'authors': authors,
      'category': category,
      'identifier': identifier,
      'publish_year': publishYear,
      'richtext': richtext,
      'score': score,
    };
  }

  AIBookSource toEntity() {
    return AIBookSource(
      title: title,
      authors: authors,
      category: category,
      identifier: identifier,
      publishYear: publishYear,
      richtext: richtext,
      score: score,
    );
  }
}
