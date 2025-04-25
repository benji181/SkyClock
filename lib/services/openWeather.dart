import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';

class WeatherApi {
 late  String location;
  late String temperature;
  late String feelsLike;
  late String weather;
  late String description;
  late String icon;
  late int humidity;
  late int pressure;
  late double windSpeed;
  late String windDirection;
  List<Map<String, dynamic>> forecast = []; // Store 5-day forecast

  WeatherApi({ required this.location});

  Future<void> getWeather() async {
    try {
      final apiKey = '61fd21087b8d5921aad42339f82a1264'; // Replace with your OpenWeatherMap API key
      final weatherUrl =
          'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiKey&units=metric';
      final forecastUrl =
          'https://api.openweathermap.org/data/2.5/forecast?q=$location&appid=$apiKey&units=metric';

      // Fetch current weather
      Response weatherResponse = await get(Uri.parse(weatherUrl));
      Map weatherData = jsonDecode(weatherResponse.body);

      temperature = weatherData['main']['temp'].toString();
      feelsLike = weatherData['main']['feels_like'].toString();
      weather = weatherData['weather'][0]['main'];
      description = weatherData['weather'][0]['description'];
      icon = weatherData['weather'][0]['icon'];
      humidity = weatherData['main']['humidity'];
      pressure = weatherData['main']['pressure'];
      windSpeed = weatherData['wind']['speed'];
      windDirection = _getWindDirection(weatherData['wind']['deg']);

      // Fetch forecast
      Response forecastResponse = await get(Uri.parse(forecastUrl));
      Map forecastData = jsonDecode(forecastResponse.body);

      // Group forecast data by day
      Map<String, List<Map<String, dynamic>>> dailyData = {};
      for (var entry in forecastData['list']) {
        DateTime dateTime = DateTime.parse(entry['dt_txt']);
        String date = DateFormat('EEEE, MMM d').format(dateTime);
        if (!dailyData.containsKey(date)) {
          dailyData[date] = [];
        }
        dailyData[date]?.add({
          'time': DateFormat.jm().format(dateTime),
          'temp': entry['main']['temp'],
          'icon': entry['weather'][0]['icon'],
          'description': entry['weather'][0]['description'],
        });
      }

      // Summarize daily data into the forecast list
      forecast = dailyData.entries.map((entry) {
        return {
          'date': entry.key,
          'minTemp': entry.value
              .map((e) => e['temp'])
              .reduce((a, b) => a < b ? a : b),
          'maxTemp': entry.value
              .map((e) => e['temp'])
              .reduce((a, b) => a > b ? a : b),
          'icon': entry.value[0]['icon'],
          'description': entry.value[0]['description'],
        };
      }).toList();
    } catch (e) {
      print('Error fetching weather/forecast data: $e');
    }
  }

  String _getWindDirection(int degrees) {
    const directions = [
      "N", "NE", "E", "SE", "S", "SW", "W", "NW", "N"
    ]; // For wrapping around
    return directions[((degrees / 45).round()) % 8];
  }
}


// import 'package:http/http.dart'; // Import the HTTP package
// import 'dart:convert';
//
// class WeatherApi {
//   String? location; // Location name
//   String? temperature; // Current temperature
//   String? weather; // Weather description
//   String? icon; // Icon code for weather condition
//   String apiKey = '61fd21087b8d5921aad42339f82a1264'; // Replace with your OpenWeatherMap API Key
//   String apiUrl = 'https://api.openweathermap.org/data/2.5/weather'; // Base URL
//
//   WeatherApi(this.location);
//
//   // Fetch weather data
//   Future<void> getWeather() async {
//     try {
//       // Build the full API URL
//       String requestUrl = '$apiUrl?q=$location&units=metric&appid=$apiKey';
//
//       // Make an HTTP GET request
//       Response response = await get(Uri.parse(requestUrl));
//
//       // Parse the JSON response
//       Map data = jsonDecode(response.body);
//
//       // Extract desired information
//       temperature = data['main']['temp'].toString(); // Current temperature
//       weather = data['weather'][0]['description']; // Weather description
//       icon = data['weather'][0]['icon']; // Weather icon code
//     } catch (e) {
//       print('Caught error: $e');
//       weather = 'Unable to fetch weather data';
//     }
//   }
// }
// // void main() async {
// //   WeatherApi weather = WeatherApi('leticia');
// //   await weather.getWeather();
// //
// //   print('Location: ${weather.location}');
// //   print('Temperature: ${weather.temperature}°C');
// //   print('Weather: ${weather.weather}');
// // }
