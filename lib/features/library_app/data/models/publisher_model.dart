import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/publisher.dart';

part 'publisher_model.g.dart';

@JsonSerializable()
class PublisherModel {
  @JsonKey(name: 'publisher_id')
  final int publisherId;
  @JsonKey(name: 'name')
  final String name;

  const PublisherModel({required this.publisherId, required this.name});

  factory PublisherModel.fromJson(Map<String, dynamic> json) =>
      _$PublisherModelFromJson(json);

  Map<String, dynamic> toJson() => _$PublisherModelToJson(this);

  Publisher toEntity() {
    return Publisher(publisherId: publisherId, name: name);
  }
}
