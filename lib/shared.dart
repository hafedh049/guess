import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

int hidden = 0;
final List<int> attempts = <int>[];

const Color pink = Color.fromARGB(255, 255, 116, 163);
const Color dark = Color.fromARGB(255, 31, 31, 31);
const Color transparent = Colors.transparent;
const Color white = Color.fromARGB(255, 255, 250, 251);
const Color blue = Color.fromARGB(255, 0, 195, 255);
const Color gold = Color.fromARGB(255, 237, 255, 174);
const Color green = Color.fromARGB(255, 116, 255, 116);
const Color red = Color.fromARGB(255, 255, 17, 0);

void showToast(BuildContext context, String message, Color color) {
  toastification.show(description: Text(message, style: TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w500)));
}
