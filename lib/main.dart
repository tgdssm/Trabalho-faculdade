import 'package:flutter/material.dart';
import 'package:front_end_api/app/product/presenter/product_screen.dart';

void main() {
  runApp(
    const MaterialApp(
      title: "Manager",
      debugShowCheckedModeBanner: false,
      home: ProductScreen(),
    ),
  );
}
