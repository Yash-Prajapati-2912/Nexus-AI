import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import '../../domain/entities/notification_item.dart';
import '../../domain/repositories/i_notification_repository.dart';
import '../../domain/usecases/delete_notification_usecase.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';

// EVENTS
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
  @override
  List<Object?> get props => [];
}

class LoadNotificationsEvent extends NotificationEvent {
  final int page;
  const LoadNotificationsEvent({this.page = 1});
  @override
  List<Object?> get props => [page];
}

class RefreshNotificationsEvent extends NotificationEvent {
  const RefreshNotificationsEvent();
}

class MarkReadEvent extends NotificationEvent {
  final String id;
  const MarkReadEvent(this.id);
  @override
  List<Object?> get props => [id];
}

class MarkAllReadEvent extends NotificationEvent {
  const MarkAllReadEvent();
}

class DeleteNotificationEvent extends NotificationEvent {
  final String id;
  const DeleteNotificationEvent(this.id);
  @override
  List<Object?> get props => [id];
}

// STATES
abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object?> get props => [];
}

class NotificationInitialState extends NotificationState {
  const NotificationInitialState();
}

class NotificationLoadingState extends NotificationState {
  const NotificationLoadingState();
}

class NotificationFailureState extends NotificationState {
  final String message;
  const NotificationFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class NotificationLoadedState extends NotificationState {
  final List<NotificationItem> notifications;
  final int unreadCount;

  const NotificationLoadedState({
    required this.notifications,
    required this.unreadCount,
  });

  NotificationLoadedState copyWith({
    List<NotificationItem>? notifications,
    int? unreadCount,
  }) {
    return NotificationLoadedState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  List<Object?> get props => [notifications, unreadCount];
}

// BLOC
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;
  final DeleteNotificationUseCase deleteNotificationUseCase;
  final INotificationRepository repository;

  NotificationBloc({
    required this.getNotificationsUseCase,
    required this.markNotificationReadUseCase,
    required this.deleteNotificationUseCase,
    required this.repository,
  }) : super(const NotificationInitialState()) {
    on<LoadNotificationsEvent>(_onLoad);
    on<RefreshNotificationsEvent>(_onRefresh);
    on<MarkReadEvent>(_onMarkRead);
    on<MarkAllReadEvent>(_onMarkAllRead);
    on<DeleteNotificationEvent>(_onDelete);
  }

  Future<void> _onLoad(LoadNotificationsEvent event, Emitter<NotificationState> emit) async {
    emit(const NotificationLoadingState());
    final res = await getNotificationsUseCase(GetNotificationsParams(page: event.page));
    final unreadRes = await repository.getUnreadCount();

    res.fold(
      (Failure f) => emit(NotificationFailureState(f.message)),
      (list) {
        final count = unreadRes.getOrElse((_) => 0);
        emit(NotificationLoadedState(notifications: list, unreadCount: count));
      },
    );
  }

  Future<void> _onRefresh(RefreshNotificationsEvent event, Emitter<NotificationState> emit) async {
    add(const LoadNotificationsEvent());
  }

  Future<void> _onMarkRead(MarkReadEvent event, Emitter<NotificationState> emit) async {
    if (state is NotificationLoadedState) {
      final current = state as NotificationLoadedState;
      await markNotificationReadUseCase(event.id);
      final updated = current.notifications.map((item) {
        if (item.id == event.id) {
          return NotificationItem(
            id: item.id,
            userId: item.userId,
            title: item.title,
            body: item.body,
            type: item.type,
            module: item.module,
            category: item.category,
            priority: item.priority,
            isRead: true,
            isArchived: item.isArchived,
            isPinned: item.isPinned,
            createdAt: item.createdAt,
            deepLinkUrl: item.deepLinkUrl,
            metadata: item.metadata,
          );
        }
        return item;
      }).toList();

      final newCount = (current.unreadCount > 0) ? current.unreadCount - 1 : 0;
      emit(current.copyWith(notifications: updated, unreadCount: newCount));
    }
  }

  Future<void> _onMarkAllRead(MarkAllReadEvent event, Emitter<NotificationState> emit) async {
    if (state is NotificationLoadedState) {
      final current = state as NotificationLoadedState;
      await repository.markAllAsRead();
      final updated = current.notifications.map((item) {
        return NotificationItem(
          id: item.id,
          userId: item.userId,
          title: item.title,
          body: item.body,
          type: item.type,
          module: item.module,
          category: item.category,
          priority: item.priority,
          isRead: true,
          isArchived: item.isArchived,
          isPinned: item.isPinned,
          createdAt: item.createdAt,
          deepLinkUrl: item.deepLinkUrl,
          metadata: item.metadata,
        );
      }).toList();

      emit(current.copyWith(notifications: updated, unreadCount: 0));
    }
  }

  Future<void> _onDelete(DeleteNotificationEvent event, Emitter<NotificationState> emit) async {
    if (state is NotificationLoadedState) {
      final current = state as NotificationLoadedState;
      await deleteNotificationUseCase(event.id);
      final updated = current.notifications.where((item) => item.id != event.id).toList();
      emit(current.copyWith(notifications: updated));
    }
  }
}
