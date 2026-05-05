import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasources/places_data_source.dart';
import 'data/datasources/favorites_local_datasource.dart';
import 'data/repositories/places_repository_impl.dart';
import 'data/repositories/favorites_repository.dart';
import 'presentation/bloc/places/places_bloc.dart';
import 'presentation/bloc/favorites/favorites_bloc.dart';
import 'presentation/bloc/theme/theme_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // HTTP Client
  getIt.registerSingleton<http.Client>(http.Client());

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Data Sources
  getIt.registerSingleton<PlacesDataSource>(
    PlacesDataSourceImpl(
      client: getIt<http.Client>(),
      sharedPreferences: getIt<SharedPreferences>(),
    ),
  );

  getIt.registerSingleton<FavoritesLocalDataSource>(
    FavoritesLocalDataSourceImpl(sharedPreferences: getIt<SharedPreferences>()),
  );

  // Repositories
  getIt.registerSingleton<PlacesRepository>(
    PlacesRepositoryImpl(remoteDataSource: getIt<PlacesDataSource>()),
  );

  getIt.registerSingleton<FavoritesRepository>(
    FavoritesRepositoryImpl(localDataSource: getIt<FavoritesLocalDataSource>()),
  );

  // BLoCs
  getIt.registerSingleton<PlacesBloc>(
    PlacesBloc(
      repository: getIt<PlacesRepository>(),
      favoritesRepository: getIt<FavoritesRepository>(),
    ),
  );

  getIt.registerSingleton<FavoritesBloc>(
    FavoritesBloc(repository: getIt<FavoritesRepository>()),
  );

  // Theme BLoC
  getIt.registerSingleton<ThemeBloc>(
    ThemeBloc(sharedPreferences: getIt<SharedPreferences>()),
  );
}
