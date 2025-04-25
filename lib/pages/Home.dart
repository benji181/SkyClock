import 'package:flutter/material.dart';

import '../services/forecast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};


  @override
  Widget build(BuildContext context) {
    // Retrieve passed arguments
    data = data.isNotEmpty
        ? data
        : (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    print("Current Data in Home: $data");

    // Set background image and color
    String bgImage = data['isDaytime'] == true ? 'day.jpeg' : 'nite2.jpeg';
    Color bgColor = data['isDaytime'] == true ? Colors.blue : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/$bgImage'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: [
                    EditLocationButton(onPressed: _chooseLocation),
                    const SizedBox(height: 100.0),
                    LocationDisplay(location: data['location']),
                    const SizedBox(height: 30.0),
                    TimeDisplay(time: data['time']),
                    const SizedBox(height: 20.0),
                    WeatherInfo(
                      temperature: data['temperature'],
                      weather: data['Weather'],
                    ),
                  ],
                ),
                ForecastButton(location: data['location']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Navigate to the location screen and update state with the result
  void _chooseLocation() async {
    dynamic result = await Navigator.pushNamed(context, '/location');
    print("API Response from Location: $result");
    setState(() {
      if (result != null) {
        data = {
          'time': result['time'],
          'location': result['location'],
          'flag': result['flag'],
          'isDaytime': result['isDaytime'],
          'temperature': result['temperature'],
          'Weather': result['weather'],
          'forecast': [],
        };
      }
    });
  }
}

// Reusable widget: Edit Location Button
class EditLocationButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EditLocationButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(Icons.edit_location, color: Colors.white, size: 28.0),
      label: Text(
        'Choose Location',
        style: TextStyle(
          fontSize: 18.0,
          fontFamily: "Poppins",
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Reusable widget: Location Display
class LocationDisplay extends StatelessWidget {
  final String? location;

  const LocationDisplay({required this.location});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.location_on, color: Colors.white, size: 28.0),
        const SizedBox(width: 10.0),
        Text(
          location ?? 'Unknown Location',
          style: TextStyle(
            fontSize: 28.0,
            fontFamily: "Poppins",
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Reusable widget: Time Display
class TimeDisplay extends StatelessWidget {
  final String? time;

  const TimeDisplay({required this.time});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Time: ${time ?? 'Not Available'}",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 40.0,
        color: Colors.white,
        fontFamily: "Poppins-Bold",
      ),
    );
  }
}

// Reusable widget: Weather Info
class WeatherInfo extends StatelessWidget {
  final String? temperature;
  final String? weather;

  const WeatherInfo({required this.temperature, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(Icons.thermostat, color: Colors.white, size: 28.0),
        const SizedBox(width: 10.0),
        Text(
          '${temperature ?? '--'}°C',
          style: TextStyle(
            fontSize: 25.0,
            fontFamily: "Poppins",
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 50.0),
        Icon(Icons.cloud, color: Colors.white, size: 20.0),
        const SizedBox(width: 6.0),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
          child: Text(
            "Weather: ${weather ?? 'Unavailable'}",
            style: TextStyle(
              fontSize: 15.5,
              fontFamily: "Poppins",
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// Reusable widget: Forecast Button
class ForecastButton extends StatelessWidget {
  final String? location;

  const ForecastButton({required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ForecastScreen(
                location: location ?? 'london',
              ),
            ),
          );
        },
        child: const Text(
          'View further weather-forecast in this location',
          style: TextStyle(
            fontSize: 13.0,
            color: Colors.white,
            fontFamily: 'Poppins-italic',
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
//
// class Home extends StatelessWidget {
//   final Map data;
//
//   const Home({required this.data, super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     String bgImage = data['isDaytime'] ? 'day.jpeg' : 'nite2.jpeg';
//     String weatherIcon = data['icon'];
//
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/$bgImage'),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   data['location'],
//                   style: const TextStyle(
//                     fontSize: 36.0,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Image.network(
//                       'https://openweathermap.org/img/wn/$weatherIcon@2x.png',
//                       width: 50,
//                       height: 50,
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       "${data['temperature']}°C",
//                       style: const TextStyle(
//                         fontSize: 48.0,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   data['weather'],
//                   style: const TextStyle(
//                     fontSize: 24.0,
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildInfoTile("Feels Like", "${data['feelsLike']}°C"),
//                     _buildInfoTile("Humidity", "${data['humidity']}%"),
//                     _buildInfoTile("Wind", "${data['windSpeed']} m/s"),
//                     _buildInfoTile("Pressure", "${data['pressure']} hPa"),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildInfoTile(String label, String value) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 16.0,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 16.0,
//             color: Colors.white,
//           ),
//         ),
//       ],
//     );
//   }
// }
//