import 'package:flutter/material.dart';

class Food {
  final int id;
  final String name;
  final String url;
  final double price;

  const Food({
    this.id,
    @required this.name,
    @required this.url,
    @required this.price,
  });
}
