import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  // Your OpenWeatherMap API Key
  final String apiKey = '61fd21087b8d5921aad42339f82a1264';  // Replace with your actual API key

  // Request permission for location access
  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  // Get current position
  Future<Position?> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception("Location services are disabled.");
      }

      bool hasPermission = await requestPermission();
      if (!hasPermission) {
        throw Exception("Location permission denied.");
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  // Fetch weather data using latitude and longitude
  Future<Map<String, dynamic>> fetchWeather(double latitude, double longitude) async {
    final response = await http.get(
      Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      String weather = data['weather'][0]['description'];
      double temperature = data['main']['temp'];
      return {
        'weather': weather,
        'temperature': temperature,
      };
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
