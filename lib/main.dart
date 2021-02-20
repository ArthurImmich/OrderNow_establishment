import 'package:flutter/material.dart';
import 'package:ordernow/constants/colors.dart';
import 'package:ordernow/views/login.dart';
import 'package:ordernow/views/register.dart';
import 'package:ordernow/views/homescreen.dart';

void main() async {
  runApp(OrderNow());
}

class OrderNow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'OrderNow',
        theme: ThemeData(
          primaryColor: Colors.black,
          accentColor: apporange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => Login(),
          '/register': (context) => Register(),
          '/homescreen': (context) => HomeScreen(),
        });
  }
}
