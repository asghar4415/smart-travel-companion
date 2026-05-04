import 'package:equatable/equatable.dart';
import 'dart:math' as math;

class WeatherModel extends Equatable {
  final double temperature;
  final double windSpeed;
  final int humidity;
  final double feelsLike;
  final String weatherDescription;
  final int weatherCode;

  const WeatherModel({
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.feelsLike,
    required this.weatherDescription,
    required this.weatherCode,
  });

  // Factory constructor to parse Open-Meteo API response
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;

    return WeatherModel(
      temperature: (current['temperature_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      humidity: current['relative_humidity_2m'] as int? ?? 0,
      feelsLike: _calculateFeelsLike(
        (current['temperature_2m'] as num).toDouble(),
        (current['wind_speed_10m'] as num).toDouble(),
      ),
      weatherDescription: _getWeatherDescription(
        current['weather_code'] as int? ?? 0,
      ),
      weatherCode: current['weather_code'] as int? ?? 0,
    );
  }

  // Calculate feels like temperature using wind chill formula (simplified)
  static double _calculateFeelsLike(double temp, double windSpeed) {
    if (windSpeed > 0) {
      // Wind chill formula: T_wc = 13.12 + 0.6215*T - 11.37*V^0.16 + 0.3965*T*V^0.16
      final v = windSpeed;
      final t = temp;
      return 13.12 +
          (0.6215 * t) -
          (11.37 * (v.pow(0.16))) +
          (0.3965 * t * (v.pow(0.16)));
    }
    return temp;
  }

  // Convert WMO weather code to description
  static String _getWeatherDescription(int code) {
    switch (code) {
      case 0:
        return 'Clear Sky';
      case 1:
      case 2:
        return 'Mostly Clear';
      case 3:
        return 'Overcast';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
        return 'Light Rain';
      case 61:
      case 63:
      case 65:
        return 'Rainy';
      case 71:
      case 73:
      case 75:
        return 'Snowy';
      case 77:
        return 'Snow Grains';
      case 80:
      case 81:
      case 82:
        return 'Rain Showers';
      case 85:
      case 86:
        return 'Snow Showers';
      case 95:
      case 96:
      case 99:
        return 'Thunderstorm';
      default:
        return 'Unknown';
    }
  }

  // Get weather icon based on weather code
  String getWeatherIcon() {
    switch (weatherCode) {
      case 0:
        return '☀️'; // Clear
      case 1:
      case 2:
        return '🌤️'; // Mostly clear
      case 3:
        return '☁️'; // Overcast
      case 45:
      case 48:
        return '🌫️'; // Foggy
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return '🌧️'; // Rain
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return '❄️'; // Snow
      case 95:
      case 96:
      case 99:
        return '⛈️'; // Thunderstorm
      default:
        return '🌡️';
    }
  }

  @override
  List<Object?> get props => [
    temperature,
    windSpeed,
    humidity,
    feelsLike,
    weatherDescription,
    weatherCode,
  ];
}

extension on double {
  double pow(double exponent) {
    return math.pow(this, exponent).toDouble();
  }
}
