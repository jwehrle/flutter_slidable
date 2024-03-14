import 'package:flutter/widgets.dart';
import 'slidable.dart';

/// An [ActionPane] motion which reveals actions as if they were behind the
/// [Slidable].
///
class BaseActionPane extends StatelessWidget {
  /// Creates a [BaseActionPane].
  ///
  /// {@animation 664 200 https://raw.githubusercontent.com/letsar/flutter_slidable/assets/behind_motion.mp4}
  const BaseActionPane({
    Key? key,
    required this.direction,
    required this.fromStart,
    required this.equalize,
    required this.children,
  }) : super(key: key);

  /// The axis in which the slidable can slide.
  final Axis direction;

  /// Whether the current action pane is the start one.
  final bool fromStart;

  /// Whether to make children same size in alignment direciton
  final bool equalize;

  /// The actions for this pane.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    // final paneData = ActionPane.of(context);
    final mainAxAl =
        fromStart ? MainAxisAlignment.start : MainAxisAlignment.end;
    Widget flex;
    if (equalize) {
      if (direction == Axis.horizontal) {
        flex = IntrinsicWidth(
          child: Flex(
            direction: direction,
            mainAxisAlignment: mainAxAl,
            children: children.map((e) => Expanded(child: e)).toList(),
          ),
        );
      } else {
        flex = IntrinsicHeight(
          child: Flex(
            direction: direction,
            mainAxisAlignment: mainAxAl,
            children: children.map((e) => Expanded(child: e)).toList(),
          ),
        );
      }
    } else {
      flex = Flex(
        direction: direction,
        mainAxisAlignment: mainAxAl,
        children: children,
      );
    }
    return Align(
      alignment: fromStart ? Alignment.centerLeft : Alignment.centerRight,
      child: SingleChildScrollView(
        scrollDirection: direction,
        clipBehavior: Clip.none,
        child: flex,
      ),
    );
  }
}
