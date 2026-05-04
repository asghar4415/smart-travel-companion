# Smart Travel Companion - Project Structure

## Overview
This is a Flutter application built using the BLoC (Business Logic Component) pattern for state management. The app follows clean architecture principles with proper separation of concerns.

## Folder Structure

```
lib/
├── core/                          # Core layer - shared utilities and constants
│   ├── constants/
│   │   ├── app_colors.dart        # All color definitions
│   │   └── app_constants.dart     # API keys, routes, static values
│   ├── theme/
│   │   └── app_theme.dart         # Light & Dark theme definitions
│   └── utils/
│       └── exception_handler.dart # Custom exceptions
│
├── data/                          # Data layer - API calls and local storage
│   ├── datasources/
│   │   └── places_data_source.dart    # Remote data source (API calls)
│   ├── models/
│   │   ├── place_model.dart           # Place data model
│   │   └── places_response_model.dart # API response model
│   └── repositories/
│       └── places_repository_impl.dart # Repository implementation
│
├── domain/                        # Domain layer - entities and business logic
│   ├── entities/
│   │   └── place.dart            # Place entity
│   ├── repositories/             # Abstract repository interfaces
│   └── usecases/                 # Use cases (future)
│
├── presentation/                 # Presentation layer - UI and BLoC
│   ├── bloc/
│   │   ├── places/
│   │   │   ├── places_bloc.dart     # BLoC for places
│   │   │   ├── places_event.dart    # Events
│   │   │   └── places_state.dart    # States
│   │   ├── favorites/              # Favorites BLoC (future)
│   │   └── search/                 # Search BLoC (future)
│   ├── pages/
│   │   ├── home/
│   │   │   └── home_screen.dart    # Home page
│   │   ├── detail/                 # Detail page (future)
│   │   ├── search/                 # Search page (future)
│   │   └── favorites/              # Favorites page (future)
│   ├── widgets/
│   │   ├── place_card.dart         # Place card widget
│   │   ├── search_bar.dart         # Search bar widget
│   │   ├── custom_bottom_nav_bar.dart  # Bottom nav bar
│   │   └── widgets.dart            # Widget exports
│   └── resources/                  # Assets and resources (future)
│
├── service_locator.dart          # Dependency injection setup
├── main.dart                     # App entry point
```

## Architecture Layers

### 1. Core Layer (`core/`)
- **Purpose**: Contains shared utilities, constants, and configurations
- **Contents**: 
  - Color schemes and app constants
  - Theme definitions
  - Exception handling classes

### 2. Data Layer (`data/`)
- **Purpose**: Handles data fetching and transformation
- **Contents**:
  - **DataSources**: Interfaces for API calls (remote) and local storage
  - **Models**: Data classes that map API responses
  - **Repositories**: Implementation of repository pattern for data access

### 3. Domain Layer (`domain/`)
- **Purpose**: Contains business logic and entities
- **Contents**:
  - **Entities**: Pure domain objects
  - **Repositories**: Abstract interfaces
  - **Use Cases**: Business logic operations

### 4. Presentation Layer (`presentation/`)
- **Purpose**: UI components and state management
- **Contents**:
  - **BLoC**: State management using flutter_bloc
  - **Pages**: Screen widgets
  - **Widgets**: Reusable UI components

## State Management - BLoC Pattern

### Places BLoC
Manages the state of places/destinations listing.

**Events:**
- `GetPlacesEvent`: Fetch places for a location
- `RefreshPlacesEvent`: Refresh places list
- `ToggleFavoriteEvent`: Toggle favorite status
- `ClearPlacesEvent`: Clear all places

**States:**
- `PlacesInitial`: Initial state
- `PlacesLoading`: Loading state
- `PlacesLoaded`: Successful load with places data
- `PlacesError`: Error occurred during fetch
- `PlacesEmpty`: No places found

## Color Palette

- **Primary**: #6C33FF (Purple)
- **Secondary**: #FF686B (Red/Pink)
- **Accent Yellow**: #F590CB
- **Accent Orange**: #DF172A
- **Background**: #F8FAFC
- **White**: #FBFAFC

## Typography

- **Font Family**: Poppins (via Google Fonts)
- **Regular**: 400
- **Medium**: 500
- **Semibold**: 600

## API Integration

### SerpAPI
- **Base URL**: https://serpapi.com/search.json
- **API Key**: 8368fdeebafe2ad402163cd88781d7b6459985d476baa87bf0e3e6d2a413affe
- **Locations**: Maldives, India, Pakistan, China

### Response Structure
```json
{
  "popular_destinations": {
    "destinations": [
      {
        "title": "Location Name",
        "description": "Description",
        "thumbnail": "Image URL",
        "flight_price": "$2,362",
        "extracted_flight_price": 2362,
        "hotel_price": "$161",
        "extracted_hotel_price": 161
      }
    ]
  }
}
```

## Dependencies

- **flutter_bloc**: ^8.1.3 - State management
- **get_it**: ^7.6.0 - Service locator/Dependency injection
- **http**: ^1.1.0 - HTTP client
- **equatable**: ^2.0.5 - Value equality
- **dartz**: ^0.10.1 - Functional programming (Either type)
- **cached_network_image**: ^3.3.0 - Image caching
- **connectivity_plus**: ^5.0.2 - Network connectivity
- **google_fonts**: ^6.1.0 - Google Fonts

## Features Implemented

✅ BLoC folder structure
✅ Light theme with custom colors and typography
✅ Home screen with:
  - Top header with menu and notifications
  - Search bar with filter button
  - Location filter chips (All, Favorites, Recent)
  - Places listing with cards
  - Bottom navigation bar
✅ API integration with SerpAPI
✅ Error handling and empty states
✅ Favorite toggle functionality
✅ Refresh functionality

## Features to Implement

- [ ] Detail screen for place information
- [ ] Search functionality
- [ ] Favorites screen
- [ ] Map view
- [ ] Dark theme
- [ ] Offline caching
- [ ] User profile
- [ ] Weather API integration
- [ ] Settings page

## Getting Started

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app:
   ```bash
   flutter run
   ```

3. The app will load the home screen with places from the SerpAPI.

## Notes

- Weather API integration is pending
- Dark theme will be added later
- All pages use the BLoC pattern for state management
- The app follows clean architecture principles
