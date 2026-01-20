import 'package:json_annotation/json_annotation.dart';

import '../../../../core/config/dio_config.dart';
import '../../domain/entities/borrow_ticket.dart';
import 'pagination_model.dart';

part 'borrow_ticket_model.g.dart';

@JsonSerializable()
class TicketModel {
  @JsonKey(name: 'ticket_id')
  final int ticketId;
  @JsonKey(name: 'ticket_code')
  final String ticketCode;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'requested_at')
  final DateTime requestedAt;
  @JsonKey(name: 'approved_at')
  final DateTime? approvedAt;
  @JsonKey(name: 'pickup_expires_at')
  final DateTime? pickupExpiresAt;
  @JsonKey(name: 'picked_up_at')
  final DateTime? pickedUpAt;
  @JsonKey(name: 'due_date')
  final DateTime? dueDate;
  @JsonKey(name: 'renew_count')
  final int renewCount;
  @JsonKey(name: 'is_overdue')
  final bool isOverdue;
  @JsonKey(name: 'overdue_days')
  final int overdueDays;

  const TicketModel({
    required this.ticketId,
    required this.ticketCode,
    required this.status,
    required this.requestedAt,
    this.approvedAt,
    this.pickupExpiresAt,
    this.pickedUpAt,
    this.dueDate,
    required this.renewCount,
    required this.isOverdue,
    required this.overdueDays,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) =>
      _$TicketModelFromJson(json);

  Map<String, dynamic> toJson() => _$TicketModelToJson(this);

  Ticket toEntity() {
    return Ticket(
      id: ticketId,
      code: ticketCode,
      status: _parseStatus(status),
      requestedAt: requestedAt,
      approvedAt: approvedAt,
      pickupExpiresAt: pickupExpiresAt,
      pickedUpAt: pickedUpAt,
      dueDate: dueDate,
      renewCount: renewCount,
      isOverdue: isOverdue,
      overdueDays: overdueDays,
    );
  }

  TicketStatus _parseStatus(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return TicketStatus.pending;
      case 'APPROVED':
        return TicketStatus.approved;
      case 'PICKED_UP':
        return TicketStatus.pickedUp;
      case 'RETURNED':
        return TicketStatus.returned;
      case 'OVERDUE':
        return TicketStatus.overdue;
      case 'CANCELLED':
        return TicketStatus.cancelled;
      default:
        return TicketStatus.pending;
    }
  }
}

@JsonSerializable()
class TicketListModel {
  @JsonKey(name: 'data')
  final List<TicketModel> data;
  @JsonKey(name: 'pagination')
  final PaginationModel pagination;

  const TicketListModel({required this.data, required this.pagination});

  factory TicketListModel.fromJson(Map<String, dynamic> json) =>
      _$TicketListModelFromJson(json);

  Map<String, dynamic> toJson() => _$TicketListModelToJson(this);
}

@JsonSerializable()
class TicketDetailModel {
  @JsonKey(name: 'ticket_id')
  final int ticketId;
  @JsonKey(name: 'ticket_code')
  final String ticketCode;
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'requested_at')
  final DateTime requestedAt;
  @JsonKey(name: 'approved_at')
  final DateTime? approvedAt;
  @JsonKey(name: 'pickup_expires_at')
  final DateTime? pickupExpiresAt;
  @JsonKey(name: 'picked_up_at')
  final DateTime? pickedUpAt;
  @JsonKey(name: 'due_date')
  final DateTime? dueDate;
  @JsonKey(name: 'renew_count')
  final int renewCount;
  @JsonKey(name: 'items')
  final List<TicketItemModel> items;

  const TicketDetailModel({
    required this.ticketId,
    required this.ticketCode,
    required this.status,
    required this.requestedAt,
    this.approvedAt,
    this.pickupExpiresAt,
    this.pickedUpAt,
    this.dueDate,
    required this.renewCount,
    required this.items,
  });

  factory TicketDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TicketDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$TicketDetailModelToJson(this);

  TicketDetail toEntity() {
    return TicketDetail(
      id: ticketId,
      code: ticketCode,
      status: _parseStatus(status),
      requestedAt: requestedAt,
      approvedAt: approvedAt,
      pickupExpiresAt: pickupExpiresAt,
      pickedUpAt: pickedUpAt,
      dueDate: dueDate,
      renewCount: renewCount,
      items: items.map((item) => item.toEntity()).toList(),
    );
  }

  TicketStatus _parseStatus(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return TicketStatus.pending;
      case 'APPROVED':
        return TicketStatus.approved;
      case 'PICKED_UP':
        return TicketStatus.pickedUp;
      case 'RETURNED':
        return TicketStatus.returned;
      case 'OVERDUE':
        return TicketStatus.overdue;
      case 'CANCELLED':
        return TicketStatus.cancelled;
      default:
        return TicketStatus.pending;
    }
  }
}

@JsonSerializable()
class TicketDetailResponseModel {
  @JsonKey(name: 'data')
  final TicketDetailModel data;

  const TicketDetailResponseModel({required this.data});

  factory TicketDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TicketDetailResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TicketDetailResponseModelToJson(this);
}

@JsonSerializable()
class TicketItemModel {
  @JsonKey(name: 'status')
  final String status;
  @JsonKey(name: 'copy')
  final TicketCopyModel copy;
  @JsonKey(name: 'book')
  final TicketBookModel book;

  const TicketItemModel({
    required this.status,
    required this.copy,
    required this.book,
  });

  factory TicketItemModel.fromJson(Map<String, dynamic> json) =>
      _$TicketItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$TicketItemModelToJson(this);

  TicketItem toEntity() {
    return TicketItem(
      status: status,
      copy: copy.toEntity(),
      book: book.toEntity(),
    );
  }
}

@JsonSerializable()
class TicketCopyModel {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'note')
  final String note;

  const TicketCopyModel({required this.id, required this.note});

  factory TicketCopyModel.fromJson(Map<String, dynamic> json) =>
      _$TicketCopyModelFromJson(json);

  Map<String, dynamic> toJson() => _$TicketCopyModelToJson(this);

  TicketCopy toEntity() {
    return TicketCopy(id: id, note: note);
  }
}

@JsonSerializable()
class TicketBookModel {
  @JsonKey(name: 'book_id')
  final int bookId;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'cover_url')
  final String? coverUrl;

  const TicketBookModel({
    required this.bookId,
    required this.title,
    this.coverUrl,
  });

  factory TicketBookModel.fromJson(Map<String, dynamic> json) =>
      _$TicketBookModelFromJson(json);

  Map<String, dynamic> toJson() => _$TicketBookModelToJson(this);

  TicketBook toEntity() {
    return TicketBook(
      bookId: bookId,
      title: title,
      coverUrl: coverUrl != null
          ? '${DioConfig.baseUrl}/public/$coverUrl'
          : null,
    );
  }
}
