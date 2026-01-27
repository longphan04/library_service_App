part of 'borrow_ticket_bloc.dart';

abstract class BorrowTicketState extends Equatable {
  const BorrowTicketState();

  @override
  List<Object?> get props => [];
}

class BorrowTicketInitial extends BorrowTicketState {
  @override
  List<Object?> get props => [];
}

class BorrowTicketListLoading extends BorrowTicketState {
  @override
  List<Object?> get props => [];
}

class BorrowTicketListLoaded extends BorrowTicketState {
  final List<Ticket> tickets;
  final Pagination pagination;
  final String? currentStatus;
  final bool isLoadingMore;
  final bool hasReachedMax;

  const BorrowTicketListLoaded(
    this.tickets,
    this.pagination, {
    this.currentStatus,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
  });

  BorrowTicketListLoaded copyWith({
    List<Ticket>? tickets,
    Pagination? pagination,
    String? currentStatus,
    bool? isLoadingMore,
    bool? hasReachedMax,
  }) {
    return BorrowTicketListLoaded(
      tickets ?? this.tickets,
      pagination ?? this.pagination,
      currentStatus: currentStatus ?? this.currentStatus,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
    tickets,
    pagination,
    currentStatus,
    isLoadingMore,
    hasReachedMax,
  ];
}

class BorrowTicketListFailure extends BorrowTicketState {
  final String message;
  final Object error;

  const BorrowTicketListFailure(this.message, this.error);

  @override
  List<Object?> get props => [message, error];
}

class BorrowTicketDetailLoading extends BorrowTicketState {
  @override
  List<Object?> get props => [];
}

class BorrowTicketDetailLoaded extends BorrowTicketState {
  final Ticket ticketDetail;

  const BorrowTicketDetailLoaded(this.ticketDetail);

  @override
  List<Object?> get props => [ticketDetail];
}

class BorrowTicketDetailFailure extends BorrowTicketState {
  final String message;
  final Object error;

  const BorrowTicketDetailFailure(this.message, this.error);

  @override
  List<Object?> get props => [message, error];
}

class BorrowTicketCanceling extends BorrowTicketState {
  @override
  List<Object?> get props => [];
}

class BorrowTicketRenewing extends BorrowTicketState {
  @override
  List<Object?> get props => [];
}

class BorrowTicketActionFailure extends BorrowTicketState {
  final String message;
  final Object error;

  const BorrowTicketActionFailure(this.message, this.error);

  @override
  List<Object?> get props => [message, error];
}

class BorrowTicketActionSuccess extends BorrowTicketState {
  @override
  List<Object?> get props => [];
}

class BorrowTicketActionLoading extends BorrowTicketState {
  @override
  List<Object?> get props => [];
}
