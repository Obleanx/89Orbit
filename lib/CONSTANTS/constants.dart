// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

//color descriptions for the onbaording screens.
const TextColor = Color(0xffe79796);
const TextsInsideButtonColor = Color(0xfffb40ad);
const NormalTextColor = Colors.white;
// Define the button style constant
final ButtonStyle elevatedButtonDesign = ElevatedButton.styleFrom(
  elevation: 8.0,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  backgroundColor: TextsInsideButtonColor,
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  // minimumSize: const Size(100, 30),
);
