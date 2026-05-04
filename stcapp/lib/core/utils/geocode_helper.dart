/// Geocoding helper to get latitude and longitude for famous places
/// Since the API doesn't provide coordinates, we use a hardcoded mapping
class GeocodeHelper {
  static final Map<String, Coordinates> _coordinatesMap = {
    // Maldives places
    'Male': Coordinates(4.1755, 73.5093),
    'Malé': Coordinates(4.1755, 73.5093),
    'Dhiraagu': Coordinates(3.8480, 72.8281),
    'Bandos Island': Coordinates(4.2667, 73.6333),
    'Velaa': Coordinates(3.9167, 72.8333),
    'Ranveli': Coordinates(3.8667, 72.8333),
    'Helengeli': Coordinates(4.2333, 73.6500),
    'Sun Island': Coordinates(3.8333, 72.7667),
    'Kandooma': Coordinates(3.8833, 72.8333),
    'Lankavati': Coordinates(3.8000, 72.7500),

    // India places
    'New Delhi': Coordinates(28.7041, 77.1025),
    'Delhi': Coordinates(28.7041, 77.1025),
    'Mumbai': Coordinates(19.0760, 72.8777),
    'Bombay': Coordinates(19.0760, 72.8777),
    'Bangalore': Coordinates(12.9716, 77.5946),
    'Agra': Coordinates(27.1767, 78.0081),
    'Jaipur': Coordinates(26.9124, 75.7873),
    'Goa': Coordinates(15.3004, 73.8343),
    'Kolkata': Coordinates(22.5726, 88.3639),
    'Hyderabad': Coordinates(17.3850, 78.4867),
    'Kerala': Coordinates(10.8505, 76.2711),
    'Kochi': Coordinates(9.9312, 76.2673),
    'Udaipur': Coordinates(24.5854, 73.7125),

    // Pakistan places
    'Islamabad': Coordinates(33.6844, 73.0479),
    'Karachi': Coordinates(24.8607, 67.0011),
    'Lahore': Coordinates(31.5497, 74.3436),
    'Peshawar': Coordinates(34.0837, 71.5769),
    'Quetta': Coordinates(30.1798, 67.0151),
    'Faisalabad': Coordinates(31.4181, 72.3458),
    'Multan': Coordinates(30.1575, 71.4289),
    'Rawalpindi': Coordinates(33.5800, 73.2817),
    'Gilgit': Coordinates(35.9282, 74.3114),
    'Hunza': Coordinates(36.8479, 74.9565),
    'Skardu': Coordinates(35.2854, 75.5740),

    // China places
    'Beijing': Coordinates(39.9042, 116.4074),
    'Shanghai': Coordinates(31.2304, 121.4737),
    'Guangzhou': Coordinates(23.1291, 113.2644),
    'Chengdu': Coordinates(30.5728, 104.0668),
    'Xi\'an': Coordinates(34.3416, 108.9398),
    'Hangzhou': Coordinates(30.2741, 120.1551),
    'Chongqing': Coordinates(29.4316, 106.9123),
    'Nanjing': Coordinates(32.0603, 118.7969),
    'Wuhan': Coordinates(30.5928, 114.3055),
    'Suzhou': Coordinates(31.2989, 120.5954),
    'Zhangjiajie': Coordinates(29.1179, 110.4899),
    'Guilin': Coordinates(25.2747, 110.2864),
    'Lhasa': Coordinates(29.6470, 91.1132),

    // New Zealand (for sample data from design)
    'New Zealand': Coordinates(-40.9006, 174.8860),
    'Lake Tekapo': Coordinates(-44.0062, 170.4658),
    'Auckland': Coordinates(-37.0082, 174.7850),
    'Wellington': Coordinates(-41.2865, 174.7762),

    // Other well-known places
    'Greece': Coordinates(39.0742, 21.8243),
    'Santorini': Coordinates(36.3932, 25.4615),
    'Canada': Coordinates(56.1304, -106.3468),
    'Japan': Coordinates(36.2048, 138.2529),
    'Kyoto': Coordinates(35.0116, 135.7681),
    'Thailand': Coordinates(15.8700, 100.9925),
    'Bangkok': Coordinates(13.7563, 100.5018),
  };

  /// Get coordinates for a place name
  /// Returns coordinates or null if place not found
  static Coordinates? getCoordinates(String placeName) {
    return _coordinatesMap[placeName] ?? _findPartialMatch(placeName);
  }

  /// Try to find a partial match for the place name
  static Coordinates? _findPartialMatch(String placeName) {
    final lowerName = placeName.toLowerCase();
    for (final entry in _coordinatesMap.entries) {
      if (entry.key.toLowerCase().contains(lowerName) ||
          lowerName.contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }
    return null;
  }
}

class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates(this.latitude, this.longitude);

  @override
  String toString() => 'Coordinates(lat: $latitude, lon: $longitude)';
}
