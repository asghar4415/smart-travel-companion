import 'package:equatable/equatable.dart';

abstract class ThemeState extends Equatable {
  final bool isDarkMode;

  const ThemeState({required this.isDarkMode});

  @override
  List<Object?> get props => [isDarkMode];
}

class ThemeInitial extends ThemeState {
  const ThemeInitial({required bool isDarkMode})
    : super(isDarkMode: isDarkMode);
}

class ThemeLoaded extends ThemeState {
  const ThemeLoaded({required bool isDarkMode}) : super(isDarkMode: isDarkMode);
}

class ThemeToggled extends ThemeState {
  const ThemeToggled({required bool isDarkMode})
    : super(isDarkMode: isDarkMode);
}
