import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_slidable/src/controller.dart';

const _defaultExtentRatio = 0.5;

/// An action pane.
class ActionPane extends StatefulWidget {
  /// Creates an [ActionPane].
  ///
  /// The [extentRatio] argument must not be null and must be between 0
  /// (exclusive) and 1 (inclusive).
  const ActionPane({
    Key? key,
    this.extentRatio = _defaultExtentRatio,
    required this.direction,
    required this.child,
  })  : assert(extentRatio > 0 && extentRatio <= 1),
        super(key: key);

  /// The total extent of this [ActionPane] relatively to the enclosing
  /// [Slidable] widget.
  ///
  /// Must be between 0 (excluded) and 1.
  final double extentRatio;

  /// Axis of slider
  final Axis direction;

  /// Widget to display when slider is moved.
  final Widget child;

  @override
  _ActionPaneState createState() => _ActionPaneState();
}

class _ActionPaneState extends State<ActionPane> implements RatioConfigurator {
  late SlidableController _controller;
  late double _openThreshold;
  late double _closeThreshold;
  late Alignment _alignment;

  @override
  double get extentRatio => widget.extentRatio;

  @override
  void initState() {
    super.initState();
    _controller = Slidable.of(context);
    _controller.endGesture.addListener(handleEndGestureChanged);
    _openThreshold = extentRatio / 2;
    _closeThreshold = extentRatio / 2;
    _controller.actionPaneConfigurator = this;
    final sign = _controller.direction.value.toDouble();
    _alignment = widget.direction == Axis.horizontal
        ? Alignment(-sign, 0)
        : Alignment(0, -sign);
  }

  @override
  void didUpdateWidget(covariant ActionPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    _openThreshold = extentRatio / 2;
    _closeThreshold = extentRatio / 2;
    final sign = _controller.direction.value.toDouble();
    _alignment = widget.direction == Axis.horizontal
        ? Alignment(-sign, 0)
        : Alignment(0, -sign);
  }

  @override
  void dispose() {
    _controller.endGesture.removeListener(handleEndGestureChanged);
    _controller.actionPaneConfigurator = null;
    super.dispose();
  }

  @override
  double normalizeRatio(double ratio) {
    final absoluteRatio = ratio.abs().clamp(0.0, extentRatio);
    if (ratio < 0) {
      return -absoluteRatio;
    }
    return absoluteRatio;
  }

  @override
  void handleEndGestureChanged() {
    final gesture = _controller.endGesture.value;
    final position = _controller.animation.value;

    if ((gesture is OpeningGesture && _openThreshold <= extentRatio) ||
        gesture is StillGesture &&
            ((gesture.opening && position >= _openThreshold) ||
                gesture.closing && position > _closeThreshold)) {
      _controller.openCurrentActionPane();
      return;
    }

    // Otherwise we close the the Slidable.
    _controller.close();
  }

  _Factors get _factors => widget.direction == Axis.horizontal
      ? _Factors(width: extentRatio, height: null)
      : _Factors(width: null, height: extentRatio);

  @override
  Widget build(BuildContext context) {
    final factors = _factors;
    return FractionallySizedBox(
      alignment: _alignment,
      widthFactor: factors.width,
      heightFactor: factors.height,
      child: Align(
        alignment: _alignment,
        child: widget.child,
      ),
    );
  }
}

/// Custom Tulple for convenience
class _Factors {
  _Factors({required this.width, required this.height});
  final double? width;
  final double? height;
}
