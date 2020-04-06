import 'package:flutter/material.dart';

class EntriesPage extends StatelessWidget {
  final Color color;

  EntriesPage(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}