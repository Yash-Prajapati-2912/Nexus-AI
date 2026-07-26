import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/update_theme_usecase.dart';
import '../../domain/usecases/update_language_usecase.dart';
import '../../domain/usecases/update_accessibility_usecase.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final UpdateThemeUseCase updateThemeUseCase;
  final UpdateLanguageUseCase updateLanguageUseCase;
  final UpdateAccessibilityUseCase updateAccessibilityUseCase;

  ThemeBloc({
    required this.updateThemeUseCase,
    required this.updateLanguageUseCase,
    required this.updateAccessibilityUseCase,
  }) : super(ThemeState.initial()) {
    on<ChangeThemeModeEvent>(_onChangeThemeMode);
    on<ToggleDynamicColorEvent>(_onToggleDynamicColor);
    on<ChangePrimaryColorEvent>(_onChangePrimaryColor);
    on<UpdateLanguageSettingsEvent>(_onUpdateLanguageSettings);
    on<UpdateAccessibilitySettingsEvent>(_onUpdateAccessibilitySettings);
  }

  Future<void> _onChangeThemeMode(ChangeThemeModeEvent event, Emitter<ThemeState> emit) async {
    final updatedTheme = state.theme.copyWith(themeMode: event.mode);
    emit(state.copyWith(theme: updatedTheme));
    await updateThemeUseCase(updatedTheme);
  }

  Future<void> _onToggleDynamicColor(ToggleDynamicColorEvent event, Emitter<ThemeState> emit) async {
    final updatedTheme = state.theme.copyWith(useDynamicColor: event.useDynamic);
    emit(state.copyWith(theme: updatedTheme));
    await updateThemeUseCase(updatedTheme);
  }

  Future<void> _onChangePrimaryColor(ChangePrimaryColorEvent event, Emitter<ThemeState> emit) async {
    final updatedTheme = state.theme.copyWith(primaryColorHex: event.hexColor);
    emit(state.copyWith(theme: updatedTheme));
    await updateThemeUseCase(updatedTheme);
  }

  Future<void> _onUpdateLanguageSettings(UpdateLanguageSettingsEvent event, Emitter<ThemeState> emit) async {
    emit(state.copyWith(language: event.language));
    await updateLanguageUseCase(event.language);
  }

  Future<void> _onUpdateAccessibilitySettings(
      UpdateAccessibilitySettingsEvent event, Emitter<ThemeState> emit) async {
    emit(state.copyWith(accessibility: event.accessibility));
    await updateAccessibilityUseCase(event.accessibility);
  }
}
