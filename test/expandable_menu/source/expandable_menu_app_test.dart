import 'package:flutter/material.dart';
import 'package:microkit/expandable_menu/expandable_menu.dart';

class ExpandableMenuTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExpandableMenuTestHome(),
    );
  }
}

class ExpandableMenuTestHome extends StatefulWidget {
  @override
  _ExpandableMenuTestHomeState createState() => _ExpandableMenuTestHomeState();
}

class _ExpandableMenuTestHomeState extends State<ExpandableMenuTestHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ExpandableMenu(
          title: {
            MenuState.collapse: Text('Collapse'),
            MenuState.expand: Text('Expand'),
          },
          backroundTitleColor: {
            MenuState.collapse: Colors.blue,
            MenuState.expand: Colors.white,
          },
          collapsable: Container(),
        ),
      ),
    );
  }
}
