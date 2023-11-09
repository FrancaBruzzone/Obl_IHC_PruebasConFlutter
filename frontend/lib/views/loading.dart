import 'package:flutter/material.dart';

// ==========================
// Vista
// ==========================
class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset('images/loading.gif'),
    );
  }
}