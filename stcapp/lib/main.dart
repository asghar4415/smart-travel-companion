import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'service_locator.dart' as service_locator;
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'presentation/bloc/places/places_bloc.dart';
import 'presentation/bloc/favorites/favorites_bloc.dart';
import 'presentation/bloc/theme/theme_bloc.dart';
import 'presentation/bloc/theme/theme_event.dart';
import 'presentation/bloc/theme/theme_state.dart';
import 'presentation/pages/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await service_locator.setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlacesBloc>(
          create: (context) => service_locator.getIt<PlacesBloc>(),
        ),
        BlocProvider<FavoritesBloc>(
          create: (context) => service_locator.getIt<FavoritesBloc>(),
        ),
        BlocProvider<ThemeBloc>(
          create: (context) =>
              service_locator.getIt<ThemeBloc>()..add(const GetThemeEvent()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            title: AppConstants.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
