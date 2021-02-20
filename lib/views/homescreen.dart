import 'package:flutter/material.dart';
import 'package:ordernow/models/restaurants.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Restaurant.loginCheck().then((isLogged) {
      if (!isLogged) Navigator.of(context).pushReplacementNamed('/login');
    });
    return Container(
      child: Text('Loged in'),
    );
  }
}
