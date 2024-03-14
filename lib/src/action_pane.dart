part of 'slidable.dart';

const _defaultExtentRatio = 0.5;

/// An action pane.
class ActionPane extends StatefulWidget {
  /// Creates an [ActionPane].
  ///
  /// The [extentRatio] argument must not be null and must be between 0
  /// (exclusive) and 1 (inclusive).
  /// The [children] argument must not be null.
  const ActionPane({
    Key? key,
    this.extentRatio = _defaultExtentRatio,
    this.dragDismissible = true,
    this.decoration,
    this.preferredExtent,
    required this.children,
  })  : assert(extentRatio > 0 && extentRatio <= 1),
        super(key: key);

  /// The total extent of this [ActionPane] relatively to the enclosing
  /// [Slidable] widget.
  ///
  /// Must be between 0 (excluded) and 1.
  final double extentRatio;

  /// Indicates whether the [Slidable] can be dismissed by dragging.
  ///
  /// Defaults to true.
  final bool dragDismissible;

  /// The actions for this pane.
  final List<Widget> children;

  /// Optional background decoration of ActionPane
  final Decoration? decoration;

  /// Optional fixed extent of slide. Not yet implemented.
  final double? preferredExtent;

  @override
  _ActionPaneState createState() => _ActionPaneState();
}

class _ActionPaneState extends State<ActionPane> implements RatioConfigurator {
  late SlidableController controller;
  late double openThreshold;
  late double closeThreshold;

  @override
  double get extentRatio => widget.extentRatio;

  @override
  void initState() {
    super.initState();
    controller = Slidable.of(context);
    controller.endGesture.addListener(handleEndGestureChanged);
    openThreshold = widget.extentRatio / 2;
    closeThreshold = widget.extentRatio / 2;
    controller.actionPaneConfigurator = this;
  }

  @override
  void didUpdateWidget(covariant ActionPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    openThreshold = widget.extentRatio / 2;
    closeThreshold = widget.extentRatio / 2;
  }

  @override
  void dispose() {
    controller.endGesture.removeListener(handleEndGestureChanged);
    controller.actionPaneConfigurator = null;
    super.dispose();
  }

  @override
  double normalizeRatio(double ratio) {
    final absoluteRatio = ratio.abs().clamp(0.0, widget.extentRatio);
    if (ratio < 0) {
      return -absoluteRatio;
    }
    return absoluteRatio;
  }

  @override
  void handleEndGestureChanged() {
    final gesture = controller.endGesture.value;
    final position = controller.animation.value;

    if ((gesture is OpeningGesture && openThreshold <= extentRatio) ||
        gesture is StillGesture &&
            ((gesture.opening && position >= openThreshold) ||
                gesture.closing && position > closeThreshold)) {
      controller.openCurrentActionPane();
      return;
    }

    // Otherwise we close the the Slidable.
    controller.close();
  }

  @override
  Widget build(BuildContext context) {
    final config = ActionPaneConfiguration.of(context);
    Widget child;
    child = BaseActionPane(
      direction: config.direction,
      fromStart: config.isStartActionPane,
      equalize: config.equalize,
      children: widget.children,
    );
    child = widget.decoration != null
        ? DecoratedBox(decoration: widget.decoration!, child: child)
        : child;
    final factor = extentRatio;
    return FractionallySizedBox(
      alignment: config.alignment,
      widthFactor: config.direction == Axis.horizontal ? factor : null,
      heightFactor: config.direction == Axis.horizontal ? null : factor,
      child: child,
    );
  }
}