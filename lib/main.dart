import 'package:flagedebugtest/pages/ChangeOfLocation.dart';
import 'package:flagedebugtest/pages/Home.dart';
import 'package:flagedebugtest/pages/loadingScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( MaterialApp(
    initialRoute: '/',
    routes:{
       '/' : (context) => LoadingState(),
      '/home': (context) => Home(),
      '/location': (context) => ChooseLocation(),

    },
  ) );
}


