import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'service_locator.dart' as service_locator;
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'presentation/bloc/places/places_bloc.dart';
import 'presentation/pages/home/home_screen.dart';

void main() {
  service_locator.setupServiceLocator();
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
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light, // Change to system for light/dark switching
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}
