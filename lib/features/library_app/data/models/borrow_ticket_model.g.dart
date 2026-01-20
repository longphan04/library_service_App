// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'borrow_ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketModel _$TicketModelFromJson(Map<String, dynamic> json) => TicketModel(
  ticketId: (json['ticket_id'] as num).toInt(),
  ticketCode: json['ticket_code'] as String,
  status: json['status'] as String,
  requestedAt: DateTime.parse(json['requested_at'] as String),
  approvedAt: json['approved_at'] == null
      ? null
      : DateTime.parse(json['approved_at'] as String),
  pickupExpiresAt: json['pickup_expires_at'] == null
      ? null
      : DateTime.parse(json['pickup_expires_at'] as String),
  pickedUpAt: json['picked_up_at'] == null
      ? null
      : DateTime.parse(json['picked_up_at'] as String),
  dueDate: json['due_date'] == null
      ? null
      : DateTime.parse(json['due_date'] as String),
  renewCount: (json['renew_count'] as num).toInt(),
  isOverdue: json['is_overdue'] as bool,
  overdueDays: (json['overdue_days'] as num).toInt(),
);

Map<String, dynamic> _$TicketModelToJson(TicketModel instance) =>
    <String, dynamic>{
      'ticket_id': instance.ticketId,
      'ticket_code': instance.ticketCode,
      'status': instance.status,
      'requested_at': instance.requestedAt.toIso8601String(),
      'approved_at': instance.approvedAt?.toIso8601String(),
      'pickup_expires_at': instance.pickupExpiresAt?.toIso8601String(),
      'picked_up_at': instance.pickedUpAt?.toIso8601String(),
      'due_date': instance.dueDate?.toIso8601String(),
      'renew_count': instance.renewCount,
      'is_overdue': instance.isOverdue,
      'overdue_days': instance.overdueDays,
    };

TicketListModel _$TicketListModelFromJson(Map<String, dynamic> json) =>
    TicketListModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => TicketModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationModel.fromJson(
        json['pagination'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$TicketListModelToJson(TicketListModel instance) =>
    <String, dynamic>{'data': instance.data, 'pagination': instance.pagination};

TicketDetailModel _$TicketDetailModelFromJson(Map<String, dynamic> json) =>
    TicketDetailModel(
      ticketId: (json['ticket_id'] as num).toInt(),
      ticketCode: json['ticket_code'] as String,
      status: json['status'] as String,
      requestedAt: DateTime.parse(json['requested_at'] as String),
      approvedAt: json['approved_at'] == null
          ? null
          : DateTime.parse(json['approved_at'] as String),
      pickupExpiresAt: json['pickup_expires_at'] == null
          ? null
          : DateTime.parse(json['pickup_expires_at'] as String),
      pickedUpAt: json['picked_up_at'] == null
          ? null
          : DateTime.parse(json['picked_up_at'] as String),
      dueDate: json['due_date'] == null
          ? null
          : DateTime.parse(json['due_date'] as String),
      renewCount: (json['renew_count'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => TicketItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TicketDetailModelToJson(TicketDetailModel instance) =>
    <String, dynamic>{
      'ticket_id': instance.ticketId,
      'ticket_code': instance.ticketCode,
      'status': instance.status,
      'requested_at': instance.requestedAt.toIso8601String(),
      'approved_at': instance.approvedAt?.toIso8601String(),
      'pickup_expires_at': instance.pickupExpiresAt?.toIso8601String(),
      'picked_up_at': instance.pickedUpAt?.toIso8601String(),
      'due_date': instance.dueDate?.toIso8601String(),
      'renew_count': instance.renewCount,
      'items': instance.items,
    };

TicketDetailResponseModel _$TicketDetailResponseModelFromJson(
  Map<String, dynamic> json,
) => TicketDetailResponseModel(
  data: TicketDetailModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TicketDetailResponseModelToJson(
  TicketDetailResponseModel instance,
) => <String, dynamic>{'data': instance.data};

TicketItemModel _$TicketItemModelFromJson(Map<String, dynamic> json) =>
    TicketItemModel(
      status: json['status'] as String,
      copy: TicketCopyModel.fromJson(json['copy'] as Map<String, dynamic>),
      book: TicketBookModel.fromJson(json['book'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TicketItemModelToJson(TicketItemModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'copy': instance.copy,
      'book': instance.book,
    };

TicketCopyModel _$TicketCopyModelFromJson(Map<String, dynamic> json) =>
    TicketCopyModel(
      id: (json['id'] as num).toInt(),
      note: json['note'] as String,
    );

Map<String, dynamic> _$TicketCopyModelToJson(TicketCopyModel instance) =>
    <String, dynamic>{'id': instance.id, 'note': instance.note};

TicketBookModel _$TicketBookModelFromJson(Map<String, dynamic> json) =>
    TicketBookModel(
      bookId: (json['book_id'] as num).toInt(),
      title: json['title'] as String,
      coverUrl: json['cover_url'] as String?,
    );

Map<String, dynamic> _$TicketBookModelToJson(TicketBookModel instance) =>
    <String, dynamic>{
      'book_id': instance.bookId,
      'title': instance.title,
      'cover_url': instance.coverUrl,
    };
