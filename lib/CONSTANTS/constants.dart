// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';

//color descriptions for the onbaording screens.
const TextColor = Color(0xffe79796);
const TextsInsideButtonColor = Color(0xfffb40ad);
const NormalTextColor = Colors.white;
// Define the button style constant
final ButtonStyle elevatedButtonDesign = ElevatedButton.styleFrom(
  minimumSize: const Size.fromHeight(50), // Customize the size as needed
  backgroundColor: TextsInsideButtonColor, // Use your predefined color
);
