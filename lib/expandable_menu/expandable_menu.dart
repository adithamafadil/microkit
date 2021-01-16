import 'package:flutter/material.dart';
import 'expandable_container.dart';

/// [MenuState] is an enum to identify your state.
enum MenuState { collapse, expand }

/// ExpandableMenu is a menu that can be expandable and contains some of
/// your information.
///
/// Example:
///
/// ```dart
/// ExpandableMenu(
///   title: {
///     MenuState.collapse: _titleWidget(MenuState.collapse),
///     MenuState.expand: _titleWidget(MenuState.expand),
///   },
///   backroundTitleColor: {
///     MenuState.expand: Colors.blue[200],
///     MenuState.collapse: Colors.transparent,
///   },
///   collapsable: Container(
///     color: Colors.lightBlue[100],
///     child: Padding(
///       padding: const EdgeInsets.all(16),
///       child: Text('yourText'),
///     ),
///   ),
///);
/// ```
class ExpandableMenu extends StatefulWidget {
  /// backgroundTitleColor is a `Map<MenuState, Color>` that will map your
  /// background color depends on your [MenuState].
  final Map<MenuState, Color> backroundTitleColor;

  /// curve is for animation's curve. You may choose beetween enum from
  /// [Curves] or using [Cubic] instead to configure it.
  final Curve curve;

  /// collapsable is a Widget that will hide if [MenuState] collapsed state.
  final Widget collapsable;

  /// expandedHeight is the height of expanded space when [MenuState]
  /// expanded state. It returns double and the default value is `230`
  final double expandedHeight;

  /// splashColor is a splash effect when your menu hit. It returns
  /// Color.
  final Color splashColor;

  /// title is a `Map<MenuState, Widget>` that will map your
  /// widget as a title of our menu.
  /// See more: [MenuState].
  final Map<MenuState, Widget> title;

  ExpandableMenu({
    Key key,
    @required this.backroundTitleColor,
    @required this.collapsable,
    this.curve = const Cubic(0.4, 0.0, 0.2, 1),
    this.expandedHeight = 230,
    this.splashColor,
    @required this.title,
  })  : assert(
          backroundTitleColor != null &&
              backroundTitleColor.keys
                  .toSet()
                  .containsAll(MenuState.values.toSet()),
          'backroundTitleColor needs all your keys from ButtonStates. You\'re missing' +
              ' keys at ${MenuState.values.toSet().difference(backroundTitleColor.keys.toSet())}',
        ),
        assert(
          title != null &&
              title.keys.toSet().containsAll(MenuState.values.toSet()),
          'title needs all your keys from ButtonStates. You\'re missing' +
              ' keys at ${MenuState.values.toSet().difference(title.keys.toSet())}',
        ),
        assert(collapsable != null),
        super(key: key);

  @override
  _ExpandableMenuState createState() => _ExpandableMenuState();
}

class _ExpandableMenuState extends State<ExpandableMenu>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  bool _tapped = false;
  MenuState _collapseState = MenuState.collapse;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    super.initState();
  }

  hadleOnTap() {
    setState(() {
      _tapped = !_tapped;
    });
    if (_tapped) {
      _animationController.forward();
      _collapseState = MenuState.expand;
    } else {
      _animationController.reverse();
      _collapseState = MenuState.collapse;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: hadleOnTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            color: _tapped
                ? widget.backroundTitleColor[MenuState.expand]
                : widget.backroundTitleColor[MenuState.collapse],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 9,
                  child: _tapped
                      ? widget.title[MenuState.expand]
                      : widget.title[MenuState.collapse],
                ),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _animationController.value * 3.1,
                        child: child,
                      );
                    },
                    child: Icon(
                      Icons.keyboard_arrow_down,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ExpandableContainer(
          child: widget.collapsable,
          controller: _animationController,
          curve: widget.curve,
          height: widget.expandedHeight,
        ),
      ],
    );
  }
}
