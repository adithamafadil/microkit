import 'package:flutter/material.dart';
import 'expandable_menu.dart';

/// ExpandableContainer is an [AnimatedWidget] that will be the expandable
/// container in your [ExpandableMenu]
class ExpandableContainer extends AnimatedWidget {
  /// child returns Widget that will be the widget that will be expandable
  final Widget child;

  /// controller for controlling your [ExpandableContainer]
  /// using AnimationController.
  final AnimationController controller;

  /// curve is for animation's curve. You may choose beetween enum from
  /// [Curves] or using [Cubic] instead to configure it.
  final Curve curve;

  /// height is for define the container's height that will collapse
  /// This returns `double` value and the default is `230`.
  final double height;
  ExpandableContainer({
    @required this.child,
    @required this.controller,
    this.curve,
    this.height,
  })  : assert(child != null),
        assert(controller != null),
        super(
          listenable: Tween<double>(begin: 0, end: height).animate(
            CurvedAnimation(
              curve: Interval(0, 1, curve: curve),
              parent: controller,
            ),
          ),
        );

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = listenable;
    return Container(
      height: animation.value,
      child: child,
    );
  }
}
