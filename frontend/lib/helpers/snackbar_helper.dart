import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showErrorSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Something went wrong!'),
      ),
    );
  }
}
