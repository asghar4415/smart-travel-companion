class AppConstants {
  // API Related
  // Use proxy server for web (CORS friendly)
  static const String apiBaseUrl = 'http://localhost:3000/api/places';
  static const String apiKey =
      '8368fdeebafe2ad402163cd88781d7b6459985d476baa87bf0e3e6d2a413affe';
  static const int apiTimeout = 30; // seconds
  static const int maxDestinationsToShow = 10; // Limit results from API

  // Locations for Places Search
  static const List<String> locations = [
    'Maldives',
    'India',
    'Pakistan',
    'China',
    'Turkey',
    'Italy',
    'Spain',
    'France',
    'Thailand',
    'Japan',
  ];

  // Default Search Query
  static const String defaultSearchQuery = 'Destinations';

  // App Name
  static const String appName = 'Smart Travel Companion';

  // Routes
  static const String homeRoute = '/';
  static const String detailRoute = '/detail';
  static const String searchRoute = '/search';
  static const String favoritesRoute = '/favorites';

  // Cache Duration (in seconds)
  static const int cacheDuration = 3600; // 1 hour
}
