
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class ForecastScreen extends StatefulWidget {
  final String location;

  const ForecastScreen({
    required this.location,
    Key? key
  }) : super(key: key);

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  List<Map<String, dynamic>> forecast = [];
  final String apiKey = '61fd21087b8d5921aad42339f82a1264';

  Future<void> fetchForecast() async {
    try {
      final response = await http.get(
          Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=${widget.location}&appid=$apiKey&units=metric')
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          forecast = (data['list'] as List<dynamic>? ?? [])
              .map((item) => {
            'icon': item['weather'][0]['icon'],
            'description': item['weather'][0]['description'],
            'date': DateFormat('E, MMM d').format(
                DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000)
            ),
            'time': DateFormat('h:mm a').format(
                DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000)
            ), // Shows: "2:45 PM"// Shows: "Mon, Dec 14"
            'minTemp': item['main']['temp_min'],
            'maxTemp': item['main']['temp_max'],
            'humidity': item['main']['humidity'], // Added humidity data

          })
              .toList();
        });

      } else {
        throw Exception('Failed to fetch forecast');
      }
    } catch (e) {
      debugPrint('Error fetching forecast: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchForecast();
  }

  @override
  Widget build(BuildContext context) {
    return SevenDayForecast(forecast: forecast);
  }
}
class SevenDayForecast extends StatelessWidget {
  final List<Map<String, dynamic>> forecast;

  const SevenDayForecast({required this.forecast, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          ' A 7-Day Forecast',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 2.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF002D4C), Color(0xFF5C4141)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            // Add refresh functionality here
          },
          child: forecast.isEmpty
              ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpinKitDancingSquare(
                  color: Colors.white,
                  size: 50.0,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Loading',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: forecast.length,
            itemBuilder: _buildForecastCard,
          ),
        ),
      ),
    );
  }

  Widget _buildForecastCard(BuildContext context, int index) {
    final dayData = forecast[index];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white12, Colors.white12],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      _buildWeatherIcon(dayData),
                      const SizedBox(width: 16.0),
                      Flexible(
                        child: _buildDateAndTemperature(dayData),
                      ),
                    ],
                  ),
                ),
                _buildHumidityIndicator(dayData),
              ],
            ),
            const SizedBox(height: 15.0),
            _buildWeatherDetails(dayData),
          ],
        ),
      ),
    );
  }

  Widget _buildHumidityIndicator(Map<String, dynamic> dayData) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.water_drop,
            color: Colors.white,
            size: 20,
          ),
          Text(
            '${dayData['humidity'] ?? '--'}%',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetails(Map<String, dynamic> dayData) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildWeatherDetail(
            Icons.thermostat_outlined,
            '${dayData['minTemp']?.toStringAsFixed(1) ?? '--'}°C',
            'Min Temp',
          ),
          _buildWeatherDetail(
            Icons.thermostat,
            '${dayData['maxTemp']?.toStringAsFixed(1) ?? '--'}°C',
            'Max Temp',
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherIcon(Map<String, dynamic> dayData) {
    final String iconCode = dayData['icon'] ??
        '13d'; // Provide a default icon code
    return Column(
      children: [
        Image.network(
          'https://openweathermap.org/img/wn/$iconCode@2x.png',
          width: 100.0,
          height: 100.0,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.cloud, size: 70, color: Colors.grey),
        ),
        const SizedBox(height: 5.0),
        Text(
          dayData['description'] ?? 'N/A',
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildDateAndTemperature(Map<String, dynamic> dayData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dayData['date'] ?? 'Unknown Date',
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 5.0),
        Text(
          dayData['time'] ?? 'Unknown Time',
          style: const TextStyle(
            fontSize: 16.0,
            fontFamily: 'Poppins',
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          'Min: ${dayData['minTemp']?.toStringAsFixed(1) ?? '--'}°C  '
              'Max: ${dayData['maxTemp']?.toStringAsFixed(1) ?? '--'}°C',
          style: const TextStyle(
            fontSize: 16.0,
            fontFamily: 'Poppins',
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

}