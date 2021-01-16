import 'package:flutter/material.dart';
import 'package:microkit/shimmer/shimmer.dart';

class ShimmerListTileTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Shimmer.listTile()
      ),
    );
  }
}