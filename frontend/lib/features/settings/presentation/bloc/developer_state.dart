import 'package:equatable/equatable.dart';
import '../../domain/entities/developer_settings_entity.dart';

abstract class DeveloperState extends Equatable {
  const DeveloperState();

  @override
  List<Object?> get props => [];
}

class DeveloperInitial extends DeveloperState {}

class DeveloperLoaded extends DeveloperState {
  final DeveloperSettingsEntity settings;
  final String? toast;

  const DeveloperLoaded(this.settings, {this.toast});

  @override
  List<Object?> get props => [settings, toast];
}
