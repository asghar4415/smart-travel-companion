# Smart Travel Companion - Setup Guide

## ✅ Completed Setup

### 1. BLoC Folder Structure
The project now follows proper BLoC architecture with clean separation of concerns:

```
lib/
├── core/              # Shared utilities, constants, and theme
├── data/              # API calls, data sources, and repositories  
├── domain/            # Entities and business logic
└── presentation/      # UI, pages, widgets, and BLoC
```

### 2. Core Configuration
- **Colors**: Custom color palette from assignment design
- **Theme**: Light theme with Poppins font (dark theme template ready)
- **Constants**: API keys, endpoints, routes, and location data

### 3. Data Layer
- **API Integration**: SerpAPI configured for destinations/places
- **Data Models**: `PlaceModel` and `PlacesResponseModel` for API responses
- **Repository Pattern**: Clean abstraction for data access
- **Exception Handling**: Custom exception classes for error handling

### 4. State Management (BLoC)
- **PlacesBloc**: Manages places listing state
- **Events**: GetPlaces, RefreshPlaces, ToggleFavorite, ClearPlaces
- **States**: Initial, Loading, Loaded, Error, Empty
- **Service Locator**: Dependency injection setup with GetIt

### 5. Home Screen
- ✅ Top header with menu and notification buttons
- ✅ Search bar with filter button
- ✅ Location filter chips (Maldives, India, Pakistan, China)
- ✅ Places listing with cards showing:
  - Place image (cached from API)
  - Place name and location
  - Description
  - Favorite button
- ✅ Bottom navigation bar with 5 tabs
- ✅ Loading, error, and empty states
- ✅ Pull-to-refresh functionality

### 6. Reusable Widgets
- `PlaceCard`: Card widget for displaying places
- `SearchBar`: Search input with filter button
- `CustomBottomNavBar`: Custom bottom navigation

### 7. Dependencies Added
```yaml
flutter_bloc: ^8.1.3
get_it: ^7.6.0
http: ^1.1.0
equatable: ^2.0.5
dartz: ^0.10.1
cached_network_image: ^3.3.0
connectivity_plus: ^5.0.2
google_fonts: ^6.1.0
fluttertoast: ^8.2.4
```

## 🚀 Running the App

### Step 1: Get Dependencies
```bash
cd stcapp
flutter pub get
```

### Step 2: Run the App
```bash
flutter run
```

The app will launch with the home screen showing places from the Maldives by default.

### Step 3: Testing
- Tap location chips to load places from different countries
- Tap heart icon to toggle favorites
- Use the search bar (functionality can be extended)
- Try pull-to-refresh to reload data
- Tap bottom nav items (they're ready for future screens)

## 📱 Current Features

✅ **Home Screen**
- Display places/destinations from SerpAPI
- Filter by location (Maldives, India, Pakistan, China)
- Add/remove favorites
- Error handling with retry option
- Empty state handling

✅ **State Management**
- Proper BLoC pattern implementation
- Clean event-driven architecture
- Automatic UI updates based on state changes

✅ **Design**
- Light theme with custom colors
- Responsive layout
- Smooth animations and transitions
- Professional UI components

## 📋 Next Steps

### 1. Detail Screen
Create a detail screen to show place information when a card is tapped:
- Large place image
- Full description
- Weather integration (when ready)
- "View on Map" button
- Rating/Reviews section

### 2. Search Functionality
Implement real search filtering:
- Filter places by text
- Search BLoC similar to PlacesBloc
- Real-time search results

### 3. Favorites Screen
Create a favorites page to display saved places:
- Show only favorited places
- Manage favorites
- Quick access from bottom nav

### 4. Map Page
Integrate Google Maps to show place locations

### 5. Profile/Settings
Create user profile and app settings:
- User information
- Preferences (dark mode, notifications)
- About & Help sections

### 6. Weather API Integration
Add weather information to detail screen:
- Current weather
- Temperature
- Weather conditions
- Weather icon

### 7. Dark Theme
Implement dark theme variant for better night viewing

## 🔧 Important Files

- **main.dart**: App entry point with BLoC providers
- **service_locator.dart**: Dependency injection setup
- **core/theme/app_theme.dart**: Theme configuration
- **core/constants/app_colors.dart**: Color palette
- **presentation/bloc/places/**: BLoC for places
- **presentation/pages/home/home_screen.dart**: Home page
- **data/datasources/places_data_source.dart**: API client

## 🎨 Customization

### Change Colors
Edit `lib/core/constants/app_colors.dart`

### Modify Theme
Edit `lib/core/theme/app_theme.dart`

### Update API Key
Edit `lib/core/constants/app_constants.dart` (already set)

### Add New Locations
Update `AppConstants.locations` in `app_constants.dart`

## 📝 Notes

- The app uses HTTP caching for images via `cached_network_image`
- Error handling is implemented with custom exceptions
- The BLoC pattern ensures separation of business logic from UI
- All screens follow the design from the assignment image
- Colors match the color palette specified in the assignment
- Font is Poppins as specified

## ❓ Troubleshooting

### App won't run?
1. Run `flutter clean`
2. Run `flutter pub get` again
3. Run `flutter run`

### Images not loading?
- Check internet connection
- Verify SerpAPI key is correct
- Check if image URLs are valid

### State not updating?
- Make sure BLoCs are properly initialized in main.dart
- Check that events are being dispatched correctly
- Verify BlocBuilder is listening to correct BLoC

## 📞 Support

Refer to `PROJECT_STRUCTURE.md` for detailed architecture documentation.

---

**Ready to start building?** Next, let's create the detail screen or add any other features you need!
