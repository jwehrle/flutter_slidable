import 'package:flutter/widgets.dart';
import 'slidable.dart';

/// An [ActionPane] motion which reveals actions as if they were behind the
/// [Slidable].
///
class BehindMotion extends StatelessWidget {
  /// Creates a [BehindMotion].
  ///
  /// {@animation 664 200 https://raw.githubusercontent.com/letsar/flutter_slidable/assets/behind_motion.mp4}
  const BehindMotion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paneData = ActionPane.of(context);
    final mainAxAl =
        paneData.fromStart ? MainAxisAlignment.start : MainAxisAlignment.end;
    Widget flex;
    if (paneData.equalize) {
      if (paneData.direction == Axis.horizontal) {
        flex = IntrinsicWidth(
          child: Flex(
            direction: paneData.direction,
            mainAxisAlignment: mainAxAl,
            children: paneData.children.map((e) => Expanded(child: e)).toList(),
          ),
        );
      } else {
        flex = IntrinsicHeight(
          child: Flex(
            direction: paneData.direction,
            mainAxisAlignment: mainAxAl,
            children: paneData.children.map((e) => Expanded(child: e)).toList(),
          ),
        );
      }
    } else {
      flex = Flex(
        direction: paneData.direction,
        mainAxisAlignment: mainAxAl,
        children: paneData.children,
      );
    }
    return Align(
      alignment:
          paneData.fromStart ? Alignment.centerLeft : Alignment.centerRight,
      child: SingleChildScrollView(
        scrollDirection: paneData.direction,
        clipBehavior: Clip.none,
        child: flex,
      ),
    );
  }
}
