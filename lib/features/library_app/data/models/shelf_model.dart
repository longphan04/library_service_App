import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/shelf.dart';

part 'shelf_model.g.dart';

@JsonSerializable()
class ShelfModel {
  @JsonKey(name: 'shelf_id')
  final int shelfId;
  @JsonKey(name: 'code')
  final String code;

  const ShelfModel({required this.shelfId, required this.code});

  factory ShelfModel.fromJson(Map<String, dynamic> json) =>
      _$ShelfModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShelfModelToJson(this);

  Shelf toEntity() {
    return Shelf(shelfId: shelfId, code: code);
  }
}
