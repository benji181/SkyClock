import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

class WeatherHomeWidget extends StatelessWidget {
  const WeatherHomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder<void>(
            future: HomeWidget.saveWidgetData(
              'temperature', '25°C',
            ),
            builder: (context, snapshot) {
              return const WeatherWidgetContent();
            },
          ),
        ),
      ),
    );
  }
}

class WeatherWidgetContent extends StatelessWidget {
  const WeatherWidgetContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Current Weather',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wb_sunny, color: Colors.white),
              SizedBox(width: 8),
              Text(
                '25°C',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
