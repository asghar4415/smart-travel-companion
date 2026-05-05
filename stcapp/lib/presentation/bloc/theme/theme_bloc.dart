import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final SharedPreferences sharedPreferences;
  static const String _themeModeKey = 'isDarkMode';

  ThemeBloc({required this.sharedPreferences})
    : super(
        ThemeInitial(
          isDarkMode: sharedPreferences.getBool(_themeModeKey) ?? false,
        ),
      ) {
    on<GetThemeEvent>(_onGetTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
    on<SetThemeEvent>(_onSetTheme);
  }

  Future<void> _onGetTheme(
    GetThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final isDarkMode = sharedPreferences.getBool(_themeModeKey) ?? false;
      emit(ThemeLoaded(isDarkMode: isDarkMode));
    } catch (e) {
      emit(ThemeLoaded(isDarkMode: false));
    }
  }

  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      final newMode = !state.isDarkMode;
      await sharedPreferences.setBool(_themeModeKey, newMode);
      emit(ThemeToggled(isDarkMode: newMode));
    } catch (e) {
      // Silently fail
    }
  }

  Future<void> _onSetTheme(
    SetThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    try {
      await sharedPreferences.setBool(_themeModeKey, event.isDarkMode);
      emit(ThemeLoaded(isDarkMode: event.isDarkMode));
    } catch (e) {
      // Silently fail
    }
  }
}
