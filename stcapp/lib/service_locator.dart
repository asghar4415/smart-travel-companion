import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'data/datasources/places_data_source.dart';
import 'data/repositories/places_repository_impl.dart';
import 'presentation/bloc/places/places_bloc.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  // HTTP Client
  getIt.registerSingleton<http.Client>(http.Client());

  // Data Sources
  getIt.registerSingleton<PlacesDataSource>(
    PlacesDataSourceImpl(client: getIt<http.Client>()),
  );

  // Repositories
  getIt.registerSingleton<PlacesRepository>(
    PlacesRepositoryImpl(remoteDataSource: getIt<PlacesDataSource>()),
  );

  // BLoCs
  getIt.registerSingleton<PlacesBloc>(
    PlacesBloc(repository: getIt<PlacesRepository>()),
  );
}
