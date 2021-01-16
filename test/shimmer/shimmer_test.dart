import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:microkit/microkit.dart';

import 'source/shimmer_listtile_test.dart';

void main() {
  testWidgets('Shimmer can be constructed', (tester) async {
    await tester.pumpWidget(Shimmer(
      baseColor: Colors.green,
      highlightColor: Colors.yellow,
      duration: Duration(milliseconds: 100),
      child: Container(
        height: 50,
        width: 200,
      ),
    ));
  });

  testWidgets('Shimmer.listTile() can be constructed', (tester) async {
    await tester.pumpWidget(ShimmerListTileTestApp());
  });
}
