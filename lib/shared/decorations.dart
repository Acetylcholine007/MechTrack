import 'package:flutter/material.dart';

InputDecoration formFieldDecoration = InputDecoration(
    border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white)),
    filled: true,
    fillColor: Colors.white
);

InputDecoration searchFieldDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(100),
    ),
    filled: true,
    fillColor: Colors.white,
    hintText: 'Search'
);

ButtonStyle buttonDecoration = ButtonStyle();