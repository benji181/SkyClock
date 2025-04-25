import 'package:http/http.dart'; // Import the Hackage
import 'dart:convert';
import 'package:intl/intl.dart';

class Worldtimeapi {
  String? location;
  String? time;
  String? flag;
  String? url; // API timezone URL
  bool? isDayTime;  // Change to non-nullable bool with default value

  Worldtimeapi( {this.location, this.flag, this.url});

  // Async method to fetch and process time data
  Future<void> getTime() async {
    try {
      Response response = await get(Uri.parse('https://www.timeapi.io/api/Time/current/zone?timeZone=$url'));
      print('API Response: ${response.body}'); // Debug log#
      print('Google response: ${response.statusCode}');

      Map data = jsonDecode(response.body);
      String dateTimeStr = data['dateTime'];

      // FIX: Trim down fractional seconds to 6 digits (or remove them)
      dateTimeStr = dateTimeStr.split('.').first; // removes milliseconds
      DateTime now = DateTime.parse(dateTimeStr);

      isDayTime = now.hour > 6 && now.hour < 19;
      time = DateFormat.jm().format(now);
    } catch (e) {
      print('Caught error: $e');
      time = 'Sorry we had an issue (error) retrieving time';
    }
  }

}
