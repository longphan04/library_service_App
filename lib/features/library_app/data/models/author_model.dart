import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/author.dart';

part 'author_model.g.dart';

@JsonSerializable()
class AuthorModel {
  @JsonKey(name: 'author_id')
  final int authorId;
  @JsonKey(name: 'name')
  final String name;

  AuthorModel({required this.authorId, required this.name});

  factory AuthorModel.fromJson(Map<String, dynamic> json) =>
      _$AuthorModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorModelToJson(this);

  Author toEntity() {
    return Author(authorId: authorId, name: name);
  }
}
