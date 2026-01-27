import 'dart:async';
import 'package:flutter/foundation.dart';

class DataRefreshService {
  static final DataRefreshService _instance = DataRefreshService._internal();
  factory DataRefreshService() => _instance;
  DataRefreshService._internal();

  final _bookDetailRefreshController = StreamController<int>.broadcast();
  final _bookListRefreshController = StreamController<void>.broadcast();
  final _homeRefreshController = StreamController<void>.broadcast();
  final _bookHoldRefreshController = StreamController<void>.broadcast();
  final _borrowTicketListRefreshController = StreamController<void>.broadcast();

  Stream<int> get onBookDetailRefresh => _bookDetailRefreshController.stream;
  Stream<void> get onBookListRefresh => _bookListRefreshController.stream;
  Stream<void> get onHomeRefresh => _homeRefreshController.stream;
  Stream<void> get onBookHoldRefresh => _bookHoldRefreshController.stream;
  Stream<void> get onBorrowTicketListRefresh =>
      _borrowTicketListRefreshController.stream;

  void triggerBookDetailRefresh(int bookId) {
    _bookDetailRefreshController.add(bookId);
    debugPrint(
      '[DataRefreshService] Triggered book detail refresh for book: $bookId',
    );
  }

  void triggerBookListRefresh() {
    _bookListRefreshController.add(null);
    debugPrint('[DataRefreshService] Triggered book list refresh');
  }

  void triggerHomeRefresh() {
    _homeRefreshController.add(null);
    debugPrint('[DataRefreshService] Triggered home refresh');
  }

  void triggerBookHoldRefresh() {
    _bookHoldRefreshController.add(null);
    debugPrint('[DataRefreshService] Triggered book hold refresh');
  }

  void triggerBorrowTicketListRefresh() {
    _borrowTicketListRefreshController.add(null);
    debugPrint('[DataRefreshService] Triggered borrow ticket list refresh');
  }

  /// Dispose service
  void dispose() {
    _bookDetailRefreshController.close();
    _bookListRefreshController.close();
    _homeRefreshController.close();
    _bookHoldRefreshController.close();
    _borrowTicketListRefreshController.close();
  }
}
