import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat_attachment.dart';

abstract class AttachmentEvent extends Equatable {
  const AttachmentEvent();
  @override
  List<Object?> get props => [];
}

class AddAttachmentEvent extends AttachmentEvent {
  final ChatAttachment attachment;
  const AddAttachmentEvent(this.attachment);
  @override
  List<Object?> get props => [attachment];
}

class RemoveAttachmentEvent extends AttachmentEvent {
  final String attachmentId;
  const RemoveAttachmentEvent(this.attachmentId);
  @override
  List<Object?> get props => [attachmentId];
}

class ClearAttachmentsEvent extends AttachmentEvent {
  const ClearAttachmentsEvent();
}

abstract class AttachmentState extends Equatable {
  const AttachmentState();
  @override
  List<Object?> get props => [];
}

class AttachmentStateData extends AttachmentState {
  final List<ChatAttachment> attachments;
  const AttachmentStateData(this.attachments);
  @override
  List<Object?> get props => [attachments];
}

class AttachmentBloc extends Bloc<AttachmentEvent, AttachmentState> {
  AttachmentBloc() : super(const AttachmentStateData([])) {
    on<AddAttachmentEvent>((event, emit) {
      final current = (state as AttachmentStateData).attachments;
      emit(AttachmentStateData(List.from(current)..add(event.attachment)));
    });

    on<RemoveAttachmentEvent>((event, emit) {
      final current = (state as AttachmentStateData).attachments;
      emit(AttachmentStateData(current.where((a) => a.id != event.attachmentId).toList()));
    });

    on<ClearAttachmentsEvent>((event, emit) {
      emit(const AttachmentStateData([]));
    });
  }
}
