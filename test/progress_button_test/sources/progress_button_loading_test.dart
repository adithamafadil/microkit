import 'package:flutter/material.dart';
import 'package:microkit/progress_button/progress_button.dart';

class ProgressLoadingTestApp extends StatelessWidget {
  final ButtonStates currentState;
  final ButtonStates nextState;

  ProgressLoadingTestApp({this.currentState, this.nextState});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProgressTestHome(
        currentState: currentState,
        nextState: nextState,
      ),
    );
  }
}

class ProgressTestHome extends StatefulWidget {
  final ButtonStates currentState;
  final ButtonStates nextState;

  ProgressTestHome({@required this.currentState, @required this.nextState});
  @override
  _ProgressTestHomeState createState() => _ProgressTestHomeState();
}

class _ProgressTestHomeState extends State<ProgressTestHome> {
  ButtonStates _state;

  @override
  void initState() {
    setState(() {
      _state = widget.currentState;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ProgressButton(
          colorState: {
            ButtonStates.failed: Colors.red,
            ButtonStates.loading: Colors.grey,
            ButtonStates.standby: Colors.blue,
            ButtonStates.succeed: Colors.green,
          },
          isLoadShrinking: false,
          state: _state,
          onPressed: () {
            setState(() {
              _state = ButtonStates.loading;
              _state = widget.nextState;
            });
          },
          widgetState: {
            ButtonStates.failed: Text('Failed'),
            ButtonStates.loading: Text('Loading'),
            ButtonStates.standby: Text('Refetch'),
            ButtonStates.succeed: Text('Succeed'),
          },
        ),
      ),
    );
  }
}
