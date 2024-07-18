import 'package:flutter/material.dart';

class ButtonThemes {
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );

  static final TextStyle elevatedButtonTextStyle = TextStyle(
    color: Colors.grey[800],
  );
}
