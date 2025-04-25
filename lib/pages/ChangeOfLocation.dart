import 'package:flutter/material.dart';
// import 'package:skyclock2/services/worldtimeapi.dart';
// import 'package:skyclock2/services/openWeather.dart';
import '../services/openWeather.dart';
import '../services/worldtimeapi.dart';

class ChooseLocation extends StatefulWidget {
  @override
  _ChooseLocationState createState() => _ChooseLocationState();
}

class _ChooseLocationState extends State<ChooseLocation> {

  List<Worldtimeapi> locations = [
    // Europe
    Worldtimeapi(url: 'Europe/London', location: 'London', flag: 'uk.png'),
    Worldtimeapi(url: 'Europe/Berlin', location: 'Berlin', flag: 'germany.png'),
    Worldtimeapi(url: 'Europe/Moscow', location: 'Moscow', flag: 'russia.png'),
    Worldtimeapi(url: 'Europe/Paris', location: 'Paris', flag: 'france.png'),
    Worldtimeapi(url: 'Europe/Rome', location: 'Rome', flag: 'italy.png'),
    Worldtimeapi(url: 'Europe/Madrid', location: 'Madrid', flag: 'spain.png'),
    Worldtimeapi(url: 'Europe/Oslo', location: 'Oslo', flag: 'norway.png'),
    Worldtimeapi(url: 'Europe/Stockholm', location: 'Stockholm', flag: 'sweden.jpeg'),
    Worldtimeapi(url: 'Europe/Zurich', location: 'Zurich', flag: 'switzerland.jpeg'),

    // Africa
    Worldtimeapi(url: 'Africa/Cairo', location: 'Cairo', flag: 'egypt.png'),
    Worldtimeapi(url: 'Africa/Nairobi', location: 'Nairobi', flag: 'kenya.png'),
    Worldtimeapi(url: 'Africa/Lagos', location: 'Lagos', flag: 'nigeria.jpeg'),
    Worldtimeapi(url: 'Africa/Johannesburg', location: 'Johannesburg', flag: 'south_africa.jpeg'),
    Worldtimeapi(url: 'Africa/Addis_Ababa', location: 'Addis Ababa', flag: 'ethiopia.jpeg'),
    Worldtimeapi(url: 'Africa/Accra', location: 'Accra', flag: 'ghana.jpeg'),
    Worldtimeapi(url: 'Africa/Algiers', location: 'Algiers', flag: 'algeria.jpeg'),
    Worldtimeapi(url: 'Africa/Casablanca', location: 'Casablanca', flag: 'morocco.jpeg'),
    Worldtimeapi(url: 'Africa/Tunis', location: 'Tunis', flag: 'tunisia.jpeg'),

    // Asia
    Worldtimeapi(url: 'Asia/Seoul', location: 'Seoul', flag: 'south_korea.png'),
    Worldtimeapi(url: 'Asia/Tokyo', location: 'Tokyo', flag: 'japan.png'),
    Worldtimeapi(url: 'Asia/Shanghai', location: 'Shanghai', flag: 'china.jpeg'),
    Worldtimeapi(url: 'Asia/Kolkata', location: 'Kolkata', flag: 'india.jpeg'),
    Worldtimeapi(url: 'Asia/Dubai', location: 'Dubai', flag: 'uae.jpeg'),
    Worldtimeapi(url: 'Asia/Beijing', location: 'Beijing', flag: 'china.jpeg'),
    Worldtimeapi(url: 'Asia/Bangkok', location: 'Bangkok', flag: 'thailand.jpeg'),
    Worldtimeapi(url: 'Asia/Singapore', location: 'Singapore', flag: 'singapore.jpeg'),
    Worldtimeapi(url: 'Asia/Kuala_Lumpur', location: 'Kuala Lumpur', flag: 'malaysia.jpeg'),
    Worldtimeapi(url: 'Asia/Hong_Kong', location: 'Hong Kong', flag: 'hong_kong.jpeg'),

    // Americas
    Worldtimeapi(url: 'America/Chicago', location: 'Chicago', flag: 'usa.png'),
    Worldtimeapi(url: 'America/New_York', location: 'New York', flag: 'usa.png'),
    Worldtimeapi(url: 'America/Los_Angeles', location: 'Los Angeles', flag: 'usa.png'),
    Worldtimeapi(url: 'America/Sao_Paulo', location: 'São Paulo', flag: 'brazil.jpeg'),
    Worldtimeapi(url: 'America/Mexico_City', location: 'Mexico City', flag: 'mexico.jpeg'),
    Worldtimeapi(url: 'America/Toronto', location: 'Toronto', flag: 'canada.jpeg'),
    Worldtimeapi(url: 'America/Bogota', location: 'Bogotá', flag: 'colombia.jpeg'),
    Worldtimeapi(url: 'America/Buenos_Aires', location: 'Buenos Aires', flag: 'argentina.jpeg'),
    Worldtimeapi(url: 'America/Lima', location: 'Lima', flag: 'peru.jpeg'),
    Worldtimeapi(url: 'America/Santiago', location: 'Santiago', flag: 'chile.jpeg'),

    // Oceania
    Worldtimeapi(url: 'Australia/Sydney', location: 'Sydney', flag: 'australia.png'),
    Worldtimeapi(url: 'Pacific/Auckland', location: 'Auckland', flag: 'new_zealand.jpeg'),
    Worldtimeapi(url: 'Australia/Melbourne', location: 'Melbourne', flag: 'australia.png'),
    Worldtimeapi(url: 'Australia/Brisbane', location: 'Brisbane', flag: 'australia.png'),
    Worldtimeapi(url: 'Pacific/Fiji', location: 'Fiji', flag: 'fiji.jpeg'),

    // Middle East
    Worldtimeapi(url: 'Asia/Riyadh', location: 'Riyadh', flag: 'saudi.jpeg'),
    Worldtimeapi(url: 'Asia/Jerusalem', location: 'Jerusalem', flag: 'israel.jpeg'),
    Worldtimeapi(url: 'Asia/Tehran', location: 'Tehran', flag: 'iran.jpeg'),
    Worldtimeapi(url: 'Asia/Baghdad', location: 'Baghdad', flag: 'iraq.jpeg'),
    Worldtimeapi(url: 'Asia/Amman', location: 'Amman', flag: 'jordan.jpeg'),

    // Additional locations
    Worldtimeapi(url: 'Antarctica/Palmer', location: 'Palmer Station', flag: 'antarctica.jpeg'),
    Worldtimeapi(url: 'Pacific/Honolulu', location: 'Honolulu', flag: 'usa.png'),
    Worldtimeapi(url: 'Atlantic/Reykjavik', location: 'Reykjavik', flag: 'iceland.jpeg'),
    Worldtimeapi(url: 'Asia/Manila', location: 'Manila', flag: 'philippines.jpeg'),
    Worldtimeapi(url: 'Africa/Dakar', location: 'Dakar', flag: 'senegal.jpeg'),
  ];



  void updateTimeAndWeather(index) async {
    Worldtimeapi timeInstance = locations[index];
    WeatherApi weatherInstance = WeatherApi(location: locations[index].location!);

    // Fetch time
    await timeInstance.getTime();

    // Fetch weather
    await weatherInstance.getWeather();

    Navigator.pop(context, {
      'location': timeInstance.location,
      'flag': timeInstance.flag,
      'time': timeInstance.time,
      'isDaytime': timeInstance.isDayTime,
      'temperature': weatherInstance.temperature,
      'weather': weatherInstance.feelsLike,
      'icon': weatherInstance.description   ,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        title: const Text(
          'Choose a Location for Time and Weather',
          style: TextStyle(fontSize: 16),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: ListView.builder(
          itemCount: locations.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 4.0),
              child: Card(
                child: ListTile(
                  onTap: () {
                    updateTimeAndWeather(index);
                  },
                  title: Text(locations[index].location!),
                  leading: CircleAvatar(
                    backgroundImage: AssetImage('assets/${locations[index].flag}'),

                  ),

                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
