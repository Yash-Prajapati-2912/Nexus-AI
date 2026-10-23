import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexus_ai/core/error/failures.dart';
import 'package:nexus_ai/core/usecases/usecase.dart';
import '../../domain/entities/connected_account.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/export_data_usecase.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();
  @override
  List<Object?> get props => [];
}

class LoadAccountsEvent extends AccountEvent {
  const LoadAccountsEvent();
}

class LinkAccountEvent extends AccountEvent {
  final String provider;
  const LinkAccountEvent(this.provider);
  @override
  List<Object?> get props => [provider];
}

class UnlinkAccountEvent extends AccountEvent {
  final String provider;
  const UnlinkAccountEvent(this.provider);
  @override
  List<Object?> get props => [provider];
}

class TriggerExportDataEvent extends AccountEvent {
  const TriggerExportDataEvent();
}

class TriggerDeleteAccountEvent extends AccountEvent {
  const TriggerDeleteAccountEvent();
}

abstract class AccountState extends Equatable {
  const AccountState();
  @override
  List<Object?> get props => [];
}

class AccountInitialState extends AccountState {
  const AccountInitialState();
}

class AccountLoadingState extends AccountState {
  const AccountLoadingState();
}

class AccountLoadedState extends AccountState {
  final List<ConnectedAccount> accounts;
  final String? exportedDownloadUrl;
  final bool isDeleted;

  const AccountLoadedState({
    required this.accounts,
    this.exportedDownloadUrl,
    this.isDeleted = false,
  });

  AccountLoadedState copyWith({
    List<ConnectedAccount>? accounts,
    String? exportedDownloadUrl,
    bool? isDeleted,
  }) {
    return AccountLoadedState(
      accounts: accounts ?? this.accounts,
      exportedDownloadUrl: exportedDownloadUrl ?? this.exportedDownloadUrl,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  List<Object?> get props => [accounts, exportedDownloadUrl, isDeleted];
}

class AccountFailureState extends AccountState {
  final String message;
  const AccountFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final ExportDataUseCase exportDataUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final IProfileRepository repository;

  AccountBloc({
    required this.exportDataUseCase,
    required this.deleteAccountUseCase,
    required this.repository,
  }) : super(const AccountInitialState()) {
    on<LoadAccountsEvent>(_onLoadAccounts);
    on<LinkAccountEvent>(_onLink);
    on<UnlinkAccountEvent>(_onUnlink);
    on<TriggerExportDataEvent>(_onExport);
    on<TriggerDeleteAccountEvent>(_onDelete);
  }

  Future<void> _onLoadAccounts(LoadAccountsEvent event, Emitter<AccountState> emit) async {
    emit(const AccountLoadingState());
    final res = await repository.getConnectedAccounts();
    res.fold(
      (Failure f) => emit(AccountFailureState(f.message)),
      (accs) => emit(AccountLoadedState(accounts: accs)),
    );
  }

  Future<void> _onLink(LinkAccountEvent event, Emitter<AccountState> emit) async {
    await repository.linkConnectedAccount(event.provider);
    add(const LoadAccountsEvent());
  }

  Future<void> _onUnlink(UnlinkAccountEvent event, Emitter<AccountState> emit) async {
    await repository.unlinkConnectedAccount(event.provider);
    add(const LoadAccountsEvent());
  }

  Future<void> _onExport(TriggerExportDataEvent event, Emitter<AccountState> emit) async {
    final res = await exportDataUseCase(const NoParams());
    if (state is AccountLoadedState) {
      final current = state as AccountLoadedState;
      res.fold(
        (Failure f) => emit(AccountFailureState(f.message)),
        (url) => emit(current.copyWith(exportedDownloadUrl: url)),
      );
    }
  }

  Future<void> _onDelete(TriggerDeleteAccountEvent event, Emitter<AccountState> emit) async {
    final res = await deleteAccountUseCase(const NoParams());
    res.fold(
      (Failure f) => emit(AccountFailureState(f.message)),
      (_) => emit(const AccountLoadedState(accounts: [], isDeleted: true)),
    );
  }
}
