import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:skyclock2/services/worldtimeapi.dart';
import '../services/openWeather.dart';
import '../services/worldtimeapi.dart';

class LoadingState extends StatefulWidget {
  const LoadingState({super.key});

  @override
  State<LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<LoadingState> {
  // String timeLd = 'loading...';
void setupWorldTime() async{
  Worldtimeapi instance = Worldtimeapi(location: 'London', flag: 'uk.png', url: 'Europe/London');
  await  instance.getTime();

  WeatherApi weather = WeatherApi( location: '${instance.location}');
  await weather.getWeather();



  Navigator.pushReplacementNamed(context, '/home', arguments:{
    'location': instance.location,
    'flag' :instance.flag,
    'time' : instance.time,
    'isDaytime' :instance.isDayTime,
    'temperature' : weather.temperature,
    'Weather': weather.weather,
  });


  // print(instance.time);
  // setState(() {
  //   timeLd = instance.time!;
  // });
}

  @override
  void initState() {
    super.initState();
 setupWorldTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SkyClock',
        style: TextStyle(
          fontFamily: "Poppins-Light",
              letterSpacing: 2.0,

        ),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[900],
      ),

      body:  Center(
        child: SpinKitFadingCube(
            color: Colors.white,
            size: 80.0,
          ),
      ),
      backgroundColor: Colors.blue[900],
    );
  }
}



// // print('DateTime: $dateTime');
// // print('Date: $date');
// print('offset: $offset');
//
// // create a datetime obj