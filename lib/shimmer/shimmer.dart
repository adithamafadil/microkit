import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Shimmer is a widget that will shown to create your skeleton for your
/// structure of your content. When the state is waiting or loading, you may
/// use Shimmer to give an expected structure to user.
class Shimmer extends StatefulWidget {
  /// child returns a [Widget] to create a shape that will be overlayed with
  /// Shimmer
  final Widget child;

  /// duration takes [Duration] for how long the shimmer from start to end.
  /// The default value is `1500 milliseconds`
  final Duration duration;

  /// baseColor use `Color` and will be the base color of your object
  /// while shimmering
  final Color baseColor;

  /// highlightColor use `Color` and will be the moving color
  /// while shimmering
  final Color highlightColor;

  Shimmer({
    this.baseColor = Colors.blueGrey,
    @required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.highlightColor = Colors.grey,
  }) : gradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
          colors: [baseColor, baseColor, highlightColor, baseColor, baseColor],
          stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
        );
  final Gradient gradient;

  @override
  _ShimmerState createState() => _ShimmerState();

  /// `Shimmer.listTile` is a [Shimmer] with builder that built with
  /// [ListTile] widget. `Shimmer.listTile` has some properties:
  /// - `baseColor` use `Color` and will be the base color of your object
  /// while shimmering
  /// - `duration` takes [Duration] for how long the shimmer from start to end
  /// The default value is `1500 milliseconds`
  /// - `highlightColor` use `Color` and will be the moving color
  /// while shimmering
  /// - `itemcount` to count how many list you want to build. It returns `int`
  /// and the default value is `10`.
  /// - `leadingShape` to define your leading shape. It returns [BoxShape]
  /// - `trailingShape` to define your trailing shape. It returns [BoxShape]
  /// - `useLeading` is a boolean to show your leading. the default
  /// value is `true`
  /// - `useTrailing` is a boolean to show your leading. the default
  /// value is `false`
  factory Shimmer.listTile({
    final Color baseColor = Colors.grey,
    final Duration duration = const Duration(milliseconds: 1500),
    final Color highlightColor = Colors.blueGrey,
    final int itemCount,
    final BoxShape leadingShape = BoxShape.circle,
    final BoxShape trailingShape = BoxShape.circle,
    final bool useLeading = true,
    final bool useTrailing = false,
  }) {
    return Shimmer(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: itemCount ?? 10,
        itemBuilder: (context, index) {
          return Shimmer(
            baseColor: baseColor,
            highlightColor: highlightColor,
            duration: duration,
            child: ListTile(
              leading: useLeading
                  ? Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: leadingShape,
                        color: Colors.white,
                      ),
                    )
                  : null,
              trailing: useTrailing
                  ? Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: trailingShape,
                        color: Colors.white,
                      ),
                    )
                  : null,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ShimmerState extends State<Shimmer> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // set the state of controller and repeat it
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() {
        setState(() {});
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Shimmer(
      child: widget.child,
      gradient: widget.gradient,
      percent: _controller.value,
    );
  }
}

class _Shimmer extends SingleChildRenderObjectWidget {
  final Widget child;
  final Gradient gradient;
  final double percent;

  _Shimmer({
    this.child,
    this.gradient,
    this.percent,
  });

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _ShimmerFilter(gradient);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    super.updateRenderObject(context, renderObject);
    (renderObject as _ShimmerFilter).shiftPercentage = percent;
  }
}

class _ShimmerFilter extends RenderProxyBox {
  final Gradient _gradient;
  double _shiftPercentage = 0.0;

  _ShimmerFilter(this._gradient);

  set shiftPercentage(double newValue) {
    if (_shiftPercentage != newValue) {
      _shiftPercentage = newValue; // set newvalue and repaint to shimmer
      markNeedsPaint();
    }
  }

  @override
  ShaderMaskLayer get layer => super.layer;

  @override
  bool get alwaysNeedsCompositing => child != null;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing);

      // get the size of the child from Shimmer class
      final width = child.size.width;
      final height = child.size.height;
      double dx = _offset(
        start: -width, // start from off child
        end: width * 2, // end until off child
        percent: _shiftPercentage,
      );
      double dy = 0.0;
      final rect = Rect.fromLTWH(dx, dy, width, height);

      layer ??= ShaderMaskLayer();
      layer
        ..shader = _gradient.createShader(rect)
        // create shader calculate from the size size of
        // the offset and child's size
        ..maskRect = offset & size
        ..blendMode = BlendMode.srcIn;
      context.pushLayer(layer, super.paint, offset);
    }
  }

  // this is for define the offset of the shimmer's movement
  double _offset({double start, double end, double percent}) =>
      start + (end - start) * percent;
}
