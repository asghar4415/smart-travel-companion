# Smart Travel Companion

Smart Travel Companion is a Flutter-based travel discovery app for browsing destinations, checking live weather, and opening places on the map. It uses live geocoding, keeps the UI simple, and is built to handle API failures without breaking the experience.

## Features
- Home screen with destination listings.
- Shows travel destinations in a clean card-based layout.
- Lets users browse places by location.
- Search and filter controls for browsing places faster.
- Light theme active, with dark theme support/template included.
- Location chips for quick browsing.
- Map launch for the selected destination.
- Cached data for better offline resilience.

## Functionalities
- Fetches destination data from the travel API used in the app.
- Lets users search and filter the destination list.
- Resolves city coordinates dynamically using geocoding.
- Passes latitude and longitude into the weather API.
- Keeps the UI responsive even if one API is slow or unavailable.
- Uses BLoC for state management and clean separation of concerns.

## APIs Used
- SerpAPI for destination suggestions and place listings.
- Open-Meteo Geocoding API for city latitude and longitude.
- Open-Meteo Weather API for live weather details.


## Tech Stack
- Flutter
- Dart
- BLoC
- GetIt
- HTTP
- dartz
- cached_network_image
- shared_preferences



## Quick Start
1. Open the `stcapp` folder.
2. Run `flutter pub get`.
3. Run `flutter run`.

