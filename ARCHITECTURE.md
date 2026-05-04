# Smart Travel Companion - Architecture Diagram

## BLoC Data Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                          │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                     Home Screen                          │  │
│  │  ┌──────────────────────────────────────────────────┐   │  │
│  │  │ BlocBuilder<PlacesBloc, PlacesState>             │   │  │
│  │  │  - Renders UI based on state                     │   │  │
│  │  │  - Rebuilds on state changes                     │   │  │
│  │  └──────────────────────────────────────────────────┘   │  │
│  └──────────────────────────────────────────────────────────┘  │
│                            △                                    │
│                            │ listens to                         │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │         BlocBuilder/BlocListener (Events Out)            │  │
│  │                                                           │  │
│  │  User Actions:                                           │  │
│  │  - Tap location chip → GetPlacesEvent                   │  │
│  │  - Tap heart → ToggleFavoriteEvent                      │  │
│  │  - Pull to refresh → RefreshPlacesEvent                 │  │
│  └──────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
                             △
                             │ emits
                             │
         ┌───────────────────────────────────────┐
         │      PLACES BLOC (State Manager)      │
         │                                       │
         │  on<GetPlacesEvent>                   │
         │   - emit(PlacesLoading)               │
         │   - call repository.getPlaces()       │
         │   - emit(PlacesLoaded/Error)          │
         │                                       │
         │  on<ToggleFavoriteEvent>              │
         │   - toggle favorite in current state  │
         │   - emit(PlacesLoaded)                │
         │                                       │
         │  on<RefreshPlacesEvent>               │
         │   - trigger GetPlacesEvent            │
         └───────────────────────────────────────┘
                             △
                             │ calls
                             │
├──────────────────────────────────────────────────────────────────┤
│                     DOMAIN LAYER                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │         PlacesRepository (Abstract Interface)            │   │
│  │  - getPlaces(location): Future<Either<Error, Places>>   │   │
│  └──────────────────────────────────────────────────────────┘   │
├──────────────────────────────────────────────────────────────────┤
│                     DATA LAYER                                    │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │    PlacesRepositoryImpl (Concrete Implementation)         │   │
│  │                                                          │   │
│  │  getPlaces(location)                                    │   │
│  │   - calls PlacesDataSource.getPlaces()                  │   │
│  │   - maps response to List<PlaceModel>                   │   │
│  │   - returns Either<Error, List>                         │   │
│  └──────────────────────────────────────────────────────────┘   │
│                            △                                     │
│                            │ uses                               │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │     PlacesDataSource (Remote Data Source)                │   │
│  │                                                          │   │
│  │  getPlaces(location)                                    │   │
│  │   - constructs SerpAPI URL                              │   │
│  │   - makes HTTP GET request                              │   │
│  │   - parses JSON response                                │   │
│  │   - maps to PlacesResponseModel                         │   │
│  │   - returns PlacesResponseModel                         │   │
│  └──────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────┘
                             △
                             │ HTTP GET
                             │
         ┌──────────────────────────────┐
         │   SerpAPI Remote Server      │
         │                              │
         │  GET: /search.json           │
         │   - engine: google           │
         │   - q: "Maldives Destinations"
         │   - api_key: ***             │
         │                              │
         │  Response:                   │
         │  {                           │
         │   "popular_destinations": {  │
         │    "destinations": [{...}]   │
         │   }                          │
         │  }                           │
         └──────────────────────────────┘
```

## State Flow Diagram

```
User Interaction
       │
       ▼
┌─────────────────────────┐
│  PlacesEvent emitted    │
│  (GetPlacesEvent, etc)  │
└────────────┬────────────┘
             │
             ▼
     ┌───────────────┐
     │ PlacesLoading │  ← UI shows loading spinner
     └───────┬───────┘
             │
             ▼
    (API call in progress)
             │
    ┌────────┴────────┐
    │                 │
    ▼                 ▼
┌──────────┐   ┌─────────────┐
│ Success  │   │ Error       │
└────┬─────┘   └──────┬──────┘
     │                │
     ▼                ▼
┌──────────────────┐  ┌──────────────┐
│ PlacesLoaded     │  │ PlacesError  │  ← UI shows error with retry
│ (with data)      │  │ (message)    │
└────────┬─────────┘  └──────┬───────┘
         │                    │
         ▼                    ▼
    UI Renders           Error UI Renders
    Place Cards         Retry Button
