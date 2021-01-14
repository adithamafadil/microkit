import 'package:flutter/material.dart';

/// ButtonStates is a conditional for the button's state
///
/// - `standby` for default button, standby state
///
/// - `loading` when you have to await something or load something
///
/// - `failed` to shown the failed state
///
/// - `succeed` to shown the succeed state
enum ButtonStates { standby, loading, failed, succeed }

/// ProgressButton is a button that has some states at [ButtonStates]
/// that will animate and change the state depends on your controller.
///
/// Example
/// ```dart
/// ProgressButton(
///   state: yourButtonState,
///   onPressed: () {
///     // some function
///   },
///   colorState: {
///     ButtonStates.loading: Colors.grey,
///     ButtonStates.succeed: Colors.green,
///     ButtonStates.failed: Colors.red,
///     ButtonStates.standby: Colors.blue,
///   },
///   widgetState: {
///     ButtonStates.loading: Container(),
///     ButtonStates.succeed: Text('Succeed'),
///     ButtonStates.failed: Text('Failed'),
///     ButtonStates.standby: Text('Refetch'),
///   },
/// )
/// ```
class ProgressButton extends StatefulWidget {
  /// animationStateController is an animation controller that will control your
  /// animation using [AnimationController]. If you fill this, don't forget
  /// to use involve [TickerProviderStateMixin] with `with` keyword at your
  /// class.
  final AnimationController animationStateController;

  /// animationDuration is a property that will filled into [Duration] as
  /// millisecond for the button's interval when being animated
  final int animationDuration;

  /// colorState is a `Map<ButtonStates, Color>` that will map your colors
  /// to your [ButtonStates].
  final Map<ButtonStates, Color> colorState;

  /// curvedAnimation return [CurvedAnimation] that will controll the curve
  /// your animation. This property needs `parent` from [AnimationController].
  /// If you wanna use this, don't forget to use `animationStateController`
  /// so you have the `parent`.
  final CurvedAnimation curvedAnimation;

  /// height use as the button's height. The default value is `50.0`
  final double height;

  /// maxWidth is the default width of the button. It has default value
  /// `200.0`

  /// isLoadShrinking is the property that returns a `bool` as indicator if you
  /// want to shrink the button into the [minWidth] or not. The default value
  /// is `true`.
  final bool isLoadShrinking;

  final double maxWidth;

  /// minWidth use when the button shrinks to loading state.
  /// It has double `90.0`
  final double minWidth;

  /// radius use as border radius of the button. radius return double.
  /// It has default value `8.0`
  /// If you prefer the sharp one, you may fill it with `0`
  final double radius;

  /// onPressed is the function when the button is pressed. it returns
  /// a function
  final Function() onPressed;

  /// state is the condition that will shown for your button.
  /// See more: [ButtonStates]
  final ButtonStates state;

  /// widgetState is a `Map<ButtonStates, Widget>` that will map your
  /// button's widget depends on your [ButtonStates]. If you want let it blank,
  /// you may fill it with `Container()`.
  final Map<ButtonStates, Widget> widgetState;

  ProgressButton({
    Key key,
    this.animationDuration = 500,
    this.animationStateController,
    @required this.colorState,
    this.curvedAnimation,
    this.height = 50,
    this.isLoadShrinking = true,
    this.maxWidth = 200,
    this.minWidth = 90,
    @required this.onPressed,
    this.radius = 8,
    @required this.state,
    @required this.widgetState,
  })  : assert(
          // Asserting onPressed cannot be null
          onPressed != null,
          'onPressed cannot be null',
        ),
        assert(state != null, 'state cannot be null'),
        assert(
          colorState != null &&
              colorState.keys.toSet().containsAll(ButtonStates.values.toSet()),
          'colorState needs all your keys from ButtonStates. You\'re missing' +
              ' keys at ${ButtonStates.values.toSet().difference(colorState.keys.toSet())}',
        ),
        assert(
          widgetState != null &&
              widgetState.keys.toSet().containsAll(ButtonStates.values.toSet()),
          'widgetState needs all your keys from ButtonStates. You\'re missing' +
              ' keys at ${ButtonStates.values.toSet().difference(widgetState.keys.toSet())}',
        ),
        super(key: key);

  @override
  _ProgressButtonStates createState() => _ProgressButtonStates();
}

class _ProgressButtonStates extends State<ProgressButton>
    with TickerProviderStateMixin {
  AnimationController _stateController;
  Animation<Color> _animationColor;
  double _width;
  Duration _animationDuration;
  CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    // set up the initial width
    _width = widget.maxWidth;

    //set up the animation duration
    _animationDuration = Duration(milliseconds: widget.animationDuration);

    // checking if user input their own controller
    if (widget.animationStateController == null) {
      _stateController = AnimationController(
        vsync: this,
        duration: _animationDuration,
      );
    } else {
      _stateController = widget.animationStateController;
    }

    // checking if user input their own curvedAnimation
    if (widget.curvedAnimation == null) {
      _curvedAnimation = CurvedAnimation(
        parent: _stateController,
        curve: Interval(0, 1, curve: Curves.easeIn),
      );
    } else {
      _curvedAnimation = widget.curvedAnimation;
    }

    super.initState();
  }

  @override
  void dispose() {
    // removing from tree
    _stateController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProgressButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // buildup if there is an update widget's state
    if (oldWidget.state != widget.state) {
      _stateController?.reset();
      startAnimation(oldWidget.state, widget.state);
    }
  }

  void startAnimation(ButtonStates oldState, ButtonStates newState) {
    Color begin = widget.colorState[oldState];
    Color end = widget.colorState[newState];

    if (widget.isLoadShrinking && newState == ButtonStates.loading) {
      _width = widget.minWidth;
    } else {
      _width = widget.maxWidth;
    }

    _animationColor = ColorTween(
      begin: begin,
      end: end,
    ).animate(_curvedAnimation);
    _stateController.forward();
  }

  Color get buttonColor => _animationColor == null
      ? widget.colorState[widget.state]
      : _animationColor.value;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _stateController,
      builder: (context, child) {
        return AnimatedContainer(
          duration: _animationDuration,
          height: widget.height,
          width: _width,
          child: RaisedButton(
            color: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius),
            ),
            onPressed:
                widget.state == ButtonStates.loading ? null : widget.onPressed,
            child: buttonChild(
              _animationColor == null ? true : _animationColor.isCompleted,
            ),
          ),
        );
      },
    );
  }

  buttonChild(bool visibility) {
    if (widget.state == ButtonStates.loading) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          widget.widgetState[widget.state],
        ],
      );
    }
    return AnimatedOpacity(
      opacity: visibility ? 1 : 0,
      duration: Duration(milliseconds: 300),
      child: widget.widgetState[widget.state],
    );
  }
}