```

## Dependency Injection Setup

```
main.dart
    │
    ├─► setupServiceLocator()
    │       │
    │       ├─► getIt.registerSingleton<http.Client>()
    │       │
    │       ├─► getIt.registerSingleton<PlacesDataSource>()
    │       │   └─► depends on: http.Client
    │       │
    │       ├─► getIt.registerSingleton<PlacesRepository>()
    │       │   └─► depends on: PlacesDataSource
    │       │
    │       └─► getIt.registerSingleton<PlacesBloc>()
    │           └─► depends on: PlacesRepository
    │
    └─► getIt<PlacesBloc>() used in BlocProvider
```

## File Organization Summary

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart          # Colors: #6C33FF, #FF686B, etc
│   │   └── app_constants.dart       # API_KEY, locations, routes
│   ├── theme/
│   │   └── app_theme.dart           # Poppins, light/dark themes
│   └── utils/
│       └── exception_handler.dart   # Custom exceptions
│
├── data/
│   ├── datasources/
│   │   └── places_data_source.dart  # HTTP → PlacesResponseModel
│   ├── models/
│   │   ├── place_model.dart         # Data class for UI
│   │   └── places_response_model.dart # API response structure
│   └── repositories/
│       └── places_repository_impl.dart # PlacesResponseModel → PlaceModel
│
├── domain/
│   ├── entities/
│   │   └── place.dart               # Pure domain object
│   └── repositories/
│       └── (abstract interfaces)
│
├── presentation/
│   ├── bloc/
│   │   └── places/
│   │       ├── places_bloc.dart     # Business logic
│   │       ├── places_event.dart    # User actions
│   │       └── places_state.dart    # UI states
│   ├── pages/
│   │   ├── home/
│   │   │   └── home_screen.dart     # Main UI screen
│   │   └── (other pages)
│   └── widgets/
│       ├── place_card.dart          # Card component
│       ├── search_bar.dart          # Search component
│       └── custom_bottom_nav_bar.dart # Nav component
│
├── service_locator.dart             # DI container (GetIt)
└── main.dart                        # App entry point
```

## Class Relationships

```
PlaceModel (UI friendly)
    └─ created from ──→ Destination (API response)
                            │
                        parsed from
                            │
                    PlacesResponseModel
                            │
                    returned from
                            │
                PlacesDataSource.getPlaces()
                            │
                        used by
                            │
                PlacesRepositoryImpl.getPlaces()
                            │
                        called by
                            │
                PlacesBloc._onGetPlaces()
                            │
                        emits
                            │
                PlacesLoaded/Error/Empty
                            │
                    listened by
                            │
                BlocBuilder in HomeScreen
```

## Request/Response Flow

```
User taps "Maldives" chip
    │
    ▼
HomeScreen emits: GetPlacesEvent(location: "Maldives")
    │
    ▼
PlacesBloc receives event
    │
    ▼
PlacesBloc calls: repository.getPlaces("Maldives")
    │
    ▼
PlacesRepositoryImpl calls: dataSource.getPlaces("Maldives")
    │
    ▼
PlacesDataSource makes HTTP request:
GET /search.json?engine=google&q=Maldives+Destinations&api_key=***
    │
    ▼
SerpAPI returns: { popular_destinations: { destinations: [...] } }
    │
    ▼
PlacesDataSource parses JSON → PlacesResponseModel
    │
    ▼
PlacesRepositoryImpl maps to List<PlaceModel>
    │
    ▼
Returns: Right(List<PlaceModel>)
    │
    ▼
PlacesBloc emits: PlacesLoaded(places, location)
    │
    ▼
HomeScreen BlocBuilder rebuilds with places
    │
    ▼
UI displays PlaceCards with images, names, descriptions
```

## State Tree

```
PlacesState
├── PlacesInitial
├── PlacesLoading
├── PlacesLoaded
│   ├── places: List<PlaceModel>
│   └── location: String
├── PlacesError
│   ├── message: String
│   └── exception: AppException?
└── PlacesEmpty
    └── message: String
```

## Event Tree

```
PlacesEvent
├── GetPlacesEvent(location)
├── RefreshPlacesEvent(location)
├── ToggleFavoriteEvent(index)
└── ClearPlacesEvent()
```

---

**This architecture ensures:**
- ✅ Clean separation of concerns
- ✅ Easy to test (each layer is independent)
- ✅ Scalable (new features follow same pattern)
- ✅ Maintainable (BLoC handles all state changes)
- ✅ Reusable (widgets and repository can be used elsewhere)
